# Fase C: Era 2 (Egipto)

Todo lo de la Era 2: 3 unidades, 3 enemigos, Pharaoh Scarab, bases, flecha, insignia, icono de Rewind y fondo.

**48 prompts** (7 referencias de personaje, 35 hojas de animación, 6 imágenes o sprites estáticos). Antes de empezar lee `README.md` (convenciones, tamaños, qué hacer si la cuadrícula sale mal). Genera cada referencia primero y luego sus animaciones en el mismo chat de Gemini, adjuntando `<id>_ref.png`.

---
### C-001 · Fondo de batalla, Era 2 (Egipto)
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Desierto egipcio al mediodía con dunas, tres pirámides, río con papiros y palmeras; camino de arena horizontal.
- **Tamaño / proporción:** 9:16 vertical, 1080x1920 px (si Gemini devuelve otra proporción, recortar a 9:16)
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Fondo de la batalla en las etapas de la Era 2 y el jefe Pharaoh Scarab.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `bg_era2.png`
- **Origen:** H02

```text
A hot Egyptian desert at noon with golden sand dunes, three sandstone pyramids in the distance, a small stretch of blue river with papyrus reeds and a few palm trees, a pale turquoise sky and a flat packed-sand path running horizontally across the middle of the image. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Tall 9:16 portrait image with no characters, no text, no logos and no UI. Place the horizontal path at about 55 to 62 percent of the image height, keep the top 12 percent calm for the game HUD, and keep the bottom 30 percent calm and low-contrast so game buttons stay readable.
```

### C-002 · Base del jugador, Era 2
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Madriguera en forma de pirámide de arenisca con puerta en arco, jeroglíficos, gema turquesa y bandera azul.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline recorta y deja 512 px de ancho)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Base del jugador (izquierda del carril) en la Era 2.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `base_p2.png`
- **Origen:** E02

```text
A small sandstone pyramid-shaped worm burrow base with a dark arched doorway, simple carved hieroglyph patterns, a turquoise gem at the peak, a blue banner hanging from the top and a little palm tree beside it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing right, centered with a wide empty margin, with only a small patch of sand directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### C-003 · Base enemiga, Era 2
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Templo dorado del escarabajo con columnas, una gran estatua de escarabajo en el techo y banderas rojas.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline recorta y deja 512 px de ancho)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Base enemiga (derecha del carril, mirando a la izquierda) en la Era 2.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `base_e2.png`
- **Origen:** E07

```text
A golden scarab temple with sandstone columns, a big golden scarab beetle statue on its roof, a dark entrance with a stepped front and red banners hanging at both sides. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing left, centered with a wide empty margin, with only a small patch of sand directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### C-004 · Shield Bearer Worm: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `p2_shield_bearer_worm`, Shield Bearer Worm. Pesado (heavy), bloquea 20% del daño a distancia.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `p2_shield_bearer_worm_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** B04 (descripción de diseño)

```text
A small golden-yellow earthworm soldier with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a gold-and-turquoise striped Egyptian headdress, carrying a big round gold shield with a turquoise scarab beetle emblem in front of him and a short bronze spear. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### C-005 · Shield Bearer Worm: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p2_shield_bearer_worm`, Shield Bearer Worm. Pesado (heavy), bloquea 20% del daño a distancia.
- **Referencia a adjuntar:** `p2_shield_bearer_worm_ref.png`
- **Archivo de salida:** `p2_shield_bearer_worm_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p2_shield_bearer_worm_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B04, fila 1 (idle loop)

```text
Using the attached reference image (p2_shield_bearer_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Shield Bearer Worm performing the 'idle' animation.
Character identity, to stay consistent: Golden-yellow earthworm soldier, blue headband, gold-and-turquoise striped Egyptian headdress, big round gold shield with a turquoise scarab, short bronze spear.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the body gently rises and sinks behind the shield, the headdress tails sway, and the eyes blink once.
```

### C-006 · Shield Bearer Worm: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p2_shield_bearer_worm`, Shield Bearer Worm. Pesado (heavy), bloquea 20% del daño a distancia.
- **Referencia a adjuntar:** `p2_shield_bearer_worm_ref.png`
- **Archivo de salida:** `p2_shield_bearer_worm_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p2_shield_bearer_worm_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B04, fila 2 (walk loop)

```text
Using the attached reference image (p2_shield_bearer_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Shield Bearer Worm performing the 'walk' animation.
Character identity, to stay consistent: Golden-yellow earthworm soldier, blue headband, gold-and-turquoise striped Egyptian headdress, big round gold shield with a turquoise scarab, short bronze spear.
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
- Character details to keep throughout the loop: the worm moves like an inchworm with the shield held steady in front, the body arching and stretching forward.
```

### C-007 · Shield Bearer Worm: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p2_shield_bearer_worm`, Shield Bearer Worm. Pesado (heavy), bloquea 20% del daño a distancia.
- **Referencia a adjuntar:** `p2_shield_bearer_worm_ref.png`
- **Archivo de salida:** `p2_shield_bearer_worm_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p2_shield_bearer_worm_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B04, fila 3 (attack)

```text
Using the attached reference image (p2_shield_bearer_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Shield Bearer Worm performing the 'attack' animation.
Character identity, to stay consistent: Golden-yellow earthworm soldier, blue headband, gold-and-turquoise striped Egyptian headdress, big round gold shield with a turquoise scarab, short bronze spear.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Heavy defender (blocks 20% of ranged damage). A shield bash forward with the spear jabbing over the top edge at the key moment; the shield always stays between the worm and the front.
Motion by frames:
- Frames 1-6: The body pulls back behind the shield, the shield draws toward the chest and the spear is gathered back along the shield's upper edge.
- Frames 7-11: The worm braces, the body compresses, the headdress tails swing back.
- Frames 12-15: The shield pushes forward in a hard bash and the spear jabs over its top edge on frame 13; the headdress tails whip forward.
- Frames 16-19: The shield stays extended, a small shock flash at the shield's rim, the spear tip retracts slightly.
- Frames 20-25: The shield and spear pull back to the guard position in front of the body, the headdress tails settle and the pose matches the idle.
```

### C-008 · Shield Bearer Worm: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p2_shield_bearer_worm`, Shield Bearer Worm. Pesado (heavy), bloquea 20% del daño a distancia.
- **Referencia a adjuntar:** `p2_shield_bearer_worm_ref.png`
- **Archivo de salida:** `p2_shield_bearer_worm_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p2_shield_bearer_worm_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B04, fila 4 (hurt)

```text
Using the attached reference image (p2_shield_bearer_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Shield Bearer Worm performing the 'hurt' animation.
Character identity, to stay consistent: Golden-yellow earthworm soldier, blue headband, gold-and-turquoise striped Egyptian headdress, big round gold shield with a turquoise scarab, short bronze spear.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-18: The hit lands: the shield takes a hit and shakes, the body is pushed back and the eyes squeeze shut.
- Frames 19-25: The worm braces again.
```

### C-009 · Shield Bearer Worm: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p2_shield_bearer_worm`, Shield Bearer Worm. Pesado (heavy), bloquea 20% del daño a distancia.
- **Referencia a adjuntar:** `p2_shield_bearer_worm_ref.png`
- **Archivo de salida:** `p2_shield_bearer_worm_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p2_shield_bearer_worm_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B04, fila 5 (defeat)

```text
Using the attached reference image (p2_shield_bearer_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Shield Bearer Worm performing the 'defeat' animation.
Character identity, to stay consistent: Golden-yellow earthworm soldier, blue headband, gold-and-turquoise striped Egyptian headdress, big round gold shield with a turquoise scarab, short bronze spear.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-20: The shield tips forward and falls flat, the worm slides down behind it.
- Frames 21-25: The Shield Bearer Worm ends lying still with tiny stars above his head. Hold this final pose still until frame 25.
```

### C-010 · Scarab Soldier: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `e2_scarab_soldier`, Scarab Soldier. Luchador (fighter), cuerpo a cuerpo.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `e2_scarab_soldier_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** C04 (descripción de diseño)

```text
A golden scarab beetle soldier with a shiny turquoise-edged shell, big round eyes, a red cloth sash across its body as team color, wearing a small gold helmet and carrying a curved bronze blade. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the left, facing left, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### C-011 · Scarab Soldier: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e2_scarab_soldier`, Scarab Soldier. Luchador (fighter), cuerpo a cuerpo.
- **Referencia a adjuntar:** `e2_scarab_soldier_ref.png`
- **Archivo de salida:** `e2_scarab_soldier_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e2_scarab_soldier_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C04, fila 1 (idle loop)

```text
Using the attached reference image (e2_scarab_soldier_ref.png) as the exact design of the character, draw an animation sprite sheet of Scarab Soldier performing the 'idle' animation.
Character identity, to stay consistent: Golden scarab beetle soldier, shiny turquoise-edged shell, red cloth sash, small gold helmet, curved bronze blade.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the body bobs, the blade tip sways, the shell glints, and the eyes blink once.
```

### C-012 · Scarab Soldier: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e2_scarab_soldier`, Scarab Soldier. Luchador (fighter), cuerpo a cuerpo.
- **Referencia a adjuntar:** `e2_scarab_soldier_ref.png`
- **Archivo de salida:** `e2_scarab_soldier_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e2_scarab_soldier_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C04, fila 2 (march loop)

```text
Using the attached reference image (e2_scarab_soldier_ref.png) as the exact design of the character, draw an animation sprite sheet of Scarab Soldier performing the 'walk' animation.
Character identity, to stay consistent: Golden scarab beetle soldier, shiny turquoise-edged shell, red cloth sash, small gold helmet, curved bronze blade.
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
- Character details to keep throughout the loop: the legs step in alternating pairs with the blade held up, the body bobbing proudly.
```

### C-013 · Scarab Soldier: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e2_scarab_soldier`, Scarab Soldier. Luchador (fighter), cuerpo a cuerpo.
- **Referencia a adjuntar:** `e2_scarab_soldier_ref.png`
- **Archivo de salida:** `e2_scarab_soldier_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e2_scarab_soldier_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C04, fila 3 (attack)

```text
Using the attached reference image (e2_scarab_soldier_ref.png) as the exact design of the character, draw an animation sprite sheet of Scarab Soldier performing the 'attack' animation.
Character identity, to stay consistent: Golden scarab beetle soldier, shiny turquoise-edged shell, red cloth sash, small gold helmet, curved bronze blade.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Melee. A diagonal bronze-blade slash.
Motion by frames:
- Frames 1-6: The scarab raises its bronze blade backward over the shoulder, the helmet tilts back and the shell lifts slightly.
- Frames 7-11: The body leans far back, the blade is held high at its maximum, the legs brace.
- Frames 12-15: A diagonal slash comes down and forward on frame 13 with a clean bright swoosh arc; the shell shines as it passes.
- Frames 16-19: The blade finishes low and forward, the body leans into the cut, the sash flutters.
- Frames 20-25: The blade is raised back to the guard position, the body straightens and the pose matches the idle.
```

### C-014 · Scarab Soldier: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e2_scarab_soldier`, Scarab Soldier. Luchador (fighter), cuerpo a cuerpo.
- **Referencia a adjuntar:** `e2_scarab_soldier_ref.png`
- **Archivo de salida:** `e2_scarab_soldier_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e2_scarab_soldier_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C04, fila 4 (hurt)

```text
Using the attached reference image (e2_scarab_soldier_ref.png) as the exact design of the character, draw an animation sprite sheet of Scarab Soldier performing the 'hurt' animation.
Character identity, to stay consistent: Golden scarab beetle soldier, shiny turquoise-edged shell, red cloth sash, small gold helmet, curved bronze blade.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body flinches backward.
- Frames 6-18: The helmet tilts, the blade wobbles.
- Frames 19-25: It recovers.
```

### C-015 · Scarab Soldier: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e2_scarab_soldier`, Scarab Soldier. Luchador (fighter), cuerpo a cuerpo.
- **Referencia a adjuntar:** `e2_scarab_soldier_ref.png`
- **Archivo de salida:** `e2_scarab_soldier_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e2_scarab_soldier_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C04, fila 5 (defeat)

```text
Using the attached reference image (e2_scarab_soldier_ref.png) as the exact design of the character, draw an animation sprite sheet of Scarab Soldier performing the 'defeat' animation.
Character identity, to stay consistent: Golden scarab beetle soldier, shiny turquoise-edged shell, red cloth sash, small gold helmet, curved bronze blade.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-20: The legs wobble, the beetle falls onto its shell with the legs in the air and the blade falling beside it.
- Frames 21-25: The Scarab Soldier ends still with tiny stars above. Hold this final pose still until frame 25.
```

### C-016 · Bow Worm: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `p2_bow_worm`, Bow Worm. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `p2_bow_worm_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** B05 (descripción de diseño)

```text
A small golden-yellow earthworm archer with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a white linen Egyptian headcloth with a thin gold band, holding a small curved wooden bow with an arrow. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### C-017 · Bow Worm: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p2_bow_worm`, Bow Worm. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** `p2_bow_worm_ref.png`
- **Archivo de salida:** `p2_bow_worm_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p2_bow_worm_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B05, fila 1 (idle loop)

```text
Using the attached reference image (p2_bow_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Bow Worm performing the 'idle' animation.
Character identity, to stay consistent: Golden-yellow earthworm archer, blue headband, white linen Egyptian headcloth with a thin gold band, small curved wooden bow with an arrow.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the body gently rises and sinks, the bow swings slightly in the hand, and the eyes blink once.
```

### C-018 · Bow Worm: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p2_bow_worm`, Bow Worm. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** `p2_bow_worm_ref.png`
- **Archivo de salida:** `p2_bow_worm_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p2_bow_worm_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B05, fila 2 (walk loop)

```text
Using the attached reference image (p2_bow_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Bow Worm performing the 'walk' animation.
Character identity, to stay consistent: Golden-yellow earthworm archer, blue headband, white linen Egyptian headcloth with a thin gold band, small curved wooden bow with an arrow.
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
- Character details to keep throughout the loop: the worm moves like an inchworm, arching up and stretching forward, the bow held at his side.
```

### C-019 · Bow Worm: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p2_bow_worm`, Bow Worm. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** `p2_bow_worm_ref.png`
- **Archivo de salida:** `p2_bow_worm_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p2_bow_worm_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B05, fila 3 (attack)

```text
Using the attached reference image (p2_bow_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Bow Worm performing the 'attack' animation.
Character identity, to stay consistent: Golden-yellow earthworm archer, blue headband, white linen Egyptian headcloth with a thin gold band, small curved wooden bow with an arrow.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Shooter, fast shots. The arrow is released at the key moment and the bow springs forward. Do NOT draw the arrow in flight: it is a separate projectile sprite.
Motion by frames:
- Frames 1-6: The bow is lifted forward at arm's length, an arrow is nocked on the string and the free hand reaches back; one eye closes to aim.
- Frames 7-11: The string is drawn back slowly to the cheek, the bow arm trembles slightly and the headcloth tails sway back.
- Frames 12-15: The string is released on frame 13: the bow springs forward, the string vibrates and the hand opens (no arrow is drawn in flight).
- Frames 16-19: The bow shakes briefly, the body leans forward from the release, the empty string vibrates.
- Frames 20-25: The arm lowers, the body relaxes and straightens, the bow returns to the side and the pose matches the idle.
```

### C-020 · Bow Worm: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p2_bow_worm`, Bow Worm. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** `p2_bow_worm_ref.png`
- **Archivo de salida:** `p2_bow_worm_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p2_bow_worm_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B05, fila 4 (hurt)

```text
Using the attached reference image (p2_bow_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Bow Worm performing the 'hurt' animation.
Character identity, to stay consistent: Golden-yellow earthworm archer, blue headband, white linen Egyptian headcloth with a thin gold band, small curved wooden bow with an arrow.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body flinches backward.
- Frames 6-18: The bow drops, the eyes squeeze shut.
- Frames 19-25: The worm grabs the bow again.
```

### C-021 · Bow Worm: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p2_bow_worm`, Bow Worm. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** `p2_bow_worm_ref.png`
- **Archivo de salida:** `p2_bow_worm_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p2_bow_worm_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B05, fila 5 (defeat)

```text
Using the attached reference image (p2_bow_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Bow Worm performing the 'defeat' animation.
Character identity, to stay consistent: Golden-yellow earthworm archer, blue headband, white linen Egyptian headcloth with a thin gold band, small curved wooden bow with an arrow.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The body wobbles.
- Frames 9-20: The Bow Worm droops, slides down flat to the ground with the bow falling beside him.
- Frames 21-25: The Bow Worm ends lying still with tiny stars above his head. Hold this final pose still until frame 25.
```

### C-022 · Proyectil: flecha
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Flecha de madera con punta de piedra y plumas blancas, apuntando a la derecha.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Proyectil del Bow Worm y el Locust Archer (Era 2); también de la Crossbow Worm (Era 3) a falta de saeta propia.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `proj_arrow.png`
- **Origen:** F02

```text
A single small wooden arrow with a gray stone tip and white feather fletching, pointing right, with a faint motion swoosh behind it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single small object, side view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### C-023 · Locust Archer: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `e2_locust_archer`, Locust Archer. Tirador (shooter), salta 2 casillas atrás tras disparar.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `e2_locust_archer_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** C05 (descripción de diseño)

```text
A slender green-and-brown locust with long bent back legs and big round eyes, a red cloth band tied around its head as team color, holding a small curved bow with an arrow, with a sly smirk. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the left, facing left, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### C-024 · Locust Archer: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e2_locust_archer`, Locust Archer. Tirador (shooter), salta 2 casillas atrás tras disparar.
- **Referencia a adjuntar:** `e2_locust_archer_ref.png`
- **Archivo de salida:** `e2_locust_archer_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e2_locust_archer_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C05, fila 1 (idle loop)

```text
Using the attached reference image (e2_locust_archer_ref.png) as the exact design of the character, draw an animation sprite sheet of Locust Archer performing the 'idle' animation.
Character identity, to stay consistent: Slender green-and-brown locust with long bent back legs, red cloth band on the head, sly smirk, small curved bow with an arrow.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the body crouches and rises slightly, the antennae twitch, the back legs flex, and the eyes blink once.
```

### C-025 · Locust Archer: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e2_locust_archer`, Locust Archer. Tirador (shooter), salta 2 casillas atrás tras disparar.
- **Referencia a adjuntar:** `e2_locust_archer_ref.png`
- **Archivo de salida:** `e2_locust_archer_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e2_locust_archer_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C05, fila 2 (hop loop)

```text
Using the attached reference image (e2_locust_archer_ref.png) as the exact design of the character, draw an animation sprite sheet of Locust Archer performing the 'walk' animation.
Character identity, to stay consistent: Slender green-and-brown locust with long bent back legs, red cloth band on the head, sly smirk, small curved bow with an arrow.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (hop): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The locust crouches, the long back legs fold and the body lowers.
- Frames 7-12: It springs forward, the back legs extend and the body stretches.
- Frames 13-19: At the top of a small hop it tucks, then starts to descend with the legs reaching down.
- Frames 20-25: It lands, absorbs the landing with a crouch and rises back to the pose of frame 1.
- Character details to keep throughout the loop: the locust crouches, springs forward in a small hop with the back legs extended, and lands.
```

### C-026 · Locust Archer: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e2_locust_archer`, Locust Archer. Tirador (shooter), salta 2 casillas atrás tras disparar.
- **Referencia a adjuntar:** `e2_locust_archer_ref.png`
- **Archivo de salida:** `e2_locust_archer_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e2_locust_archer_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C05, fila 3 (attack)

```text
Using the attached reference image (e2_locust_archer_ref.png) as the exact design of the character, draw an animation sprite sheet of Locust Archer performing the 'attack' animation.
Character identity, to stay consistent: Slender green-and-brown locust with long bent back legs, red cloth band on the head, sly smirk, small curved bow with an arrow.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Shoots, then hops backward 2 units. The arrow is released at the key moment (do NOT draw it in flight); frames 19-25 end with a small backward hop that stays inside the cell.
Motion by frames:
- Frames 1-6: The locust rears up slightly on its back legs, raises the bow and nocks an arrow; its sly smirk widens.
- Frames 7-11: The string is drawn back slowly to the cheek, the antennae lean back, the long back legs flex ready to spring.
- Frames 12-15: The string is released on frame 13: the bow springs forward and the string vibrates (no arrow in flight).
- Frames 16-19: The body recoils and crouches, the long back legs bend deeply for the hop.
- Frames 20-25: A small hop backward (during these frames): the legs extend, the body lifts a little off the standing line and lands again in the idle pose on frame 25, staying inside the cell.
```

### C-027 · Locust Archer: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e2_locust_archer`, Locust Archer. Tirador (shooter), salta 2 casillas atrás tras disparar.
- **Referencia a adjuntar:** `e2_locust_archer_ref.png`
- **Archivo de salida:** `e2_locust_archer_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e2_locust_archer_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C05, fila 4 (hurt)

```text
Using the attached reference image (e2_locust_archer_ref.png) as the exact design of the character, draw an animation sprite sheet of Locust Archer performing the 'hurt' animation.
Character identity, to stay consistent: Slender green-and-brown locust with long bent back legs, red cloth band on the head, sly smirk, small curved bow with an arrow.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body flinches backward.
- Frames 6-18: The bow drops, the antennae flatten.
- Frames 19-25: It grabs the bow again.
```

### C-028 · Locust Archer: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e2_locust_archer`, Locust Archer. Tirador (shooter), salta 2 casillas atrás tras disparar.
- **Referencia a adjuntar:** `e2_locust_archer_ref.png`
- **Archivo de salida:** `e2_locust_archer_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e2_locust_archer_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C05, fila 5 (defeat)

```text
Using the attached reference image (e2_locust_archer_ref.png) as the exact design of the character, draw an animation sprite sheet of Locust Archer performing the 'defeat' animation.
Character identity, to stay consistent: Slender green-and-brown locust with long bent back legs, red cloth band on the head, sly smirk, small curved bow with an arrow.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-20: The long legs fold, the locust topples sideways with the bow beside it.
- Frames 21-25: The Locust Archer ends still with tiny stars above. Hold this final pose still until frame 25.
```

### C-029 · Cobra Charmer Worm: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `p2_cobra_charmer_worm`, Cobra Charmer Worm. Apoyo (support), ralentiza 20%.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `p2_cobra_charmer_worm_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** B06 (descripción de diseño)

```text
A small golden-yellow earthworm musician with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a turquoise turban with a small gold jewel and playing a little wooden flute, while a friendly sand-yellow cobra with a gentle smile rises from a woven basket beside him. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### C-030 · Cobra Charmer Worm: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p2_cobra_charmer_worm`, Cobra Charmer Worm. Apoyo (support), ralentiza 20%.
- **Referencia a adjuntar:** `p2_cobra_charmer_worm_ref.png`
- **Archivo de salida:** `p2_cobra_charmer_worm_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p2_cobra_charmer_worm_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B06, fila 1 (idle loop)

```text
Using the attached reference image (p2_cobra_charmer_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Cobra Charmer Worm performing the 'idle' animation.
Character identity, to stay consistent: Golden-yellow earthworm musician, blue headband, turquoise turban with a small gold jewel, little wooden flute; a friendly sand-yellow cobra rising from a woven basket beside him.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the worm sways side to side while playing, the cobra sways the opposite way in the basket, little musical notes float up, and both blink once.
```

### C-031 · Cobra Charmer Worm: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p2_cobra_charmer_worm`, Cobra Charmer Worm. Apoyo (support), ralentiza 20%.
- **Referencia a adjuntar:** `p2_cobra_charmer_worm_ref.png`
- **Archivo de salida:** `p2_cobra_charmer_worm_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p2_cobra_charmer_worm_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B06, fila 2 (walk loop)

```text
Using the attached reference image (p2_cobra_charmer_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Cobra Charmer Worm performing the 'walk' animation.
Character identity, to stay consistent: Golden-yellow earthworm musician, blue headband, turquoise turban with a small gold jewel, little wooden flute; a friendly sand-yellow cobra rising from a woven basket beside him.
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
- Character details to keep throughout the loop: the worm moves like an inchworm while carrying the basket with the cobra peeking out and bobbing.
```

### C-032 · Cobra Charmer Worm: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p2_cobra_charmer_worm`, Cobra Charmer Worm. Apoyo (support), ralentiza 20%.
- **Referencia a adjuntar:** `p2_cobra_charmer_worm_ref.png`
- **Archivo de salida:** `p2_cobra_charmer_worm_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p2_cobra_charmer_worm_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B06, fila 3 (attack)

```text
Using the attached reference image (p2_cobra_charmer_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Cobra Charmer Worm performing the 'attack' animation.
Character identity, to stay consistent: Golden-yellow earthworm musician, blue headband, turquoise turban with a small gold jewel, little wooden flute; a friendly sand-yellow cobra rising from a woven basket beside him.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Support that slows enemies by 20%. The worm blows the flute harder and the cobra rises tall, flares its hood and strikes forward; a few slow teal music notes may drift forward.
Motion by frames:
- Frames 1-6: The worm takes a deep breath, the body leans back with the flute at the lips and the notes start to float up; the cobra begins to rise from the basket.
- Frames 7-11: The flute is blown harder, the body arches, the cobra rises tall with its eyes locked on the target and its hood starting to flare.
- Frames 12-15: The cobra flares its hood wide and strikes forward with its mouth open on frame 13; a few slow, heavy teal music notes burst out of the flute.
- Frames 16-19: The cobra's strike stays extended with the hood flared, the worm keeps blowing, the notes drift forward.
- Frames 20-25: The cobra pulls back and slides into the basket, the hood folds and the worm lowers the flute; the pose matches the idle.
```

### C-033 · Cobra Charmer Worm: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p2_cobra_charmer_worm`, Cobra Charmer Worm. Apoyo (support), ralentiza 20%.
- **Referencia a adjuntar:** `p2_cobra_charmer_worm_ref.png`
- **Archivo de salida:** `p2_cobra_charmer_worm_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p2_cobra_charmer_worm_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B06, fila 4 (hurt)

```text
Using the attached reference image (p2_cobra_charmer_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Cobra Charmer Worm performing the 'hurt' animation.
Character identity, to stay consistent: Golden-yellow earthworm musician, blue headband, turquoise turban with a small gold jewel, little wooden flute; a friendly sand-yellow cobra rising from a woven basket beside him.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-18: The hit lands: the worm flinches backward and the flute squeaks, the cobra ducks into the basket and peeks out.
- Frames 19-25: Both recover.
```

### C-034 · Cobra Charmer Worm: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p2_cobra_charmer_worm`, Cobra Charmer Worm. Apoyo (support), ralentiza 20%.
- **Referencia a adjuntar:** `p2_cobra_charmer_worm_ref.png`
- **Archivo de salida:** `p2_cobra_charmer_worm_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p2_cobra_charmer_worm_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B06, fila 5 (defeat)

```text
Using the attached reference image (p2_cobra_charmer_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Cobra Charmer Worm performing the 'defeat' animation.
Character identity, to stay consistent: Golden-yellow earthworm musician, blue headband, turquoise turban with a small gold jewel, little wooden flute; a friendly sand-yellow cobra rising from a woven basket beside him.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The flute drops.
- Frames 9-20: The worm droops and slides down flat, the cobra slumps over the basket rim.
- Frames 21-25: Both end still with tiny stars above their heads. Hold this final pose still until frame 25.
```

### C-035 · Mummy Moth: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `e2_mummy_moth`, Mummy Moth. Apoyo (support), cura 5%/s.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `e2_mummy_moth_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** C06 (descripción de diseño)

```text
A fluffy beige moth with soft dusty wings loosely wrapped in old linen bandages, big sleepy round eyes, a red cloth ribbon tied on one wing as team color, holding a fresh roll of bandage in one leg with a gentle caring expression. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, hovering with slow wing beats, in a neutral pose, three-quarter view slightly turned toward the left, facing left, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### C-036 · Mummy Moth: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e2_mummy_moth`, Mummy Moth. Apoyo (support), cura 5%/s.
- **Referencia a adjuntar:** `e2_mummy_moth_ref.png`
- **Archivo de salida:** `e2_mummy_moth_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e2_mummy_moth_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C06, fila 1 (idle loop)

```text
Using the attached reference image (e2_mummy_moth_ref.png) as the exact design of the character, draw an animation sprite sheet of Mummy Moth performing the 'idle' animation.
Character identity, to stay consistent: Fluffy beige moth with dusty wings loosely wrapped in old linen bandages, sleepy round eyes, red ribbon on one wing, a fresh roll of bandage in one leg.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the wings flutter slowly up and down, the body hovers, a loose bandage end sways, and the eyes blink once.
```

### C-037 · Mummy Moth: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e2_mummy_moth`, Mummy Moth. Apoyo (support), cura 5%/s.
- **Referencia a adjuntar:** `e2_mummy_moth_ref.png`
- **Archivo de salida:** `e2_mummy_moth_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e2_mummy_moth_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C06, fila 2 (fly loop)

```text
Using the attached reference image (e2_mummy_moth_ref.png) as the exact design of the character, draw an animation sprite sheet of Mummy Moth performing the 'walk' animation.
Character identity, to stay consistent: Fluffy beige moth with dusty wings loosely wrapped in old linen bandages, sleepy round eyes, red ribbon on one wing, a fresh roll of bandage in one leg.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (fly): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The wings are raised high above the back and the body tilts forward.
- Frames 7-12: The wings sweep down fast, the body rises slightly.
- Frames 13-19: The wings swing back up, the body dips.
- Frames 20-25: The wings sweep down again and everything returns to the pose of frame 1 (the flap goes through two full cycles in the sheet).
- Character details to keep throughout the loop: the wings flap in a full cycle while the body glides forward and the bandage trails behind.
```

### C-038 · Mummy Moth: attack = heal (curar)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e2_mummy_moth`, Mummy Moth. Apoyo (support), cura 5%/s.
- **Referencia a adjuntar:** `e2_mummy_moth_ref.png`
- **Archivo de salida:** `e2_mummy_moth_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e2_mummy_moth_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C06, fila 3 (heal)

```text
Using the attached reference image (e2_mummy_moth_ref.png) as the exact design of the character, draw an animation sprite sheet of Mummy Moth performing the 'attack' animation.
Character identity, to stay consistent: Fluffy beige moth with dusty wings loosely wrapped in old linen bandages, sleepy round eyes, red ribbon on one wing, a fresh roll of bandage in one leg.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single HEAL cast with anticipation, release and recovery back to the starting pose. Key moment (the ring of light expands) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Healer (5% per second to allies). This is the HEAL animation: the bandage unrolls, is swirled, and a soft golden glow ring expands outward (it may extend beyond the body).
Motion by frames:
- Frames 1-6: The moth rises slightly with slow wing beats and holds the bandage roll with its leg; a loose end of the bandage unfurls.
- Frames 7-11: The bandage unrolls and swirls in a slow circle around the moth (draw the cloth trail), the wings spread wider.
- Frames 12-15: A soft golden glow ring expands outward from the swirling bandage on frame 13, with tiny sparkles along the ring (it may extend beyond the body).
- Frames 16-19: The ring keeps expanding and fades, golden sparkles fall, the bandage flutters loosely.
- Frames 20-25: The bandage rolls back up into a neat roll, the wings return to their slow beat and the pose matches the idle.
```

### C-039 · Mummy Moth: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e2_mummy_moth`, Mummy Moth. Apoyo (support), cura 5%/s.
- **Referencia a adjuntar:** `e2_mummy_moth_ref.png`
- **Archivo de salida:** `e2_mummy_moth_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e2_mummy_moth_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C06, fila 4 (hurt)

```text
Using the attached reference image (e2_mummy_moth_ref.png) as the exact design of the character, draw an animation sprite sheet of Mummy Moth performing the 'hurt' animation.
Character identity, to stay consistent: Fluffy beige moth with dusty wings loosely wrapped in old linen bandages, sleepy round eyes, red ribbon on one wing, a fresh roll of bandage in one leg.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the wings fold in.
- Frames 6-18: The body is pushed backward, bandages flutter loose.
- Frames 19-25: It recovers.
```

### C-040 · Mummy Moth: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e2_mummy_moth`, Mummy Moth. Apoyo (support), cura 5%/s.
- **Referencia a adjuntar:** `e2_mummy_moth_ref.png`
- **Archivo de salida:** `e2_mummy_moth_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e2_mummy_moth_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C06, fila 5 (defeat)

```text
Using the attached reference image (e2_mummy_moth_ref.png) as the exact design of the character, draw an animation sprite sheet of Mummy Moth performing the 'defeat' animation.
Character identity, to stay consistent: Fluffy beige moth with dusty wings loosely wrapped in old linen bandages, sleepy round eyes, red ribbon on one wing, a fresh roll of bandage in one leg.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The wings stop.
- Frames 9-20: The bandages unwind, the moth drifts down and lands flat.
- Frames 21-25: The Mummy Moth ends still with tiny stars above. Hold this final pose still until frame 25.
```

### C-041 · Pharaoh Scarab (jefe Era 2): referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `b2_pharaoh_scarab`, Pharaoh Scarab (jefe Era 2). Jefe pesado; invoca 3 escarabajos, fase 2 tormenta de arena.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `b2_pharaoh_scarab_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** D02 (descripción de diseño)

```text
The Pharaoh Scarab, a giant golden scarab beetle with a shiny turquoise-and-gold shell, a tall striped royal pharaoh headdress, big dramatic eyes, a red cloth cape draped over his back, holding a golden crook and flail, wearing a solemn proud grin. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the left, facing left, filling most of the frame, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### C-042 · Pharaoh Scarab (jefe Era 2): idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b2_pharaoh_scarab`, Pharaoh Scarab (jefe Era 2). Jefe pesado; invoca 3 escarabajos, fase 2 tormenta de arena.
- **Referencia a adjuntar:** `b2_pharaoh_scarab_ref.png`
- **Archivo de salida:** `b2_pharaoh_scarab_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `b2_pharaoh_scarab_idle_x2_sheet.png` (celda 1024 px / hoja 5120x5120 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido en el cuerpo del jefe (que ya llena la celda). Lienzo normal.
- **Origen:** D02, fila 1 (idle loop)

```text
Using the attached reference image (b2_pharaoh_scarab_ref.png) as the exact design of the character, draw an animation sprite sheet of Pharaoh Scarab performing the 'idle' animation.
Character identity, to stay consistent: Pharaoh Scarab: giant golden scarab beetle, turquoise-and-gold shell, tall striped pharaoh headdress, red cape, golden crook and flail.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the shell glints, the cape sways, the crook and flail hang still, and the eyes blink once.
```

### C-043 · Pharaoh Scarab (jefe Era 2): walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b2_pharaoh_scarab`, Pharaoh Scarab (jefe Era 2). Jefe pesado; invoca 3 escarabajos, fase 2 tormenta de arena.
- **Referencia a adjuntar:** `b2_pharaoh_scarab_ref.png`
- **Archivo de salida:** `b2_pharaoh_scarab_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `b2_pharaoh_scarab_walk_x2_sheet.png` (celda 1024 px / hoja 5120x5120 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido en el cuerpo del jefe (que ya llena la celda). Lienzo normal.
- **Origen:** D02, fila 2 (walk loop)

```text
Using the attached reference image (b2_pharaoh_scarab_ref.png) as the exact design of the character, draw an animation sprite sheet of Pharaoh Scarab performing the 'walk' animation.
Character identity, to stay consistent: Pharaoh Scarab: giant golden scarab beetle, turquoise-and-gold shell, tall striped pharaoh headdress, red cape, golden crook and flail.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (walk): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The first group of legs (front and rear on one side, middle on the other) steps forward while the others push back; the body dips a little.
- Frames 7-12: Weight passes over the planted legs, the body rises to its highest point.
- Frames 13-19: The second group of legs steps forward while the first pushes back; the body dips again.
- Frames 20-25: Weight passes again and the legs return to the exact positions of frame 1.
- Character details to keep throughout the loop: the legs step in slow alternating pairs, the cape flowing behind, the headdress bobbing.
```

### C-044 · Pharaoh Scarab (jefe Era 2): attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b2_pharaoh_scarab`, Pharaoh Scarab (jefe Era 2). Jefe pesado; invoca 3 escarabajos, fase 2 tormenta de arena.
- **Referencia a adjuntar:** `b2_pharaoh_scarab_ref.png`
- **Archivo de salida:** `b2_pharaoh_scarab_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `b2_pharaoh_scarab_attack_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 1024 px / hoja 5120x5120 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el golpe/aliento/ráfaga del jefe llega muy lejos del cuerpo. Recomendado lienzo doble: celda 1024 px, hoja 5120x5120 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** D02, fila 3 (attack)

```text
Using the attached reference image (b2_pharaoh_scarab_ref.png) as the exact design of the character, draw an animation sprite sheet of Pharaoh Scarab performing the 'attack' animation.
Character identity, to stay consistent: Pharaoh Scarab: giant golden scarab beetle, turquoise-and-gold shell, tall striped pharaoh headdress, red cape, golden crook and flail.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Boss. The flail is raised, spun once overhead and slammed down and forward with a burst of golden dust. The raised crook may glow briefly (hint of his summon power, drawn by the game).
Motion by frames:
- Frames 1-6: The Pharaoh raises the golden flail high over his head with one arm, the headdress tilts back and the cape lifts; the crook is held up in the other arm.
- Frames 7-11: The flail is spun once overhead in a full circle (draw the chain in 3 or 4 positions), the body leans back and the shell gleams.
- Frames 12-15: The flail is slammed down and forward on frame 13, hitting the ground with a burst of golden dust that sprays outward.
- Frames 16-19: The flail stays on the ground, the golden dust drifts upward, the cape swings forward and the headdress tips.
- Frames 20-25: The flail is lifted back to the guard position, the crook lowers, the body straightens and the pose matches the idle.
```

### C-045 · Pharaoh Scarab (jefe Era 2): hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b2_pharaoh_scarab`, Pharaoh Scarab (jefe Era 2). Jefe pesado; invoca 3 escarabajos, fase 2 tormenta de arena.
- **Referencia a adjuntar:** `b2_pharaoh_scarab_ref.png`
- **Archivo de salida:** `b2_pharaoh_scarab_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `b2_pharaoh_scarab_hurt_x2_sheet.png` (celda 1024 px / hoja 5120x5120 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido en el cuerpo del jefe (que ya llena la celda). Lienzo normal.
- **Origen:** D02, fila 4 (hurt)

```text
Using the attached reference image (b2_pharaoh_scarab_ref.png) as the exact design of the character, draw an animation sprite sheet of Pharaoh Scarab performing the 'hurt' animation.
Character identity, to stay consistent: Pharaoh Scarab: giant golden scarab beetle, turquoise-and-gold shell, tall striped pharaoh headdress, red cape, golden crook and flail.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the headdress tips.
- Frames 6-18: The body is pushed back, the shell shows a small crack.
- Frames 19-25: He straightens.
```

### C-046 · Pharaoh Scarab (jefe Era 2): defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b2_pharaoh_scarab`, Pharaoh Scarab (jefe Era 2). Jefe pesado; invoca 3 escarabajos, fase 2 tormenta de arena.
- **Referencia a adjuntar:** `b2_pharaoh_scarab_ref.png`
- **Archivo de salida:** `b2_pharaoh_scarab_defeat_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `b2_pharaoh_scarab_defeat_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 1024 px / hoja 5120x5120 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el jefe cae y se derrumba ocupando mucho más espacio. Recomendado lienzo doble: celda 1024 px, hoja 5120x5120 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** D02, fila 5 (defeat)

```text
Using the attached reference image (b2_pharaoh_scarab_ref.png) as the exact design of the character, draw an animation sprite sheet of Pharaoh Scarab performing the 'defeat' animation.
Character identity, to stay consistent: Pharaoh Scarab: giant golden scarab beetle, turquoise-and-gold shell, tall striped pharaoh headdress, red cape, golden crook and flail.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The headdress falls off.
- Frames 9-20: The legs fold, the scarab sinks flat with the cape covering him.
- Frames 21-25: The Pharaoh Scarab ends still with tiny stars above. Hold this final pose still until frame 25.
```

### C-047 · Insignia de era: Antiguo Egipto
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Medalla dorada con un escarabajo turquesa en el centro.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Cabecera del mapa y Home en la Era 2, selector de era.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `era_2.png`
- **Origen:** G13

```text
A round golden medallion with a turquoise scarab beetle in the center, a decorative border of tiny triangles and a polished shine. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### C-048 · Icono de poder: Rewind
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Esfera de reloj dorada con una gran flecha turquesa curva girando en sentido contrario a las agujas.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Botón de poder del HUD y selector de poderes; se desbloquea tras el jefe de la Era 2.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `power_rewind.png`
- **Origen:** G09

```text
A round golden clock face with a big curved teal arrow circling counterclockwise around it and small gears and sparkles behind it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```
