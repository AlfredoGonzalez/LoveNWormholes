# Fase E: Era 3 (Medieval)

Todo lo de la Era 3, incluyendo Sir Sizzle, proyectiles de estrella mágica y bola de estiércol y el icono de Dirt Shield.

**49 prompts** (7 referencias de personaje, 35 hojas de animación, 7 imágenes o sprites estáticos). Antes de empezar lee `README.md` (convenciones, tamaños, qué hacer si la cuadrícula sale mal). Genera cada referencia primero y luego sus animaciones en el mismo chat de Gemini, adjuntando `<id>_ref.png`.

---
### E-001 · Fondo de batalla, Era 3 (Medieval)
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Reino medieval verde con colinas, castillo lejano, molinos, estandartes y camino de piedra horizontal.
- **Tamaño / proporción:** 9:16 vertical, 1080x1920 px (si Gemini devuelve otra proporción, recortar a 9:16)
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Fondo de la batalla en las etapas de la Era 3 y el jefe Sir Sizzle.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `bg_era3.png`
- **Origen:** H03

```text
A green medieval kingdom with rolling hills, a small stone castle far in the distance, two windmills, colorful banners on poles, wooden fences, a soft afternoon sky with fluffy clouds and a flat stone-brick path running horizontally across the middle of the image. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Tall 9:16 portrait image with no characters, no text, no logos and no UI. Place the horizontal path at about 55 to 62 percent of the image height, keep the top 12 percent calm for the game HUD, and keep the bottom 30 percent calm and low-contrast so game buttons stay readable.
```

### E-002 · Base del jugador, Era 3
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Torre de castillo acogedora de piedra con almenas, puerta de madera, hiedra, ventana con luz y bandera azul y blanca.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline recorta y deja 512 px de ancho)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Base del jugador (izquierda del carril) en la Era 3.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `base_p3.png`
- **Origen:** E03

```text
A small cozy stone castle tower with tiny battlements, a sturdy wooden gate, ivy climbing the walls, an arched window glowing with warm candlelight and a blue-and-white banner on a pole at the top. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing right, centered with a wide empty margin, with only a small patch of grass directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### E-003 · Base enemiga, Era 3
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Castillo gris oscuro de torres puntiagudas, puerta de hierro, antorchas y estandartes rojos con escarabajo.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline recorta y deja 512 px de ancho)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Base enemiga (derecha del carril, mirando a la izquierda) en la Era 3.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `base_e3.png`
- **Origen:** E08

```text
A dark slate-gray castle with tall pointed towers, a heavy iron gate, small flickering torches and red banners with a beetle emblem hanging from the walls, looking grumpy but still cute. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing left, centered with a wide empty margin, with only a small patch of rocky ground directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### E-004 · Knight Worm: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `p3_knight_worm`, Knight Worm. Luchador (fighter), primer golpe +50%.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `p3_knight_worm_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** B07 (descripción de diseño)

```text
A small golden-yellow earthworm knight with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a tiny shiny steel helmet with a blue plume, holding a short sword and a blue-and-white kite shield. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### E-005 · Knight Worm: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p3_knight_worm`, Knight Worm. Luchador (fighter), primer golpe +50%.
- **Referencia a adjuntar:** `p3_knight_worm_ref.png`
- **Archivo de salida:** `p3_knight_worm_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p3_knight_worm_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B07, fila 1 (idle loop)

```text
Using the attached reference image (p3_knight_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Knight Worm performing the 'idle' animation.
Character identity, to stay consistent: Golden-yellow earthworm knight, blue headband, tiny shiny steel helmet with a blue plume, short sword, blue-and-white kite shield.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A calm looping idle: subtle breathing motion, the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: Slow inhale: the body rises slightly.
- Frames 7-12: The top of the breath, a tiny pause, the body starts to settle.
- Frames 13-19: Slow exhale: the body sinks a little below its resting height.
- Frames 20-25: The lowest point, a tiny settle, then the body returns to exactly the pose of frame 1.
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the body gently rises and sinks, the helmet plume sways, the sword tip bobs, and the eyes blink once.
```

### E-006 · Knight Worm: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p3_knight_worm`, Knight Worm. Luchador (fighter), primer golpe +50%.
- **Referencia a adjuntar:** `p3_knight_worm_ref.png`
- **Archivo de salida:** `p3_knight_worm_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p3_knight_worm_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B07, fila 2 (walk loop)

```text
Using the attached reference image (p3_knight_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Knight Worm performing the 'walk' animation.
Character identity, to stay consistent: Golden-yellow earthworm knight, blue headband, tiny shiny steel helmet with a blue plume, short sword, blue-and-white kite shield.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (walk): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: Contact pose: the body is stretched long and low, the head reaches forward.
- Frames 7-12: The tail end pulls forward along the ground while the middle of the body starts to arch up.
- Frames 13-19: The middle is arched at its highest like a small bridge, the head comes down.
- Frames 20-25: The front stretches forward again and the body flattens, ending in exactly the pose of frame 1.
- Character details to keep throughout the loop: the worm moves like an inchworm with the shield forward and the sword at his side, the plume bouncing.
```

### E-007 · Knight Worm: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p3_knight_worm`, Knight Worm. Luchador (fighter), primer golpe +50%.
- **Referencia a adjuntar:** `p3_knight_worm_ref.png`
- **Archivo de salida:** `p3_knight_worm_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p3_knight_worm_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B07, fila 3 (attack)

```text
Using the attached reference image (p3_knight_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Knight Worm performing the 'attack' animation.
Character identity, to stay consistent: Golden-yellow earthworm knight, blue headband, tiny shiny steel helmet with a blue plume, short sword, blue-and-white kite shield.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Fighter with a +50% first hit. One big, clean diagonal sword slash with the shield tucked in; the slash arc reads as a clear swoosh.
Motion by frames:
- Frames 1-6: The sword is lifted back over the shoulder and the shield tucks in toward the body; the plume tilts back.
- Frames 7-11: The body coils, the front leans back, the sword reaches its highest point with the blade pointing up and back.
- Frames 12-15: A big diagonal slash comes down and forward from the upper back to the lower front on frame 13, with a clean bright swoosh arc following the blade.
- Frames 16-19: The sword finishes low and forward, the body leans into the slash, the plume swings forward.
- Frames 20-25: The sword is raised back to the guard position, the shield returns to the front, the body straightens and the pose matches the idle.
```

### E-008 · Knight Worm: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p3_knight_worm`, Knight Worm. Luchador (fighter), primer golpe +50%.
- **Referencia a adjuntar:** `p3_knight_worm_ref.png`
- **Archivo de salida:** `p3_knight_worm_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p3_knight_worm_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B07, fila 4 (hurt)

```text
Using the attached reference image (p3_knight_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Knight Worm performing the 'hurt' animation.
Character identity, to stay consistent: Golden-yellow earthworm knight, blue headband, tiny shiny steel helmet with a blue plume, short sword, blue-and-white kite shield.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body flinches backward.
- Frames 6-18: The plume bends, the shield lifts and the eyes squeeze shut.
- Frames 19-25: The worm recovers.
```

### E-009 · Knight Worm: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p3_knight_worm`, Knight Worm. Luchador (fighter), primer golpe +50%.
- **Referencia a adjuntar:** `p3_knight_worm_ref.png`
- **Archivo de salida:** `p3_knight_worm_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p3_knight_worm_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B07, fila 5 (defeat)

```text
Using the attached reference image (p3_knight_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Knight Worm performing the 'defeat' animation.
Character identity, to stay consistent: Golden-yellow earthworm knight, blue headband, tiny shiny steel helmet with a blue plume, short sword, blue-and-white kite shield.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The helmet slides over the eyes.
- Frames 9-20: The worm droops and slides down flat, the sword and shield fall beside him.
- Frames 21-25: He ends lying still with tiny stars above his head. Hold this final pose still until frame 25.
```

### E-010 · Beetle Knight: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `e3_beetle_knight`, Beetle Knight. Luchador (fighter), carga con lanza.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `e3_beetle_knight_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** C07 (descripción de diseño)

```text
A sturdy dark-brown beetle knight with a shiny steel helmet topped with a red plume, steel shoulder plates, big round eyes, carrying a long lance and a small shield with a red emblem. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the left, facing left, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### E-011 · Beetle Knight: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e3_beetle_knight`, Beetle Knight. Luchador (fighter), carga con lanza.
- **Referencia a adjuntar:** `e3_beetle_knight_ref.png`
- **Archivo de salida:** `e3_beetle_knight_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e3_beetle_knight_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C07, fila 1 (idle loop)

```text
Using the attached reference image (e3_beetle_knight_ref.png) as the exact design of the character, draw an animation sprite sheet of Beetle Knight performing the 'idle' animation.
Character identity, to stay consistent: Sturdy dark-brown beetle knight, shiny steel helmet with a red plume, steel shoulder plates, long lance, small shield with a red emblem.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A calm looping idle: subtle breathing motion, the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: Slow inhale: the body rises slightly.
- Frames 7-12: The top of the breath, a tiny pause, the body starts to settle.
- Frames 13-19: Slow exhale: the body sinks a little below its resting height.
- Frames 20-25: The lowest point, a tiny settle, then the body returns to exactly the pose of frame 1.
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the body rises and sinks as it breathes, the plume sways, the lance tip bobs, and the eyes blink once.
```

### E-012 · Beetle Knight: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e3_beetle_knight`, Beetle Knight. Luchador (fighter), carga con lanza.
- **Referencia a adjuntar:** `e3_beetle_knight_ref.png`
- **Archivo de salida:** `e3_beetle_knight_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e3_beetle_knight_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C07, fila 2 (march loop)

```text
Using the attached reference image (e3_beetle_knight_ref.png) as the exact design of the character, draw an animation sprite sheet of Beetle Knight performing the 'walk' animation.
Character identity, to stay consistent: Sturdy dark-brown beetle knight, shiny steel helmet with a red plume, steel shoulder plates, long lance, small shield with a red emblem.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (march): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The first group of legs (front and rear on one side, middle on the other) steps forward while the others push back; the body dips a little.
- Frames 7-12: Weight passes over the planted legs, the body rises to its highest point.
- Frames 13-19: The second group of legs steps forward while the first pushes back; the body dips again.
- Frames 20-25: Weight passes again and the legs return to the exact positions of frame 1.
- Character details to keep throughout the loop: the legs step in alternating pairs, the shield held forward, the plume bouncing.
```

### E-013 · Beetle Knight: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e3_beetle_knight`, Beetle Knight. Luchador (fighter), carga con lanza.
- **Referencia a adjuntar:** `e3_beetle_knight_ref.png`
- **Archivo de salida:** `e3_beetle_knight_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e3_beetle_knight_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C07, fila 3 (attack)

```text
Using the attached reference image (e3_beetle_knight_ref.png) as the exact design of the character, draw an animation sprite sheet of Beetle Knight performing the 'attack' animation.
Character identity, to stay consistent: Sturdy dark-brown beetle knight, shiny steel helmet with a red plume, steel shoulder plates, long lance, small shield with a red emblem.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Lance charge, +50% first hit. The lance is pulled back and thrust forward with the whole body leaning into it.
Motion by frames:
- Frames 1-6: The beetle pulls the long lance back along its side, the shield rises in front and the plume tilts back.
- Frames 7-11: The body leans back and the legs brace, the lance tip is held high behind, a stern look.
- Frames 12-15: The whole body lunges forward and the lance thrusts straight ahead on frame 13, the shield tucked in, the plume streaming back.
- Frames 16-19: The lance stays extended at the end of the thrust, the body leans far forward, the cape-like plume whips.
- Frames 20-25: The lance pulls back along the side, the shield lowers, the body straightens and the pose matches the idle.
```

### E-014 · Beetle Knight: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e3_beetle_knight`, Beetle Knight. Luchador (fighter), carga con lanza.
- **Referencia a adjuntar:** `e3_beetle_knight_ref.png`
- **Archivo de salida:** `e3_beetle_knight_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e3_beetle_knight_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C07, fila 4 (hurt)

```text
Using the attached reference image (e3_beetle_knight_ref.png) as the exact design of the character, draw an animation sprite sheet of Beetle Knight performing the 'hurt' animation.
Character identity, to stay consistent: Sturdy dark-brown beetle knight, shiny steel helmet with a red plume, steel shoulder plates, long lance, small shield with a red emblem.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body flinches backward.
- Frames 6-18: The shield jerks up, the plume bends.
- Frames 19-25: It recovers.
```

### E-015 · Beetle Knight: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e3_beetle_knight`, Beetle Knight. Luchador (fighter), carga con lanza.
- **Referencia a adjuntar:** `e3_beetle_knight_ref.png`
- **Archivo de salida:** `e3_beetle_knight_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e3_beetle_knight_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C07, fila 5 (defeat)

```text
Using the attached reference image (e3_beetle_knight_ref.png) as the exact design of the character, draw an animation sprite sheet of Beetle Knight performing the 'defeat' animation.
Character identity, to stay consistent: Sturdy dark-brown beetle knight, shiny steel helmet with a red plume, steel shoulder plates, long lance, small shield with a red emblem.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The helmet slides over the eyes.
- Frames 9-20: The knees give way, the beetle falls onto its side with the lance and shield beside it.
- Frames 21-25: The Beetle Knight ends still with tiny stars above. Hold this final pose still until frame 25.
```

### E-016 · Crossbow Worm: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `p3_crossbow_worm`, Crossbow Worm. Tirador (shooter), disparo lento y fuerte.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `p3_crossbow_worm_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** B08 (descripción de diseño)

```text
A small golden-yellow earthworm archer with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a brown hood and holding a wooden crossbow with a bolt loaded. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### E-017 · Crossbow Worm: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p3_crossbow_worm`, Crossbow Worm. Tirador (shooter), disparo lento y fuerte.
- **Referencia a adjuntar:** `p3_crossbow_worm_ref.png`
- **Archivo de salida:** `p3_crossbow_worm_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p3_crossbow_worm_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B08, fila 1 (idle loop)

```text
Using the attached reference image (p3_crossbow_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Crossbow Worm performing the 'idle' animation.
Character identity, to stay consistent: Golden-yellow earthworm archer, blue headband, brown hood, wooden crossbow with a bolt loaded.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A calm looping idle: subtle breathing motion, the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: Slow inhale: the body rises slightly.
- Frames 7-12: The top of the breath, a tiny pause, the body starts to settle.
- Frames 13-19: Slow exhale: the body sinks a little below its resting height.
- Frames 20-25: The lowest point, a tiny settle, then the body returns to exactly the pose of frame 1.
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the body gently rises and sinks, the hood tip sways, the crossbow rests in the arms, and the eyes blink once.
```

### E-018 · Crossbow Worm: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p3_crossbow_worm`, Crossbow Worm. Tirador (shooter), disparo lento y fuerte.
- **Referencia a adjuntar:** `p3_crossbow_worm_ref.png`
- **Archivo de salida:** `p3_crossbow_worm_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p3_crossbow_worm_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B08, fila 2 (walk loop)

```text
Using the attached reference image (p3_crossbow_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Crossbow Worm performing the 'walk' animation.
Character identity, to stay consistent: Golden-yellow earthworm archer, blue headband, brown hood, wooden crossbow with a bolt loaded.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (walk): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: Contact pose: the body is stretched long and low, the head reaches forward.
- Frames 7-12: The tail end pulls forward along the ground while the middle of the body starts to arch up.
- Frames 13-19: The middle is arched at its highest like a small bridge, the head comes down.
- Frames 20-25: The front stretches forward again and the body flattens, ending in exactly the pose of frame 1.
- Character details to keep throughout the loop: the worm moves like an inchworm with the crossbow held up in front, the hood bobbing.
```

### E-019 · Crossbow Worm: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p3_crossbow_worm`, Crossbow Worm. Tirador (shooter), disparo lento y fuerte.
- **Referencia a adjuntar:** `p3_crossbow_worm_ref.png`
- **Archivo de salida:** `p3_crossbow_worm_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p3_crossbow_worm_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B08, fila 3 (attack)

```text
Using the attached reference image (p3_crossbow_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Crossbow Worm performing the 'attack' animation.
Character identity, to stay consistent: Golden-yellow earthworm archer, blue headband, brown hood, wooden crossbow with a bolt loaded.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Shooter, slow heavy shot. A long aiming pause, then the bolt is released at the key moment with a hard recoil. Do NOT draw the bolt in flight.
Motion by frames:
- Frames 1-6: The crossbow rises from the arms to eye level, the hood tip sways, one eye closes to aim.
- Frames 7-11: A long, steady aiming pause: the body is almost still, the crossbow is level, the finger rests on the trigger.
- Frames 12-15: The trigger is squeezed and the crossbow kicks back hard on frame 13; the string snaps forward (no bolt is drawn in flight), a small puff of dust at the tip.
- Frames 16-19: The recoil pushes the body slightly back, the crossbow tilts up and shakes.
- Frames 20-25: The crossbow lowers to rest in the arms again, the hood bobs, the body relaxes and the pose matches the idle.
```

### E-020 · Crossbow Worm: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p3_crossbow_worm`, Crossbow Worm. Tirador (shooter), disparo lento y fuerte.
- **Referencia a adjuntar:** `p3_crossbow_worm_ref.png`
- **Archivo de salida:** `p3_crossbow_worm_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p3_crossbow_worm_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B08, fila 4 (hurt)

```text
Using the attached reference image (p3_crossbow_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Crossbow Worm performing the 'hurt' animation.
Character identity, to stay consistent: Golden-yellow earthworm archer, blue headband, brown hood, wooden crossbow with a bolt loaded.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body flinches backward.
- Frames 6-18: The hood is pushed down over the eyes, the crossbow wobbles.
- Frames 19-25: The worm recovers.
```

### E-021 · Crossbow Worm: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p3_crossbow_worm`, Crossbow Worm. Tirador (shooter), disparo lento y fuerte.
- **Referencia a adjuntar:** `p3_crossbow_worm_ref.png`
- **Archivo de salida:** `p3_crossbow_worm_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p3_crossbow_worm_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B08, fila 5 (defeat)

```text
Using the attached reference image (p3_crossbow_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Crossbow Worm performing the 'defeat' animation.
Character identity, to stay consistent: Golden-yellow earthworm archer, blue headband, brown hood, wooden crossbow with a bolt loaded.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-20: The worm droops and slides down flat to the ground with the crossbow falling beside him.
- Frames 21-25: The Crossbow Worm ends lying still with tiny stars above his head. Hold this final pose still until frame 25.
```

### E-022 · Dung Catapult: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `e3_dung_catapult`, Dung Catapult. Tirador (shooter), catapulta de largo alcance.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `e3_dung_catapult_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** C08 (descripción de diseño)

```text
A stout dung beetle with big round eyes pushing a small wooden catapult on two wheels that is loaded with a round brown ball, a red banner flag attached to the catapult as team color, wearing a tiny leather cap and a mischievous grin. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the left, facing left, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### E-023 · Dung Catapult: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e3_dung_catapult`, Dung Catapult. Tirador (shooter), catapulta de largo alcance.
- **Referencia a adjuntar:** `e3_dung_catapult_ref.png`
- **Archivo de salida:** `e3_dung_catapult_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e3_dung_catapult_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C08, fila 1 (idle loop)

```text
Using the attached reference image (e3_dung_catapult_ref.png) as the exact design of the character, draw an animation sprite sheet of Dung Catapult performing the 'idle' animation.
Character identity, to stay consistent: Stout dung beetle with a tiny leather cap and a mischievous grin, pushing a small wooden two-wheeled catapult loaded with a round brown ball, red banner on it.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A calm looping idle: subtle breathing motion, the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: Slow inhale: the body rises slightly.
- Frames 7-12: The top of the breath, a tiny pause, the body starts to settle.
- Frames 13-19: Slow exhale: the body sinks a little below its resting height.
- Frames 20-25: The lowest point, a tiny settle, then the body returns to exactly the pose of frame 1.
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the beetle breathes, the banner flaps, the arm of the catapult rocks slightly, and the eyes blink once.
```

### E-024 · Dung Catapult: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e3_dung_catapult`, Dung Catapult. Tirador (shooter), catapulta de largo alcance.
- **Referencia a adjuntar:** `e3_dung_catapult_ref.png`
- **Archivo de salida:** `e3_dung_catapult_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e3_dung_catapult_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C08, fila 2 (push loop)

```text
Using the attached reference image (e3_dung_catapult_ref.png) as the exact design of the character, draw an animation sprite sheet of Dung Catapult performing the 'walk' animation.
Character identity, to stay consistent: Stout dung beetle with a tiny leather cap and a mischievous grin, pushing a small wooden two-wheeled catapult loaded with a round brown ball, red banner on it.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (push): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The first group of legs (front and rear on one side, middle on the other) steps forward while the others push back; the body dips a little.
- Frames 7-12: Weight passes over the planted legs, the body rises to its highest point.
- Frames 13-19: The second group of legs steps forward while the first pushes back; the body dips again.
- Frames 20-25: Weight passes again and the legs return to the exact positions of frame 1.
- Character details to keep throughout the loop: the beetle pushes the catapult forward with its legs stepping, the wheels turning, the banner flapping.
```

### E-025 · Dung Catapult: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e3_dung_catapult`, Dung Catapult. Tirador (shooter), catapulta de largo alcance.
- **Referencia a adjuntar:** `e3_dung_catapult_ref.png`
- **Archivo de salida:** `e3_dung_catapult_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e3_dung_catapult_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C08, fila 3 (attack)

```text
Using the attached reference image (e3_dung_catapult_ref.png) as the exact design of the character, draw an animation sprite sheet of Dung Catapult performing the 'attack' animation.
Character identity, to stay consistent: Stout dung beetle with a tiny leather cap and a mischievous grin, pushing a small wooden two-wheeled catapult loaded with a round brown ball, red banner on it.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Long-range catapult that targets the highest-HP unit. The lever is pulled, the arm swings forward and the ball is flung at the key moment. Do NOT draw the ball in flight.
Motion by frames:
- Frames 1-6: The beetle stops pushing and plants its legs; it reaches for the lever with the catapult arm lowered and the ball in the cup.
- Frames 7-11: The beetle pulls the lever back, the catapult arm tilts backward under tension, the wheels creak and the ropes tighten.
- Frames 12-15: The lever is released on frame 13: the catapult arm swings forward and flings the ball (the cup is empty after the throw, no ball drawn in flight); the whole catapult shakes.
- Frames 16-19: The arm swings past and bounces, the banner flaps, the beetle's cap flies up a little.
- Frames 20-25: The arm is cranked back down and a new ball is loaded; the beetle straightens its cap and the pose matches the idle.
```

### E-026 · Dung Catapult: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e3_dung_catapult`, Dung Catapult. Tirador (shooter), catapulta de largo alcance.
- **Referencia a adjuntar:** `e3_dung_catapult_ref.png`
- **Archivo de salida:** `e3_dung_catapult_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e3_dung_catapult_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C08, fila 4 (hurt)

```text
Using the attached reference image (e3_dung_catapult_ref.png) as the exact design of the character, draw an animation sprite sheet of Dung Catapult performing the 'hurt' animation.
Character identity, to stay consistent: Stout dung beetle with a tiny leather cap and a mischievous grin, pushing a small wooden two-wheeled catapult loaded with a round brown ball, red banner on it.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-18: The hit lands: the catapult is knocked backward, a wheel wobbles.
- Frames 19-25: The beetle's cap flies up and it recovers.
```

### E-027 · Dung Catapult: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e3_dung_catapult`, Dung Catapult. Tirador (shooter), catapulta de largo alcance.
- **Referencia a adjuntar:** `e3_dung_catapult_ref.png`
- **Archivo de salida:** `e3_dung_catapult_defeat_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e3_dung_catapult_defeat_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — caída o desarme con piezas, humo o chispas que se salen del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C08, fila 5 (defeat)

```text
Using the attached reference image (e3_dung_catapult_ref.png) as the exact design of the character, draw an animation sprite sheet of Dung Catapult performing the 'defeat' animation.
Character identity, to stay consistent: Stout dung beetle with a tiny leather cap and a mischievous grin, pushing a small wooden two-wheeled catapult loaded with a round brown ball, red banner on it.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: A wheel falls off.
- Frames 9-20: The catapult tips over, the beetle tumbles flat beside it.
- Frames 21-25: Everything ends still with tiny stars above. Hold this final pose still until frame 25.
```

### E-028 · Proyectil: bola de estiércol
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Bola marrón irregular de estiércol con pajitas y estela de polvo; apunta a la izquierda. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Proyectil de la Dung Catapult (Era 3). NUEVO: el original no lo traía.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `proj_dung_ball.png`
- **Origen:** nuevo (no estaba en el original)

```text
A single round lumpy brown dung ball with a few small straw bits stuck to it, a faint dusty motion swoosh behind it, pointing left. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single small object, side view pointing left, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### E-029 · Wizard Worm: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `p3_wizard_worm`, Wizard Worm. Apoyo (support), aura de daño +15%.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `p3_wizard_worm_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** B09 (descripción de diseño)

```text
A small golden-yellow earthworm wizard with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a tall pointy deep-blue wizard hat with gold stars and holding a wand topped with a glowing golden star, sparkles floating around, with a wise and slightly dizzy smile. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### E-030 · Wizard Worm: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p3_wizard_worm`, Wizard Worm. Apoyo (support), aura de daño +15%.
- **Referencia a adjuntar:** `p3_wizard_worm_ref.png`
- **Archivo de salida:** `p3_wizard_worm_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p3_wizard_worm_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B09, fila 1 (idle loop)

```text
Using the attached reference image (p3_wizard_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Wizard Worm performing the 'idle' animation.
Character identity, to stay consistent: Golden-yellow earthworm wizard, blue headband, tall pointy deep-blue hat with gold stars, wand with a glowing golden star, sparkles around.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A calm looping idle: subtle breathing motion, the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: Slow inhale: the body rises slightly.
- Frames 7-12: The top of the breath, a tiny pause, the body starts to settle.
- Frames 13-19: Slow exhale: the body sinks a little below its resting height.
- Frames 20-25: The lowest point, a tiny settle, then the body returns to exactly the pose of frame 1.
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the body gently rises and sinks, the hat tip flops side to side, the wand star pulses and sparkles twinkle, and the eyes blink once.
```

### E-031 · Wizard Worm: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p3_wizard_worm`, Wizard Worm. Apoyo (support), aura de daño +15%.
- **Referencia a adjuntar:** `p3_wizard_worm_ref.png`
- **Archivo de salida:** `p3_wizard_worm_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p3_wizard_worm_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B09, fila 2 (walk loop)

```text
Using the attached reference image (p3_wizard_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Wizard Worm performing the 'walk' animation.
Character identity, to stay consistent: Golden-yellow earthworm wizard, blue headband, tall pointy deep-blue hat with gold stars, wand with a glowing golden star, sparkles around.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (walk): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: Contact pose: the body is stretched long and low, the head reaches forward.
- Frames 7-12: The tail end pulls forward along the ground while the middle of the body starts to arch up.
- Frames 13-19: The middle is arched at its highest like a small bridge, the head comes down.
- Frames 20-25: The front stretches forward again and the body flattens, ending in exactly the pose of frame 1.
- Character details to keep throughout the loop: the worm moves like an inchworm with the wand held up, the hat bobbing and a few sparkles trailing behind.
```

### E-032 · Wizard Worm: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p3_wizard_worm`, Wizard Worm. Apoyo (support), aura de daño +15%.
- **Referencia a adjuntar:** `p3_wizard_worm_ref.png`
- **Archivo de salida:** `p3_wizard_worm_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p3_wizard_worm_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B09, fila 3 (attack)

```text
Using the attached reference image (p3_wizard_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Wizard Worm performing the 'attack' animation.
Character identity, to stay consistent: Golden-yellow earthworm wizard, blue headband, tall pointy deep-blue hat with gold stars, wand with a glowing golden star, sparkles around.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Support that boosts allied damage +15%. The wand is circled and pointed forward; a small golden star burst appears only at the wand tip (the star bolt itself is a separate sprite).
Motion by frames:
- Frames 1-6: The wand is lifted high with one hand, the hat tip flops back and a few sparkles start to gather around the wand star.
- Frames 7-11: The wand traces a full circle in the air above the head (draw the faint golden trail of the circle), the star glows brighter, the body sways.
- Frames 12-15: The wand points forward and a golden star burst pops at its tip on frame 13 (only the burst at the tip, no bolt in flight); the hat leans back and the body recoils slightly.
- Frames 16-19: The sparkles scatter forward and fade, the wand shakes, the hat flops.
- Frames 20-25: The wand lowers, the glow returns to its soft pulse, the worm straightens the hat and the pose matches the idle.
```

### E-033 · Wizard Worm: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p3_wizard_worm`, Wizard Worm. Apoyo (support), aura de daño +15%.
- **Referencia a adjuntar:** `p3_wizard_worm_ref.png`
- **Archivo de salida:** `p3_wizard_worm_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p3_wizard_worm_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B09, fila 4 (hurt)

```text
Using the attached reference image (p3_wizard_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Wizard Worm performing the 'hurt' animation.
Character identity, to stay consistent: Golden-yellow earthworm wizard, blue headband, tall pointy deep-blue hat with gold stars, wand with a glowing golden star, sparkles around.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body flinches backward.
- Frames 6-18: The hat flops over the eyes, sparkles scatter.
- Frames 19-25: The worm straightens the hat.
```

### E-034 · Wizard Worm: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p3_wizard_worm`, Wizard Worm. Apoyo (support), aura de daño +15%.
- **Referencia a adjuntar:** `p3_wizard_worm_ref.png`
- **Archivo de salida:** `p3_wizard_worm_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p3_wizard_worm_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B09, fila 5 (defeat)

```text
Using the attached reference image (p3_wizard_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Wizard Worm performing the 'defeat' animation.
Character identity, to stay consistent: Golden-yellow earthworm wizard, blue headband, tall pointy deep-blue hat with gold stars, wand with a glowing golden star, sparkles around.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-20: The wand star flickers out, the worm droops and slides down flat with the hat covering his face.
- Frames 21-25: The Wizard Worm ends lying still with tiny stars above his head. Hold this final pose still until frame 25.
```

### E-035 · Proyectil: estrella mágica
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Estrella dorada de cinco puntas brillante con dos chispas, volando a la derecha.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Proyectil de la Wizard Worm (Era 3).
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `proj_magic_star.png`
- **Origen:** F05

```text
A single glowing golden five-pointed star with a soft warm glow and two tiny sparkles trailing behind it, tilted slightly as if flying to the right. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single small object, side view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### E-036 · Hornet Scout: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `e3_hornet_scout`, Hornet Scout. Aéreo (air), vuela sobre luchadores.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `e3_hornet_scout_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** C09 (descripción de diseño)

```text
A small yellow-and-black striped hornet flying with blurry translucent wings, big round determined eyes, wearing a tiny leather helmet and a red cloth scarf as team color, holding a small spear pointed forward. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, hovering in a neutral pose with wings blurred, three-quarter view slightly turned toward the left, facing left, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### E-037 · Hornet Scout: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e3_hornet_scout`, Hornet Scout. Aéreo (air), vuela sobre luchadores.
- **Referencia a adjuntar:** `e3_hornet_scout_ref.png`
- **Archivo de salida:** `e3_hornet_scout_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e3_hornet_scout_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C09, fila 1 (hover loop)

```text
Using the attached reference image (e3_hornet_scout_ref.png) as the exact design of the character, draw an animation sprite sheet of Hornet Scout performing the 'idle' animation.
Character identity, to stay consistent: Small yellow-and-black striped hornet, blurry translucent wings, tiny leather helmet, red cloth scarf, small spear.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A calm looping idle: subtle breathing motion, the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The body drifts gently up.
- Frames 7-12: It reaches the top of the bob and the loose parts sway to one side.
- Frames 13-19: It drifts gently down and the loose parts sway the other way.
- Frames 20-25: It settles back to exactly the pose of frame 1.
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the wings buzz in blurry up and down positions, the body bobs slightly, the scarf flutters, and the eyes blink once.
```

### E-038 · Hornet Scout: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e3_hornet_scout`, Hornet Scout. Aéreo (air), vuela sobre luchadores.
- **Referencia a adjuntar:** `e3_hornet_scout_ref.png`
- **Archivo de salida:** `e3_hornet_scout_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e3_hornet_scout_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C09, fila 2 (flight loop)

```text
Using the attached reference image (e3_hornet_scout_ref.png) as the exact design of the character, draw an animation sprite sheet of Hornet Scout performing the 'walk' animation.
Character identity, to stay consistent: Small yellow-and-black striped hornet, blurry translucent wings, tiny leather helmet, red cloth scarf, small spear.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (flight): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The wings are raised high above the back and the body tilts forward.
- Frames 7-12: The wings sweep down fast, the body rises slightly.
- Frames 13-19: The wings swing back up, the body dips.
- Frames 20-25: The wings sweep down again and everything returns to the pose of frame 1 (the flap goes through two full cycles in the sheet).
- Character details to keep throughout the loop: the body tilts forward, the wings flap fast, the scarf streams behind, the spear points ahead.
```

### E-039 · Hornet Scout: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e3_hornet_scout`, Hornet Scout. Aéreo (air), vuela sobre luchadores.
- **Referencia a adjuntar:** `e3_hornet_scout_ref.png`
- **Archivo de salida:** `e3_hornet_scout_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e3_hornet_scout_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C09, fila 3 (attack)

```text
Using the attached reference image (e3_hornet_scout_ref.png) as the exact design of the character, draw an animation sprite sheet of Hornet Scout performing the 'attack' animation.
Character identity, to stay consistent: Small yellow-and-black striped hornet, blurry translucent wings, tiny leather helmet, red cloth scarf, small spear.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Flying unit that passes over fighters. It pulls back, then dives forward and thrusts the spear at the key moment, then swings back up.
Motion by frames:
- Frames 1-6: The hornet pulls its body back and rises slightly, the spear pulled in close and the wings buzzing in blur.
- Frames 7-11: It tilts into a dive angle, the stinger end pointing toward the target, the scarf streams back.
- Frames 12-15: The hornet dives forward on frame 13 and thrusts the spear straight ahead at the end of the dive; the wings stretch back.
- Frames 16-19: It swings upward past the target in an arc, the scarf whipping.
- Frames 20-25: It returns to its hover height, the spear comes back to point forward and the pose matches the hover idle.
```

### E-040 · Hornet Scout: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e3_hornet_scout`, Hornet Scout. Aéreo (air), vuela sobre luchadores.
- **Referencia a adjuntar:** `e3_hornet_scout_ref.png`
- **Archivo de salida:** `e3_hornet_scout_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e3_hornet_scout_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C09, fila 4 (hurt)

```text
Using the attached reference image (e3_hornet_scout_ref.png) as the exact design of the character, draw an animation sprite sheet of Hornet Scout performing the 'hurt' animation.
Character identity, to stay consistent: Small yellow-and-black striped hornet, blurry translucent wings, tiny leather helmet, red cloth scarf, small spear.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body is knocked backward and spins slightly.
- Frames 6-18: The wings stutter, the scarf whips.
- Frames 19-25: It recovers.
```

### E-041 · Hornet Scout: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e3_hornet_scout`, Hornet Scout. Aéreo (air), vuela sobre luchadores.
- **Referencia a adjuntar:** `e3_hornet_scout_ref.png`
- **Archivo de salida:** `e3_hornet_scout_defeat_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e3_hornet_scout_defeat_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — caída o desarme con piezas, humo o chispas que se salen del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C09, fila 5 (defeat)

```text
Using the attached reference image (e3_hornet_scout_ref.png) as the exact design of the character, draw an animation sprite sheet of Hornet Scout performing the 'defeat' animation.
Character identity, to stay consistent: Small yellow-and-black striped hornet, blurry translucent wings, tiny leather helmet, red cloth scarf, small spear.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The wings stop.
- Frames 9-20: The helmet falls off, the hornet spirals downward and lands flat.
- Frames 21-25: The Hornet Scout ends still with tiny stars above. Hold this final pose still until frame 25.
```

### E-042 · Sir Sizzle the Dragon (jefe Era 3): referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `b3_sir_sizzle`, Sir Sizzle the Dragon (jefe Era 3). Jefe pesado; aliento de fuego, fase 2 vuela.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `b3_sir_sizzle_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** D03 (descripción de diseño)

```text
Sir Sizzle, a chubby red-orange dragon with small leathery wings, a cream belly and big round eyes, wearing a dented tin knight helmet that is too small for his head, little curls of smoke rising from his nostrils and a red banner tied to his tail. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the left, facing left, filling most of the frame, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### E-043 · Sir Sizzle the Dragon (jefe Era 3): idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b3_sir_sizzle`, Sir Sizzle the Dragon (jefe Era 3). Jefe pesado; aliento de fuego, fase 2 vuela.
- **Referencia a adjuntar:** `b3_sir_sizzle_ref.png`
- **Archivo de salida:** `b3_sir_sizzle_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `b3_sir_sizzle_idle_x2_sheet.png` (celda 1024 px / hoja 5120x5120 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido en el cuerpo del jefe (que ya llena la celda). Lienzo normal.
- **Origen:** D03, fila 1 (idle loop)

```text
Using the attached reference image (b3_sir_sizzle_ref.png) as the exact design of the character, draw an animation sprite sheet of Sir Sizzle the Dragon performing the 'idle' animation.
Character identity, to stay consistent: Sir Sizzle: chubby red-orange dragon, small leathery wings, cream belly, dented tin knight helmet that is too small, smoke from the nostrils, red banner on the tail.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A calm looping idle: subtle breathing motion, the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: Slow inhale: the body rises slightly.
- Frames 7-12: The top of the breath, a tiny pause, the body starts to settle.
- Frames 13-19: Slow exhale: the body sinks a little below its resting height.
- Frames 20-25: The lowest point, a tiny settle, then the body returns to exactly the pose of frame 1.
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): smoke curls rise from the nostrils, the helmet wobbles, the wings twitch, the banner sways, and the eyes blink once.
```

### E-044 · Sir Sizzle the Dragon (jefe Era 3): walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b3_sir_sizzle`, Sir Sizzle the Dragon (jefe Era 3). Jefe pesado; aliento de fuego, fase 2 vuela.
- **Referencia a adjuntar:** `b3_sir_sizzle_ref.png`
- **Archivo de salida:** `b3_sir_sizzle_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `b3_sir_sizzle_walk_x2_sheet.png` (celda 1024 px / hoja 5120x5120 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido en el cuerpo del jefe (que ya llena la celda). Lienzo normal.
- **Origen:** D03, fila 2 (walk loop)

```text
Using the attached reference image (b3_sir_sizzle_ref.png) as the exact design of the character, draw an animation sprite sheet of Sir Sizzle the Dragon performing the 'walk' animation.
Character identity, to stay consistent: Sir Sizzle: chubby red-orange dragon, small leathery wings, cream belly, dented tin knight helmet that is too small, smoke from the nostrils, red banner on the tail.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (walk): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The body tilts to the right as the left foot lifts in a clumsy waddle.
- Frames 7-12: The left foot lands, the belly jiggles, the body tilts back to the center.
- Frames 13-19: The body tilts to the left as the right foot lifts.
- Frames 20-25: The right foot lands and the body returns to the pose of frame 1.
- Character details to keep throughout the loop: clumsy waddling steps with alternating legs, the wings flapping slightly and the helmet bouncing.
```

### E-045 · Sir Sizzle the Dragon (jefe Era 3): attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b3_sir_sizzle`, Sir Sizzle the Dragon (jefe Era 3). Jefe pesado; aliento de fuego, fase 2 vuela.
- **Referencia a adjuntar:** `b3_sir_sizzle_ref.png`
- **Archivo de salida:** `b3_sir_sizzle_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `b3_sir_sizzle_attack_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 1024 px / hoja 5120x5120 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el golpe/aliento/ráfaga del jefe llega muy lejos del cuerpo. Recomendado lienzo doble: celda 1024 px, hoja 5120x5120 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** D03, fila 3 (attack)

```text
Using the attached reference image (b3_sir_sizzle_ref.png) as the exact design of the character, draw an animation sprite sheet of Sir Sizzle the Dragon performing the 'attack' animation.
Character identity, to stay consistent: Sir Sizzle: chubby red-orange dragon, small leathery wings, cream belly, dented tin knight helmet that is too small, smoke from the nostrils, red banner on the tail.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Boss. He inhales so the belly swells, rears the head back, then breathes a big cartoon fireball forward with the helmet flying up. Phase 2 makes him fly in the game, but this sheet keeps him walking.
Motion by frames:
- Frames 1-6: Sir Sizzle takes a deep breath: the belly begins to swell, the wings lift and the helmet wobbles on his head.
- Frames 7-11: The belly is at its biggest, the head rears far back, the smoke curls thicken, the cheeks puff.
- Frames 12-15: He thrusts the head forward and breathes a big cartoon fireball on frame 13, the helmet flying up off his head; the flame stretches far in front of him.
- Frames 16-19: The fire keeps pouring forward in a streak as the belly shrinks, the banner on the tail whips, the helmet spins in the air.
- Frames 20-25: The flame fades into a wisp of smoke, the helmet drops back onto his head crooked, the belly settles and the pose matches the idle.
```

### E-046 · Sir Sizzle the Dragon (jefe Era 3): hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b3_sir_sizzle`, Sir Sizzle the Dragon (jefe Era 3). Jefe pesado; aliento de fuego, fase 2 vuela.
- **Referencia a adjuntar:** `b3_sir_sizzle_ref.png`
- **Archivo de salida:** `b3_sir_sizzle_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `b3_sir_sizzle_hurt_x2_sheet.png` (celda 1024 px / hoja 5120x5120 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido en el cuerpo del jefe (que ya llena la celda). Lienzo normal.
- **Origen:** D03, fila 4 (hurt)

```text
Using the attached reference image (b3_sir_sizzle_ref.png) as the exact design of the character, draw an animation sprite sheet of Sir Sizzle the Dragon performing the 'hurt' animation.
Character identity, to stay consistent: Sir Sizzle: chubby red-orange dragon, small leathery wings, cream belly, dented tin knight helmet that is too small, smoke from the nostrils, red banner on the tail.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the helmet is knocked over his eyes.
- Frames 6-18: The body is pushed back, the wings flare.
- Frames 19-25: He straightens it.
```

### E-047 · Sir Sizzle the Dragon (jefe Era 3): defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b3_sir_sizzle`, Sir Sizzle the Dragon (jefe Era 3). Jefe pesado; aliento de fuego, fase 2 vuela.
- **Referencia a adjuntar:** `b3_sir_sizzle_ref.png`
- **Archivo de salida:** `b3_sir_sizzle_defeat_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `b3_sir_sizzle_defeat_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 1024 px / hoja 5120x5120 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el jefe cae y se derrumba ocupando mucho más espacio. Recomendado lienzo doble: celda 1024 px, hoja 5120x5120 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** D03, fila 5 (defeat)

```text
Using the attached reference image (b3_sir_sizzle_ref.png) as the exact design of the character, draw an animation sprite sheet of Sir Sizzle the Dragon performing the 'defeat' animation.
Character identity, to stay consistent: Sir Sizzle: chubby red-orange dragon, small leathery wings, cream belly, dented tin knight helmet that is too small, smoke from the nostrils, red banner on the tail.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The helmet clangs off.
- Frames 9-20: The legs give way, he sits, then flops backward with a puff of smoke.
- Frames 21-25: Sir Sizzle ends still with tiny stars above. Hold this final pose still until frame 25.
```

### E-048 · Insignia de era: Medieval
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Medalla de plata con una torre de castillo y estandarte azul y blanco.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Cabecera del mapa y Home en la Era 3, selector de era.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `era_3.png`
- **Origen:** G14

```text
A round silver medallion with a tiny castle tower and a blue-and-white banner in the center, a studded rim and a soft metallic shine. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### E-049 · Icono de poder: Dirt Shield
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Escudo redondo de tierra compactada con piedrecitas, un brote verde y borde dorado.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Botón de poder del HUD y selector de poderes; se desbloquea tras el jefe de la Era 3.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `power_dirt_shield.png`
- **Origen:** G10

```text
A sturdy round shield made of packed brown dirt with small pebbles pressed into it and a tiny green sprout growing from the top, with a thin golden rim. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```
