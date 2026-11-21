# Audio candidates (CC0) and how to replace the placeholders

Nothing from this list is downloaded or included. They are leads found by web search on 2026-11-21 for Alfredo to
audition and choose (spec 9.5). **Licenses on OpenGameArt/Freesound are per upload and can change: re-check the
license line on each page before downloading**, and add a row to `assets/audio/CREDITS.md` (file, author, source URL,
license, date) for every file that ships. "Credit" below is a courtesy, not a legal requirement, unless the license
says CC-BY. Items marked *verify* had a gap in what the search showed (license shown only by a third party, or no
author seen).

## Sound effects

| Use | Name | URL | License | Author | Notes |
|---|---|---|---|---|---|
| ui_tap, ui_back, buy, coin | Kenney Interface Sounds (100 OGG) | https://kenney.nl/assets/interface-sounds | CC0 (official page) | Kenney | Credit "Kenney.nl" optional. Also mirrored: https://github.com/Calinou/kenney-interface-sounds |
| ui_tap, ui_back | Kenney UI Audio (50 files) | https://godotengine.org/asset-library/asset/796 | CC0 (Godot library port) | Kenney | *verify* on kenney.nl/assets/ui-audio |
| hit, death, base_hit, spawn | Kenney Impact Sounds (~130 files) | https://kenney.nl/assets/impact-sounds | CC0 (via Godot library port; official page not seen) | Kenney | *verify* license on kenney.nl page |
| power casts, gem, capsule_*, ad_reward, boss_warning | Kenney Digital Audio (60 files) | https://kenney.nl/assets/digital-audio | CC0 (official page) | Kenney | Lasers, zaps, power-ups; good for power_cast_1..6 |
| power casts, boss_warning | Kenney Sci-fi Sounds | https://www.kenney.nl/assets/sci-fi-sounds | CC0 (Kenney pack; *verify* on page) | Kenney | Alternative for alerts |
| ui_tap (alt) | 51 UI sound effects, buttons, switches and clicks | https://opengameart.org/content/51-ui-sound-effects-buttons-switches-and-clicks | check page (shown as CC0 in listing; *verify*) | see page | Fallback UI set |
| gem, coin, spawn (alt) | Freesound, filter "Creative Commons 0" only | https://freesound.org/search/?f=license%3A%22Creative+Commons+0%22 | CC0 only (filter) | various | Pick per file; CC-BY or CC-BY-NC files are not allowed |

## Music

| Use (id) | Name | URL | License | Author | Notes |
|---|---|---|---|---|---|
| battle_1 (Era 1, drums) | Krakatoa | https://opengameart.org/content/krakatoa | CC0 | Kistol | Tribal percussion, tagged seamless loop |
| battle_1 (alt) | Prehistoric Drum Loop | https://opengameart.org/content/prehistoric-drum-loop | CC0 | hornpipe2 | Only 6 s, layer under another track |
| battle_1 (alt) | Tribal | https://opengameart.org/content/tribal | CC0 | Of Far Different Nature | Chilled; may be too calm for battle |
| battle_2 (Era 2, desert) | Desert Loop | https://opengameart.org/content/desert-loop | CC0 | iamoneabe | Loopable, oriental style; MP3 (a Lo-Fi remaster also exists) |
| battle_2 (alt) | Desert Overworld | https://opengameart.org/content/desert-overworld | CC0 | KarateStudios | FLAC, loop not stated: check seam |
| battle_2 (alt) | Eastern Arctic Dubstep | https://opengameart.org/content/eastern-arctic-dubstep | CC0 | VishwaJai | Loopable, Egyptian/Arabic feel, 5:15 |
| battle_3 (Era 3, lute) | Medieval: Minstrel Dance | https://opengameart.org/content/medieval-minstrel-dance | CC0 | RandomMind | Lute/minstrel, includes Loop WAV |
| battle_3 (alt) | Medieval Fair [Loop] | https://opengameart.org/content/medieval-fair-loop | CC0 | Woli34 | 8 bars, 130 bpm |
| battle_3 (alt) | Medieval: The Old Tower Inn | https://opengameart.org/content/medieval-the-old-tower-inn | CC0 | RandomMind | Loop WAV included |
| battle_4 (Era 4, gears) | A Clockwork | https://opengameart.org/content/a-clockwork | CC0 | see page | Cogwheel, loopable, electronic |
| battle_4 (alt) | Steampunk music | https://opengameart.org/content/steampunk-music | CC0 | see page | 140 bpm, large FLAC; *verify* URL slug |
| battle_4 (alt) | Ticking clock (SFX layer) | https://opengameart.org/content/ticking-clock | CC0 | see page | Loop of ticks; author appreciates credit |
| battle_5 (Era 5, synth) | The Cogs | https://opengameart.org/content/the-cogs | CC0 (*verify*) | see page | Sci-fi looping background, about 1 min |
| menu | Peace At Last (Loop) | https://opengameart.org/content/peace-at-last-loop | CC0 | Trex0n | Short uplifting retro synth, happy |
| menu (alt) | Menu Theme | https://opengameart.org/content/menu-theme | CC0 | tamesu | Chiptune, BeepBox source editable |
| map (alt) | Main Menu Music (Loop) | https://opengameart.org/content/main-menu-music-loop | CC0 (author states public domain) | Pro Sensory | Electronic |
| boss | Continue? Theme | https://opengameart.org/content/continue-theme | CC0 (*verify*) | CleytonKauffman | SNES style, tagged fight; boss track still open: search "boss" CC0 with the license filter |
| victory / defeat stingers | none chosen yet | https://opengameart.org/art-search-advanced?keys=victory+jingle&field_art_licenses_tid%5B%5D=4 | CC0 filter | various | Kenney Digital Audio has short fanfare-like cues |

Not usable (seen in results, not CC0): Short Medieval Loop (CC-BY), Cinematic Arabian Princess / Desert Biome / Nomads
(CC-BY), Tribal Town (CC-BY-SA). Per spec 9.5, if no CC0 music fits the tone, buy a royalty-free pack and keep the
written license in `docs/licenses/`.

## Replacing a placeholder (file name -> id)

Every sound is an id in `data/audio.json`. While the file at its `file` path does not exist, `AudioService` plays
a synthesized placeholder, so nothing is ever silent.

1. Convert to OGG Vorbis 96 to 128 kbps (music about -14 LUFS, SFX about -10 LUFS; music loops must be seamless).
2. Save it with the id as the file name:
   - SFX: `assets/audio/sfx/<id>.ogg`, ids: spawn, hit, death, base_hit, power_cast_1..6, ui_tap, ui_back, coin, gem,
     buy, capsule_common, capsule_rare, capsule_epic, ad_reward, boss_warning, victory, defeat.
   - Music: `assets/audio/music/<id>.ogg`, ids: menu, map, battle_1..battle_5 (one per era), boss, victory, defeat
     (the last two are non-looping stingers; `"loop": false` in the catalog).
3. Looping: enable loop in the OGG import settings for entries with `"loop": true`.
4. Tune `volume` (linear gain), `bus`, `cooldown` (min seconds between plays) and `duck_db` (music dip) in
   `data/audio.json` without touching code. Different file path or format: change the `file` field.
5. Add the CREDITS row in `assets/audio/CREDITS.md` (Settings shows lines starting with "- ").
6. Screen/era to music mapping lives in `music_map` of the same JSON.
