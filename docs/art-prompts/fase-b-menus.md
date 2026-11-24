# Fase B: Menús y Home

Lo que ve el jugador al abrir el juego: logo, Home, mapa, textura de papel, iconos de la barra superior, Wormina, Núcleo Crono, intro de historia y Count Magpie. Se mueve aquí la intro de 3 paneles (se muestra en la primera partida) y el icono de la app.

**16 prompts** (0 referencias de personaje, 0 hojas de animación, 16 imágenes o sprites estáticos). Antes de empezar lee `README.md` (convenciones, tamaños, qué hacer si la cuadrícula sale mal). Genera cada referencia primero y luego sus animaciones en el mismo chat de Gemini, adjuntando `<id>_ref.png`.

---
### B-001 · Logo del juego
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Logo con el nombre del juego en letras naranjas redondeadas con borde turquesa, el gusano Squirmy asomando y un cartel dorado con forma de engranaje 'Lost in Time'.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (se recorta al logo; ancho final ≈ 900 px)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Pantalla de título (title_screen.gd, hoy un rectángulo 'LOGO' de 150 px de alto) y Créditos (credits_screen.gd).
- **Referencia a adjuntar:** `squirmy_ref.png` (para que el gusano sea idéntico al héroe)
- **Archivo de salida:** `logo.png`
- **Origen:** H08

```text
A game logo with the words "Love 'n Wormholes" spelled exactly, on two lines ("Love 'n" smaller above and "Wormholes" larger below), written in chunky rounded hand-painted letters in warm orange with a thick teal outline, a small cute bright-green worm wearing a black baseball cap with a letter A peeking playfully over the top of the first letter, and below it a smaller golden banner shaped like a clock gear with the words "Lost in Time" spelled exactly. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no gradient and no border. Crisp clean edges. Do not use magenta or pink anywhere on the logo. Square 1:1 image.
```

### B-002 · Fondo de título y Home
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Jardín en hora dorada con flores, madriguera en la esquina inferior izquierda y un portal del tiempo dorado y turquesa en el cielo; centro superior libre para el logo.
- **Tamaño / proporción:** 9:16 vertical, 1080x1920 px (si Gemini devuelve otra proporción, recortar a 9:16)
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Fondo de la pantalla de título (title_screen.gd) y de Home (home_screen.gd), detrás del botón Play, Squirmy y la madriguera.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `bg_home.png`
- **Origen:** H06

```text
A cozy garden at golden hour with soft grass, big colorful flowers, a small dirt burrow hole with a tiny wooden door in the lower left, and high in the sky a glowing golden-and-teal swirling time portal made of clockwork gears and light. Leave the upper center calm and empty for a logo. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Tall 9:16 portrait image with no characters, no text, no logos and no UI.
```

### B-003 · Textura de papel para paneles
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Textura de papel crema cálido con manchas de acuarela y fibras, sin objetos, repetible.
- **Tamaño / proporción:** 1:1 cuadrada, 1024x1024 px, que se pueda repetir en mosaico
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Fondo repetido de los paneles y diálogos de menú (src/ui/ui.gd, cajas de Home, Squad, Upgrades, Shop, Capsules, Ajustes).
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `paper_texture.png`
- **Origen:** H15

```text
A flat evenly lit warm cream paper texture with subtle watercolor stains, tiny paper fibers and soft slightly darker edges, with no objects, no patterns and no text, suitable as a repeating background for menu panels. Storybook watercolor style with soft hand-painted washes and subtle paper grain. Square 1:1 image.
```

### B-004 · Icono de gema
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Gema azul turquesa facetada en forma de diamante redondeado con brillos y dos chispas.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Chip de gemas de la barra superior (todas las pantallas), precios de cápsulas y Tienda, recompensa diaria.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_gem.png`
- **Origen:** G03

```text
A faceted teal-blue gem shaped like a rounded diamond with bright white highlights on its facets and two tiny sparkles beside it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### B-005 · Icono de cápsula del tiempo
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Cápsula del tiempo en forma de huevo, mitad dorada y mitad turquesa, con reloj central y engranajes.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Chip de cápsulas de la barra superior, botón Capsules de Home y arte principal de la pantalla de cápsulas (capsule_screen.gd, hoy un placeholder 120x120).
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_capsule.png`
- **Origen:** G05

```text
A glossy egg-shaped time capsule split into a golden half and a teal half, with a small round clock face in the middle, tiny gears around the seam and a few sparkles around it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### B-006 · Icono de Chrono Dust
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Montículo brillante de polvo dorado y turquesa con engranajes pequeños y estrellitas.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Chip de polvo en la pantalla de cápsulas y reliquias (compra de reliquias con Dust, duplicados).
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_chrono_dust.png`
- **Origen:** G04

```text
A small glowing mound of golden-and-teal sparkling dust with a few tiny gear shapes mixed in and little stars floating above it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### B-007 · Mapa del mundo (selección de etapa)
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Mapa del tesoro acuarelado sobre papel envejecido con camino punteado que cruza las cinco eras de abajo hacia arriba y una brújula de relojería.
- **Tamaño / proporción:** 9:16 vertical, 1080x1920 px (si Gemini devuelve otra proporción, recortar a 9:16)
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Pantalla de selección de etapa/mapa (level_select_screen.gd): fondo del mapa con los nodos de etapa y el botón del jefe encima.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `world_map.png`
- **Origen:** H07

```text
A hand-painted storybook treasure map on aged cream paper with a winding dotted path running from the bottom to the top through five regions stacked vertically: a jungle with a smoking volcano, a desert with pyramids, green hills with a castle, a steampunk city with chimneys and a floating space island with a ringed planet, plus a small clockwork compass in one corner. Leave the path areas clear and open. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Tall 9:16 portrait image with no characters, no text, no labels, no logos and no UI.
```

### B-008 · Insignia de era: Edad de Piedra
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Medalla de piedra con una huella de dinosaurio tallada y una hoja de helecho.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Cabecera del mapa y de Home ('Era 1 · Dino Valley'), selector de era en Squad/Upgrades.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `era_1.png`
- **Origen:** G12

```text
A round stone medallion with a carved dinosaur footprint in the center, a small green fern leaf on one side and a rough chiseled rim. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### B-009 · Icono de poder: Time Freeze
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Reloj de bolsillo dorado congelado dentro de cristales de hielo con carámbanos y copos.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Botón de poder del HUD y selector de poderes; se desbloquea tras el jefe de la Era 1, así que se necesita justo al terminar la Fase A.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `power_time_freeze.png`
- **Origen:** G08

```text
A round golden pocket watch frozen inside pale-blue ice crystals, with small icicles hanging from it and snowflake sparkles around it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### B-010 · Wormina
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Wormina: gusana rosa con pelo rizado rosa chicle, margarita, gafas redondas y brackets, en pose neutra mirando al frente.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline recorta y deja unos 384 px de alto)
- **Datos técnicos:** fondo azul plano #0000FF (Wormina es rosa); sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Sprite estático de Wormina en la historia y eco de Wormina en el mapa (etapas que 'ocultan un eco'); también sirve de referencia para los paneles de historia.
- **Referencia a adjuntar:** hoja oficial de personaje de Wormina de Alfredo (adjuntar si la tienes). Este sprite ES la referencia de Wormina: no hay `_ref.png` aparte.
- **Archivo de salida:** `wormina.png`
- **Origen:** A03

```text
Wormina, a small cheerful soft-pink earthworm girl with a lighter pink segmented belly, long wavy bubblegum-pink hair with a pretty curl on top, a white daisy with a yellow center tucked into the hair, round thin-framed glasses over big sparkling eyes with long lashes, rosy cheeks, a happy smile with tiny braces and two small simple hands, standing upright in a neutral pose with her body gently curved, looking forward with wonder. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin dark-rose ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, side view facing right, centered with a wide empty margin, drawn on a perfectly flat solid pure blue background (#0000FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use blue anywhere on the subject. Square 1:1 image.
```

### B-011 · El Núcleo Crono
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** El Núcleo Crono: esfera de relojería dorada y turquesa del tamaño de una manzana con cinco engarces para gemas y grietas que dejan escapar luz.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline recorta y deja unos 384 px de alto)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Sprite estático del Núcleo en Home (indicador de fragmentos 'Shards 0 / 5'), historia y créditos.
- **Referencia a adjuntar:** ninguna (este sprite es su propia referencia)
- **Archivo de salida:** `chrono_core.png`
- **Origen:** A05

```text
The Chrono Core, a glowing apple-sized clockwork orb made of polished gold and teal metal with tiny visible gears, five small round gem sockets around its middle and hairline cracks letting warm golden light leak out, floating slightly with a few sparkles around it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single object, front view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### B-012 · Historia, intro 1: picnic en el jardín
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Picnic romántico de tierra de Squirmy y Wormina en el jardín. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Panel 1 de la secuencia 'intro' (story_screen.gd): 'Squirmy y Wormina tenían el picnic más romántico del mundo'. Aparece en la primera partida.
- **Referencia a adjuntar:** `squirmy_ref.png` y `wormina.png`
- **Archivo de salida:** `story_intro_1.png`
- **Origen:** nuevo (no estaba en el original)

```text
A romantic dirt picnic in a sunny garden: Squirmy, a bright-green worm with a lighter yellow-green belly, big brown eyes, small hands and a black baseball cap with a letter A, and Wormina, a soft-pink worm with long wavy pink hair, round glasses, braces and a white daisy in her hair, sitting close together on a tiny checkered cloth spread on the soil, sharing two small leaf plates with crumbs, a dewdrop in a tiny acorn cup and a ladybug watching from a flower stem, warm golden light. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, comic-book panel composition with no text, no logos and no UI.
```

### B-013 · Historia, intro 2: la esfera dorada
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Squirmy y Wormina descubren la esfera dorada brillante en la hierba.
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Panel 2 de la secuencia 'intro': 'Entonces encontraron una esfera dorada que brillaba'. (Original H09 'el descubrimiento'.)
- **Referencia a adjuntar:** `squirmy_ref.png`, `wormina.png` y `chrono_core.png`
- **Archivo de salida:** `story_intro_2.png`
- **Origen:** H09

```text
Two small earthworms in a sunny garden looking at a glowing golden-and-teal clockwork orb resting in the grass: Squirmy, a bright-green worm with a lighter yellow-green belly, big brown eyes, small hands and a black baseball cap with a letter A, and Wormina, a soft-pink worm with long wavy pink hair, round glasses, braces and a white daisy in her hair, both leaning forward with curiosity. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, warm light, comic-book panel composition with no text, no logos and no UI.
```

### B-014 · Historia, intro 3: flash y portal
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Destello: Wormina es absorbida por la esfera, que se rompe en cinco fragmentos, y Squirmy extiende la mano.
- **Tamaño / proporción:** 16:9 horizontal, 1920x1080 px
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Panel 3 de la secuencia 'intro': 'FLASH! Wormina desapareció y la esfera se rompió en cinco fragmentos'. (Original H10 'Wormina desaparece'.)
- **Referencia a adjuntar:** `squirmy_ref.png` y `wormina.png`
- **Archivo de salida:** `story_intro_3.png`
- **Origen:** H10

```text
A dramatic bright flash as Wormina, a soft-pink worm with long wavy pink hair, round glasses and a white daisy in her hair, is pulled into a glowing golden-and-teal clockwork orb in a swirl of golden light and flying gears, with five golden shards of the orb flying outward, while Squirmy, a bright-green worm with a lighter yellow-green belly and a black baseball cap with a letter A, reaches out in shock, his cap flying off in the wind. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, dynamic comic-book panel composition with no text, no logos and no UI.
```

### B-015 · Count Magpie (villano de la historia)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Count Magpie: urraca gordita y elegante con sombrero de copa índigo, monóculo dorado y capa corta, con un engranaje dorado en la garra.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline recorta y deja unos 384 px de alto)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Sprite estático del villano en los paneles/escenas de historia y créditos (la Era 5 usa a Count Magpie 3000 en su lugar).
- **Referencia a adjuntar:** ninguna (este sprite es su propia referencia)
- **Archivo de salida:** `count_magpie.png`
- **Origen:** A04

```text
Count Magpie, a plump dapper magpie with glossy black-and-white feathers, iridescent blue-green wing tips, a deep indigo top hat, a gold monocle and a short dark-blue cape, wearing a smug grin and holding a tiny glowing golden gear in one claw, standing proudly with his chest puffed out. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, side view facing left, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### B-016 · Icono de la app
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Primer plano de Squirmy valiente frente a un engranaje dorado y remolino de luz turquesa que llena todo el fondo.
- **Tamaño / proporción:** 1:1 cuadrada, 1024x1024 px (se exporta a 512x512 para Google Play)
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Icono del lanzador de Android (project.godot / export_presets.cfg) y ficha de Google Play.
- **Referencia a adjuntar:** `squirmy_ref.png`
- **Archivo de salida:** `app_icon.png`
- **Origen:** H13

```text
A square mobile game app icon showing a close-up of Squirmy, a cheerful bright-green earthworm with big round brown eyes with white highlights, a lighter yellow-green belly, soft peach-pink cheeks and a black baseball cap with a letter A, with a brave grin, in front of a glowing golden clockwork gear and a swirl of teal and golden light that fills the whole background. Bold simple composition that stays readable at a small size, subject centered with a small margin, full-bleed background. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin dark-green ink outlines, cute rounded shapes and friendly saturated colors. No text, no logos and no border. Square 1:1 image.
```
