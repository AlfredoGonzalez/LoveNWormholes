# 05 · Rediseño de interfaz (Hito 6)

Basado en tu prototipo de Unity. Detalle del recorrido y las pantallas: [`docs/DESIGN.md`](../docs/DESIGN.md). **Importante:** nada de esto lleva texto incrustado (los textos los pone el juego en español e inglés).

---

## Intro y capítulos de historia

Al abrir el juego por primera vez se muestran 3 paneles de cómic que van apareciendo sobre el fondo de papel (toca para continuar). Al llegar a una era nueva, aparece su panel de capítulo. Los paneles NO llevan texto: los diálogos los escribe el juego en ES/EN.

### `intro_bg.png`
**Archivo:** `intro_bg.png` → `public/assets/story/` · **Tamaño final:** 1080×1920 px · ✅ el juego ya lo usa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Full-screen game background: cream paper background with a faint tone-on-tone pattern of hand-drawn doodles: little smiling worms, apples with a door, hearts, leaves, clocks, spears, stone axes and stopwatches, very low contrast so text and panels stay readable. Vertical composition, aspect ratio 9:16 (final 1080×1920 px). Keep the center calm and uncluttered so UI can sit on top. No characters unless stated, no text, no UI.
```

### `story_01.png`
**Archivo:** `story_01.png` → `public/assets/story/` · **Tamaño final:** 1024×640 px · ✅ el juego ya lo usa

> Intro 1/3: la pareja feliz

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Illustration: a comic panel with a leafy vine border: the green worm with a black cap with an "A" and the pink worm with long pink hair, glasses and a white daisy cuddling happily inside their cozy hollow apple house, hearts floating, warm light, a round window behind them. Aspect ratio 8:5 (final 1024×640 px). Background allowed (full scene). No text, no speech-bubble text.
```

### `story_02.png`
**Archivo:** `story_02.png` → `public/assets/story/` · **Tamaño final:** 1024×640 px · ✅ el juego ya lo usa

> Intro 2/3: encuentra el aparato

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Illustration: a comic panel with a leafy vine border: the pink worm with glasses and a daisy shows the green worm with the black "A" cap a strange glowing retro handheld gadget with an antenna, the green worm looks confused with a question mark above his head, inside the apple house. Aspect ratio 8:5 (final 1024×640 px). Background allowed (full scene). No text, no speech-bubble text.
```

### `story_03.png`
**Archivo:** `story_03.png` → `public/assets/story/` · **Tamaño final:** 1024×640 px · ✅ el juego ya lo usa

> Intro 3/3: el portal se la lleva

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Illustration: a comic panel with a leafy vine border: the pink worm presses the big button of the gadget and a swirling blue-purple wormhole portal opens and starts pulling her tail, she looks scared, the green worm with the black cap reaches out toward her with a shocked face. Aspect ratio 8:5 (final 1024×640 px). Background allowed (full scene). No text, no speech-bubble text.
```

### `story_egipto.png`
**Archivo:** `story_egipto.png` → `public/assets/story/` · **Tamaño final:** 1024×640 px · 🕓 aún no integrado

> Capítulo: llegada a Egipto

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Illustration: a comic panel with a leafy vine border: the pink worm with glasses and a daisy lands on warm sand in ancient Egypt in front of a pyramid, a giant curious cat looming behind her, she waves for help with a speech bubble containing a heart. Aspect ratio 8:5 (final 1024×640 px). Background allowed (full scene). No text, no speech-bubble text.
```

### `story_medieval.png`
**Archivo:** `story_medieval.png` → `public/assets/story/` · **Tamaño final:** 1024×640 px · 🕓 aún no integrado

> Capítulo: llegada a la Edad Media

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Illustration: a comic panel with a leafy vine border: the pink worm with glasses and a daisy peeks from a castle tower window, a sleepy dragon snoring below, she calls for help. Aspect ratio 8:5 (final 1024×640 px). Background allowed (full scene). No text, no speech-bubble text.
```

### `story_oeste.png`
**Archivo:** `story_oeste.png` → `public/assets/story/` · **Tamaño final:** 1024×640 px · 🕓 aún no integrado

> Capítulo: llegada al Lejano Oeste

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Illustration: a comic panel with a leafy vine border: the pink worm with glasses wearing a deputy star and a tiny cowboy hat next to a scorpion wearing a sheriff hat in a dusty wild west town, she looks worried. Aspect ratio 8:5 (final 1024×640 px). Background allowed (full scene). No text, no speech-bubble text.
```


---

## Pantalla de título

Capas separadas: fondo de selva, logo, Gusanito en pose y botón de madera en blanco (el juego escribe «JUGAR»/«PLAY»).

### `logo.png`
**Archivo:** `logo.png` → `public/assets/ui/` · **Tamaño final:** 1024×512 px · **Fondo al generar:** blanco #FFFFFF · ✅ el juego ya lo usa

> el texto de la IA suele salir con errores: revísalo; si falla, genera solo el emblema sin texto

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. game logo: the words "Love n' Wormholes" carved in a mossy stone sign with vines and small flowers, a small portrait of the green worm with a black cap at the top-left corner and a small portrait of the pink worm with glasses and a daisy at the top-right corner. Aspect ratio 2:1 (final 1024×512 px). isolated on a plain, solid, flat pure white background (#FFFFFF), no gradient, no shadow on the ground.
```

### `title_bg.png`
**Archivo:** `title_bg.png` → `public/assets/ui/` · **Tamaño final:** 1080×1920 px · ✅ el juego ya lo usa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Full-screen game background: prehistoric jungle at dusk, purple-pink twilight sky, dinosaur silhouettes in the distance, giant ferns and tree trunks framing the sides, a mossy cliff with a round stone cave entrance with a dark opening in the lower middle, NO characters and NO text, empty space at the top for a logo and at the bottom for a button. Vertical composition, aspect ratio 9:16 (final 1080×1920 px). Keep the center calm and uncluttered so UI can sit on top. No characters unless stated, no text, no UI.
```

### `title_hero.png`
**Archivo:** `title_hero.png` → `public/assets/ui/` · **Tamaño final:** 768×768 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

> pose grande para el título

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: Gusanito, the bright-green worm with a black baseball cap with a white "A", frowning with determination, holding a big bone club on his shoulder, upper body rising from the ground, dynamic pose, facing the viewer. A single object centered and filling about 85% of the frame, square image (1:1final 768×768 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```


---

## Botones y ventanas

Piezas en blanco y reutilizables (sin texto).

### `btn_wood.png`
**Archivo:** `btn_wood.png` → `public/assets/ui/` · **Tamaño final:** 512×192 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

> sin texto: el juego pone «JUGAR» / «PLAY»

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a blank orange wooden sign button with a rope-tied bone-and-stick frame at the corners, rough carved texture, NO text (the text is added by the game in each language). A single object centered and filling about 85% of the frame, aspect ratio 8:3 (final 512×192 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `btn_stone.png`
**Archivo:** `btn_stone.png` → `public/assets/ui/` · **Tamaño final:** 512×160 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

> botón secundario

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a blank grey stone slab button, rounded rectangle, carved edges, NO text. A single object centered and filling about 85% of the frame, aspect ratio 16:5 (final 512×160 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `ribbon_title.png`
**Archivo:** `ribbon_title.png` → `public/assets/ui/` · **Tamaño final:** 800×200 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

> encabezado de pantallas (el texto lo pone el juego)

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a blank title banner made of a bone with a ribbon of aged parchment wrapped around it, NO text, wide. A single object centered and filling about 85% of the frame, aspect ratio 4:1 (final 800×200 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `popup_frame.png`
**Archivo:** `popup_frame.png` → `public/assets/ui/` · **Tamaño final:** 800×900 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

> ventanas emergentes (resultados, ajustes, avisos)

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a vertical popup window panel made of aged parchment with a thick stone border and small ferns at the corners, empty inside, NO text. A single object centered and filling about 85% of the frame, aspect ratio 8:9 (final 800×900 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```


---

## Hub: fondos por era

Fondo de papel con patrón muy tenue (cambia con la era). La casa de piedra del centro es `base_<era>_home.png` y Gusanito es su hoja `_idle`.

### `hub_bg_prehistoria.png`
**Archivo:** `hub_bg_prehistoria.png` → `public/assets/backgrounds/` · **Tamaño final:** 1080×1920 px · ✅ el juego ya lo usa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Full-screen game background: cream paper background with a faint tone-on-tone pattern of hand-drawn prehistoric items: stone spears, axes, bones, footprints, apples, small stone tablets, very low contrast. Vertical composition, aspect ratio 9:16 (final 1080×1920 px). Keep the center calm and uncluttered so UI can sit on top. No characters unless stated, no text, no UI.
```

### `hub_bg_egipto.png`
**Archivo:** `hub_bg_egipto.png` → `public/assets/backgrounds/` · **Tamaño final:** 1080×1920 px · ✅ el juego ya lo usa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Full-screen game background: sand-colored papyrus background with a faint tone-on-tone pattern of hand-drawn ancient Egyptian items: ankhs, scarabs, eyes of Horus, pyramids, hieroglyph bits, very low contrast. Vertical composition, aspect ratio 9:16 (final 1080×1920 px). Keep the center calm and uncluttered so UI can sit on top. No characters unless stated, no text, no UI.
```

### `hub_bg_medieval.png`
**Archivo:** `hub_bg_medieval.png` → `public/assets/backgrounds/` · **Tamaño final:** 1080×1920 px · ✅ el juego ya lo usa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Full-screen game background: pale grey-blue parchment background with a faint tone-on-tone pattern of hand-drawn medieval items: swords, shields, castles, crowns, keys, very low contrast. Vertical composition, aspect ratio 9:16 (final 1080×1920 px). Keep the center calm and uncluttered so UI can sit on top. No characters unless stated, no text, no UI.
```

### `hub_bg_oeste.png`
**Archivo:** `hub_bg_oeste.png` → `public/assets/backgrounds/` · **Tamaño final:** 1080×1920 px · ✅ el juego ya lo usa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Full-screen game background: warm sand-orange paper background with a faint tone-on-tone pattern of hand-drawn wild west items: cowboy hats, horseshoes, cacti, revolvers, stars, wanted posters, very low contrast. Vertical composition, aspect ratio 9:16 (final 1080×1920 px). Keep the center calm and uncluttered so UI can sit on top. No characters unless stated, no text, no UI.
```


---

## Hub: barra superior y navegación

Barra superior (monedas, gemas, título del nivel, ajustes, menú, misiones) y barra inferior de 5 pestañas: Mapa · Recuerdos · **Batalla** (centro, destacada) · Mejoras · Tienda.

### `topbar.png`
**Archivo:** `topbar.png` → `public/assets/ui/` · **Tamaño final:** 1080×160 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a horizontal dark stone bar for a game top HUD with a chiseled edge, empty, NO text. A single object centered and filling about 85% of the frame, aspect ratio 27:4 (final 1080×160 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `pill.png`
**Archivo:** `pill.png` → `public/assets/ui/` · **Tamaño final:** 320×96 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a blank stone pill-shaped counter slot (rounded rectangle) used to show a currency amount, carved edges, NO text. A single object centered and filling about 85% of the frame, aspect ratio 10:3 (final 320×96 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `btn_round.png`
**Archivo:** `btn_round.png` → `public/assets/ui/` · **Tamaño final:** 160×160 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a blank round grey stone button, carved rim, empty center, NO icon. A single object centered and filling about 85% of the frame, square image (1:1final 160×160 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `icon_gear.png`
**Archivo:** `icon_gear.png` → `public/assets/ui/` · **Tamaño final:** 128×128 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a settings gear icon carved in stone, simple and chunky. A single object centered and filling about 85% of the frame, square image (1:1final 128×128 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `icon_menu.png`
**Archivo:** `icon_menu.png` → `public/assets/ui/` · **Tamaño final:** 128×128 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a hamburger menu icon (three horizontal bars) carved in stone, simple and chunky. A single object centered and filling about 85% of the frame, square image (1:1final 128×128 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `icon_quests.png`
**Archivo:** `icon_quests.png` → `public/assets/ui/` · **Tamaño final:** 128×128 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a rolled parchment quest scroll icon with a tiny seal, simple and chunky. A single object centered and filling about 85% of the frame, square image (1:1final 128×128 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `navbar.png`
**Archivo:** `navbar.png` → `public/assets/ui/` · **Tamaño final:** 1080×220 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a horizontal bottom navigation strip made of grey stone bricks with a chiseled top edge, empty, NO text. A single object centered and filling about 85% of the frame, aspect ratio 54:11 (final 1080×220 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `nav_tile.png`
**Archivo:** `nav_tile.png` → `public/assets/ui/` · **Tamaño final:** 200×200 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a blank square grey stone tile with rounded corners and carved edges, empty, NO icon. A single object centered and filling about 85% of the frame, square image (1:1final 200×200 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `nav_tile_active.png`
**Archivo:** `nav_tile_active.png` → `public/assets/ui/` · **Tamaño final:** 260×260 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

> pestaña central destacada (Batalla)

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a raised round wooden shield badge with a stone rim, slightly larger, empty center, NO icon. A single object centered and filling about 85% of the frame, square image (1:1final 260×260 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `nav_map.png`
**Archivo:** `nav_map.png` → `public/assets/ui/` · **Tamaño final:** 128×128 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: an icon of a dark stone cave entrance with torches on each side (the dungeon map tab). A single object centered and filling about 85% of the frame, square image (1:1final 128×128 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `nav_memories.png`
**Archivo:** `nav_memories.png` → `public/assets/ui/` · **Tamaño final:** 128×128 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: an icon of two small worms, one pink with glasses and one green with a cap, snuggling together (the memories tab). A single object centered and filling about 85% of the frame, square image (1:1final 128×128 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `nav_battle.png`
**Archivo:** `nav_battle.png` → `public/assets/ui/` · **Tamaño final:** 160×160 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: an icon of two crossed bone-swords over a round wooden shield (the battle tab). A single object centered and filling about 85% of the frame, square image (1:1final 160×160 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `nav_upgrades.png`
**Archivo:** `nav_upgrades.png` → `public/assets/ui/` · **Tamaño final:** 128×128 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: an icon of a fan of stone cards with a percent sign "%" on the front (the upgrades tab). A single object centered and filling about 85% of the frame, square image (1:1final 128×128 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `nav_shop.png`
**Archivo:** `nav_shop.png` → `public/assets/ui/` · **Tamaño final:** 128×128 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: an icon of a cute market stall with a red-and-white striped awning and colorful potions (the shop tab). A single object centered and filling about 85% of the frame, square image (1:1final 128×128 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `hud_unit_btn.png`
**Archivo:** `hud_unit_btn.png` → `public/assets/ui/` · **Tamaño final:** 252×200 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

> botón de invocar unidades en batalla

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a stone slab summon button with an empty circular area at the top for a unit portrait and a small empty badge at the bottom-right for the energy cost, NO text. A single object centered and filling about 85% of the frame, aspect ratio 63:50 (final 252×200 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```


---

## Marcos de pantalla

Marcos a pantalla completa con el centro en **magenta plano** (el script lo vuelve transparente). Se dibujan sobre `parchment`/fondos de cada pantalla.

### `frame_map.png`
**Archivo:** `frame_map.png` → `public/assets/ui/` · **Tamaño final:** 1080×1920 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Full-screen decorative frame: an aged parchment page frame with sketchy ink ferns and leaves in the corners and a thin ink border, the whole center rectangle (about 90% of the image) is a solid flat magenta color #FF00FF to be cut out. Vertical composition, aspect ratio 9:16 (final 1080×1920 px). The magenta area must be one flat uniform color with no shading. No text.
```

### `frame_memories.png`
**Archivo:** `frame_memories.png` → `public/assets/ui/` · **Tamaño final:** 1080×1920 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Full-screen decorative frame: an aged parchment page frame decorated with big cartoon bones along the edges and tiny hearts in the corners, the whole center rectangle (about 85% of the image) is a solid flat magenta color #FF00FF to be cut out. Vertical composition, aspect ratio 9:16 (final 1080×1920 px). The magenta area must be one flat uniform color with no shading. No text.
```

### `frame_upgrades.png`
**Archivo:** `frame_upgrades.png` → `public/assets/ui/` · **Tamaño final:** 1080×1920 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Full-screen decorative frame: a carved grey stone slab frame with fern leaves and small bones at the corners and a banner at the top, the whole center rectangle (about 80% of the image) is a solid flat magenta color #FF00FF to be cut out. Vertical composition, aspect ratio 9:16 (final 1080×1920 px). The magenta area must be one flat uniform color with no shading. No text.
```

### `frame_shop.png`
**Archivo:** `frame_shop.png` → `public/assets/ui/` · **Tamaño final:** 1080×1920 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Full-screen decorative frame: an aged parchment page frame with a wooden plank border tied with vines and little leaves, the whole center rectangle (about 88% of the image) is a solid flat magenta color #FF00FF to be cut out. Vertical composition, aspect ratio 9:16 (final 1080×1920 px). The magenta area must be one flat uniform color with no shading. No text.
```


---

## Mapa de niveles

Los caminos punteados y las estrellas se dibujan por código; aquí solo los iconos de cada nivel, el jefe final de la era y los eventos temporales.

### `map_node_prehistoria.png`
**Archivo:** `map_node_prehistoria.png` → `public/assets/ui/` · **Tamaño final:** 256×256 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a small round stone cave entrance with a dark opening and a few bones, hand-inked map icon. A single object centered and filling about 85% of the frame, square image (1:1final 256×256 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `map_boss_prehistoria.png`
**Archivo:** `map_boss_prehistoria.png` → `public/assets/ui/` · **Tamaño final:** 384×384 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

> jefe final de la era: aparece arriba del mapa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a fierce spiky green dinosaur-lizard boss rising from a hole in the ground, roaring, hand-inked map illustration. A single object centered and filling about 85% of the frame, square image (1:1final 384×384 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `map_node_egipto.png`
**Archivo:** `map_node_egipto.png` → `public/assets/ui/` · **Tamaño final:** 256×256 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a small sandstone pyramid with a dark doorway, hand-inked map icon. A single object centered and filling about 85% of the frame, square image (1:1final 256×256 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `map_boss_egipto.png`
**Archivo:** `map_boss_egipto.png` → `public/assets/ui/` · **Tamaño final:** 384×384 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

> jefe final de la era: aparece arriba del mapa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a giant golden scarab king emerging from the sand, roaring, hand-inked map illustration. A single object centered and filling about 85% of the frame, square image (1:1final 384×384 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `map_node_medieval.png`
**Archivo:** `map_node_medieval.png` → `public/assets/ui/` · **Tamaño final:** 256×256 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a small stone castle gate with a flag, hand-inked map icon. A single object centered and filling about 85% of the frame, square image (1:1final 256×256 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `map_boss_medieval.png`
**Archivo:** `map_boss_medieval.png` → `public/assets/ui/` · **Tamaño final:** 384×384 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

> jefe final de la era: aparece arriba del mapa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a big sleepy dragon curled on a castle tower, one eye open, hand-inked map illustration. A single object centered and filling about 85% of the frame, square image (1:1final 384×384 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `map_node_oeste.png`
**Archivo:** `map_node_oeste.png` → `public/assets/ui/` · **Tamaño final:** 256×256 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a small wooden saloon front with swinging doors, hand-inked map icon. A single object centered and filling about 85% of the frame, square image (1:1final 256×256 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `map_boss_oeste.png`
**Archivo:** `map_boss_oeste.png` → `public/assets/ui/` · **Tamaño final:** 384×384 px · **Fondo al generar:** magenta #FF00FF · ✅ el juego ya lo usa

> jefe final de la era: aparece arriba del mapa

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a giant scorpion wearing a sheriff hat rising from the desert sand, hand-inked map illustration. A single object centered and filling about 85% of the frame, square image (1:1final 384×384 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `map_node_locked.png`
**Archivo:** `map_node_locked.png` → `public/assets/ui/` · **Tamaño final:** 256×256 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a small grey cave entrance sealed with a padlock and chains, hand-inked map icon. A single object centered and filling about 85% of the frame, square image (1:1final 256×256 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `event_slot.png`
**Archivo:** `event_slot.png` → `public/assets/ui/` · **Tamaño final:** 192×240 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a blank small parchment card with a stone border for a timed event, with an empty area for an icon and a small hourglass at the bottom, NO text. A single object centered and filling about 85% of the frame, aspect ratio 4:5 (final 192×240 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `event_hunt.png`
**Archivo:** `event_hunt.png` → `public/assets/ui/` · **Tamaño final:** 128×128 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a caveman hunter silhouette holding a spear, icon. A single object centered and filling about 85% of the frame, square image (1:1final 128×128 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `event_bones.png`
**Archivo:** `event_bones.png` → `public/assets/ui/` · **Tamaño final:** 128×128 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a crossed pair of big bones, icon. A single object centered and filling about 85% of the frame, square image (1:1final 128×128 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `event_forge.png`
**Archivo:** `event_forge.png` → `public/assets/ui/` · **Tamaño final:** 128×128 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a stone axe with a lashed handle, icon. A single object centered and filling about 85% of the frame, square image (1:1final 128×128 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `event_campfire.png`
**Archivo:** `event_campfire.png` → `public/assets/ui/` · **Tamaño final:** 128×128 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a small campfire with logs and flames, icon. A single object centered and filling about 85% of the frame, square image (1:1final 128×128 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```


---

## Recuerdos de los gusanos

Álbum de fotos tipo polaroid que se desbloquea con el Medidor de Amor (barra dibujada por código).

### `memory_frame.png`
**Archivo:** `memory_frame.png` → `public/assets/ui/` · **Tamaño final:** 512×600 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a blank polaroid photo frame (white card with a thin shadow, slightly tilted) with an empty square picture area, NO picture, NO text. A single object centered and filling about 85% of the frame, aspect ratio 64:75 (final 512×600 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `memory_locked.png`
**Archivo:** `memory_locked.png` → `public/assets/ui/` · **Tamaño final:** 512×600 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a polaroid photo frame whose picture area is a dark silhouette of two worms hugging with a small padlock in the middle, NO text. A single object centered and filling about 85% of the frame, aspect ratio 64:75 (final 512×600 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `memory_01.png`
**Archivo:** `memory_01.png` → `public/assets/story/` · **Tamaño final:** 480×480 px · 🕓 aún no integrado

> recuerdo 01/06 (se desbloquea con el Medidor de Amor)

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Illustration: sepia ink sketch of a pink worm with glasses and a green worm with a cap meeting for the first time, both blushing, small hearts. Aspect ratio 1:1 (final 480×480 px). Background allowed (full scene). No text, no speech-bubble text.
```

### `memory_02.png`
**Archivo:** `memory_02.png` → `public/assets/story/` · **Tamaño final:** 480×480 px · 🕓 aún no integrado

> recuerdo 02/06 (se desbloquea con el Medidor de Amor)

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Illustration: sepia ink sketch of the two worms on a first date sharing a berry under a tree, small hearts. Aspect ratio 1:1 (final 480×480 px). Background allowed (full scene). No text, no speech-bubble text.
```

### `memory_03.png`
**Archivo:** `memory_03.png` → `public/assets/story/` · **Tamaño final:** 480×480 px · 🕓 aún no integrado

> recuerdo 03/06 (se desbloquea con el Medidor de Amor)

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Illustration: sepia ink sketch of the two worms having a small funny fight, back to back with crossed arms and puffed cheeks. Aspect ratio 1:1 (final 480×480 px). Background allowed (full scene). No text, no speech-bubble text.
```

### `memory_04.png`
**Archivo:** `memory_04.png` → `public/assets/story/` · **Tamaño final:** 480×480 px · 🕓 aún no integrado

> recuerdo 04/06 (se desbloquea con el Medidor de Amor)

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Illustration: sepia ink sketch of the two worms reuniting with a big hug, joyful, hearts and sparkles. Aspect ratio 1:1 (final 480×480 px). Background allowed (full scene). No text, no speech-bubble text.
```

### `memory_05.png`
**Archivo:** `memory_05.png` → `public/assets/story/` · **Tamaño final:** 480×480 px · 🕓 aún no integrado

> recuerdo 05/06 (se desbloquea con el Medidor de Amor)

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Illustration: sepia ink sketch of the two worms exploring a deep underground burrow with a tiny lantern. Aspect ratio 1:1 (final 480×480 px). Background allowed (full scene). No text, no speech-bubble text.
```

### `memory_06.png`
**Archivo:** `memory_06.png` → `public/assets/story/` · **Tamaño final:** 480×480 px · 🕓 aún no integrado

> recuerdo 06/06 (se desbloquea con el Medidor de Amor)

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Illustration: sepia ink sketch of the two worms hunting together as a couple, one with a club and one with a slingshot, funny poses. Aspect ratio 1:1 (final 480×480 px). Background allowed (full scene). No text, no speech-bubble text.
```


---

## Mejoras (cartas)

Tres ranuras de cartas equipables, estadísticas (ataque, vida, crítico) y botón para volver a sacar cartas.

### `card_frame.png`
**Archivo:** `card_frame.png` → `public/assets/ui/` · **Tamaño final:** 256×360 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a blank upgrade card: parchment center with a stone border, an empty area for an illustration at the top and an empty area for text at the bottom, NO text. A single object centered and filling about 85% of the frame, aspect ratio 32:45 (final 256×360 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `card_back.png`
**Archivo:** `card_back.png` → `public/assets/ui/` · **Tamaño final:** 256×360 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: an unknown card slot: a dashed-outline parchment card with a big question mark "?" in the middle. A single object centered and filling about 85% of the frame, aspect ratio 32:45 (final 256×360 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `stat_attack.png`
**Archivo:** `stat_attack.png` → `public/assets/ui/` · **Tamaño final:** 128×128 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a stone sword icon, chunky, simple. A single object centered and filling about 85% of the frame, square image (1:1final 128×128 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `stat_health.png`
**Archivo:** `stat_health.png` → `public/assets/ui/` · **Tamaño final:** 128×128 px · **Fondo al generar:** blanco #FFFFFF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a red heart icon with a thick outline, simple. A single object centered and filling about 85% of the frame, square image (1:1final 128×128 px). isolated on a plain, solid, flat pure white background (#FFFFFF), no gradient, no shadow on the ground. No text, no watermark.
```

### `stat_crit.png`
**Archivo:** `stat_crit.png` → `public/assets/ui/` · **Tamaño final:** 128×128 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a golden star icon with a thick outline, simple. A single object centered and filling about 85% of the frame, square image (1:1final 128×128 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `btn_reroll.png`
**Archivo:** `btn_reroll.png` → `public/assets/ui/` · **Tamaño final:** 192×192 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a round stone button with a circular double-arrow "reroll" symbol and a tiny gold coin at the bottom, NO text. A single object centered and filling about 85% of the frame, square image (1:1final 192×192 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```


---

## Tienda (The Worm Mart)

Tendero, ofertas diarias y paquetes de gemas (los iconos de paquetes están en `03-ui.md`: `shop_gems_*`).

### `mart_shopkeeper.png`
**Archivo:** `mart_shopkeeper.png` → `public/assets/ui/` · **Tamaño final:** 512×512 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a friendly worm shopkeeper wearing a hat made of a bone and leaves, smiling, waving, bust portrait, with an empty speech bubble area NOT drawn. A single object centered and filling about 85% of the frame, square image (1:1final 512×512 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `deal_potion.png`
**Archivo:** `deal_potion.png` → `public/assets/ui/` · **Tamaño final:** 256×256 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

> oferta diaria: poción de energía

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a round glass potion bottle with a cork and a glowing orange liquid, ink-sketch style item icon. A single object centered and filling about 85% of the frame, square image (1:1final 256×256 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `deal_sword.png`
**Archivo:** `deal_sword.png` → `public/assets/ui/` · **Tamaño final:** 256×256 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

> oferta diaria: carta de ataque

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a prehistoric stone sword with a lashed handle, ink-sketch style item icon. A single object centered and filling about 85% of the frame, square image (1:1final 256×256 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `deal_bone.png`
**Archivo:** `deal_bone.png` → `public/assets/ui/` · **Tamaño final:** 256×256 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

> oferta diaria: paquete de monedas

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a big carved bone with runes, ink-sketch style item icon. A single object centered and filling about 85% of the frame, square image (1:1final 256×256 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```


---

## Retratos de Gusanita

Aparecen en los mensajes de cada era.

### `gusanita_prehistoria.png`
**Archivo:** `gusanita_prehistoria.png` → `public/assets/characters/` · **Tamaño final:** 512×512 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

> retrato de Gusanita para los mensajes de cada era

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: Gusanita, a cute chubby pink (#ff8fb8) worm with long wavy pink hair, round glasses, a white daisy flower on her head, big shiny eyes and a curious sweet expression, bust portrait (head and upper body) looking at the viewer, holding her strange glowing gadget, worried face, a few leaves in her hair. A single object centered and filling about 85% of the frame, square image (1:1final 512×512 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `gusanita_egipto.png`
**Archivo:** `gusanita_egipto.png` → `public/assets/characters/` · **Tamaño final:** 512×512 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

> retrato de Gusanita para los mensajes de cada era

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: Gusanita, a cute chubby pink (#ff8fb8) worm with long wavy pink hair, round glasses, a white daisy flower on her head, big shiny eyes and a curious sweet expression, bust portrait (head and upper body) looking at the viewer, wearing a gold headband and a tiny golden collar, waving for help. A single object centered and filling about 85% of the frame, square image (1:1final 512×512 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `gusanita_medieval.png`
**Archivo:** `gusanita_medieval.png` → `public/assets/characters/` · **Tamaño final:** 512×512 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

> retrato de Gusanita para los mensajes de cada era

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: Gusanita, a cute chubby pink (#ff8fb8) worm with long wavy pink hair, round glasses, a white daisy flower on her head, big shiny eyes and a curious sweet expression, bust portrait (head and upper body) looking at the viewer, wearing a small pointed princess hat with a veil, calling for help. A single object centered and filling about 85% of the frame, square image (1:1final 512×512 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

### `gusanita_oeste.png`
**Archivo:** `gusanita_oeste.png` → `public/assets/characters/` · **Tamaño final:** 512×512 px · **Fondo al generar:** magenta #FF00FF · 🕓 aún no integrado

> retrato de Gusanita para los mensajes de cada era

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: Gusanita, a cute chubby pink (#ff8fb8) worm with long wavy pink hair, round glasses, a white daisy flower on her head, big shiny eyes and a curious sweet expression, bust portrait (head and upper body) looking at the viewer, wearing a tiny cowboy hat and a deputy star badge, waving a tiny flag. A single object centered and filling about 85% of the frame, square image (1:1final 512×512 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```

