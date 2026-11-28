# Fase J: Mi casita (nueva casa exterior e interior)
Estilo de esta fase: **sin acuarela ni toques de pincel**, ilustración de cuento limpia con sombreado suave y contorno marrón fino. Los textos y los retratos los pone el juego, por eso los marcos y el estante van **vacíos**.
Cómo trabajamos: tú generas y subes las piezas y haces un mock del interior con cada cosa en su sitio; yo coloco y programo la pantalla (tocar la casa en Home abre 'Mi casita'; fragmentos en el estante, fotos de Squirmy y Wormina en los marcos).

### J-001 · Casita exterior (nueva)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Madriguera-casita en una colina de hierba: puerta redonda verde, ventana redonda, chimenea con humo, farolito, escalones de piedra.
- **Tamaño / proporción:** 4:3 horizontal, 1536x1152 px
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios; el pipeline recorta al contenido
- **Dónde se usa:** Sustituye a `home_burrow`: la casa de Home (35-46 % del ancho de pantalla, junto al sendero). Al tocarla se abre 'Mi casita'. La base debe quedar plana y limpia para apoyarse en el sendero.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `home_burrow.png`

```text
A cozy storybook hobbit-style home built into a small grassy hill, seen from the front at a slight three-quarter angle. A big round wooden door painted warm green with a golden knob, a small round window with warm yellow light, a little stone chimney with a curl of white smoke, a tiny hanging lantern beside the door, three flat stone steps in front, clover and small white daisies growing on the roof of the hill, a small wooden mailbox. The bottom edge of the house is flat and clean so it can stand on a path. Clean polished storybook cartoon illustration with smooth soft shading, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. A single object, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object. Horizontal 4:3 image.
```

### J-002 · Interior de Mi casita (fondo)
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Habitación vacía en corte transversal: paredes de tierra y raíces, vigas de madera, ventana redonda con bosque al fondo, suelo de tablas.
- **Tamaño / proporción:** 9:16 vertical, 1536x2752 px (nada importante en el 10 % lateral)
- **Datos técnicos:** imagen completa; sin texto ni personajes; sin muebles
- **Dónde se usa:** Fondo de la pantalla 'Mi casita' (se abre al tocar la casa en Home). Zonas: 0-14 % superior = vigas y raíces tranquilas (fichas de monedas encima); 14-45 % = pared trasera con la ventana redonda al centro; 45-85 % = pared y suelo despejados donde se colocan estante, fotos, cama, mesa y alfombra; 85-100 % = suelo liso (botón Volver).
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `bg_house.png`

```text
The empty interior of a cozy underground storybook worm home, seen straight from the front like a cutaway room in a vertical 9:16 composition: warm earthy walls with visible tree roots and wooden beams across the ceiling, a round window in the center of the back wall showing a soft green forest outside with warm daylight, a wooden plank floor in the lower part, soft warm golden light and gentle shadows in the corners. The room is completely empty: no furniture, no shelves, no pictures, no rug, no characters, no text. Keep the lower 15% as plain floor and keep details away from the left and right edges. Clean polished storybook cartoon illustration with smooth soft shading, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. Vertical 9:16 image.
```

### J-003 · Cama de Squirmy
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Camita de gusano con colchón verde claro, manta a rayas y almohada.
- **Tamaño / proporción:** 1:1, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios; el pipeline recorta al contenido
- **Dónde se usa:** Mi casita: su camita (se coloca sobre el suelo).
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `house_bed.png`

```text
A tiny cozy worm bed, long and low, with a wooden frame, a light-green mattress, a striped orange-and-cream blanket and a small round pillow, seen from the front at a slight three-quarter angle, the bottom edge flat. Clean polished storybook cartoon illustration with smooth soft shading, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. A single object, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object. Square 1:1 image.
```

### J-004 · Estante de fragmentos
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Estante de madera con cinco nichos redondos vacíos para los fragmentos del Núcleo.
- **Tamaño / proporción:** 1:1, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios; el pipeline recorta al contenido
- **Dónde se usa:** Mi casita: cada nicho se ilumina con un fragmento del Núcleo (0/5) según los jefes vencidos. Los nichos van vacíos.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `house_shelf.png`

```text
A wide wooden wall shelf with five empty round niches in a row, each niche slightly recessed with a soft darker inner shade and a thin golden rim, small carved leaves on the wooden frame, seen straight from the front. The niches are completely empty. Clean polished storybook cartoon illustration with smooth soft shading, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. A single object, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object. Square 1:1 image.
```

### J-005 · Marco de foto
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Marco de madera vertical, vacío, con un pequeño lazo.
- **Tamaño / proporción:** 1:1, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios; el pipeline recorta al contenido
- **Dónde se usa:** Mi casita: el juego pone dentro el retrato de Squirmy, de Wormina y otros. Debe verse vacío: sin fotografía.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `house_frame.png`

```text
A single empty vertical wooden picture frame with rounded corners and a small bow at the top corner, seen straight from the front, the inside of the frame is plain flat warm cream with no picture and no pattern. Clean polished storybook cartoon illustration with smooth soft shading, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. A single object, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object. Square 1:1 image.
```

### J-006 · Mesa con vela
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Mesita redonda de madera con una vela y una taza.
- **Tamaño / proporción:** 1:1, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios; el pipeline recorta al contenido
- **Dónde se usa:** Mi casita: decoración junto a la cama.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `house_table.png`

```text
A small round wooden table with a short thick candle with a small flame and a little teacup on it, seen from the front at a slight three-quarter angle, the bottom of the legs flat. Clean polished storybook cartoon illustration with smooth soft shading, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. A single object, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object. Square 1:1 image.
```

### J-007 · Alfombra
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Alfombra redonda de trapo con borde de tréboles.
- **Tamaño / proporción:** 1:1, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios; el pipeline recorta al contenido
- **Dónde se usa:** Mi casita: en el suelo, bajo la cama y la mesa.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `house_rug.png`

```text
A round woven rag rug viewed from a three-quarter top-down angle so it looks like an oval, cream with concentric green and orange rings and a border of tiny clover leaves. Clean polished storybook cartoon illustration with smooth soft shading, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. A single object, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object. Square 1:1 image.
```

### J-008 · Lámpara colgante
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Farol colgante con luz cálida.
- **Tamaño / proporción:** 1:1, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios; el pipeline recorta al contenido
- **Dónde se usa:** Mi casita: cuelga del techo; el juego añade un brillo cálido y suave.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `house_lamp.png`

```text
A single hanging lantern with a short chain at the top, a rounded brass body with warm yellow glass and a glowing light inside, seen from the front. Clean polished storybook cartoon illustration with smooth soft shading, thin warm dark-brown ink outlines (#5B3A22), cute rounded shapes and friendly saturated colors. A single object, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text. Crisp clean edges. Do not use magenta or pink anywhere on the object. Square 1:1 image.
```
