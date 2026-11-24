# Prompts de arte (Gemini): ORIGINAL

> Archivo histórico. El formato vigente está en `docs/art-prompts/` (una hoja por animación, por fases). `tools/gen_art_prompts.py` lee este archivo para los textos de diseño y las filas de animación: no lo edites sin regenerar.

Copia fiel de la sección 10 del spec de Alfredo (el documento original en Claude Docs), con **los 89 prompts completos**.
Cada prompt es autónomo: copia un bloque, pégalo en Gemini y guarda el resultado con el nombre indicado sobre el bloque
(en `art-inbox/`; ver `docs/ART_PIPELINE.md`). El estado de cada pieza se genera con `python3 tools/art_status.py`
(escribe `docs/ART_STATUS.md`).

## Art bible and Gemini prompts

All art is generated in Gemini from the 90 prompts below; every prompt is complete on its own, so copy one box, paste it into Gemini and generate.

## 10.1 How to use the prompts

- IMAGE means a finished picture used as it is (backgrounds, story panels, logo, icon, store art). SPRITE means a single object on a flat magenta (#FF00FF) background that gets cut out and becomes a transparent PNG.
- Copy a prompt, generate, pick the best result and save it with the file name shown above the prompt.
- Gemini may not return exact pixel sizes or a perfect grid. Ask for 1:1 for sprites and sheets, 9:16 for portrait backgrounds and 16:9 for wide images as the prompts do. For sheets: if a frame drifts (different size, a cropped limb, magenta on the body), regenerate the whole sheet or ask Gemini to redraw only that row, then paste it in. If a character looks different between rows, regenerate with the same prompt in the same chat. Keep the 5x5 sheet as the source of truth; tools/process_sprites.py trims, removes the magenta, resizes and builds atlases.
- Work one era per Gemini chat so the style stays consistent. If a result has magenta on the subject, text, extra objects, a cropped subject or a different color scheme, regenerate with the same prompt.
- Player units face right, enemies face left. Animated characters (hero, units, enemies, bosses) are SPRITE SHEETS 5x5: one image, 5 columns by 5 rows, 25 frames, one animation per row (idle, walk, attack, hurt, defeat; the hero has idle, two casts, hurt, celebrate). Each prompt already describes what moves in every row. Static pieces (Wormina, Count Magpie, Chrono Core, bases, projectiles, icons) are single-pose SPRITES. The game is portrait, so backgrounds are 9:16.

| Asset type | Source from Gemini | Final in game |
|---|---|---|
| Unit and enemy sprite sheets | 1:1 sheet, 5x5 grid, one frame per cell | Slice into 25 frames, 256 px tall each |
| Boss sprite sheets | 1:1 | Slice into 25 frames, 512 px tall each |
| Base sprites | 1:1 | Trim, 512 px wide |
| Hero and character sprites | 1:1 | Hero sheets: 25 frames, 384 px tall each; static characters: trim, 256 to 384 px tall |
| Projectiles and icons | 1:1 | 96 to 128 px |
| Battle backgrounds | 16:9 | Portrait 9:16, crop to 1080 x 1920 (use 9:16 source) |
| Story panels | 16:9 | 1920 x 1080 |
| App icon | 1:1 | 1024, export 512 for Play |
| Play feature graphic | wide | Crop to 1024 x 500 |

## 10.2 Era color moods

| Era | Dominant colors | Light |
|---|---|---|
| 1 Stone Age | Leaf green, ochre, volcanic orange | Warm morning |
| 2 Egypt | Sand gold, turquoise, terracotta | Hot noon |
| 3 Medieval | Slate blue, grass green, banner crimson | Soft afternoon |
| 4 Industrial | Copper, brass, teal smog | Dusk with steam glow |
| 5 Far Future | Deep indigo, neon cyan, soft violet-white | Starlight |

## 10.3 Characters and cosmetics (SPRITE)

Characters with animation are generated as SPRITE SHEET 5x5: one image with 25 frames (5 rows, one animation per row, 5 frames per row). Static characters (Wormina, Count Magpie, Chrono Core) stay single-pose SPRITES. Squirmy and Wormina have official character sheets made by Alfredo: attach the matching sheet as a reference image in every Gemini chat that draws them (hero sheets, skins, Wormina, story panels, app icon, banner) so the faces, colors and the cap with the letter A stay identical. Squirmy is bright green and Wormina is soft pink, so Wormina's sprite uses a blue key background instead of magenta.

A01 · SPRITE SHEET 5x5 · Squirmy (hero). Save as assets/sprites/hero/squirmy_sheet.png. Rows: idle, cast Squirm Slam, cast generic power, hurt, celebrate.

```text
Squirmy, a small cheerful bright-green earthworm with a lighter yellow-green segmented belly, big round brown eyes with white highlights, soft peach-pink blushing cheeks, two small simple hands, a black baseball cap worn slightly tilted with a small stylized letter A on the front, and a friendly confident smile. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin dark-green ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body stands upright like a friendly question mark and slowly rises and sinks as if breathing, one little hand gives a tiny wave, the cap brim bobs slightly, and the eyes blink on frame 4. Row 2, casting Squirm Slam: the head leans back, both hands rise, the body coils like a spring, then the whole front half rises high and slams down toward the ground with the cap tipping forward, with small golden sparks around the impact in the last two frames. Row 3, casting a generic power: the head tilts up, both little hands stretch toward the sky with a determined open-mouth battle cry while a swirl of golden and teal light with tiny gears grows around him and then fades. Row 4, getting hurt: the body flinches backward, the eyes squeeze shut, the cap tips down over one eye, the body wobbles, and then he recovers to a standing pose. Row 5, celebrating: the body bounces up in a happy jump with one fist pumped in the air, the cap stays on, a small spin, and a cheerful landing with a tiny tip of the cap.
```

A03 · SPRITE · Wormina. Save as assets/sprites/hero/wormina.png

```text
Wormina, a small cheerful soft-pink earthworm girl with a lighter pink segmented belly, long wavy bubblegum-pink hair with a pretty curl on top, a white daisy with a yellow center tucked into the hair, round thin-framed glasses over big sparkling eyes with long lashes, rosy cheeks, a happy smile with tiny braces and two small simple hands, standing upright in a neutral pose with her body gently curved, looking forward with wonder. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin dark-rose ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, side view facing right, centered with a wide empty margin, drawn on a perfectly flat solid pure blue background (#0000FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use blue anywhere on the subject. Square 1:1 image.
```

Wormina is pink, so this one sprite uses a flat blue background (#0000FF) instead of magenta. tools/process_sprites.py must read the key color per asset from assets/manifest.json (key_color, default #FF00FF; Wormina: #0000FF).

A04 · SPRITE · Count Magpie (story villain). Save as assets/sprites/hero/count_magpie.png

```text
Count Magpie, a plump dapper magpie with glossy black-and-white feathers, iridescent blue-green wing tips, a deep indigo top hat, a gold monocle and a short dark-blue cape, wearing a smug grin and holding a tiny glowing golden gear in one claw, standing proudly with his chest puffed out. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, side view facing left, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

A05 · SPRITE · The Chrono Core. Save as assets/sprites/hero/chrono_core.png

```text
The Chrono Core, a glowing apple-sized clockwork orb made of polished gold and teal metal with tiny visible gears, five small round gem sockets around its middle and hairline cracks letting warm golden light leak out, floating slightly with a few sparkles around it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single object, front view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

A06 · SPRITE SHEET 5x5 · Squirmy skin: Pirate. Save as assets/sprites/hero/squirmy_skin_pirate_sheet.png. Same five rows as A01.

```text
Squirmy, a small cheerful bright-green earthworm with a lighter yellow-green segmented belly, big round brown eyes with white highlights, soft peach-pink blushing cheeks and two small simple hands, dressed as a pirate with a small black tricorn hat with a gold star instead of his cap and a tiny black eyepatch. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin dark-green ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body stands upright and slowly rises and sinks as if breathing, one little hand gives a tiny wave, the hat bobs, and the visible eye blinks on frame 4. Row 2, casting Squirm Slam: the head leans back with the hat tilting, the body coils like a spring, then the front half rises high and slams down toward the ground, with golden sparks at the impact in the last two frames. Row 3, casting a generic power: the head tilts up with a pirate battle cry, both little hands stretch toward the sky while a swirl of golden and teal light with tiny gears grows around him and fades. Row 4, getting hurt: the body flinches backward, the hat tips over one eye, the body wobbles, and then he recovers. Row 5, celebrating: the body bounces up in a happy jump with one fist pumped, a small spin in the air, the hat stays on, and a cheerful landing with a tiny bow.
```

A07 · SPRITE SHEET 5x5 · Squirmy skin: Knight. Save as assets/sprites/hero/squirmy_skin_knight_sheet.png. Same five rows as A01.

```text
Squirmy, a small cheerful bright-green earthworm with a lighter yellow-green segmented belly, big round brown eyes with white highlights, soft peach-pink blushing cheeks and two small simple hands, dressed as a knight with a tiny shiny silver helmet with a blue plume instead of his cap and a small round silver shield strapped to his body. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin dark-green ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body stands upright and slowly rises and sinks as if breathing, the helmet plume sways, and the eyes blink on frame 4. Row 2, casting Squirm Slam: the head leans back, the body coils like a spring, then the front half rises and slams down with the shield forward, with golden sparks at the impact in the last two frames. Row 3, casting a generic power: the head tilts up with a brave battle cry, both little hands stretch toward the sky while a swirl of golden and teal light with tiny gears grows around him and fades. Row 4, getting hurt: the body flinches backward, the plume bends, the shield lifts to block, the body wobbles, and then he recovers. Row 5, celebrating: the body bounces up in a happy jump with the shield raised high, a small spin, and a proud landing.
```

A08 · SPRITE SHEET 5x5 · Squirmy skin: Astronaut. Save as assets/sprites/hero/squirmy_skin_astronaut_sheet.png. Same five rows as A01.

```text
Squirmy, a small cheerful bright-green earthworm with a lighter yellow-green segmented belly, big round brown eyes with white highlights, soft peach-pink blushing cheeks and two small simple hands, dressed as an astronaut with a round clear glass space helmet instead of his cap and a small white backpack with a tiny antenna. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin dark-green ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body stands upright and slowly rises and sinks as if breathing, the antenna on the backpack wobbles, and the eyes blink on frame 4. Row 2, casting Squirm Slam: the head leans back, the body coils like a spring, then the front half rises and slams down, with golden sparks at the impact in the last two frames. Row 3, casting a generic power: the head tilts up with an excited shout, both little hands stretch toward the sky while a swirl of golden and teal light with tiny gears grows around him and fades. Row 4, getting hurt: the body flinches backward, the helmet glass shows a tiny crack of light, the antenna bends, the body wobbles, and then he recovers. Row 5, celebrating: the body floats up in a slow happy bounce as if in low gravity, a gentle spin, and a soft landing with a small wave.
```

## 10.4 Player units (SPRITE, facing right, blue cloth team color)

Every unit is a SPRITE SHEET 5x5 with the same five rows: 1 idle, 2 walk, 3 attack, 4 hurt, 5 defeat. Ids B01 to B15.

B01 · SPRITE SHEET 5x5 · Club Worm (Era 1). Save as assets/sprites/units/p1_club_worm_sheet.png.

```text
A small golden-yellow earthworm soldier with a cream-colored segmented belly, big round dark eyes, a small blue cloth headband as team color, wearing a tiny brown animal-fur tunic and gripping a thick wooden club. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks, the club rests on the shoulder, the headband tails sway, and the eyes blink on frame 4. Row 2, walk loop: the worm moves like an inchworm, the body arches up in the middle and stretches forward again, the club bobs on the shoulder. Row 3, attack: the club is raised high behind the head, the body coils back, then swings the club down and forward with a determined grin, and recovers. Row 4, hurt: the body flinches backward, the eyes squeeze shut, the club drops low, the headband flies forward, and the worm recovers. Row 5, defeat: the body wobbles, droops, slides down flat to the ground with the club falling beside him, and ends lying still with tiny stars above his head.
```

B02 · SPRITE SHEET 5x5 · Slinger Worm (Era 1). Save as assets/sprites/units/p1_slinger_worm_sheet.png.

```text
A small golden-yellow earthworm soldier with a cream-colored segmented belly, big round dark eyes, a small blue cloth headband as team color, wearing a tiny brown animal-fur tunic and holding a leather sling with a round gray stone. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks, the sling swings a little in the hand, and the eyes blink on frame 4. Row 2, walk loop: the worm moves like an inchworm, arching up in the middle and stretching forward, the sling bouncing at his side. Row 3, attack: one eye squints, the sling spins in a circle above the head over three frames, then the arm snaps forward and releases the stone, and the body relaxes. Row 4, hurt: the body flinches backward, the eyes squeeze shut, the sling tangles around the hand, and the worm recovers. Row 5, defeat: the body wobbles, droops, slides down flat to the ground with the sling falling beside him, and ends lying still with tiny stars above his head.
```

B03 · SPRITE SHEET 5x5 · Dino Rider Worm (Era 1). Save as assets/sprites/units/p1_dino_rider_worm_sheet.png.

```text
A small golden-yellow earthworm rider with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, riding on the back of a chubby friendly baby triceratops with a green body, three small horns and a tan frill, holding a short bone lance. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character group, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the characters. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the dinosaur breathes with its sides rising and falling and its tail swaying, the rider rocks slightly and blinks on frame 4. Row 2, walk loop: the dinosaur stomps with alternating legs, the body bobbing up and down, the rider bouncing on its back and the lance tip bobbing. Row 3, attack: the dinosaur lowers its head and horns and lunges forward, the rider levels the lance and thrusts it ahead, then both settle back. Row 4, hurt: the dinosaur rears back with a surprised face, the rider tilts backward and the lance wobbles, then both recover. Row 5, defeat: the dinosaur sits down with its legs folding, the rider slides off its back, and both end lying still with tiny stars above their heads.
```

B04 · SPRITE SHEET 5x5 · Shield Bearer Worm (Era 2). Save as assets/sprites/units/p2_shield_bearer_worm_sheet.png.

```text
A small golden-yellow earthworm soldier with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a gold-and-turquoise striped Egyptian headdress, carrying a big round gold shield with a turquoise scarab beetle emblem in front of him and a short bronze spear. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks behind the shield, the headdress tails sway, and the eyes blink on frame 4. Row 2, walk loop: the worm moves like an inchworm with the shield held steady in front, the body arching and stretching forward. Row 3, attack: the shield pushes forward in a bash, the spear jabs out over the top edge, then both pull back. Row 4, hurt: the shield takes a hit and shakes, the body is pushed back and the eyes squeeze shut, then the worm braces again. Row 5, defeat: the shield tips forward and falls flat, the worm slides down behind it, and ends lying still with tiny stars above his head.
```

B05 · SPRITE SHEET 5x5 · Bow Worm (Era 2). Save as assets/sprites/units/p2_bow_worm_sheet.png.

```text
A small golden-yellow earthworm archer with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a white linen Egyptian headcloth with a thin gold band, holding a small curved wooden bow with an arrow. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks, the bow swings slightly in the hand, and the eyes blink on frame 4. Row 2, walk loop: the worm moves like an inchworm, arching up and stretching forward, the bow held at his side. Row 3, attack: the arrow is nocked, the string is pulled back with one eye closed over three frames, then the string is released and the bow springs forward, and the body relaxes. Row 4, hurt: the body flinches backward, the bow drops, the eyes squeeze shut, then the worm grabs the bow again. Row 5, defeat: the body wobbles, droops, slides down flat to the ground with the bow falling beside him, and ends lying still with tiny stars above his head.
```

B06 · SPRITE SHEET 5x5 · Cobra Charmer Worm (Era 2). Save as assets/sprites/units/p2_cobra_charmer_worm_sheet.png.

```text
A small golden-yellow earthworm musician with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a turquoise turban with a small gold jewel and playing a little wooden flute, while a friendly sand-yellow cobra with a gentle smile rises from a woven basket beside him. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character group, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the characters. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the worm sways side to side while playing, the cobra sways the opposite way in the basket, little musical notes float up, and both blink on frame 4. Row 2, walk loop: the worm moves like an inchworm while carrying the basket with the cobra peeking out and bobbing. Row 3, attack: the flute is blown harder, the cobra rises tall, flares its hood and strikes forward with its mouth open, then returns to the basket. Row 4, hurt: the worm flinches backward and the flute squeaks, the cobra ducks into the basket and peeks out, then both recover. Row 5, defeat: the flute drops, the worm droops and slides down flat, the cobra slumps over the basket rim, and both end still with tiny stars above their heads.
```

B07 · SPRITE SHEET 5x5 · Knight Worm (Era 3). Save as assets/sprites/units/p3_knight_worm_sheet.png.

```text
A small golden-yellow earthworm knight with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a tiny shiny steel helmet with a blue plume, holding a short sword and a blue-and-white kite shield. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks, the helmet plume sways, the sword tip bobs, and the eyes blink on frame 4. Row 2, walk loop: the worm moves like an inchworm with the shield forward and the sword at his side, the plume bouncing. Row 3, attack: the sword is lifted back, the body coils, then a big diagonal slash comes down and forward with the shield tucked in, and the body recovers. Row 4, hurt: the body flinches backward, the plume bends, the shield lifts and the eyes squeeze shut, then the worm recovers. Row 5, defeat: the helmet slides over the eyes, the worm droops and slides down flat, the sword and shield fall beside him, and he ends lying still with tiny stars above his head.
```

B08 · SPRITE SHEET 5x5 · Crossbow Worm (Era 3). Save as assets/sprites/units/p3_crossbow_worm_sheet.png.

```text
A small golden-yellow earthworm archer with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a brown hood and holding a wooden crossbow with a bolt loaded. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks, the hood tip sways, the crossbow rests in the arms, and the eyes blink on frame 4. Row 2, walk loop: the worm moves like an inchworm with the crossbow held up in front, the hood bobbing. Row 3, attack: the crossbow rises to eye level, one eye closes to aim, the trigger is squeezed, the crossbow kicks back as the bolt flies off, and the body relaxes. Row 4, hurt: the body flinches backward, the hood is pushed down over the eyes, the crossbow wobbles, then the worm recovers. Row 5, defeat: the worm droops and slides down flat to the ground with the crossbow falling beside him, and ends lying still with tiny stars above his head.
```

B09 · SPRITE SHEET 5x5 · Wizard Worm (Era 3). Save as assets/sprites/units/p3_wizard_worm_sheet.png.

```text
A small golden-yellow earthworm wizard with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a tall pointy deep-blue wizard hat with gold stars and holding a wand topped with a glowing golden star, sparkles floating around, with a wise and slightly dizzy smile. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks, the hat tip flops side to side, the wand star pulses and sparkles twinkle, and the eyes blink on frame 4. Row 2, walk loop: the worm moves like an inchworm with the wand held up, the hat bobbing and a few sparkles trailing behind. Row 3, attack: the wand is lifted high, swirled in a circle, then pointed forward and a golden star bolt bursts from the tip, and the body recoils slightly. Row 4, hurt: the body flinches backward, the hat flops over the eyes, sparkles scatter, then the worm straightens the hat. Row 5, defeat: the wand star flickers out, the worm droops and slides down flat with the hat covering his face, and ends lying still with tiny stars above his head.
```

B10 · SPRITE SHEET 5x5 · Gear Gunner Worm (Era 4). Save as assets/sprites/units/p4_gear_gunner_worm_sheet.png.

```text
A small golden-yellow earthworm gunner with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing brass goggles on his forehead and a small leather vest, holding a copper steam rifle. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks, small puffs of white steam rise from the rifle, the goggles glint, and the eyes blink on frame 4. Row 2, walk loop: the worm moves like an inchworm with the rifle on his shoulder, the goggles bouncing. Row 3, attack: the rifle is raised and aimed with a cocky grin, a puff of white steam shoots out with a recoil kick, then the rifle is lowered. Row 4, hurt: the body flinches backward, the goggles slip down over the eyes, the rifle sputters steam, then the worm recovers. Row 5, defeat: the rifle drops, the worm droops and slides down flat, steam fizzles out, and he ends lying still with tiny stars above his head.
```

B11 · SPRITE SHEET 5x5 · Boiler Tank Worm (Era 4). Save as assets/sprites/units/p4_boiler_tank_worm_sheet.png.

```text
A small golden-yellow earthworm driver with big round dark eyes and a small blue cloth headband as team color, peeking out of the hatch of a chunky round copper-and-brass steam tank with rivets, a tall chimney puffing white steam, small treads and a stubby cannon. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same vehicle with its driver, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the characters. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the tank body shudders gently, steam puffs rise from the chimney, and the driver blinks on frame 4. Row 2, drive loop: the treads roll, the tank bounces up and down as it moves, the chimney puffs faster, the driver holds on. Row 3, attack: the cannon barrel slides back, a flash and a puff of smoke shoot out of the muzzle, the whole tank rocks backward, then settles. Row 4, hurt: the tank rocks back, the driver ducks into the hatch and peeks out, a few rivets pop and sparks fly, then it recovers. Row 5, defeat: the chimney bends, steam leaks out in puffs, the tank tilts and sinks, the driver slumps out of the hatch, and it ends still with tiny stars above.
```

B12 · SPRITE SHEET 5x5 · Balloon Bomber Worm (Era 4). Save as assets/sprites/units/p4_balloon_bomber_worm_sheet.png.

```text
A small golden-yellow earthworm bomber with a cream-colored segmented belly, big round dark eyes, a small blue cloth headband as team color and brass goggles, hanging from a small wicker basket under a patched teal-and-cream hot-air balloon, holding a round black bomb with a lit sparking fuse. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same balloon and worm, side view facing right, with identical size, identical proportions and the same height in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the characters. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the balloon floats up and down gently, the basket sways below it, the bomb fuse sparkles, and the worm blinks on frame 4. Row 2, fly loop: the balloon tilts forward and drifts, the basket swings behind it, the ropes stretch and relax, the worm grins. Row 3, attack: the worm lifts the bomb over the basket edge, winds up, drops it with a mischievous grin, and the balloon bobs upward lighter. Row 4, hurt: the balloon squashes sideways, the basket swings wildly, a small patch rips and puffs of air escape, the worm holds on and recovers. Row 5, defeat: the balloon deflates and wrinkles, the basket drops down, the worm waves a tiny white flag, and everything ends still on the ground with tiny stars above.
```

B13 · SPRITE SHEET 5x5 · Laser Blade Worm (Era 5). Save as assets/sprites/units/p5_laser_blade_worm_sheet.png.

```text
A small golden-yellow earthworm warrior with big round dark eyes and a small blue cloth headband as team color, wearing a sleek white-and-teal helmet with a glowing cyan visor and light armor plates on his body, wielding a glowing cyan laser sword. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks, the laser sword hums and its glow pulses, the visor glints, and the eyes blink on frame 4. Row 2, dash loop: the worm moves in quick forward arches with the sword held back, a faint cyan trail behind him. Row 3, attack: the body coils back, the sword sweeps in a bright cyan arc from above to the front, the body lunges forward, and then pulls back. Row 4, hurt: the body flinches backward, the visor flickers, the armor plates rattle, then the worm raises the sword again. Row 5, defeat: the sword light flickers out, the worm droops and slides down flat, the visor goes dark, and he ends lying still with tiny stars above his head.
```

B14 · SPRITE SHEET 5x5 · Mecha Worm (Era 5). Save as assets/sprites/units/p5_mecha_worm_sheet.png.

```text
A small golden-yellow earthworm pilot with big round dark eyes and a small blue cloth headband as team color, sitting in the glass cockpit dome of a chunky white-and-blue walking mech with two stubby legs, rounded armor plates, glowing cyan joints and a small arm cannon. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same mech with its pilot, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the characters. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the mech sinks and rises slightly on its legs, the cyan joints pulse, the arm cannon swings a little, and the pilot blinks on frame 4. Row 2, walk loop: the mech steps with alternating stubby legs, the body bobbing, the pilot bouncing in the dome. Row 3, attack: the arm cannon lifts and glows, a bright cyan shot fires with a recoil kick backward, and the mech steadies. Row 4, hurt: the mech staggers backward, the cockpit dome flashes, sparks fly from one joint, then it steadies. Row 5, defeat: the joint lights go out one by one, the legs fold, the mech sits down and tilts, the pilot slumps in the dome, and it ends still with tiny stars above.
```

B15 · SPRITE SHEET 5x5 · Time Medic Worm (Era 5). Save as assets/sprites/units/p5_time_medic_worm_sheet.png.

```text
A small golden-yellow earthworm medic with big round dark eyes and a small blue cloth headband as team color, riding on top of a round white-and-teal hovering drone that holds a glowing golden-teal healing orb, wearing a tiny backpack marked with a gear symbol, with a calm kind smile. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same drone with its medic, side view facing right, with identical size, identical proportions and the same height in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the characters. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the drone hovers up and down, the healing orb pulses softly, the medic blinks on frame 4. Row 2, fly loop: the drone tilts forward and glides, a thin teal trail behind it, the backpack bouncing. Row 3, heal: the medic raises both arms, the orb grows bright and releases a ring of golden-teal light that expands outward, then the orb shrinks back. Row 4, hurt: the drone is knocked backward and spins slightly, the orb flickers, the medic holds on and recovers. Row 5, defeat: the orb goes dark, the drone sputters and sinks to the ground, the medic slides off, and everything ends still with tiny stars above.
```

## 10.5 Enemy units (SPRITE, facing left, red cloth accents)

Every enemy is a SPRITE SHEET 5x5 facing left with the same five rows: 1 idle, 2 walk (or fly), 3 attack, 4 hurt, 5 defeat. Ids C01 to C15.

C01 · SPRITE SHEET 5x5 · Ant Clubber (Era 1). Save as assets/sprites/enemies/e1_ant_clubber_sheet.png.

```text
A small black ant warrior with big round eyes and a comically angry snarl, a red cloth band tied around its head as team color, wearing a rough leather loincloth and carrying a heavy stone club. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body bobs up and down, the antennae twitch, the club rests on the shoulder, and the eyes blink on frame 4. Row 2, walk loop: the six legs step in alternating pairs, the body bobs, the club bounces on the shoulder. Row 3, attack: the club is lifted back over the head, the body leans back, then the club swings down and forward with a snarl, and the ant recovers. Row 4, hurt: the body flinches backward, the eyes squeeze shut, the antennae flatten, the club slips, and the ant recovers. Row 5, defeat: the legs wobble, the ant flips onto its back with the legs curled up and the club falling beside it, and ends still with tiny stars above.
```

C02 · SPRITE SHEET 5x5 · Ant Spitter (Era 1). Save as assets/sprites/enemies/e1_ant_spitter_sheet.png.

```text
A small black ant with big round eyes and puffed cheeks, a red cloth band tied around its head as team color, holding a long bone blowpipe to its mouth with a glowing drop of green acid at the tip. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body bobs up and down, the antennae twitch, the green drop wobbles at the tip of the blowpipe, and the eyes blink on frame 4. Row 2, walk loop: the six legs step in alternating pairs with the blowpipe held at the side. Row 3, attack: the cheeks puff up, the blowpipe lifts to the mouth, a green acid glob shoots out with a recoil, and the cheeks deflate. Row 4, hurt: the body flinches backward, the blowpipe jerks, the cheeks deflate with a squeak, and the ant recovers. Row 5, defeat: the legs wobble, the ant flips onto its back with the blowpipe falling beside it, and ends still with tiny stars above.
```

C03 · SPRITE SHEET 5x5 · Stone Beetle (Era 1). Save as assets/sprites/enemies/e1_stone_beetle_sheet.png.

```text
A chunky brown beetle with a thick shell made of gray rock slabs with patches of green moss, small grumpy eyes, and a red cloth band tied around one horn as team color. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the heavy shell rises and sinks as it breathes, the horn tilts, and the eyes blink on frame 4. Row 2, walk loop: the short legs stomp slowly one after another and the shell rocks side to side like a walking boulder. Row 3, attack: the beetle rears back, lowers the horn, and rams forward with a head butt, then pulls back. Row 4, hurt: the shell cracks with a small dust puff, the body is knocked back, the eyes squeeze shut, and it recovers. Row 5, defeat: the legs give way, the body drops, the shell breaks into slabs, and it ends flat on the ground with tiny stars above.
```

C04 · SPRITE SHEET 5x5 · Scarab Soldier (Era 2). Save as assets/sprites/enemies/e2_scarab_soldier_sheet.png.

```text
A golden scarab beetle soldier with a shiny turquoise-edged shell, big round eyes, a red cloth sash across its body as team color, wearing a small gold helmet and carrying a curved bronze blade. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body bobs, the blade tip sways, the shell glints, and the eyes blink on frame 4. Row 2, march loop: the legs step in alternating pairs with the blade held up, the body bobbing proudly. Row 3, attack: the blade is raised back, the body leans, then a diagonal slash comes down and forward, and the beetle recovers. Row 4, hurt: the body flinches backward, the helmet tilts, the blade wobbles, and it recovers. Row 5, defeat: the legs wobble, the beetle falls onto its shell with the legs in the air and the blade falling beside it, and ends still with tiny stars above.
```

C05 · SPRITE SHEET 5x5 · Locust Archer (Era 2). Save as assets/sprites/enemies/e2_locust_archer_sheet.png.

```text
A slender green-and-brown locust with long bent back legs and big round eyes, a red cloth band tied around its head as team color, holding a small curved bow with an arrow, with a sly smirk. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body crouches and rises slightly, the antennae twitch, the back legs flex, and the eyes blink on frame 4. Row 2, hop loop: the locust crouches, springs forward in a small hop with the back legs extended, and lands. Row 3, attack: the arrow is nocked, the string pulled back with a smirk over three frames, then released as the bow springs forward, and the body relaxes. Row 4, hurt: the body flinches backward, the bow drops, the antennae flatten, and it grabs the bow again. Row 5, defeat: the long legs fold, the locust topples sideways with the bow beside it, and ends still with tiny stars above.
```

C06 · SPRITE SHEET 5x5 · Mummy Moth (Era 2). Save as assets/sprites/enemies/e2_mummy_moth_sheet.png.

```text
A fluffy beige moth with soft dusty wings loosely wrapped in old linen bandages, big sleepy round eyes, a red cloth ribbon tied on one wing as team color, holding a fresh roll of bandage in one leg with a gentle caring expression. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the wings flutter slowly up and down, the body hovers, a loose bandage end sways, and the eyes blink on frame 4. Row 2, fly loop: the wings flap in a full cycle while the body glides forward and the bandage trails behind. Row 3, heal: the moth unrolls the bandage, swirls it in a circle, and a soft golden glow ring expands outward, then the bandage rolls back. Row 4, hurt: the wings fold in, the body is pushed backward, bandages flutter loose, and it recovers. Row 5, defeat: the wings stop, the bandages unwind, the moth drifts down and lands flat, and ends still with tiny stars above.
```

C07 · SPRITE SHEET 5x5 · Beetle Knight (Era 3). Save as assets/sprites/enemies/e3_beetle_knight_sheet.png.

```text
A sturdy dark-brown beetle knight with a shiny steel helmet topped with a red plume, steel shoulder plates, big round eyes, carrying a long lance and a small shield with a red emblem. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body rises and sinks as it breathes, the plume sways, the lance tip bobs, and the eyes blink on frame 4. Row 2, march loop: the legs step in alternating pairs, the shield held forward, the plume bouncing. Row 3, attack: the lance is pulled back, the body leans, then it thrusts the lance forward with a stern look and pulls back. Row 4, hurt: the body flinches backward, the shield jerks up, the plume bends, and it recovers. Row 5, defeat: the helmet slides over the eyes, the knees give way, the beetle falls onto its side with the lance and shield beside it, and ends still with tiny stars above.
```

C08 · SPRITE SHEET 5x5 · Dung Catapult (Era 3). Save as assets/sprites/enemies/e3_dung_catapult_sheet.png.

```text
A stout dung beetle with big round eyes pushing a small wooden catapult on two wheels that is loaded with a round brown ball, a red banner flag attached to the catapult as team color, wearing a tiny leather cap and a mischievous grin. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same beetle and catapult, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the characters. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the beetle breathes, the banner flaps, the arm of the catapult rocks slightly, and the eyes blink on frame 4. Row 2, push loop: the beetle pushes the catapult forward with its legs stepping, the wheels turning, the banner flapping. Row 3, attack: the beetle pulls a lever, the catapult arm swings forward and flings the ball, the whole catapult shakes, and it resets. Row 4, hurt: the catapult is knocked backward, a wheel wobbles, the beetle's cap flies up and it recovers. Row 5, defeat: a wheel falls off, the catapult tips over, the beetle tumbles flat beside it, and everything ends still with tiny stars above.
```

C09 · SPRITE SHEET 5x5 · Hornet Scout (Era 3, flying). Save as assets/sprites/enemies/e3_hornet_scout_sheet.png.

```text
A small yellow-and-black striped hornet flying with blurry translucent wings, big round determined eyes, wearing a tiny leather helmet and a red cloth scarf as team color, holding a small spear pointed forward. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, hover loop: the wings buzz in blurry up and down positions, the body bobs slightly, the scarf flutters, and the eyes blink on frame 4. Row 2, flight loop: the body tilts forward, the wings flap fast, the scarf streams behind, the spear points ahead. Row 3, attack: the hornet pulls back, then dives forward and thrusts the spear, and swings back up. Row 4, hurt: the body is knocked backward and spins slightly, the wings stutter, the scarf whips, and it recovers. Row 5, defeat: the wings stop, the helmet falls off, the hornet spirals downward and lands flat, and ends still with tiny stars above.
```

C10 · SPRITE SHEET 5x5 · Cog Roach (Era 4). Save as assets/sprites/enemies/e4_cog_roach_sheet.png.

```text
A clockwork cockroach with brass body plates, visible gears and rivets on its back, big round eyes, a red cloth band tied around its head as team color, carrying a big iron wrench over its shoulder with a cheeky grin. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the back gears turn slowly, the body bobs, the antennae twitch, and the eyes blink on frame 4. Row 2, run loop: the six legs run in fast alternating pairs, the body leaning forward, the wrench bouncing on the shoulder. Row 3, attack: the wrench is lifted behind the head, the body coils, then the wrench swings down and forward and the roach recovers. Row 4, hurt: the body flinches backward, a gear pops off, sparks fly, and it recovers. Row 5, defeat: the gears slow and stop, the legs fold, the roach flips onto its back with the wrench falling beside it, and ends still with tiny stars above.
```

C11 · SPRITE SHEET 5x5 · Spark Fly (Era 4, flying). Save as assets/sprites/enemies/e4_spark_fly_sheet.png.

```text
A mechanical firefly with a copper body, tiny propeller wings, big round eyes and a glass-lantern abdomen crackling with blue-white electricity, a red cloth ribbon tied to one antenna as team color, with a playful grin. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, hover loop: the propellers spin in blurry positions, the body bobs, the lantern glow pulses, and the eyes blink on frame 4. Row 2, flight loop: the body tilts forward, the propellers spin fast, the ribbon streams behind, small sparks trail. Row 3, attack: the lantern glows brighter, the body curls back, then a bolt of blue-white electricity zaps forward from the lantern, and the glow dims. Row 4, hurt: the body is knocked backward, the lantern flickers, sparks fly, and it recovers. Row 5, defeat: the lantern goes dark, the propellers slow and stop, the firefly drops to the ground and ends still with tiny stars above.
```

C12 · SPRITE SHEET 5x5 · Clank Crab (Era 4). Save as assets/sprites/enemies/e4_clank_crab_sheet.png.

```text
A heavy steam-powered crab with riveted iron shell plates, brass pipes releasing puffs of white steam, two big riveted claws, small angry round eyes on stalks and a small red flag on its back as team color. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the claws open and close slowly, the steam puffs from the pipes, the eye stalks wobble, and the eyes blink on frame 4. Row 2, scuttle loop: the legs step in quick alternating pairs, the body shakes from side to side, the steam puffs faster. Row 3, attack: both claws are lifted high, then slammed down and forward with a clank, and the crab pulls back. Row 4, hurt: the shell dents with a spark, the body is knocked backward, the eye stalks droop, and it recovers. Row 5, defeat: a pipe bursts with steam, the legs fold, the crab sinks flat and tips over, and ends still with tiny stars above.
```

C13 · SPRITE SHEET 5x5 · Laser Bug (Era 5). Save as assets/sprites/enemies/e5_laser_bug_sheet.png.

```text
A round armored beetle robot in dark gunmetal gray with a glowing red visor, a small laser cannon mounted on its back, thin red stripes on its shell as team color and six small legs, with a menacing but cute look. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body hovers just above the ground rising and sinking, the red visor pulses, the cannon on the back rotates slightly, and the visor blinks on frame 4. Row 2, walk loop: the six legs step in alternating pairs, the body bobbing, the visor glowing steadily. Row 3, attack: the cannon on the back swivels forward, charges with a growing red glow, fires a red bolt with a recoil kick, and cools down. Row 4, hurt: the body is knocked backward, the visor flickers white, a leg twitches, and it recovers. Row 5, defeat: the visor goes dark, the cannon droops, the legs fold, the shell opens a little with sparks, and it ends still with tiny stars above.
```

C14 · SPRITE SHEET 5x5 · Drone Fly (Era 5, flying). Save as assets/sprites/enemies/e5_drone_fly_sheet.png.

```text
A hovering robotic fly with a dark gray metal body, large glassy lens eyes, thin transparent propeller wings, tiny claws and a small blinking red light on its head as team color, with a mischievous look. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, hover loop: the propeller wings blur in different positions, the body bobs slightly, the red light blinks, and the lens eyes flash on frame 4. Row 2, flight loop: the body tilts forward, the wings spin fast, the claws tuck under the body. Row 3, attack: the drone pulls back, dives forward with the claws extended to grab and swipe, and returns up. Row 4, hurt: the body is knocked backward and spins slightly, the red light flickers, a wing stutters, and it recovers. Row 5, defeat: the wings stop, the light goes dark, the drone drops to the ground with a bounce, and ends still with tiny stars above.
```

C15 · SPRITE SHEET 5x5 · Mecha Beetle (Era 5). Save as assets/sprites/enemies/e5_mecha_beetle_sheet.png.

```text
A huge armored rhinoceros-beetle robot in dark gunmetal gray with glowing red joints, thick sturdy legs, a big horn that doubles as a cannon and a small red emblem on its shell as team color, imposing but still cute. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body rises and sinks heavily as it breathes, the red joints pulse, the horn tilts, and the eyes blink on frame 4. Row 2, stomp loop: the thick legs stomp one after another, the body rocks side to side and the horn bobs. Row 3, attack: the horn lowers and glows red, a charged shot fires from the horn with a strong recoil that pushes the body backward, and it settles. Row 4, hurt: a plate cracks with sparks, the body is knocked backward, the joints flicker, and it recovers. Row 5, defeat: the red joints go out one by one, the legs fold, the body crashes down with a dust puff, and it ends still with tiny stars above.
```

## 10.6 Bosses (SPRITE, facing left)

Every boss is a SPRITE SHEET 5x5 facing left with the same five rows: 1 idle, 2 walk, 3 attack, 4 hurt, 5 defeat. Bosses fill most of each cell.

D01 · SPRITE SHEET 5x5 · Rexy the T-Rex (Era 1 boss). Save as assets/sprites/bosses/b1_rexy_sheet.png.

```text
Rexy, a big chubby green T-Rex with a cream belly, comically tiny arms, a huge goofy toothy grin and small round eyes, a red cloth bandana tied around his neck and a necklace of colorful stones. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character filling most of the cell, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with a small empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the belly rises and sinks as he breathes, the tail sways, the tiny arms twitch, and the eyes blink on frame 4. Row 2, walk loop: heavy stomps with alternating legs, the body bobbing, the tail swinging and the necklace bouncing. Row 3, attack: he rears back, takes a big breath, then lunges forward and chomps with a loud roar, the tail swinging the other way. Row 4, hurt: the head jerks back, the eyes squeeze shut, the tiny arms flail, the body staggers, and he recovers. Row 5, defeat: the legs wobble, he sits down with a thud, topples onto his side with his tongue out, and ends still with tiny stars above.
```

D02 · SPRITE SHEET 5x5 · Pharaoh Scarab (Era 2 boss). Save as assets/sprites/bosses/b2_pharaoh_scarab_sheet.png.

```text
The Pharaoh Scarab, a giant golden scarab beetle with a shiny turquoise-and-gold shell, a tall striped royal pharaoh headdress, big dramatic eyes, a red cloth cape draped over his back, holding a golden crook and flail, wearing a solemn proud grin. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character filling most of the cell, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with a small empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the shell glints, the cape sways, the crook and flail hang still, and the eyes blink on frame 4. Row 2, walk loop: the legs step in slow alternating pairs, the cape flowing behind, the headdress bobbing. Row 3, attack: the flail is raised over the head, spun once, then slammed down and forward while golden dust bursts from the impact. Row 4, hurt: the headdress tips, the body is pushed back, the shell shows a small crack, and he straightens. Row 5, defeat: the headdress falls off, the legs fold, the scarab sinks flat with the cape covering him, and ends still with tiny stars above.
```

D03 · SPRITE SHEET 5x5 · Sir Sizzle the Dragon (Era 3 boss). Save as assets/sprites/bosses/b3_sir_sizzle_sheet.png.

```text
Sir Sizzle, a chubby red-orange dragon with small leathery wings, a cream belly and big round eyes, wearing a dented tin knight helmet that is too small for his head, little curls of smoke rising from his nostrils and a red banner tied to his tail. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character filling most of the cell, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with a small empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: smoke curls rise from the nostrils, the helmet wobbles, the wings twitch, the banner sways, and the eyes blink on frame 4. Row 2, walk loop: clumsy waddling steps with alternating legs, the wings flapping slightly and the helmet bouncing. Row 3, attack: he inhales so the belly swells, the head rears back, then he breathes a big cartoon fireball forward with the helmet flying up, and the belly shrinks. Row 4, hurt: the helmet is knocked over his eyes, the body is pushed back, the wings flare, and he straightens it. Row 5, defeat: the helmet clangs off, the legs give way, he sits then flops backward with a puff of smoke, and ends still with tiny stars above.
```

D04 · SPRITE SHEET 5x5 · The Clockwork Queen (Era 4 boss). Save as assets/sprites/bosses/b4_clockwork_queen_sheet.png.

```text
The Clockwork Queen, a large mechanical spider with a brass-and-copper body, a small golden crown, visible gears and rivets, six thin jointed legs, a glass-dome abdomen full of swirling white steam, glowing red eyes and a red silk sash across her body. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character filling most of the cell, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with a small empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the steam swirls in the dome, the gears turn, the legs shift slightly, and the red eyes blink on frame 4. Row 2, walk loop: the thin legs step in alternating groups, the body rising and sinking, the sash fluttering. Row 3, attack: the front legs rise, the dome glows and the queen releases a burst of hot steam forward while the front legs stab down. Row 4, hurt: the crown tilts, the body is pushed backward, gears spit out, sparks fly, and she recovers. Row 5, defeat: the glow in the dome fades, the legs fold one by one, the crown rolls off, the body sinks with a puff of steam, and she ends still with tiny stars above.
```

D05 · SPRITE SHEET 5x5 · Count Magpie 3000 (Era 5 final boss). Save as assets/sprites/bosses/b5_count_magpie_3000_sheet.png.

```text
Count Magpie 3000, a giant mechanical magpie with chrome-and-indigo plating, glowing cyan eyes, a metal top hat, a gold monocle, wings made of shiny metal blades and a red cape, clutching a glowing golden Chrono Core shard in one claw, wearing a smug grin. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character filling most of the cell, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with a small empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the chest puffs up and down, the blade wings flex, the shard in the claw glows and pulses, the cape sways, and the eyes blink on frame 4. Row 2, walk loop: proud strutting steps with alternating legs, the head bobbing, the cape flowing behind. Row 3, attack: the wings spread wide, the shard glows brighter, the claw swings forward and releases a golden-cyan time wave, and the wings fold back. Row 4, hurt: the top hat flies off, the monocle flashes, the body is pushed backward, sparks fly, and he recovers. Row 5, defeat: the cyan eyes flicker out, the wings droop, the shard falls from the claw, the body tips over with a shower of sparks, and he ends still with tiny stars above.
```

## 10.7 Bases (SPRITE)

Player bases open to the right and use blue accents. Enemy bases open to the left and use red accents.

E01 · SPRITE · Player base, Era 1. Save as assets/sprites/bases/base_p1.png

```text
A cozy prehistoric worm burrow base: a big round dirt mound with a dark round hole as the entrance, a thatched leaf roof on top, a small bone fence, a little campfire, big green ferns at its sides and a small blue cloth flag on a wooden stick. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing right, centered with a wide empty margin, with only a small patch of ground directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

E02 · SPRITE · Player base, Era 2. Save as assets/sprites/bases/base_p2.png

```text
A small sandstone pyramid-shaped worm burrow base with a dark arched doorway, simple carved hieroglyph patterns, a turquoise gem at the peak, a blue banner hanging from the top and a little palm tree beside it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing right, centered with a wide empty margin, with only a small patch of sand directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

E03 · SPRITE · Player base, Era 3. Save as assets/sprites/bases/base_p3.png

```text
A small cozy stone castle tower with tiny battlements, a sturdy wooden gate, ivy climbing the walls, an arched window glowing with warm candlelight and a blue-and-white banner on a pole at the top. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing right, centered with a wide empty margin, with only a small patch of grass directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

E04 · SPRITE · Player base, Era 4. Save as assets/sprites/bases/base_p4.png

```text
A brass-and-copper steam fortress with two round riveted towers, tall chimneys puffing white steam, big turning gears on the walls, a glowing furnace-door entrance and a blue flag on top. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing right, centered with a wide empty margin, with only a small iron platform directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

E05 · SPRITE · Player base, Era 5. Save as assets/sprites/bases/base_p5.png

```text
A futuristic white-and-teal glass dome base with a glowing cyan ring around it, an antenna topped with a blue light, a small landing pad, a round sliding door entrance and a few small floating panels around it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing right, centered with a wide empty margin, with only a small floating metal platform directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

E06 · SPRITE · Enemy base, Era 1. Save as assets/sprites/bases/base_e1.png

```text
A tall brown anthill fortress with a dark tunnel entrance, sharp wooden and bone spikes around it, simple tribal paint marks on the dirt and a red cloth flag on a bone pole at the top. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing left, centered with a wide empty margin, with only a small patch of ground directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

E07 · SPRITE · Enemy base, Era 2. Save as assets/sprites/bases/base_e2.png

```text
A golden scarab temple with sandstone columns, a big golden scarab beetle statue on its roof, a dark entrance with a stepped front and red banners hanging at both sides. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing left, centered with a wide empty margin, with only a small patch of sand directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

E08 · SPRITE · Enemy base, Era 3. Save as assets/sprites/bases/base_e3.png

```text
A dark slate-gray castle with tall pointed towers, a heavy iron gate, small flickering torches and red banners with a beetle emblem hanging from the walls, looking grumpy but still cute. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing left, centered with a wide empty margin, with only a small patch of rocky ground directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

E09 · SPRITE · Enemy base, Era 4. Save as assets/sprites/bases/base_e4.png

```text
A grimy iron factory fortress with tall smokestacks pouring dark gray smoke, giant gears on the front wall, pipes, small glowing red lights, a heavy riveted iron gate and a red flag on the roof. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing left, centered with a wide empty margin, with only a small iron platform directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

E10 · SPRITE · Enemy base, Era 5. Save as assets/sprites/bases/base_e5.png

```text
A black-and-gunmetal crystal spire base on a small floating rock, with glowing red cracks and red energy lines running up the walls, a round dark gate entrance and small red warning lights. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing left, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

## 10.8 Projectiles and effects (SPRITE)

F01 · SPRITE · Stone. Save as assets/sprites/fx/proj_stone.png

```text
A single round gray stone with a few small cracks and a tiny motion swoosh behind it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single small object, side view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

F02 · SPRITE · Arrow. Save as assets/sprites/fx/proj_arrow.png

```text
A single small wooden arrow with a gray stone tip and white feather fletching, pointing right, with a faint motion swoosh behind it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single small object, side view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

F03 · SPRITE · Steam cannonball. Save as assets/sprites/fx/proj_cannonball.png

```text
A single round iron cannonball with a brass band and small rivets, trailing a small puff of white steam behind it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single small object, side view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

F04 · SPRITE · Laser bolt. Save as assets/sprites/fx/proj_laser.png

```text
A single short glowing cyan laser bolt shaped like a rounded capsule with a bright white core and a soft cyan glow, pointing right. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single small object, side view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

F05 · SPRITE · Magic star bolt. Save as assets/sprites/fx/proj_magic_star.png

```text
A single glowing golden five-pointed star with a soft warm glow and two tiny sparkles trailing behind it, tilted slightly as if flying to the right. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single small object, side view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

F06 · SPRITE · Impact burst. Save as assets/sprites/fx/fx_impact.png

```text
A single comic-style impact burst shaped like a rounded starburst with a bright yellow center, an orange outer ring and a few small white sparks flying outward. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single small object, front view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

## 10.9 Icons (SPRITE)

G01 · SPRITE · Coin icon. Save as assets/sprites/icons/icon_coin.png

```text
A shiny round gold coin with a tiny smiling worm face embossed in the center, a raised rim and a small white sparkle on one edge. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

G02 · SPRITE · Food icon. Save as assets/sprites/icons/icon_food.png

```text
A shiny juicy red apple with a short brown stem, one green leaf and a tiny bite mark on one side, with a small white highlight. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

G03 · SPRITE · Gem icon. Save as assets/sprites/icons/icon_gem.png

```text
A faceted teal-blue gem shaped like a rounded diamond with bright white highlights on its facets and two tiny sparkles beside it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

G04 · SPRITE · Chrono Dust icon. Save as assets/sprites/icons/icon_chrono_dust.png

```text
A small glowing mound of golden-and-teal sparkling dust with a few tiny gear shapes mixed in and little stars floating above it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

G05 · SPRITE · Time Capsule icon. Save as assets/sprites/icons/icon_capsule.png

```text
A glossy egg-shaped time capsule split into a golden half and a teal half, with a small round clock face in the middle, tiny gears around the seam and a few sparkles around it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

G06 · SPRITE · Power icon: Squirm Slam. Save as assets/sprites/icons/power_squirm_slam.png

```text
The round orange head of a cute worm slamming into the ground with a big starburst shockwave, cracks spreading in the dirt and small chunks of earth flying up. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

G07 · SPRITE · Power icon: Apple Rain. Save as assets/sprites/icons/power_apple_rain.png

```text
Three shiny red apples with green leaves falling diagonally from the top with small motion lines and tiny sparkles. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

G08 · SPRITE · Power icon: Time Freeze. Save as assets/sprites/icons/power_time_freeze.png

```text
A round golden pocket watch frozen inside pale-blue ice crystals, with small icicles hanging from it and snowflake sparkles around it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

G09 · SPRITE · Power icon: Rewind. Save as assets/sprites/icons/power_rewind.png

```text
A round golden clock face with a big curved teal arrow circling counterclockwise around it and small gears and sparkles behind it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

G10 · SPRITE · Power icon: Dirt Shield. Save as assets/sprites/icons/power_dirt_shield.png

```text
A sturdy round shield made of packed brown dirt with small pebbles pressed into it and a tiny green sprout growing from the top, with a thin golden rim. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

G11 · SPRITE · Power icon: Fast-Forward. Save as assets/sprites/icons/power_fast_forward.png

```text
Two bold golden chevron arrows pointing right in front of a small round clock face, with speed lines trailing behind them and a few sparkles. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

G12 · SPRITE · Era badge: Stone Age. Save as assets/sprites/icons/era_1.png

```text
A round stone medallion with a carved dinosaur footprint in the center, a small green fern leaf on one side and a rough chiseled rim. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

G13 · SPRITE · Era badge: Ancient Egypt. Save as assets/sprites/icons/era_2.png

```text
A round golden medallion with a turquoise scarab beetle in the center, a decorative border of tiny triangles and a polished shine. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

G14 · SPRITE · Era badge: Medieval. Save as assets/sprites/icons/era_3.png

```text
A round silver medallion with a tiny castle tower and a blue-and-white banner in the center, a studded rim and a soft metallic shine. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

G15 · SPRITE · Era badge: Industrial. Save as assets/sprites/icons/era_4.png

```text
A round copper medallion with two interlocking brass gears in the center, a small puff of white steam rising from the top and a riveted rim. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

G16 · SPRITE · Era badge: Far Future. Save as assets/sprites/icons/era_5.png

```text
A round deep-indigo medallion with a glowing cyan ringed planet in the center, tiny white stars around it and a sleek metallic rim with cyan light. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

## 10.10 Backgrounds, story panels and store art (IMAGE, except the logo)

The game is portrait, so backgrounds are tall 9:16 images with a horizontal lane (the path) across the middle where units walk left and right. Story panels stay wide 16:9 and are shown full width at the top of the screen.

H01 · IMAGE · Battle background, Era 1 (portrait). Save as assets/images/backgrounds/bg_era1.png.

```text
A sunny prehistoric jungle valley with giant ferns, tall palm-like trees, a smoking volcano far in the distance, a calm blue sky with soft clouds, a few gentle dinosaur silhouettes very far away and a flat packed-dirt path running horizontally across the middle of the image, warm morning light. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Tall 9:16 portrait image with no characters, no text, no logos and no UI. Place the horizontal path at about 55 to 62 percent of the image height, keep the top 12 percent calm for the game HUD, and keep the bottom 30 percent calm and low-contrast so game buttons stay readable.
```

H02 · IMAGE · Battle background, Era 2 (portrait). Save as assets/images/backgrounds/bg_era2.png.

```text
A hot Egyptian desert at noon with golden sand dunes, three sandstone pyramids in the distance, a small stretch of blue river with papyrus reeds and a few palm trees, a pale turquoise sky and a flat packed-sand path running horizontally across the middle of the image. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Tall 9:16 portrait image with no characters, no text, no logos and no UI. Place the horizontal path at about 55 to 62 percent of the image height, keep the top 12 percent calm for the game HUD, and keep the bottom 30 percent calm and low-contrast so game buttons stay readable.
```

H03 · IMAGE · Battle background, Era 3 (portrait). Save as assets/images/backgrounds/bg_era3.png.

```text
A green medieval kingdom with rolling hills, a small stone castle far in the distance, two windmills, colorful banners on poles, wooden fences, a soft afternoon sky with fluffy clouds and a flat stone-brick path running horizontally across the middle of the image. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Tall 9:16 portrait image with no characters, no text, no logos and no UI. Place the horizontal path at about 55 to 62 percent of the image height, keep the top 12 percent calm for the game HUD, and keep the bottom 30 percent calm and low-contrast so game buttons stay readable.
```

H04 · IMAGE · Battle background, Era 4 (portrait). Save as assets/images/backgrounds/bg_era4.png.

```text
An industrial steam city at dusk with tall brass towers, giant pipes, chimneys puffing white and teal smoke, big gears hanging in the sky, a few hot-air balloons far away, glowing warm orange windows and a flat iron-plated cobblestone path running horizontally across the middle of the image. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Tall 9:16 portrait image with no characters, no text, no logos and no UI. Place the horizontal path at about 55 to 62 percent of the image height, keep the top 12 percent calm for the game HUD, and keep the bottom 30 percent calm and low-contrast so game buttons stay readable.
```

H05 · IMAGE · Battle background, Era 5 (portrait). Save as assets/images/backgrounds/bg_era5.png.

```text
A floating futuristic platform in deep space with a huge ringed planet, twinkling stars, a soft violet-white nebula, glowing neon cyan lines, small floating panels, tiny distant spaceships and a flat glowing metal path running horizontally across the middle of the image. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Tall 9:16 portrait image with no characters, no text, no logos and no UI. Place the horizontal path at about 55 to 62 percent of the image height, keep the top 12 percent calm for the game HUD, and keep the bottom 30 percent calm and low-contrast so game buttons stay readable.
```

H06 · IMAGE · Title and Home background (portrait). Save as assets/images/backgrounds/bg_home.png.

```text
A cozy garden at golden hour with soft grass, big colorful flowers, a small dirt burrow hole with a tiny wooden door in the lower left, and high in the sky a glowing golden-and-teal swirling time portal made of clockwork gears and light. Leave the upper center calm and empty for a logo. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Tall 9:16 portrait image with no characters, no text, no logos and no UI.
```

H07 · IMAGE · World map (portrait). Save as assets/images/backgrounds/world_map.png.

```text
A hand-painted storybook treasure map on aged cream paper with a winding dotted path running from the bottom to the top through five regions stacked vertically: a jungle with a smoking volcano, a desert with pyramids, green hills with a castle, a steampunk city with chimneys and a floating space island with a ringed planet, plus a small clockwork compass in one corner. Leave the path areas clear and open. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Tall 9:16 portrait image with no characters, no text, no labels, no logos and no UI.
```

H08 · SPRITE · Game logo (cut out on magenta). Save as assets/images/ui/logo.png

```text
A game logo with the words "Worm Warriors" spelled exactly, written in chunky rounded hand-painted letters in warm orange with a thick teal outline, a small cute bright-green worm wearing a black baseball cap with a letter A peeking playfully over the top of the first letter, and below it a smaller golden banner shaped like a clock gear with the words "Lost in Time" spelled exactly. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no gradient and no border. Crisp clean edges. Do not use magenta or pink anywhere on the logo. Square 1:1 image.
```

H09 · IMAGE · Story panel 1: the discovery. Save as assets/images/story/story_01_discovery.png

```text
Two small earthworms in a sunny garden looking at a glowing golden-and-teal clockwork orb resting in the grass: Squirmy, a bright-green worm with a lighter yellow-green belly, big brown eyes, small hands and a black baseball cap with a letter A, and Wormina, a soft-pink worm with long wavy pink hair, round glasses, braces and a white daisy in her hair, both leaning forward with curiosity. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, warm light, comic-book panel composition with no text, no logos and no UI.
```

H10 · IMAGE · Story panel 2: Wormina disappears. Save as assets/images/story/story_02_vanish.png

```text
A dramatic bright flash as Wormina, a soft-pink worm with long wavy pink hair, round glasses and a white daisy in her hair, is pulled into a glowing golden-and-teal clockwork orb in a swirl of golden light and flying gears, while Squirmy, a bright-green worm with a lighter yellow-green belly and a black baseball cap with a letter A, reaches out in shock, his cap flying off in the wind. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, dynamic comic-book panel composition with no text, no logos and no UI.
```

H11 · IMAGE · Story panel 3: the portal. Save as assets/images/story/story_03_portal.png

```text
Seen from behind, a small bright-green earthworm with a black baseball cap worn backward-tilted stands bravely in front of a huge swirling teal-and-gold time portal in the sky, with small glimpses inside the portal of a dinosaur valley, a pyramid, a castle, a steam city and a planet in space. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, epic and funny mood, comic-book panel composition with no text, no logos and no UI.
```

H12 · IMAGE · Story panel 4: the reunion. Save as assets/images/story/story_04_reunion.png

```text
Two small earthworms reunited and snuggling together in a garden at sunset: a bright-green worm with a lighter yellow-green belly and a black baseball cap with a letter A, and a soft-pink worm with long wavy pink hair, round glasses, braces and a white daisy in her hair, with a repaired glowing golden-and-teal clockwork orb resting softly in the grass and one black-and-white feather floating down. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, warm and tender mood, comic-book panel composition with no text, no logos and no UI.
```

H13 · IMAGE · App icon. Save as assets/images/store/app_icon.png

```text
A square mobile game app icon showing a close-up of Squirmy, a cheerful bright-green earthworm with big round brown eyes with white highlights, a lighter yellow-green belly, soft peach-pink cheeks and a black baseball cap with a letter A, with a brave grin, in front of a glowing golden clockwork gear and a swirl of teal and golden light that fills the whole background. Bold simple composition that stays readable at a small size, subject centered with a small margin, full-bleed background. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin dark-green ink outlines, cute rounded shapes and friendly saturated colors. No text, no logos and no border. Square 1:1 image.
```

H14 · IMAGE · Google Play feature graphic. Save as assets/images/store/feature_graphic.png

```text
A wide banner scene of a bright-green earthworm hero with a black baseball cap with a letter A leading a line of small golden-yellow worm soldiers dressed for different eras (a caveman fur tunic, an Egyptian headdress, a knight helmet, steampunk goggles and a futuristic visor) toward the right, in front of a huge glowing golden-and-teal time portal, with a big sky full of clouds and gears. Leave the left third calm and open for a title to be added later. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 2:1 landscape image with no text, no logos and no UI.
```

H15 · IMAGE · Paper texture for UI panels. Save as assets/images/ui/paper_texture.png

```text
A flat evenly lit warm cream paper texture with subtle watercolor stains, tiny paper fibers and soft slightly darker edges, with no objects, no patterns and no text, suitable as a repeating background for menu panels. Storybook watercolor style with soft hand-painted washes and subtle paper grain. Square 1:1 image.
```

## 10.11 Asset checklist for Claude Code

Total 89 prompts (39 of them are 5x5 sprite sheets: hero, 3 skins, 15 units, 15 enemies and 5 bosses): 7 characters and skins, 15 player units, 15 enemies, 5 bosses, 10 bases, 6 projectiles and effects, 16 icons, 15 images (one of them, the logo, is a cut-out). Claude Code should:

- Create a manifest assets/manifest.json listing every ID, file path, type (IMAGE or SPRITE), target size and whether it is present.
- Use clearly marked placeholder rectangles for missing art so the game is playable before all art arrives.
- Run tools/process_sprites.py on any new SPRITE: remove magenta (with edge cleanup), trim, resize to the target, export PNG. For SPRITE SHEET 5x5: cut the image into a 5x5 grid of equal cells, remove magenta, trim every frame with the same crop box so frames stay aligned (anchor at the feet), resize, and write one PNG per frame plus a manifest entry with the five rows (idle, walk, attack, hurt, defeat), frame rates and hit_frame.
- Fail the build only on missing assets that the current phase requires.
