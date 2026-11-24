# Fase H: Historia y tienda de Play

14 paneles de historia (aperturas y cierres de era y final), gráfico de funciones y el portal opcional. Las capturas de pantalla de Play NO son prompts: se sacan del juego con tools/screenshots.gd cuando el arte real esté integrado.

**16 prompts** (0 referencias de personaje, 0 hojas de animación, 16 imágenes o sprites estáticos). Antes de empezar lee `README.md` (convenciones, tamaños, qué hacer si la cuadrícula sale mal). Genera cada referencia primero y luego sus animaciones en el mismo chat de Gemini, adjuntando `<id>_ref.png`.

---
### H-001 · Historia: Era 1 apertura: Valle Dino
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Squirmy aterriza en el Valle Dino ante hormigas gruñonas. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Panel de historia `story_era1_open_1` (story_screen.gd, secuencia de data/story.json, texto `story.era1.open.1`: «Dino Valley: Squirmy lands»). NUEVO: el original solo traía 4 paneles con otros nombres.
- **Referencia a adjuntar:** `squirmy_ref.png`
- **Archivo de salida:** `story_era1_open_1.png`
- **Origen:** nuevo (no estaba en el original)

```text
Dino Valley: Squirmy, a bright-green worm with a lighter yellow-green belly, big brown eyes, small hands and a black baseball cap with a letter A, has just tumbled out of a small swirling portal onto the grass of a prehistoric valley with giant ferns, a smoking volcano in the distance and a few grumpy black ants with red head bands peeking out from behind a rock. Warm morning light. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, comic-book panel composition with no text, no logos and no UI.
```

### H-002 · Historia: Era 1 cierre: Rexy cae
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Rexy derrotado y aturdido; Squirmy sostiene el primer fragmento y cae un pétalo de margarita. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Panel de historia `story_era1_close_1` (story_screen.gd, secuencia de data/story.json, texto `story.era1.close.1`: «Rexy down, shard + daisy petal»). NUEVO: el original solo traía 4 paneles con otros nombres.
- **Referencia a adjuntar:** `squirmy_ref.png` y `b1_rexy_ref.png`
- **Archivo de salida:** `story_era1_close_1.png`
- **Origen:** nuevo (no estaba en el original)

```text
Rexy, a big chubby green T-Rex with a red bandana and tiny arms, sits dazed on the ground with little stars around his head, while Squirmy, a bright-green worm with a lighter yellow-green belly, big brown eyes, small hands and a black baseball cap with a letter A, holds up a glowing golden shard of a clockwork orb in wonder, and a single white daisy petal floats down through the air between them. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, comic-book panel composition with no text, no logos and no UI.
```

### H-003 · Historia: Era 2 apertura: Arenas Escarabajo
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Squirmy cubierto de arena ve marchar una legión de escarabajos por las dunas. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Panel de historia `story_era2_open_1` (story_screen.gd, secuencia de data/story.json, texto `story.era2.open.1`: «Scarab Sands»). NUEVO: el original solo traía 4 paneles con otros nombres.
- **Referencia a adjuntar:** `squirmy_ref.png`
- **Archivo de salida:** `story_era2_open_1.png`
- **Origen:** nuevo (no estaba en el original)

```text
Scarab Sands: Squirmy, a bright-green worm with a lighter yellow-green belly, big brown eyes, small hands and a black baseball cap with a letter A, stands on a golden dune with a small pile of sand on his cap and sand in his eyes, squinting under a hot noon sun, while a legion of golden scarab beetle soldiers marches over the dunes toward him and three pyramids shine in the distance. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, comic-book panel composition with no text, no logos and no UI.
```

### H-004 · Historia: Era 2 cierre: Faraón y nota
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** El Faraón Escarabajo entrega el fragmento y una nota de Wormina vuela entre ellos. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Panel de historia `story_era2_close_1` (story_screen.gd, secuencia de data/story.json, texto `story.era2.close.1`: «Pharaoh Scarab + Wormina's note»). NUEVO: el original solo traía 4 paneles con otros nombres.
- **Referencia a adjuntar:** `squirmy_ref.png` y `b2_pharaoh_scarab_ref.png`
- **Archivo de salida:** `story_era2_close_1.png`
- **Origen:** nuevo (no estaba en el original)

```text
The Pharaoh Scarab, a giant golden scarab with a striped pharaoh headdress, gently hands a glowing golden shard to Squirmy, a bright-green worm with a lighter yellow-green belly, big brown eyes, small hands and a black baseball cap with a letter A, while a small rolled papyrus note with a tiny doodle of a daisy flutters between them (no readable text); a sphinx statue sits in the background. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, comic-book panel composition with no text, no logos and no UI.
```

### H-005 · Historia: Era 3 apertura: Reino de las Migajas
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Squirmy con hambre mira el Reino de las Migajas con caballeros escarabajo y molinos. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Panel de historia `story_era3_open_1` (story_screen.gd, secuencia de data/story.json, texto `story.era3.open.1`: «Kingdom of Crumbs»). NUEVO: el original solo traía 4 paneles con otros nombres.
- **Referencia a adjuntar:** `squirmy_ref.png`
- **Archivo de salida:** `story_era3_open_1.png`
- **Origen:** nuevo (no estaba en el original)

```text
The Kingdom of Crumbs: Squirmy, a bright-green worm with a lighter yellow-green belly, big brown eyes, small hands and a black baseball cap with a letter A, looks hungrily and determinedly up at a medieval village where the towers and walls look like giant loaves of bread and cheese crumbs, with beetle knights on patrol, colorful banners and two windmills, soft afternoon light. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, comic-book panel composition with no text, no logos and no UI.
```

### H-006 · Historia: Era 3 cierre: Sir Sizzle llora
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Sir Sizzle sorbe la nariz y entrega el fragmento; hay un malvavisco tostado cerca. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Panel de historia `story_era3_close_1` (story_screen.gd, secuencia de data/story.json, texto `story.era3.close.1`: «Sir Sizzle sniffles, shard»). NUEVO: el original solo traía 4 paneles con otros nombres.
- **Referencia a adjuntar:** `squirmy_ref.png` y `b3_sir_sizzle_ref.png`
- **Archivo de salida:** `story_era3_close_1.png`
- **Origen:** nuevo (no estaba en el original)

```text
Sir Sizzle, a chubby red-orange dragon in a dented tin helmet, sniffles with a big tear and a runny nose while holding out a glowing golden shard in one claw; a stick with a toasted marshmallow lies on the ground by a tiny campfire, and Squirmy, a bright-green worm with a lighter yellow-green belly, big brown eyes, small hands and a black baseball cap with a letter A, looks up at him kindly. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, comic-book panel composition with no text, no logos and no UI.
```

### H-007 · Historia: Era 4 apertura: Ciudad Vapor
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Squirmy saluda con educación a una cucaracha mecánica en Ciudad Vapor. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Panel de historia `story_era4_open_1` (story_screen.gd, secuencia de data/story.json, texto `story.era4.open.1`: «Steam City»). NUEVO: el original solo traía 4 paneles con otros nombres.
- **Referencia a adjuntar:** `squirmy_ref.png`
- **Archivo de salida:** `story_era4_open_1.png`
- **Origen:** nuevo (no estaba en el original)

```text
Steam City: Squirmy, a bright-green worm with a lighter yellow-green belly, big brown eyes, small hands and a black baseball cap with a letter A, politely tips his cap toward a scowling clockwork cockroach with a wrench, between tall brass towers, screaming pipes, big gears and clouds of white steam, dusk light with warm orange windows. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, comic-book panel composition with no text, no logos and no UI.
```

### H-008 · Historia: Era 4 cierre: la Reina Mecánica se apaga
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** La Reina Mecánica apagada; en sus engranes suena una grabación de Wormina; Squirmy emocionado. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Panel de historia `story_era4_close_1` (story_screen.gd, secuencia de data/story.json, texto `story.era4.close.1`: «Clockwork Queen + Wormina's voice»). NUEVO: el original solo traía 4 paneles con otros nombres.
- **Referencia a adjuntar:** `squirmy_ref.png` y `b4_clockwork_queen_ref.png`
- **Archivo de salida:** `story_era4_close_1.png`
- **Origen:** nuevo (no estaba en el original)

```text
The Clockwork Queen, a large brass mechanical spider with a small golden crown, sits powered down with her glass dome open; inside the gears a tiny glowing recorder plays sound waves shaped like little hearts and a daisy, and Squirmy, a bright-green worm with a lighter yellow-green belly, big brown eyes, small hands and a black baseball cap with a letter A, holds his cap in his hands with watery eyes while a little steam drifts by. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, comic-book panel composition with no text, no logos and no UI.
```

### H-009 · Historia: Era 5 apertura: Órbita Neón + Count Magpie
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Órbita Neón: Count Magpie sobre un montón de cosas brillantes con un fragmento; Squirmy lo mira desde abajo. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Panel de historia `story_era5_open_1` (story_screen.gd, secuencia de data/story.json, texto `story.era5.open.1`: «Neon Orbit + Count Magpie»). NUEVO: el original solo traía 4 paneles con otros nombres.
- **Referencia a adjuntar:** `squirmy_ref.png` y `count_magpie.png`
- **Archivo de salida:** `story_era5_open_1.png`
- **Origen:** nuevo (no estaba en el original)

```text
Neon Orbit: on a floating futuristic platform with a huge ringed planet and stars behind, Count Magpie, a plump dapper black-and-white magpie with an indigo top hat, a gold monocle and a short dark-blue cape, perches smugly on a heap of shiny gadgets holding a golden shard, while Squirmy, a bright-green worm with a lighter yellow-green belly, big brown eyes, small hands and a black baseball cap with a letter A, looks up at him. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, comic-book panel composition with no text, no logos and no UI.
```

### H-010 · Historia: Era 5 cierre: cae Count Magpie 3000
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Count Magpie 3000 estrellado entre sus tesoros; Squirmy toma el último fragmento. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Panel de historia `story_era5_close_1` (story_screen.gd, secuencia de data/story.json, texto `story.era5.close.1`: «Count Magpie 3000 falls»). NUEVO: el original solo traía 4 paneles con otros nombres.
- **Referencia a adjuntar:** `squirmy_ref.png` y `b5_count_magpie_3000_ref.png`
- **Archivo de salida:** `story_era5_close_1.png`
- **Origen:** nuevo (no estaba en el original)

```text
Count Magpie 3000, a giant chrome-and-indigo mechanical magpie, has crashed into a big pile of his own shiny trinkets, sparks flying and one tiny tear on his cheek, while Squirmy, a bright-green worm with a lighter yellow-green belly, big brown eyes, small hands and a black baseball cap with a letter A, grabs the last glowing golden shard from the heap. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, comic-book panel composition with no text, no logos and no UI.
```

### H-011 · Historia: Final 1: el Núcleo se reensambla
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Squirmy encaja el último fragmento en el Núcleo, que abre un portal. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Panel de historia `story_end_1` (story_screen.gd, secuencia de data/story.json, texto `story.end.1`: «Core reassembled»). NUEVO: el original solo traía 4 paneles con otros nombres.
- **Referencia a adjuntar:** `squirmy_ref.png` y `chrono_core.png`
- **Archivo de salida:** `story_end_1.png`
- **Origen:** nuevo (no estaba en el original)

```text
Squirmy, a bright-green worm with a lighter yellow-green belly, big brown eyes, small hands and a black baseball cap with a letter A, clicks the last of five glowing golden shards into the five round gem sockets of the apple-sized golden-and-teal clockwork orb, the orb humming with bright light and a swirling golden-and-teal portal beginning to open above it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, comic-book panel composition with no text, no logos and no UI.
```

### H-012 · Historia: Final 2: Wormina vuelve
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Wormina sale del portal con los brazos abiertos y Squirmy corre hacia ella. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Panel de historia `story_end_2` (story_screen.gd, secuencia de data/story.json, texto `story.end.2`: «Wormina returns»). NUEVO: el original solo traía 4 paneles con otros nombres.
- **Referencia a adjuntar:** `squirmy_ref.png` y `wormina.png`
- **Archivo de salida:** `story_end_2.png`
- **Origen:** nuevo (no estaba en el original)

```text
Wormina, a soft-pink worm with long wavy pink hair, round glasses, braces and a white daisy in her hair, steps out of a swirling golden-and-teal portal with her arms open and a huge happy smile, while Squirmy, a bright-green worm with a lighter yellow-green belly, big brown eyes, small hands and a black baseball cap with a letter A, runs toward her with sand falling out of his cap, golden light all around. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, comic-book panel composition with no text, no logos and no UI.
```

### H-013 · Historia: Final 3, de vuelta en el jardín
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Squirmy y Wormina abrazados en el jardín al atardecer con el Núcleo reparado y una pluma cayendo.
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Panel final `story_end_3` (story_screen.gd, texto `story.end.3`: 'De vuelta en el jardín...'). (Original H12 'el reencuentro'.)
- **Referencia a adjuntar:** `squirmy_ref.png` y `wormina.png`
- **Archivo de salida:** `story_end_3.png`
- **Origen:** H12

```text
Two small earthworms reunited and snuggling together in a garden at sunset: a bright-green worm with a lighter yellow-green belly and a black baseball cap with a letter A, and a soft-pink worm with long wavy pink hair, round glasses, braces and a white daisy in her hair, with a repaired glowing golden-and-teal clockwork orb resting softly in the grass and one black-and-white feather floating down. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, warm and tender mood, comic-book panel composition with no text, no logos and no UI.
```

### H-014 · Historia: Final 4: un sexto engarce brilla
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** El Núcleo en la hierba con un sexto engarce que brilla; los dos lo miran sorprendidos. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Panel de historia `story_end_4` (story_screen.gd, secuencia de data/story.json, texto `story.end.4`: «A sixth socket glows»). NUEVO: el original solo traía 4 paneles con otros nombres.
- **Referencia a adjuntar:** `squirmy_ref.png`, `wormina.png` y `chrono_core.png`
- **Archivo de salida:** `story_end_4.png`
- **Origen:** nuevo (no estaba en el original)

```text
The golden-and-teal clockwork orb rests in the garden grass at dusk, a sixth gem socket now glowing in a new mysterious color, while Squirmy, a bright-green worm with a lighter yellow-green belly, big brown eyes, small hands and a black baseball cap with a letter A, and Wormina, a soft-pink worm with long wavy pink hair, round glasses, braces and a white daisy in her hair, lean in with surprised wide eyes. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, comic-book panel composition with no text, no logos and no UI.
```

### H-015 · Gráfico de funciones de Google Play
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Banner con Squirmy liderando gusanos soldado de distintas eras hacia un portal del tiempo; tercio izquierdo libre para el título.
- **Tamaño / proporción:** 2:1 apaisada; si Gemini no da 2:1, generar 16:9 y recortar a 1024x500 px finales
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Ficha de Google Play (banner superior). Se añade el título encima con el editor de la tienda, no se dibuja.
- **Referencia a adjuntar:** `squirmy_ref.png`
- **Archivo de salida:** `feature_graphic.png`
- **Origen:** H14

```text
A wide banner scene of a bright-green earthworm hero with a black baseball cap with a letter A leading a line of small golden-yellow worm soldiers dressed for different eras (a caveman fur tunic, an Egyptian headdress, a knight helmet, steampunk goggles and a futuristic visor) toward the right, in front of a huge glowing golden-and-teal time portal, with a big sky full of clouds and gears. Leave the left third calm and open for a title to be added later. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 2:1 landscape image with no text, no logos and no UI.
```

### H-016 · Portal con vistazos de las eras (opcional)
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Squirmy de espaldas ante un enorme portal del tiempo con vistazos de las cinco eras (opcional).
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** OPCIONAL: el original H11 no coincide con ningún panel del juego; sirve como pantalla de carga o imagen de marketing.
- **Referencia a adjuntar:** `squirmy_ref.png`
- **Archivo de salida:** `story_03_portal.png`
- **Origen:** H11

```text
Seen from behind, a small bright-green earthworm with a black baseball cap worn backward-tilted stands bravely in front of a huge swirling teal-and-gold time portal in the sky, with small glimpses inside the portal of a dinosaur valley, a pyramid, a castle, a steam city and a planet in space. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, epic and funny mood, comic-book panel composition with no text, no logos and no UI.
```
