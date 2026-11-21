#!/usr/bin/env python3
"""Sprite pipeline: art-inbox/ raw art -> assets/sprites/** atlases + assets/manifest.json.

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
from PIL import Image

GRID = 5
DEFAULT_KEY = "#FF00FF"
ROWS_STD = ["idle", "walk", "attack", "hurt", "defeat"]
ROWS_HERO = ["idle", "cast_slam", "cast_power", "hurt", "celebrate"]
FPS = {"idle": 6, "walk": 10, "attack": 12, "hurt": 10, "defeat": 8,
       "cast_slam": 12, "cast_power": 12, "celebrate": 8}
SHEET_HEIGHT = {"unit": 256, "enemy": 256, "boss": 512, "hero": 384}
CATEGORY_DIR = {"unit": "units", "enemy": "enemies", "boss": "bosses", "hero": "hero",
                "base": "bases", "character": "characters", "icon": "icons"}
KEY_OVERRIDES = {"wormina": "#0000FF"}  # default key per id (a manifest key_color wins)
IMG_EXT = {".png", ".jpg", ".jpeg", ".webp"}


def hex_to_rgb(h):
    h = h.lstrip("#")
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))


def classify(stem):
    """Return (id, kind, category). kind is 'sheet', 'static' or None (unknown)."""
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
    if sid.startswith(("proj_", "icon_", "projectile_")):
        return sid, "static", "icon"
    return sid, "static", "character"


def remove_key(img, key_rgb, t0=70.0, t1=150.0):
    """RGB -> RGBA: soft alpha from colour distance to the key, with edge decontamination."""
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
    img = Image.open(src).convert("RGB")
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


def process_static(src, key_rgb, cat):
    img = remove_key(Image.open(src).convert("RGB"), key_rgb)
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


def main(argv=None):
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=str(Path(__file__).resolve().parent.parent))
    args = ap.parse_args(argv)
    root = Path(args.root)
    inbox = root / "art-inbox"
    manifest_path = root / "assets" / "manifest.json"
    manifest = {"version": 1, "sprites": {}}
    if manifest_path.exists():
        try:
            loaded = json.loads(manifest_path.read_text() or "{}")
            if isinstance(loaded, dict) and isinstance(loaded.get("sprites"), dict):
                manifest = loaded
        except json.JSONDecodeError:
            print("warning: manifest.json unreadable, rebuilding", file=sys.stderr)
    sprites = manifest["sprites"]

    files = []
    if inbox.is_dir():
        files = sorted(p for p in inbox.rglob("*")
                       if p.is_file() and p.suffix.lower() in IMG_EXT
                       and "legacy" not in p.relative_to(inbox).parts[:-1])
    done = 0
    for src in files:
        sid, kind, cat = classify(src.stem)
        if kind is None:
            print(f"skip (unknown name): {src.name}")
            continue
        prev = sprites.get(sid, {})
        key = prev.get("key_color") or KEY_OVERRIDES.get(sid, DEFAULT_KEY)
        rel = f"assets/sprites/{CATEGORY_DIR[cat]}/{src.stem}.png"
        out = root / rel
        out.parent.mkdir(parents=True, exist_ok=True)
        try:
            if kind == "sheet":
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
