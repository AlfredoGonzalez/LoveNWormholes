# Art pipeline

How raw Gemini art becomes game-ready sprites. Spec: `docs/spec.md` section 10.

Prompts de Gemini (formato nuevo, por fases): `docs/art-prompts/README.md` (una hoja 5x5 por animación, `<id>_<anim>_sheet.png`, referencia `<id>_ref.png`, sufijo `_x2` para lienzo doble). Los 89 prompts originales se conservan en `docs/ART_PROMPTS_ORIGINAL.md`. Estado de cada pieza: `docs/ART_STATUS.md` (`python3 tools/art_status.py`). Los prompts se regeneran con `python3 tools/gen_art_prompts.py`.

Nota: las secciones 1 a 3 de abajo describen el pipeline antiguo (una hoja con 5 animaciones por fila); se actualizan cuando se implemente la convención nueva.

## 1. Drop files in `art-inbox/`

Put the raw images straight in `art-inbox/` (subfolders are fine, scanned recursively;
`art-inbox/legacy/` is ignored). PNG, JPG or WEBP. The file name decides everything.

### Characters: one sheet per animation

Each **animation** is its own **5x5 sheet = 25 frames** (left to right, top to bottom) of that single
animation. Name: `<id>_<anim>_sheet.png`.

| Kind | id examples | Animations | Frame height |
|---|---|---|---|
| player unit (`p<era>_`) | `p1_club_worm` | idle, walk, attack, hurt, defeat | 256 |
| enemy (`e<era>_`) | `e1_ant_clubber` | idle, walk, attack, hurt, defeat | 256 |
| boss (`b<era>_`, also `count_magpie`, `chrono_core`) | `b1_rexy` | idle, walk, attack, hurt, defeat (may be only idle) | 512 |
| hero (`squirmy`, `squirmy_skin_<name>`) | `squirmy` | idle, cast_slam, cast_power, hurt, celebrate | 384 |
| other characters (e.g. `wormina`) | `wormina` | any of the above (often only idle) | 384 |

Examples: `p1_club_worm_idle_sheet.png`, `p1_club_worm_attack_sheet.png`,
`squirmy_skin_pirate_cast_slam_sheet.png`, `wormina_idle_sheet.png`. Any animation may be missing:
the game shows the placeholder rectangle for it until the art arrives.

**Double canvas `_x2`**: when the motion sticks out of a normal cell, ask for a double-size cell and
add `_x2` before `_sheet`: `p1_club_worm_attack_x2_sheet.png`. The character is drawn at the *same
pixel size* as in a normal cell, so the frames are **not** reduced: the output frame is 2x the normal
size (512 instead of 256 for a unit, 768 for the hero, 1024 for a boss), the whole canvas is kept (no
crop) and the feet are anchored at the bottom centre. The game scales by the character's nominal
height, so an `_x2` animation shows the same body size as the others.

**`<id>_ref.png`**: static reference pose of the character. Not used in game; it is only reduced to a
small portrait (max side 128) in `assets/sprites/refs/` and listed under `refs` in the manifest.

Other files: `base_p1.png` / `base_e3.png` (static base, 512 px wide), `proj_*.png` / `icon_*.png`
(max side 128), anything else without `_sheet` (e.g. `chrono_core.png`) is a static character, 384 px
tall.

**Deprecated**: the old single `<id>_sheet.png` (5 rows = 5 animations) is still processed (manifest
entry with `rows`) but prints a deprecation note, and is skipped when per-animation sheets of the
same id are present in the inbox.

Background: flat magenta `#FF00FF`. Wormina (pink) uses flat blue `#0000FF` (built in for the id
`wormina`). Another key: set `"key_color": "#00FF00"` by hand in `assets/manifest.json`; it survives
re-runs.

## 2. Run the script

```
pip install pillow numpy pytest      # once
python3 tools/process_sprites.py
python3 -m pytest tools/tests_py     # script tests (tools/check.sh runs them when the deps exist)
```

Then commit `assets/sprites/**` and `assets/manifest.json` (not `art-inbox/`). Re-running with no
changes gives byte-identical output; an empty inbox leaves the manifest as is. Existing entries are
preserved (only re-processed files are replaced, each animation is merged into its character).

## 3. What it does

1. Removes the key colour with a soft alpha and decontaminates edge pixels (no magenta halo).
2. Per animation sheet: cuts the 5x5 grid, scales every frame with the **same** factor
   (`target_height / cell_height`; x2: `2 * target_height / cell_height`) and, for normal sheets,
   crops with **one** box (union of the frames' opaque pixels + 6 px) shared by all 25 frames. Frames are
   never cropped or rescaled one by one, so the character does not shake. The feet anchor (cell
   centre x, lowest opaque pixel) is stored in the manifest. Output atlas:
   `assets/sprites/<units|enemies|bosses|hero|characters>/<id>_<anim>[_x2]_sheet.png`, 5 columns.
3. `frames_used` (default 25): a hand-set smaller number keeps evenly spaced frames (atlas gets
   `ceil(n/5)` rows). It survives re-runs, like a hand-set `fps` or `hit_frame`.
4. Manifest (`version` 2) entry per character:

```
"p1_club_worm": {"id", "kind": "sheet", "format": 2, "category", "facing", "key_color",
  "nominal_h": 256, "frame_w": 256, "frame_h": 256,
  "expected_anims": ["idle","walk","attack","hurt","defeat"],
  "anims": {"idle": {"path", "frame_w", "frame_h", "anchor": [x, y], "cols": 5, "frames": 25,
                      "frames_used": 25, "fps": 12, "loop": true, "x2": false},
            "attack": {..., "x2": true, "hit_frame": 10}}}
```

   `anims` lists only the animations that exist; `expected_anims` minus `anims` = pending art.
   FPS / loop: idle 12 loop, walk 14 loop, attack 18, hurt 15, defeat 14, cast_* 16, celebrate 12
   loop (the rest do not loop). Default attack `hit_frame` = 40% of the frames (10 of 25).
   Facing: right for hero / units / characters, left for enemies / bosses.

## 4. In the game

`SpriteFactory.make_animated("p1_club_worm")` builds an `AnimatedSprite2D` with one `SpriteFrames`
animation per existing sheet; `make_static("base_p1")` builds statics. `Actor.play_row("attack")`,
signals `hit_frame_reached`, `row_finished`. `SpriteManifest` reads the file tolerantly
(`has_anim`, `get_anim`, `anim_names`, `missing_anims`) and understands both formats.

Fallbacks: no art at all -> labelled rectangle (blue player, red enemy/boss); art for some animations
only (idle but no attack) -> the sprite plays those and the rectangle is shown while a missing one
would play. Battle views scale by `nominal_h`, never by the (possibly x2) frame size. Simulation is
not involved.

## 5. Try a new sprite in the game

1. Drop the sheets in `art-inbox/`, run `python3 tools/process_sprites.py`, check the new
   entry in `assets/manifest.json`.
2. Capture: `xvfb-run -a godot --path . --rendering-method gl_compatibility --rendering-driver opengl3
   --script res://tools/screenshots.gd` (see `docs/DEV.md`); the battle shots in `build/shots/` use the
   squad `p1_club_worm`, `p1_slinger_worm`, `p1_dino_rider_worm`, so name the id in the `battle` entry
   of `tools/screenshots.gd` you want to see.
3. `tools/check.sh` must stay green.

## Studio intro video

`assets/video/studio_intro.ogv` (Ogg Theora, played by `StudioIntro`). To rebuild from an mp4:
`ffmpeg -i logo.mp4 -c:v libtheora -q:v 7 -c:a libvorbis assets/video/studio_intro.ogv`.
Keep the source mp4 out of the repo.
