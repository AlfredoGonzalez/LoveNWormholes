"""Tests for the per-animation sheet format (`<id>_<anim>[_x2]_sheet.png`, 25 frames each)."""
import json
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
sys.path.insert(0, str(Path(__file__).resolve().parent))
import process_sprites as ps  # noqa: E402
from test_process_sprites import make_sheet, run  # noqa: E402


def make_anim_sheet(path, key=(255, 0, 255), cell=100):
    """5x5 cells; a body that wobbles sideways but whose feet sit on the same line."""
    img = Image.new("RGB", (cell * 5, cell * 5), key)
    d = ImageDraw.Draw(img)
    for i in range(25):
        r, c = divmod(i, 5)
        x0, y0 = c * cell, r * cell
        dx = (i % 3) * cell // 25
        d.rectangle([x0 + cell * 3 // 10 + dx, y0 + cell // 5,
                     x0 + cell * 6 // 10 + dx, y0 + cell * 85 // 100], fill=(30 + i * 8, 200, 80))
    img.save(path)


def inbox_of(tmp_path):
    inbox = tmp_path / "art-inbox"
    inbox.mkdir()
    return inbox


def test_parse_names():
    assert ps.parse_name("p1_club_worm_idle_sheet")["anim"] == "idle"
    n = ps.parse_name("squirmy_skin_pirate_cast_slam_x2_sheet")
    assert n["id"] == "squirmy_skin_pirate" and n["anim"] == "cast_slam" and n["x2"]
    assert n["category"] == "hero"
    assert ps.parse_name("p1_club_worm_ref")["kind"] == "ref"
    assert ps.parse_name("p1_club_worm_sheet")["kind"] is None  # legacy name
    assert ps.parse_name("base_p1")["kind"] is None


def test_anim_sheets_per_animation(tmp_path):
    inbox = inbox_of(tmp_path)
    make_anim_sheet(inbox / "p1_club_worm_idle_sheet.png")
    make_anim_sheet(inbox / "p1_club_worm_attack_sheet.png")
    m = run(tmp_path)["sprites"]
    e = m["p1_club_worm"]
    assert e["format"] == 2 and e["category"] == "unit" and e["facing"] == "right"
    assert set(e["anims"]) == {"idle", "attack"} and e["expected_anims"] == ps.ROWS_STD
    assert e["nominal_h"] == 256 and e["frame_h"] == 256
    idle, atk = e["anims"]["idle"], e["anims"]["attack"]
    assert idle["fps"] == 12 and idle["loop"] is True
    assert atk["fps"] == 18 and atk["loop"] is False and atk["hit_frame"] == 12
    assert idle["frames"] == 25 and idle["frames_used"] == 25 and idle["x2"] is False
    im = Image.open(tmp_path / idle["path"])
    fw, fh = idle["frame_w"], idle["frame_h"]
    assert im.size == (fw * 5, fh * 5) and im.mode == "RGBA"
    ax, ay = idle["anchor"]
    assert 0 <= ax < fw and 0 < ay <= fh
    # Same scale/crop for all frames: the feet row is identical in every frame (no jitter).
    a = np.asarray(im)
    bottoms = set()
    for i in range(25):
        cell = a[(i // 5) * fh:(i // 5 + 1) * fh, (i % 5) * fw:(i % 5 + 1) * fw, 3]
        bottoms.add(int(np.nonzero((cell > 128).any(axis=1))[0].max()))
    assert max(bottoms) - min(bottoms) <= 1
    assert abs(ay - 1 - max(bottoms)) <= 2  # the anchor is the feet line
    first = (tmp_path / idle["path"]).read_bytes()
    assert run(tmp_path)["sprites"] == m and (tmp_path / idle["path"]).read_bytes() == first


def test_x2_canvas_hero_and_frames_used(tmp_path):
    inbox = inbox_of(tmp_path)
    make_anim_sheet(inbox / "p1_club_worm_attack_x2_sheet.png", cell=200)
    make_anim_sheet(inbox / "squirmy_cast_slam_sheet.png")
    m = run(tmp_path)
    p = m["sprites"]["p1_club_worm"]
    a = p["anims"]["attack"]
    assert a["x2"] is True and a["frame_h"] == 512 and a["frame_w"] == 512  # whole double canvas
    assert a["anchor"][0] == 256 and a["path"].endswith("_attack_x2_sheet.png")
    assert p["frame_w"] == 256  # nominal (single-canvas) width
    h = m["sprites"]["squirmy"]
    assert h["category"] == "hero" and h["nominal_h"] == 384
    assert h["anims"]["cast_slam"]["fps"] == 16 and h["expected_anims"] == ps.ROWS_HERO
    # A hand-set frames_used / hit_frame survives and subsamples the atlas.
    mp = tmp_path / "assets" / "manifest.json"
    d = json.loads(mp.read_text())
    d["sprites"]["p1_club_worm"]["anims"]["attack"].update(frames_used=10, hit_frame=4)
    mp.write_text(json.dumps(d))
    a = run(tmp_path)["sprites"]["p1_club_worm"]["anims"]["attack"]
    assert a["frames"] == 10 and a["frames_used"] == 10 and a["hit_frame"] == 4
    assert Image.open(tmp_path / a["path"]).size == (512 * 5, 512 * 2)
    idx = ps.sample_indices(10)
    assert idx[0] == 0 and idx[-1] == 24 and len(set(idx)) == 10


def test_ref_boss_ids_and_legacy(tmp_path):
    inbox = inbox_of(tmp_path)
    make_anim_sheet(inbox / "count_magpie_idle_sheet.png")
    make_anim_sheet(inbox / "wormina_idle_sheet.png", key=(0, 0, 255))
    make_sheet(inbox / "e1_ant_clubber_sheet.png")  # legacy, still works
    img = Image.new("RGB", (300, 300), (255, 0, 255))
    ImageDraw.Draw(img).ellipse([80, 40, 220, 260], fill=(10, 200, 10))
    img.save(inbox / "p1_club_worm_ref.png")
    d = run(tmp_path)
    s = d["sprites"]
    assert s["count_magpie"]["category"] == "boss" and s["count_magpie"]["nominal_h"] == 512
    assert s["count_magpie"]["facing"] == "left"
    assert s["wormina"]["category"] == "character" and s["wormina"]["key_color"] == "#0000FF"
    assert "rows" in s["e1_ant_clubber"] and "anims" not in s["e1_ant_clubber"]
    ref = d["refs"]["p1_club_worm"]
    assert max(Image.open(tmp_path / ref).size) == 128 and "p1_club_worm" not in s


def test_legacy_skipped_when_new_format_exists(tmp_path):
    inbox = inbox_of(tmp_path)
    make_sheet(inbox / "p1_club_worm_sheet.png")
    make_anim_sheet(inbox / "p1_club_worm_idle_sheet.png")
    e = run(tmp_path)["sprites"]["p1_club_worm"]
    assert e["format"] == 2 and "rows" not in e


def test_artist_names_are_normalised():
    assert ps.normalize_stem("Gusanito-gusanito_idle-v1") == "squirmy_idle_sheet"
    assert ps.parse_name("Gusanito-gusanito_idle-v1")["id"] == "squirmy"
    assert ps.parse_name("gusanita_idle")["id"] == "wormina"
    assert ps.parse_name("p1_club_worm_attack_x2_sheet")["x2"] is True
    assert ps.parse_name("base_p1")["kind"] is None
