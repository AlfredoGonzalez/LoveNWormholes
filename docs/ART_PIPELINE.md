# Art pipeline

How raw Gemini art becomes game-ready sprites. Spec: `docs/spec.md` section 10.

## 1. Drop files in `art-inbox/`

Put the raw images straight in `art-inbox/` (subfolders are fine, they are scanned
recursively; `art-inbox/legacy/` is ignored). PNG, JPG or WEBP. The file name decides
everything; the same names as the spec prompts, but folders do not matter:

| File name | Becomes | Final size |
|---|---|---|
| `p1_club_worm_sheet.png` (`p<era>_..._sheet`) | player unit sheet, id `p1_club_worm` | frames 256 px tall |
| `e1_ant_clubber_sheet.png` (`e<era>_..._sheet`) | enemy sheet | 256 px tall |
| `b1_rexy_sheet.png` (`b<era>_..._sheet`) | boss sheet | 512 px tall |
| `squirmy_sheet.png`, `squirmy_skin_pirate_sheet.png` | hero sheet | 384 px tall |
| `base_p1.png`, `base_e3.png` | static base | 512 px wide |
| `proj_*.png`, `icon_*.png` | static projectile / icon | max side 128 px |
| anything else without `_sheet` (e.g. `wormina.png`, `chrono_core.png`) | static character | 384 px tall |

The id is the file name without `_sheet` / extension. A `_sheet` file whose name does not
start with `squirmy`, `p<n>`, `e<n>` or `b<n>` is skipped with a message.

Sheets are **1:1 images, 5 columns x 5 rows** (columns = 5 frames, rows = animations).
Rows: units / enemies / bosses = `idle, walk, attack, hurt, defeat`; hero =
`idle, cast_slam, cast_power, hurt, celebrate`. The grid is cut by dividing the image into
equal fifths, so ask Gemini for an even grid and regenerate when frames drift.

Background: flat magenta `#FF00FF`. Wormina (pink) uses flat blue `#0000FF`; this is built in
for the id `wormina`. For any other asset that needs a different key, add the entry to
`assets/manifest.json` by hand (`"key_color": "#00FF00"`); the script keeps it on re-runs.

## 2. Run the script

```
pip install pillow numpy      # once
python3 tools/process_sprites.py
python3 -m pytest tools/tests_py   # optional: script tests
```

Then commit `assets/sprites/**` and `assets/manifest.json` (not `art-inbox/`).
Running it again with no changes gives byte-identical output; running it on an empty inbox
just keeps the manifest as is. Existing manifest entries are preserved (only re-processed
files are replaced), and a hand-set `hit_frame` or `key_color` survives.

## 3. What it does

1. Removes the key colour with a soft alpha (colour distance) and *decontaminates* edge
   pixels, so there is no magenta halo.
2. Sheets: uses one shared crop box for all 25 frames (so the animation does not jitter),
   scales to the target height and writes one packed atlas
   `assets/sprites/<units|enemies|bosses|hero>/<name>_sheet.png`.
   Statics are trimmed and scaled (`bases/`, `icons/`, `characters/`).
3. Writes `assets/manifest.json` entries: `id, kind, category, path, frame_w, frame_h, rows,
   frames_per_row (5), fps per row, hit_frame (2 = 3rd frame of attack), facing, key_color`.
   FPS: idle 6, walk 10, attack 12, hurt 10, defeat 8 (hero casts 12, celebrate 8).
   Facing: right for hero/units, left for enemies/bosses.

## 4. In the game

`SpriteFactory.make_animated("p1_club_worm")` / `make_static("base_p1")` build the nodes
from the manifest (`play_row("attack")`, signals `hit_frame_reached`, `row_finished`). Until
the art exists they return a labelled placeholder rectangle (blue = player, red =
enemy/boss), so the game is always playable.

## Studio intro video

`assets/video/studio_intro.ogv` (Ogg Theora, played by `StudioIntro`). To rebuild from an mp4:
`ffmpeg -i logo.mp4 -c:v libtheora -q:v 7 -c:a libvorbis assets/video/studio_intro.ogv`.
Keep the source mp4 out of the repo.
