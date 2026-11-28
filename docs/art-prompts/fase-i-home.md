# Fase I: Home pixel perfect (marcos, iconos y fondo fijo)
Piezas para rehacer la pantalla Home como la de carga: tú haces un *mock* con todo en su sitio y subes cada elemento; yo lo coloco con tus medidas. Los textos (cifras, nombres de etapa, Jugar/Play, etiquetas) los dibuja el juego, por eso los marcos van **vacíos**.
Ya existen en otras fases y se reutilizan: `icon_coin` (monedas), `icon_gem` (B-004), `icon_capsule` (B-005, también en la pestaña Cápsulas), `home_burrow` (madriguera) y Squirmy animado.
Colores de referencia: crema #FFF7E6, marrón de borde #5B3A22, naranja #F28C28, verde azulado #15707A, rojo aviso #C8453B.

### I-001 · Fondo estático de Home
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Claro del bosque de tréboles y margaritas con un sendero de tierra al centro; copas de árbol arriba, hierba despejada abajo. Sin casa ni personajes (van aparte).
- **Tamaño / proporción:** 9:16 vertical, 1536x2752 px (el juego lo escala para cubrir la pantalla y recorta a los lados: nada importante en el 10 % lateral)
- **Datos técnicos:** imagen completa; sin texto ni interfaz; sin personajes ni madriguera
- **Dónde se usa:** Fondo fijo de Home, detrás de todo. Zonas: 0-14 % superior = follaje tranquilo (las fichas de monedas van encima); 38-55 % = claro con sendero horizontal donde se colocan la madriguera (izquierda) y Squirmy (derecha); 60-100 % = hierba suave y poco detalle (la tarjeta de etapa y la barra de navegación la tapan).
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `bg_home_static.png`

```text
A sunny storybook forest clearing seen from a slightly high front view in a vertical 9:16 composition: dense green tree canopy and tree trunks across the top 14%, a calm open meadow with a winding dirt path running horizontally across the middle (45% to 55% of the height), clovers, daisies and small ferns, soft golden light, gentle haze in the background. The lower 40% is soft quiet grass with very little detail. Keep the center of the image uncluttered and keep important details away from the left and right edges. No characters, no animals, no house, no burrow, no text, no interface. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. Vertical 9:16 image.
```

### I-002 · Marco de ficha (monedas, gemas, cápsulas)
- **Tipo:** Marco de interfaz (recortado sobre magenta)
- **Descripción de la imagen:** Píldora horizontal crema con borde marrón, vacía.
- **Tamaño / proporción:** 16:9, 1536x864 px, la píldora ocupa ~70 % del ancho y está centrada
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras; bordes limpios; el pipeline recorta al contenido (máx. 1024 px de ancho)
- **Dónde se usa:** Fondo de las fichas de la barra superior (monedas, gemas, cápsulas) y de 'Fragmentos 0/5'. El juego la estira como 9-slice y pone icono y número encima.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `ui_chip.png`

```text
A single empty horizontal pill-shaped UI frame, about 4 times wider than tall, filled with warm cream (#FFF7E6) with a thin parchment texture, a thick warm dark-brown outline (#5B3A22) and a subtle inner lighter edge. Completely empty inside: no icon, no text, no number. Perfectly symmetrical left and right. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. Front view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object.
```

### I-003 · Marco de botón cuadrado (ajustes y diario)
- **Tipo:** Marco de interfaz (recortado sobre magenta)
- **Descripción de la imagen:** Botón cuadrado de esquinas redondeadas, crema con borde marrón, vacío.
- **Tamaño / proporción:** 1:1, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras; bordes limpios; el pipeline recorta al contenido (máx. 1024 px de ancho)
- **Dónde se usa:** Botones de ajustes y misiones diarias (arriba a la derecha). Icono encima.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `ui_btn_square.png`

```text
A single empty rounded-square UI button frame, warm cream (#FFF7E6) fill with a thin parchment texture, a thick warm dark-brown outline (#5B3A22), a soft lighter bevel on the top edge and a small darker bottom edge to suggest a raised button. Completely empty inside: no icon, no text. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. Front view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object.
```

### I-004 · Insignia roja de aviso
- **Tipo:** Marco de interfaz (recortado sobre magenta)
- **Descripción de la imagen:** Círculo rojo con borde crema/marrón, vacío.
- **Tamaño / proporción:** 1:1, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras; bordes limpios; el pipeline recorta al contenido (máx. 1024 px de ancho)
- **Dónde se usa:** Contador de avisos sobre el botón de misiones y puntos de aviso en la navegación.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `ui_badge.png`

```text
A single empty round red notification badge, glossy tomato red (#C8453B) with a small white highlight, a thick warm dark-brown outline (#5B3A22). Completely empty: no number, no text. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. Front view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object.
```

### I-005 · Tarjeta de etapa
- **Tipo:** Marco de interfaz (recortado sobre magenta)
- **Descripción de la imagen:** Tarjeta de papel crema, esquinas redondeadas, borde marrón grueso, vacía.
- **Tamaño / proporción:** 16:9, 1536x864 px, la tarjeta ocupa ~80 % del ancho
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras; bordes limpios; el pipeline recorta al contenido (máx. 1024 px de ancho)
- **Dónde se usa:** Fondo de la tarjeta inferior con 'Era 1 · Valle de los Dinos', nombre de etapa, etiquetas y botón Jugar (9-slice).
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `ui_panel_stage.png`

```text
A single empty horizontal UI card, about 2.6 times wider than tall, warm cream parchment paper (#FFF7E6) with subtle paper grain, rounded corners, a thick warm dark-brown outline (#5B3A22) and a thin lighter inner border line. Completely empty inside: no text, no icons, no decoration in the middle; corners and edges slightly ornamented with tiny leaf details only on the outline. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. Front view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object.
```

### I-006 · Botón Jugar
- **Tipo:** Marco de interfaz (recortado sobre magenta)
- **Descripción de la imagen:** Botón naranja grande, vacío (el texto Jugar/Play lo pone el juego).
- **Tamaño / proporción:** 16:9, 1536x864 px, el botón ocupa ~80 % del ancho
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras; bordes limpios; el pipeline recorta al contenido (máx. 1024 px de ancho)
- **Dónde se usa:** Botón principal de Home (~6:1 en pantalla), 9-slice con estados normal/pulsado por código.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `ui_btn_play.png`

```text
A single empty wide horizontal game button, about 5 times wider than tall, vivid orange (#F28C28) with a glossy lighter top half, a thick warm dark-brown outline (#5B3A22) and a darker orange bottom edge to look raised. Completely empty: no text, no icon, no arrow. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. Front view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object.
```

### I-007 · Pestaña de navegación (normal)
- **Tipo:** Marco de interfaz (recortado sobre magenta)
- **Descripción de la imagen:** Pestaña de esquinas redondeadas, beige claro, vacía.
- **Tamaño / proporción:** 1:1, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras; bordes limpios; el pipeline recorta al contenido (máx. 1024 px de ancho)
- **Dónde se usa:** Botón de la barra de navegación inferior (Escuadrón, Mejoras, Cápsulas, Tienda, Mapa); icono y texto van encima.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `ui_tab.png`

```text
A single empty rounded UI tab button frame, slightly taller than wide, a soft beige-cream (#EADFC4) fill, a thick warm dark-brown outline (#5B3A22) with a soft bevel. Completely empty: no icon, no text. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. Front view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object.
```

### I-008 · Pestaña de navegación (activa)
- **Tipo:** Marco de interfaz (recortado sobre magenta)
- **Descripción de la imagen:** Pestaña de esquinas redondeadas, crema brillante con detalle naranja, vacía.
- **Tamaño / proporción:** 1:1, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras; bordes limpios; el pipeline recorta al contenido (máx. 1024 px de ancho)
- **Dónde se usa:** Botón de la barra de navegación inferior (Escuadrón, Mejoras, Cápsulas, Tienda, Mapa); icono y texto van encima.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `ui_tab_active.png`

```text
A single empty rounded UI tab button frame, slightly taller than wide, a bright warm cream (#FFF7E6) fill, a thin orange (#F28C28) line along the top edge and a slightly stronger outline, a thick warm dark-brown outline (#5B3A22) with a soft bevel. Completely empty: no icon, no text. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. Front view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object.
```

### I-009 · Pestaña de navegación (bloqueada)
- **Tipo:** Marco de interfaz (recortado sobre magenta)
- **Descripción de la imagen:** Pestaña de esquinas redondeadas, gris arena apagado, vacía.
- **Tamaño / proporción:** 1:1, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras; bordes limpios; el pipeline recorta al contenido (máx. 1024 px de ancho)
- **Dónde se usa:** Botón de la barra de navegación inferior (Escuadrón, Mejoras, Cápsulas, Tienda, Mapa); icono y texto van encima.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `ui_tab_locked.png`

```text
A single empty rounded UI tab button frame, slightly taller than wide, a muted dusty tan-grey (#D9CDB4) fill with no highlights, flat and dull, a thick warm dark-brown outline (#5B3A22) with a soft bevel. Completely empty: no icon, no text. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. Front view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object.
```

### I-010 · Etiqueta pequeña (rol enemigo)
- **Tipo:** Marco de interfaz (recortado sobre magenta)
- **Descripción de la imagen:** Píldora crema pequeña, vacía.
- **Tamaño / proporción:** 16:9, 1536x864 px, la píldora ocupa ~50 % del ancho
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras; bordes limpios; el pipeline recorta al contenido (máx. 1024 px de ancho)
- **Dónde se usa:** Etiquetas 'Luchador x8' de la tarjeta de etapa.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `ui_tag.png`

```text
A single small empty pill-shaped label frame, about 3 times wider than tall, warm cream (#FFF7E6), a medium warm dark-brown outline (#5B3A22). Completely empty: no text, no icon. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. Front view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object.
```

### I-011 · Icono de fragmento del Núcleo
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Fragmento de cristal dorado y turquesa, angular, con destellos.
- **Tamaño / proporción:** 1:1, 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Fragmentos 0/5 de la ficha de Home y del mapa.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_shard.png`

```text
A single jagged shard of a golden-and-teal crystal with a glowing core, a tiny gear engraved on its surface and two small sparkles. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object. Square 1:1 image.
```

### I-012 · Icono de ajustes
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Engranaje marrón-dorado.
- **Tamaño / proporción:** 1:1, 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Botón de ajustes (arriba a la derecha).
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_settings.png`

```text
A single chunky friendly gear with eight rounded teeth, warm brown-gold color with a lighter highlight and a round hole in the center. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object. Square 1:1 image.
```

### I-013 · Icono de misiones diarias
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Pergamino enrollado con una estrella.
- **Tamaño / proporción:** 1:1, 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Botón de misiones/recompensa diaria.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_quests.png`

```text
A single rolled parchment scroll with curled ends, tied with a small red ribbon, with a golden star on the paper. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object. Square 1:1 image.
```

### I-014 · Icono de candado
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Candado dorado pequeño.
- **Tamaño / proporción:** 1:1, 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Pestañas de navegación bloqueadas.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_lock.png`

```text
A single small chunky golden padlock, closed, with a tiny keyhole and a soft highlight. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object. Square 1:1 image.
```

### I-015 · Icono de nav: Escuadrón
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Casco de gusano con escudo.
- **Tamaño / proporción:** 1:1, 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Pestaña Escuadrón.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_nav_squad.png`

```text
A single round little worm-soldier helmet with a small shield behind it, warm leather brown and gold. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object. Square 1:1 image.
```

### I-016 · Icono de nav: Mejoras
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Flecha hacia arriba sobre un martillo.
- **Tamaño / proporción:** 1:1, 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Pestaña Mejoras.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_nav_upgrades.png`

```text
A single bold green upward arrow rising from a small wooden hammer, with two small sparkles. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object. Square 1:1 image.
```

### I-017 · Icono de nav: Tienda
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Puesto de mercado con toldo rojo y crema.
- **Tamaño / proporción:** 1:1, 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Pestaña Tienda.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_nav_shop.png`

```text
A single tiny market stall with a red-and-cream striped awning, a wooden counter and a small coin on it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object. Square 1:1 image.
```

### I-018 · Icono de nav: Mapa
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Mapa del tesoro enrollado con una X.
- **Tamaño / proporción:** 1:1, 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Pestaña Mapa.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_nav_map.png`

```text
A single unrolled treasure map with curled corners, a dotted path and a red X mark. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object. Square 1:1 image.
```
