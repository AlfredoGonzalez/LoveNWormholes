#!/usr/bin/env python3
"""Sprite pipeline: art-inbox/ raw art -> assets/sprites/** atlases + assets/manifest.json.
New format: one 5x5 (25-frame) sheet per animation, `<id>_<anim>[_x2]_sheet.png`; the old
5-row `<id>_sheet.png` is still accepted (deprecated).

See docs/ART_PIPELINE.md. Idempotent; safe on an empty inbox.
Usage: python3 tools/process_sprites.py [--root DIR]
"""
import argparse
import json
import math
import re
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFilter

GRID = 5
DEFAULT_KEY = "#FF00FF"
ROWS_STD = ["idle", "walk", "attack", "hurt", "defeat"]
ROWS_HERO = ["idle", "cast_slam", "cast_power", "hurt", "celebrate"]
ALL_ANIMS = ["idle", "walk", "attack", "hurt", "defeat", "cast_slam", "cast_power", "celebrate"]
# Legacy (deprecated) 5-row sheet: fps per row.
FPS_LEGACY = {"idle": 6, "walk": 10, "attack": 12, "hurt": 10, "defeat": 8,
              "cast_slam": 12, "cast_power": 12, "celebrate": 8}
FPS = FPS_LEGACY
# New format: one 5x5 sheet (25 frames) per animation.
ANIM_FPS = {"idle": 12, "walk": 14, "attack": 18, "hurt": 15, "defeat": 14,
            "cast_slam": 16, "cast_power": 16, "celebrate": 12}
ANIM_LOOP = {"idle": True, "walk": True, "celebrate": True}  # everything else: no loop
FRAMES_USED_DEFAULT = 25  # of 25; a hand-set anims.<a>.frames_used in the manifest survives
ATTACK_HIT_RATIO = 0.48   # default hit frame = frames_used * 0.48 (frame 13 of 25) (hand-set hit_frame survives)
MANIFEST_VERSION = 2
BOSS_IDS = {"count_magpie", "chrono_core"}
CROP_PAD = 6
ANIM_RE = re.compile(r"^(?P<id>.+?)_(?P<anim>" + "|".join(ALL_ANIMS) + r")(?P<x2>_x2)?_sheet$")
SHEET_HEIGHT = {"unit": 256, "enemy": 256, "boss": 512, "hero": 384, "character": 384}
CATEGORY_DIR = {"unit": "units", "enemy": "enemies", "boss": "bosses", "hero": "hero",
                "base": "bases", "character": "characters", "icon": "icons", "ref": "refs"}
KEY_OVERRIDES = {"wormina": "#0000FF"}  # default key per id (a manifest key_color wins)
IMG_EXT = {".png", ".jpg", ".jpeg", ".webp"}


def hex_to_rgb(h):
    h = h.lstrip("#")
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))


def category_of(sid):
    if sid.startswith("squirmy"):
        return "hero"
    if re.match(r"^p\d", sid):
        return "unit"
    if re.match(r"^e\d", sid):
        return "enemy"
    if re.match(r"^b\d", sid) or sid in BOSS_IDS:
        return "boss"
    return None


# Names the artist uses for characters -> internal ids (the files can say "gusanito", the game says "squirmy").
ALIASES = {"gusanito": "squirmy", "gusanita": "wormina"}
_VERSION_RE = re.compile(r"[-_ ]v\d+$")
_BARE_ANIM_RE = re.compile(r"^(?P<id>.+?)_(?P<anim>" + "|".join(ALL_ANIMS) + r")(?P<x2>_x2)?$")


def normalize_stem(stem):
    """Tolerant file names: lowercase, spaces/dashes -> '_', a trailing '-v1' dropped, aliases mapped
    (gusanito -> squirmy; a doubled "Gusanito-squirmy_idle" / "Gusanito-gusanito_idle" collapses to one id), and
    '_sheet' optional after a known animation."""
    s = _VERSION_RE.sub("", stem.strip().lower())
    s = re.sub(r"[-\s]+", "_", s)
    names = set(ALIASES) | set(ALIASES.values())
    parts = s.split("_")
    while len(parts) > 1 and parts[0] in names and parts[1] in names:   # "gusanito_squirmy_..." -> "squirmy_..."
        parts = parts[1:]
    if parts and parts[0] in ALIASES:
        parts[0] = ALIASES[parts[0]]
    s = "_".join(parts)
    m = _BARE_ANIM_RE.match(s)
    if m and not s.endswith("_sheet"):
        s += "_sheet"
    return s


def parse_name(stem):
    """New-format names. Returns dict(kind='anim'|'ref'|None, id, anim, x2, category)."""
    stem = normalize_stem(stem)
    m = ANIM_RE.match(stem)
    if m:
        sid = m.group("id")
        return {"kind": "anim", "id": sid, "anim": m.group("anim"), "x2": bool(m.group("x2")),
                "category": category_of(sid) or "character"}
    if stem.endswith("_ref") and len(stem) > 4:
        return {"kind": "ref", "id": stem[:-4], "anim": None, "x2": False, "category": "ref"}
    return {"kind": None}


def classify(stem):
    """Legacy classifier. Return (id, kind, category). kind is 'sheet', 'static' or None."""
    stem = normalize_stem(stem)
    sheet = stem.endswith("_sheet")
    sid = stem[:-6] if sheet else stem
    if sheet:
        if sid.startswith("squirmy"):
            cat = "hero"
        elif re.match(r"^p\d", sid):
            cat = "unit"
        elif re.match(r"^e\d", sid):
            cat = "enemy"
        elif re.match(r"^b\d", sid):
            cat = "boss"
        else:
            return sid, None, None
        return sid, "sheet", cat
    if sid.startswith("base_"):
        return sid, "static", "base"
    if sid.startswith(("proj_", "icon_", "projectile_", "era_", "power_", "fx_")):
        return sid, "static", "icon"
    return sid, "static", "character"


def open_image(src):
    """RGBA when the file already has real transparency (more than 2% of pixels not opaque: the artist or the
    generator already cut the background out), plain RGB otherwise (flat key colour to remove)."""
    img = Image.open(src)
    if img.mode in ("RGBA", "LA", "P") and "A" in img.convert("RGBA").getbands():
        rgba = img.convert("RGBA")
        alpha = np.asarray(rgba.getchannel("A"))
        if (alpha < 250).mean() > 0.02:
            return rgba
    return img.convert("RGB")


def remove_key(img, key_rgb, t0=70.0, t1=150.0):
    """RGB -> RGBA: soft alpha from colour distance to the key, with edge decontamination.
    An image that is already RGBA (real transparency) is returned untouched."""
    if img.mode == "RGBA":
        return img
    a = np.asarray(img.convert("RGB"), dtype=np.float32)
    key = np.array(key_rgb, dtype=np.float32)
    dist = np.sqrt(((a - key) ** 2).sum(axis=2))
    alpha = np.clip((dist - t0) / (t1 - t0), 0.0, 1.0)
    # Pixel = a*C + (1-a)*K  ->  C = (Pixel - (1-a)*K) / a   (removes the key fringe)
    safe = np.maximum(alpha, 1e-3)[..., None]
    c = np.clip((a - (1.0 - alpha[..., None]) * key) / safe, 0, 255)
    edge = (alpha > 0.0) & (alpha < 1.0)
    c[~edge] = a[~edge]
    out = np.zeros(a.shape[:2] + (4,), dtype=np.uint8)
    out[..., :3] = np.where(alpha[..., None] > 0, c, 0).astype(np.uint8)
    out[..., 3] = (alpha * 255 + 0.5).astype(np.uint8)
    return Image.fromarray(out, "RGBA")


def despill_magenta(img, ring=5):
    """Removes the magenta halo left on the border of a keyed cut-out: on pixels within `ring` px of transparency,
    red and blue are pulled down to the green level when they exceed it (magenta = high R and B, low G)."""
    a = np.asarray(img, dtype=np.float32).copy()
    alpha = a[..., 3]
    solid = (alpha > 200).astype(np.uint8)
    # distance-to-transparent by iterative erosion (cheap, no scipy)
    near = np.zeros(solid.shape, dtype=bool)
    cur = solid.astype(bool)
    for _ in range(ring):
        er = cur.copy()
        er[1:, :] &= cur[:-1, :]
        er[:-1, :] &= cur[1:, :]
        er[:, 1:] &= cur[:, :-1]
        er[:, :-1] &= cur[:, 1:]
        near |= cur & ~er
        cur = er
    edge = near | ((alpha > 0) & (alpha <= 200))
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    spill = np.minimum(np.maximum(r - g, 0), np.maximum(b - g, 0))
    mask = edge & (spill > 3)
    a[..., 0] = np.where(mask, r - spill * 0.9, r)
    a[..., 2] = np.where(mask, b - spill * 0.9, b)
    return Image.fromarray(np.clip(a, 0, 255).astype(np.uint8), "RGBA")


def white_to_alpha(img, tol=14):
    """Cuts a plain white background by flood fill from the borders (white details INSIDE the subject stay)."""
    rgb = img.convert("RGB")
    w, h = rgb.size
    mask = Image.new("L", (w, h), 0)
    px = np.asarray(rgb).astype(np.int16)
    near_white = (px.min(axis=2) >= 255 - tol)
    flood = Image.fromarray((near_white * 255).astype(np.uint8)).copy()   # a writable copy (fromarray is read-only)
    ImageDraw.floodfill(flood, (0, 0), 128, thresh=0)
    for pt in ((w - 1, 0), (0, h - 1), (w - 1, h - 1)):
        if flood.getpixel(pt) == 255:
            ImageDraw.floodfill(flood, pt, 128, thresh=0)
    bg = np.asarray(flood) == 128
    alpha = np.where(bg, 0, 255).astype(np.uint8)
    out = np.dstack([np.asarray(rgb), alpha])
    res = Image.fromarray(out, "RGBA")
    # soften the 1px staircase of the cut
    a = res.getchannel("A").filter(ImageFilter.GaussianBlur(0.8))
    res.putalpha(a)
    return res


def alpha_bbox(img):
    return img.getchannel("A").point(lambda v: 255 if v > 8 else 0).getbbox()


def bbox_union(frames):
    box = None
    for f in frames:
        b = alpha_bbox(f)
        if b is None:
            continue
        box = b if box is None else (min(box[0], b[0]), min(box[1], b[1]),
                                     max(box[2], b[2]), max(box[3], b[3]))
    return box


def process_sheet(src, key_rgb, cat):
    img = open_image(src)
    W, H = img.size
    cw, ch = W // GRID, H // GRID
    raw = []
    for r in range(GRID):
        for c in range(GRID):
            cell = img.crop((c * cw, r * ch, (c + 1) * cw, (r + 1) * ch))
            raw.append(remove_key(cell, key_rgb))
    # One shared crop box for all frames keeps the animation steady (no jitter).
    box = bbox_union(raw)
    if box is None:
        raise ValueError("sheet is empty after key removal")
    target_h = SHEET_HEIGHT[cat]
    scale = target_h / (box[3] - box[1])
    fw = max(1, int(math.ceil((box[2] - box[0]) * scale)))
    atlas = Image.new("RGBA", (fw * GRID, target_h * GRID), (0, 0, 0, 0))
    for i, f in enumerate(raw):
        f = f.crop(box).resize((fw, target_h), Image.LANCZOS)
        atlas.paste(f, ((i % GRID) * fw, (i // GRID) * target_h))
    return atlas, fw, target_h


def sample_indices(n_used, total=GRID * GRID):
    """Evenly spaced subset of the 25 frames (frames_used)."""
    n = max(1, min(total, int(n_used)))
    if n == 1:
        return [0]
    return [int(round(i * (total - 1) / (n - 1))) for i in range(n)]


def process_anim_sheet(src, key_rgb, cat, x2=False, frames_used=FRAMES_USED_DEFAULT):
    """One animation = one 5x5 sheet of 25 frames. No per-frame crop/rescale: every frame uses
    the same scale, crop box and anchor, so the character does not jitter.
    Returns (atlas, frame_w, frame_h, (anchor_x, anchor_y), n_frames)."""
    img = open_image(src)
    W, H = img.size
    cw, ch = W // GRID, H // GRID
    idx = sample_indices(frames_used)
    cells = []
    for i in idx:
        r, c = divmod(i, GRID)
        cells.append(remove_key(img.crop((c * cw, r * ch, (c + 1) * cw, (r + 1) * ch)), key_rgb))
    box = bbox_union(cells)
    if box is None:
        raise ValueError("sheet is empty after key removal")
    # Feet: cell centre x and the MEDIAN of each frame's lowest opaque pixel. The lowest pixel of the whole sheet would
    # be set by effects (cracks, sparks, a body lying down) and make the standing frames float above the ground.
    bottoms = sorted(b[3] for b in (alpha_bbox(c) for c in cells) if b is not None)
    ax, ay = cw / 2.0, float(bottoms[len(bottoms) // 2])
    if x2:
        crop = (0, 0, cw, ch)  # double canvas: keep it whole (the movement overflows)
    else:
        crop = (max(0, min(box[0], int(ax)) - CROP_PAD), max(0, box[1] - CROP_PAD),
                min(cw, max(box[2], int(math.ceil(ax))) + CROP_PAD), min(ch, box[3] + CROP_PAD))
    scale = SHEET_HEIGHT[cat] * (2 if x2 else 1) / ch
    fw = max(1, int(round((crop[2] - crop[0]) * scale)))
    fh = max(1, int(round((crop[3] - crop[1]) * scale)))
    cols = GRID
    rows = int(math.ceil(len(cells) / cols))
    atlas = Image.new("RGBA", (fw * cols, fh * rows), (0, 0, 0, 0))
    for i, f in enumerate(cells):
        f = f.crop(crop).resize((fw, fh), Image.LANCZOS)
        atlas.paste(f, ((i % cols) * fw, (i // cols) * fh))
    anchor = (int(round((ax - crop[0]) * scale)), int(round((ay - crop[1]) * scale)))
    return atlas, fw, fh, anchor, len(cells)


IMAGE_PREFIXES = ("bg_", "story_", "logo", "app_icon", "feature_", "paper_", "title_", "map_", "play_", "btn_", "background", "jugar_", "language", "slider", "loader", "progress", "home_", "ui_")
IMAGE_TARGET_W = {"bg_": 1080, "background": 1080, "story_": 1920, "title_": 1080, "map_": 1080}


def image_rel(sid):
    if sid.startswith("home_"):
        return f"assets/images/home/{sid}.{'jpg' if sid.endswith('_sky') else 'png'}"
    sub = "backgrounds" if sid.startswith(("bg_", "background", "title_", "map_")) else "story" if sid.startswith("story_") else "ui"
    ext = "jpg" if sid.startswith(("bg_", "background", "story_", "title_", "map_")) else "png"
    return f"assets/images/{sub}/{sid}.{ext}"


def process_image(src, out, sid, rel):
    """A finished picture: resized to its target width (never enlarged), no key removal. Backgrounds/panels -> JPEG.
    A PNG/WEBP that already has transparency (logo, buttons) keeps its alpha and is trimmed to the visible area."""
    img = open_image(src)
    if sid.startswith(("home_", "ui_")) and img.mode != "RGBA" and not sid.endswith("_sky"):
        # Scene layers / props generated by Gemini: magenta key (layers keep their full canvas, they must line up)
        # or a plain white background (props: cut by flood fill, then trimmed).
        arr = np.asarray(img.convert("RGB")).astype(int)
        mag = float(((arr[..., 0] > 200) & (arr[..., 1] < 90) & (arr[..., 2] > 200)).mean())
        if mag > 0.02 or sid.startswith("ui_"):
            img = despill_magenta(remove_key(img.convert("RGB"), (255, 0, 255), t0=95.0, t1=175.0))
        else:
            img = white_to_alpha(img)
            box = alpha_bbox(img)
            if box is not None:
                img = img.crop(box)
    if out.suffix == ".jpg" or img.mode != "RGBA":
        img = img.convert("RGB")
    elif not sid.startswith("home_"):
        box = alpha_bbox(img)
        if box is not None:
            img = img.crop(box)
    w = next((v for k, v in IMAGE_TARGET_W.items() if sid.startswith(k)), None)
    if w is None and img.mode == "RGBA" and img.width > 1024 and not sid.startswith("home_"):
        w = 1024
    if w and img.width > w:
        img = img.resize((w, int(round(img.height * w / img.width))), Image.LANCZOS)
    if out.suffix == ".jpg":
        img.save(out, quality=90, optimize=True)
    else:
        img.save(out, optimize=True)
    return {"id": sid, "kind": "image", "category": "image", "path": rel, "frame_w": img.width, "frame_h": img.height}


def process_static(src, key_rgb, cat):
    img = remove_key(open_image(src), key_rgb)
    box = alpha_bbox(img)
    if box is None:
        raise ValueError("image is empty after key removal")
    img = img.crop(box)
    w, h = img.size
    if cat == "base":
        s = 512 / w
    elif cat == "icon":
        s = 128 / max(w, h)
    else:
        s = 384 / h
    return img.resize((max(1, round(w * s)), max(1, round(h * s))), Image.LANCZOS)


def process_anim_file(root, src, info, sprites):
    """Process one `<id>_<anim>[_x2]_sheet` into its own atlas and merge it into sprites[id]."""
    sid, anim, cat, x2 = info["id"], info["anim"], info["category"], info["x2"]
    prev = sprites.get(sid, {})
    if prev.get("format") != 2:
        prev = {}
    key = prev.get("key_color") or KEY_OVERRIDES.get(sid, DEFAULT_KEY)
    old = prev.get("anims", {}).get(anim, {})
    used = int(old.get("frames_used", FRAMES_USED_DEFAULT))
    atlas, fw, fh, anchor, n = process_anim_sheet(src, hex_to_rgb(key), cat, x2, used)
    rel = f"assets/sprites/{CATEGORY_DIR[cat]}/{sid}_{anim}{'_x2' if x2 else ''}_sheet.png"
    out = root / rel
    out.parent.mkdir(parents=True, exist_ok=True)
    atlas.save(out, optimize=True)
    a = {"path": rel, "frame_w": fw, "frame_h": fh, "anchor": list(anchor), "cols": GRID,
         "frames": n, "frames_used": used, "fps": old.get("fps", ANIM_FPS[anim]),
         "loop": ANIM_LOOP.get(anim, False), "x2": x2}
    if anim in ("attack", "cast_slam", "cast_power"):
        ratio = {"cast_slam": 0.68, "cast_power": 0.64}.get(anim, ATTACK_HIT_RATIO)   # prompts: hit on frame 13 / 18 / 17 of 25
        a["hit_frame"] = old.get("hit_frame", max(0, min(n - 1, int(n * ratio))))
    anims = dict(prev.get("anims", {}))
    anims[anim] = a
    order = sorted(anims, key=ALL_ANIMS.index)
    nominal = SHEET_HEIGHT[cat]
    base = anims.get("idle") or anims[order[0]]
    if cat in ("hero", "unit", "enemy", "boss") and sid not in BOSS_IDS:
        expected = ROWS_HERO if cat == "hero" else ROWS_STD
    else:
        expected = order
    sprites[sid] = {"id": sid, "kind": "sheet", "format": 2, "category": cat,
                    "frame_w": base["frame_w"] // (2 if base["x2"] else 1), "frame_h": nominal,
                    "nominal_h": nominal, "expected_anims": expected,
                    "anims": {k: anims[k] for k in order},
                    # A hand-set facing survives re-runs: it says which way the ART looks (the game flips by side).
                    "facing": (sprites.get(sid) or {}).get("facing") or ("left" if cat in ("enemy", "boss") else "right"),
                    "key_color": key}


def main(argv=None):
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=str(Path(__file__).resolve().parent.parent))
    args = ap.parse_args(argv)
    root = Path(args.root)
    inbox = root / "art-inbox"
    manifest_path = root / "assets" / "manifest.json"
    manifest = {"version": MANIFEST_VERSION, "sprites": {}}
    if manifest_path.exists():
        try:
            loaded = json.loads(manifest_path.read_text() or "{}")
            if isinstance(loaded, dict) and isinstance(loaded.get("sprites"), dict):
                manifest = loaded
        except json.JSONDecodeError:
            print("warning: manifest.json unreadable, rebuilding", file=sys.stderr)
    manifest["version"] = MANIFEST_VERSION
    sprites = manifest["sprites"]
    refs = manifest.setdefault("refs", {})

    files = []
    if inbox.is_dir():
        files = sorted(p for p in inbox.rglob("*")
                       if p.is_file() and p.suffix.lower() in IMG_EXT
                       and "legacy" not in p.relative_to(inbox).parts[:-1])
    done = 0
    new_ids = {parse_name(p.stem)["id"] for p in files if parse_name(p.stem)["kind"] == "anim"}
    for src in files:
        info = parse_name(src.stem)
        if info["kind"] is not None:
            try:
                if info["kind"] == "ref":
                    sid = info["id"]
                    prev = sprites.get(sid, {})
                    key = prev.get("key_color") or KEY_OVERRIDES.get(sid, DEFAULT_KEY)
                    img = process_static(src, hex_to_rgb(key), "icon")
                    rel = f"assets/sprites/refs/{src.stem}.png"
                    (root / rel).parent.mkdir(parents=True, exist_ok=True)
                    img.save(root / rel, optimize=True)
                    refs[sid] = rel
                else:
                    process_anim_file(root, src, info, sprites)
            except Exception as e:
                print(f"ERROR {src.name}: {e}", file=sys.stderr)
                continue
            done += 1
            print(f"ok: {src.name}")
            continue
        sid, kind, cat = classify(src.stem)
        if kind == "sheet" and sid in new_ids:
            print(f"skip (legacy sheet, per-animation sheets exist): {src.name}")
            continue
        if kind == "sheet":
            print(f"DEPRECATED: {src.name} is the old 5-row sheet; use <id>_<anim>_sheet.png "
                  "(see docs/ART_PIPELINE.md)")
        if kind is None:
            print(f"skip (unknown name): {src.name}")
            continue
        prev = sprites.get(sid, {})
        if kind == "static" and sid.startswith(IMAGE_PREFIXES):
            kind, cat = "image", "image"   # finished pictures (backgrounds, story panels...): no background to key out
        key = prev.get("key_color") or KEY_OVERRIDES.get(sid, DEFAULT_KEY)
        rel = f"assets/sprites/{CATEGORY_DIR[cat]}/{src.stem}.png" if kind != "image" else image_rel(sid)
        out = root / rel
        out.parent.mkdir(parents=True, exist_ok=True)
        try:
            if kind == "image":
                entry = process_image(src, out, sid, rel)
            elif kind == "sheet":
                atlas, fw, fh = process_sheet(src, hex_to_rgb(key), cat)
                atlas.save(out, optimize=True)
                rows = ROWS_HERO if cat == "hero" else ROWS_STD
                entry = {"id": sid, "kind": "sheet", "category": cat, "path": rel,
                         "frame_w": fw, "frame_h": fh, "rows": rows,
                         "frames_per_row": GRID, "fps": {r: FPS[r] for r in rows},
                         "hit_frame": prev.get("hit_frame", 2),
                         "facing": "right" if cat in ("hero", "unit") else "left",
                         "key_color": key}
            else:
                img = process_static(src, hex_to_rgb(key), cat)
                img.save(out, optimize=True)
                entry = {"id": sid, "kind": "static", "category": cat, "path": rel,
                         "frame_w": img.width, "frame_h": img.height,
                         "facing": "left" if sid.startswith("base_e") else "right",
                         "key_color": key}
        except Exception as e:  # keep going on a bad file
            print(f"ERROR {src.name}: {e}", file=sys.stderr)
            continue
        sprites[sid] = entry
        done += 1
        print(f"ok: {src.name} -> {rel}")

    manifest_path.parent.mkdir(parents=True, exist_ok=True)
    manifest_path.write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n")
    print(f"processed {done} file(s); manifest has {len(sprites)} sprite(s)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
