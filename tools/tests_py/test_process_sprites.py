import json
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
import process_sprites as ps  # noqa: E402


def make_sheet(path, key=(255, 0, 255), size=500):
    img = Image.new("RGB", (size, size), key)
    d = ImageDraw.Draw(img)
    cell = size // 5
    for r in range(5):
        for c in range(5):
            x, y = c * cell + 20 + c * 3, r * cell + 15
            d.ellipse([x, y, x + 50, y + 70], fill=(40 + r * 40, 200, 60 + c * 30))
    img.save(path)


def run(root):
    assert ps.main(["--root", str(root)]) == 0
    return json.loads((root / "assets" / "manifest.json").read_text())


def test_empty_inbox(tmp_path):
    assert run(tmp_path)["sprites"] == {}


def test_sheet_unit_and_idempotent(tmp_path):
    (tmp_path / "art-inbox" / "legacy").mkdir(parents=True)
    make_sheet(tmp_path / "art-inbox" / "p1_club_worm_sheet.png")
    make_sheet(tmp_path / "art-inbox" / "legacy" / "e1_x_sheet.png")
    m = run(tmp_path)
    assert list(m["sprites"]) == ["p1_club_worm"]
    e = m["sprites"]["p1_club_worm"]
    assert e["frame_h"] == 256 and e["frames_per_row"] == 5
    assert e["rows"] == ps.ROWS_STD and e["facing"] == "right" and e["hit_frame"] == 2
    assert e["fps"]["attack"] == 12 and e["key_color"] == "#FF00FF"
    out = tmp_path / e["path"]
    im = Image.open(out)
    assert im.size == (e["frame_w"] * 5, 256 * 5) and im.mode == "RGBA"
    a = np.asarray(im)
    assert a[0, 0, 3] == 0
    opaque = a[a[..., 3] == 255][:, :3].astype(int)
    assert opaque.size
    assert not ((opaque[:, 0] > 200) & (opaque[:, 1] < 60) & (opaque[:, 2] > 200)).any()
    first = out.read_bytes()
    assert run(tmp_path) == m and out.read_bytes() == first


def test_categories_and_blue_key(tmp_path):
    inbox = tmp_path / "art-inbox"
    inbox.mkdir()
    for n in ("b1_rexy_sheet", "e1_ant_clubber_sheet", "squirmy_sheet"):
        make_sheet(inbox / (n + ".png"))
    img = Image.new("RGB", (300, 300), (0, 0, 255))
    ImageDraw.Draw(img).ellipse([80, 40, 220, 260], fill=(255, 150, 200))
    img.save(inbox / "wormina.png")
    make_sheet(inbox / "base_p1.png")
    m = run(tmp_path)["sprites"]
    assert m["b1_rexy"]["frame_h"] == 512 and m["b1_rexy"]["facing"] == "left"
    assert m["e1_ant_clubber"]["facing"] == "left"
    assert m["squirmy"]["frame_h"] == 384 and m["squirmy"]["rows"][1] == "cast_slam"
    assert m["wormina"]["key_color"] == "#0000FF" and m["wormina"]["frame_h"] == 384
    assert Image.open(tmp_path / m["wormina"]["path"]).getpixel((0, 0))[3] == 0
    assert m["base_p1"]["frame_w"] == 512
