# Fase G: Era 5 (Futuro lejano)

Todo lo de la Era 5, incluyendo a Count Magpie 3000 (jefe final) y los láseres.

**48 prompts** (7 referencias de personaje, 35 hojas de animación, 6 imágenes o sprites estáticos). Antes de empezar lee `README.md` (convenciones, tamaños, qué hacer si la cuadrícula sale mal). Genera cada referencia primero y luego sus animaciones en el mismo chat de Gemini, adjuntando `<id>_ref.png`.

---
### G-001 · Fondo de batalla, Era 5 (Futuro lejano)
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Plataforma futurista flotante en el espacio con planeta con anillos, estrellas, nebulosa violeta, líneas de neón cian y camino de metal brillante.
- **Tamaño / proporción:** 9:16 vertical, 1080x1920 px (si Gemini devuelve otra proporción, recortar a 9:16)
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Fondo de la batalla en las etapas de la Era 5 y el jefe final Count Magpie 3000.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `bg_era5.png`
- **Origen:** H05

```text
A floating futuristic platform in deep space with a huge ringed planet, twinkling stars, a soft violet-white nebula, glowing neon cyan lines, small floating panels, tiny distant spaceships and a flat glowing metal path running horizontally across the middle of the image. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Tall 9:16 portrait image with no characters, no text, no logos and no UI. Place the horizontal path at about 55 to 62 percent of the image height, keep the top 12 percent calm for the game HUD, and keep the bottom 30 percent calm and low-contrast so game buttons stay readable.
```

### G-002 · Base del jugador, Era 5
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Base de cúpula de cristal blanca y turquesa con anillo cian, antena, pista de aterrizaje y puerta redonda.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline recorta y deja 512 px de ancho)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Base del jugador (izquierda del carril) en la Era 5.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `base_p5.png`
- **Origen:** E05

```text
A futuristic white-and-teal glass dome base with a glowing cyan ring around it, an antenna topped with a blue light, a small landing pad, a round sliding door entrance and a few small floating panels around it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing right, centered with a wide empty margin, with only a small floating metal platform directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### G-003 · Base enemiga, Era 5
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Aguja de cristal negra y gris sobre una roca flotante con grietas rojas y luces de aviso.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline recorta y deja 512 px de ancho)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Base enemiga (derecha del carril, mirando a la izquierda) en la Era 5.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `base_e5.png`
- **Origen:** E10

```text
A black-and-gunmetal crystal spire base on a small floating rock, with glowing red cracks and red energy lines running up the walls, a round dark gate entrance and small red warning lights. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing left, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### G-004 · Laser Blade Worm: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `p5_laser_blade_worm`, Laser Blade Worm. Luchador (fighter), rápido.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `p5_laser_blade_worm_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** B13 (descripción de diseño)

```text
A small golden-yellow earthworm warrior with big round dark eyes and a small blue cloth headband as team color, wearing a sleek white-and-teal helmet with a glowing cyan visor and light armor plates on his body, wielding a glowing cyan laser sword. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### G-005 · Laser Blade Worm: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p5_laser_blade_worm`, Laser Blade Worm. Luchador (fighter), rápido.
- **Referencia a adjuntar:** `p5_laser_blade_worm_ref.png`
- **Archivo de salida:** `p5_laser_blade_worm_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p5_laser_blade_worm_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B13, fila 1 (idle loop)

```text
Using the attached reference image (p5_laser_blade_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Laser Blade Worm performing the 'idle' animation.
Character identity, to stay consistent: Golden-yellow earthworm warrior, blue headband, sleek white-and-teal helmet with a glowing cyan visor, light armor plates, glowing cyan laser sword.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the body gently rises and sinks, the laser sword hums and its glow pulses, the visor glints, and the eyes blink once.
```

### G-006 · Laser Blade Worm: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p5_laser_blade_worm`, Laser Blade Worm. Luchador (fighter), rápido.
- **Referencia a adjuntar:** `p5_laser_blade_worm_ref.png`
- **Archivo de salida:** `p5_laser_blade_worm_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p5_laser_blade_worm_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B13, fila 2 (dash loop)

```text
Using the attached reference image (p5_laser_blade_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Laser Blade Worm performing the 'walk' animation.
Character identity, to stay consistent: Golden-yellow earthworm warrior, blue headband, sleek white-and-teal helmet with a glowing cyan visor, light armor plates, glowing cyan laser sword.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (dash): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: Contact pose: the body is stretched long and low, the head reaches forward.
- Frames 7-12: The tail end pulls forward along the ground while the middle of the body starts to arch up.
- Frames 13-19: The middle is arched at its highest like a small bridge, the head comes down.
- Frames 20-25: The front stretches forward again and the body flattens, ending in exactly the pose of frame 1.
- Character details to keep throughout the loop: the worm moves in quick forward arches with the sword held back, a faint cyan trail behind him.
```

### G-007 · Laser Blade Worm: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p5_laser_blade_worm`, Laser Blade Worm. Luchador (fighter), rápido.
- **Referencia a adjuntar:** `p5_laser_blade_worm_ref.png`
- **Archivo de salida:** `p5_laser_blade_worm_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p5_laser_blade_worm_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B13, fila 3 (attack)

```text
Using the attached reference image (p5_laser_blade_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Laser Blade Worm performing the 'attack' animation.
Character identity, to stay consistent: Golden-yellow earthworm warrior, blue headband, sleek white-and-teal helmet with a glowing cyan visor, light armor plates, glowing cyan laser sword.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Fast fighter. A lunging cyan arc slash with a short bright cyan afterimage trail.
Motion by frames:
- Frames 1-6: The body coils back low, the laser sword is pulled behind the body with its glow brightening, the visor glints.
- Frames 7-11: The worm tenses and starts to push forward, the sword reaches its farthest back position, a faint cyan trail gathers behind the blade.
- Frames 12-15: The body lunges forward and the sword sweeps in a bright cyan arc from above-behind to the front on frame 13, leaving a clean cyan afterimage trail.
- Frames 16-19: The arc fades into a short trail, the body is stretched forward at the end of the lunge, the glow flickers.
- Frames 20-25: The body pulls back and the sword returns to the ready position, the hum calms and the pose matches the idle.
```

### G-008 · Laser Blade Worm: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p5_laser_blade_worm`, Laser Blade Worm. Luchador (fighter), rápido.
- **Referencia a adjuntar:** `p5_laser_blade_worm_ref.png`
- **Archivo de salida:** `p5_laser_blade_worm_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p5_laser_blade_worm_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B13, fila 4 (hurt)

```text
Using the attached reference image (p5_laser_blade_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Laser Blade Worm performing the 'hurt' animation.
Character identity, to stay consistent: Golden-yellow earthworm warrior, blue headband, sleek white-and-teal helmet with a glowing cyan visor, light armor plates, glowing cyan laser sword.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body flinches backward.
- Frames 6-18: The visor flickers, the armor plates rattle.
- Frames 19-25: The worm raises the sword again.
```

### G-009 · Laser Blade Worm: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p5_laser_blade_worm`, Laser Blade Worm. Luchador (fighter), rápido.
- **Referencia a adjuntar:** `p5_laser_blade_worm_ref.png`
- **Archivo de salida:** `p5_laser_blade_worm_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p5_laser_blade_worm_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B13, fila 5 (defeat)

```text
Using the attached reference image (p5_laser_blade_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Laser Blade Worm performing the 'defeat' animation.
Character identity, to stay consistent: Golden-yellow earthworm warrior, blue headband, sleek white-and-teal helmet with a glowing cyan visor, light armor plates, glowing cyan laser sword.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The sword light flickers out.
- Frames 9-20: The worm droops and slides down flat, the visor goes dark.
- Frames 21-25: He ends lying still with tiny stars above his head. Hold this final pose still until frame 25.
```

### G-010 · Laser Bug: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `e5_laser_bug`, Laser Bug. Tirador (shooter), rayo que atraviesa.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `e5_laser_bug_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** C13 (descripción de diseño)

```text
A round armored beetle robot in dark gunmetal gray with a glowing red visor, a small laser cannon mounted on its back, thin red stripes on its shell as team color and six small legs, with a menacing but cute look. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the left, facing left, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### G-011 · Laser Bug: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e5_laser_bug`, Laser Bug. Tirador (shooter), rayo que atraviesa.
- **Referencia a adjuntar:** `e5_laser_bug_ref.png`
- **Archivo de salida:** `e5_laser_bug_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e5_laser_bug_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C13, fila 1 (idle loop)

```text
Using the attached reference image (e5_laser_bug_ref.png) as the exact design of the character, draw an animation sprite sheet of Laser Bug performing the 'idle' animation.
Character identity, to stay consistent: Round armored robot beetle in dark gunmetal gray, glowing red visor, small laser cannon on its back, thin red stripes on the shell, six small legs.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the body hovers just above the ground rising and sinking, the red visor pulses, the cannon on the back rotates slightly, and the visor blinks once.
```

### G-012 · Laser Bug: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e5_laser_bug`, Laser Bug. Tirador (shooter), rayo que atraviesa.
- **Referencia a adjuntar:** `e5_laser_bug_ref.png`
- **Archivo de salida:** `e5_laser_bug_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e5_laser_bug_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C13, fila 2 (walk loop)

```text
Using the attached reference image (e5_laser_bug_ref.png) as the exact design of the character, draw an animation sprite sheet of Laser Bug performing the 'walk' animation.
Character identity, to stay consistent: Round armored robot beetle in dark gunmetal gray, glowing red visor, small laser cannon on its back, thin red stripes on the shell, six small legs.
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
- Character details to keep throughout the loop: the six legs step in alternating pairs, the body bobbing, the visor glowing steadily.
```

### G-013 · Laser Bug: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e5_laser_bug`, Laser Bug. Tirador (shooter), rayo que atraviesa.
- **Referencia a adjuntar:** `e5_laser_bug_ref.png`
- **Archivo de salida:** `e5_laser_bug_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e5_laser_bug_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C13, fila 3 (attack)

```text
Using the attached reference image (e5_laser_bug_ref.png) as the exact design of the character, draw an animation sprite sheet of Laser Bug performing the 'attack' animation.
Character identity, to stay consistent: Round armored robot beetle in dark gunmetal gray, glowing red visor, small laser cannon on its back, thin red stripes on the shell, six small legs.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Shooter with a piercing beam. The back cannon swivels forward, charges with a growing red glow and fires with a recoil kick. Draw only the muzzle flash, NOT the beam (separate sprite).
Motion by frames:
- Frames 1-6: The bug lowers its body slightly and the cannon on its back swivels forward; the red visor brightens.
- Frames 7-11: The cannon charges with a growing red glow at the muzzle, tiny red particles gather, the legs brace.
- Frames 12-15: The cannon fires on frame 13: a bright red muzzle flash and a strong recoil kick (no beam drawn), the whole body skids back a little.
- Frames 16-19: Smoke curls from the muzzle, the visor flickers and the barrel is hot red.
- Frames 20-25: The cannon cools to dark gray and swivels back to rest, the visor returns to its steady glow and the pose matches the idle.
```

### G-014 · Laser Bug: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e5_laser_bug`, Laser Bug. Tirador (shooter), rayo que atraviesa.
- **Referencia a adjuntar:** `e5_laser_bug_ref.png`
- **Archivo de salida:** `e5_laser_bug_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e5_laser_bug_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C13, fila 4 (hurt)

```text
Using the attached reference image (e5_laser_bug_ref.png) as the exact design of the character, draw an animation sprite sheet of Laser Bug performing the 'hurt' animation.
Character identity, to stay consistent: Round armored robot beetle in dark gunmetal gray, glowing red visor, small laser cannon on its back, thin red stripes on the shell, six small legs.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body is knocked backward.
- Frames 6-18: The visor flickers white, a leg twitches.
- Frames 19-25: It recovers.
```

### G-015 · Laser Bug: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e5_laser_bug`, Laser Bug. Tirador (shooter), rayo que atraviesa.
- **Referencia a adjuntar:** `e5_laser_bug_ref.png`
- **Archivo de salida:** `e5_laser_bug_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e5_laser_bug_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C13, fila 5 (defeat)

```text
Using the attached reference image (e5_laser_bug_ref.png) as the exact design of the character, draw an animation sprite sheet of Laser Bug performing the 'defeat' animation.
Character identity, to stay consistent: Round armored robot beetle in dark gunmetal gray, glowing red visor, small laser cannon on its back, thin red stripes on the shell, six small legs.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The visor goes dark.
- Frames 9-20: The cannon droops, the legs fold, the shell opens a little with sparks.
- Frames 21-25: It ends still with tiny stars above. Hold this final pose still until frame 25.
```

### G-016 · Proyectil: rayo láser
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Rayo láser cian corto con forma de cápsula y núcleo blanco, apuntando a la derecha.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Proyectil de la Mecha Worm (Era 5).
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `proj_laser.png`
- **Origen:** F04

```text
A single short glowing cyan laser bolt shaped like a rounded capsule with a bright white core and a soft cyan glow, pointing right. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single small object, side view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### G-017 · Proyectil: rayo láser rojo
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Rayo láser rojo corto con forma de cápsula y núcleo blanco, apuntando a la izquierda. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Proyectil del Laser Bug y del Mecha Beetle (Era 5, enemigos). NUEVO: el original solo trae el láser cian.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `proj_laser_red.png`
- **Origen:** nuevo (no estaba en el original)

```text
A single short glowing red laser bolt shaped like a rounded capsule with a bright white-hot core and a soft red glow, pointing left. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single small object, side view pointing left, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### G-018 · Mecha Worm: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `p5_mecha_worm`, Mecha Worm. Pesado (heavy), 400 HP.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `p5_mecha_worm_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** B14 (descripción de diseño)

```text
A small golden-yellow earthworm pilot with big round dark eyes and a small blue cloth headband as team color, sitting in the glass cockpit dome of a chunky white-and-blue walking mech with two stubby legs, rounded armor plates, glowing cyan joints and a small arm cannon. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing on its two stubby legs in a neutral pose, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### G-019 · Mecha Worm: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p5_mecha_worm`, Mecha Worm. Pesado (heavy), 400 HP.
- **Referencia a adjuntar:** `p5_mecha_worm_ref.png`
- **Archivo de salida:** `p5_mecha_worm_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p5_mecha_worm_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B14, fila 1 (idle loop)

```text
Using the attached reference image (p5_mecha_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Mecha Worm performing the 'idle' animation.
Character identity, to stay consistent: Golden-yellow worm pilot with blue headband in the glass cockpit dome of a chunky white-and-blue walking mech with stubby legs, glowing cyan joints and an arm cannon.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A calm looping idle: subtle breathing motion, the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The body drifts gently up.
- Frames 7-12: It reaches the top of the bob and the loose parts sway to one side.
- Frames 13-19: It drifts gently down and the loose parts sway the other way.
- Frames 20-25: It settles back to exactly the pose of frame 1.
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the mech sinks and rises slightly on its legs, the cyan joints pulse, the arm cannon swings a little, and the pilot blinks once.
```

### G-020 · Mecha Worm: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p5_mecha_worm`, Mecha Worm. Pesado (heavy), 400 HP.
- **Referencia a adjuntar:** `p5_mecha_worm_ref.png`
- **Archivo de salida:** `p5_mecha_worm_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p5_mecha_worm_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B14, fila 2 (walk loop)

```text
Using the attached reference image (p5_mecha_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Mecha Worm performing the 'walk' animation.
Character identity, to stay consistent: Golden-yellow worm pilot with blue headband in the glass cockpit dome of a chunky white-and-blue walking mech with stubby legs, glowing cyan joints and an arm cannon.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (walk): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The left stubby leg lifts and steps forward, the cockpit leans slightly forward.
- Frames 7-12: The left foot plants with a small thud, the body sinks, the pilot bounces in the dome.
- Frames 13-19: The right stubby leg lifts and steps forward.
- Frames 20-25: The right foot plants and the machine returns to the pose of frame 1.
- Character details to keep throughout the loop: the mech steps with alternating stubby legs, the body bobbing, the pilot bouncing in the dome.
```

### G-021 · Mecha Worm: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p5_mecha_worm`, Mecha Worm. Pesado (heavy), 400 HP.
- **Referencia a adjuntar:** `p5_mecha_worm_ref.png`
- **Archivo de salida:** `p5_mecha_worm_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p5_mecha_worm_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B14, fila 3 (attack)

```text
Using the attached reference image (p5_mecha_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Mecha Worm performing the 'attack' animation.
Character identity, to stay consistent: Golden-yellow worm pilot with blue headband in the glass cockpit dome of a chunky white-and-blue walking mech with stubby legs, glowing cyan joints and an arm cannon.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Heavy (400 HP). The arm cannon fires a big cyan shot with a strong recoil. Draw only the muzzle flash, NOT the shot in flight.
Motion by frames:
- Frames 1-6: The mech plants its legs wide and sinks slightly; the arm cannon lifts and starts to glow cyan, the pilot leans forward in the dome.
- Frames 7-11: The cannon charges: the cyan glow grows and the joints flash brighter, the body shakes slightly.
- Frames 12-15: A bright cyan muzzle flash on frame 13 (no shot in flight) and a strong recoil that pushes the mech's upper body backward.
- Frames 16-19: The mech skids slightly backward, small cyan sparks and a puff of smoke at the muzzle, the dome flashes.
- Frames 20-25: The arm lowers, the legs steady, the joints dim to their normal pulse and the pose matches the idle.
```

### G-022 · Mecha Worm: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p5_mecha_worm`, Mecha Worm. Pesado (heavy), 400 HP.
- **Referencia a adjuntar:** `p5_mecha_worm_ref.png`
- **Archivo de salida:** `p5_mecha_worm_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p5_mecha_worm_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B14, fila 4 (hurt)

```text
Using the attached reference image (p5_mecha_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Mecha Worm performing the 'hurt' animation.
Character identity, to stay consistent: Golden-yellow worm pilot with blue headband in the glass cockpit dome of a chunky white-and-blue walking mech with stubby legs, glowing cyan joints and an arm cannon.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the mech staggers backward.
- Frames 6-18: The cockpit dome flashes, sparks fly from one joint.
- Frames 19-25: It steadies.
```

### G-023 · Mecha Worm: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p5_mecha_worm`, Mecha Worm. Pesado (heavy), 400 HP.
- **Referencia a adjuntar:** `p5_mecha_worm_ref.png`
- **Archivo de salida:** `p5_mecha_worm_defeat_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p5_mecha_worm_defeat_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — caída o desarme con piezas, humo o chispas que se salen del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B14, fila 5 (defeat)

```text
Using the attached reference image (p5_mecha_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Mecha Worm performing the 'defeat' animation.
Character identity, to stay consistent: Golden-yellow worm pilot with blue headband in the glass cockpit dome of a chunky white-and-blue walking mech with stubby legs, glowing cyan joints and an arm cannon.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The joint lights go out one by one.
- Frames 9-20: The legs fold, the mech sits down and tilts, the pilot slumps in the dome.
- Frames 21-25: It ends still with tiny stars above. Hold this final pose still until frame 25.
```

### G-024 · Mecha Beetle: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `e5_mecha_beetle`, Mecha Beetle. Pesado (heavy), 450 HP, ataca al de más vida.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `e5_mecha_beetle_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** C15 (descripción de diseño)

```text
A huge armored rhinoceros-beetle robot in dark gunmetal gray with glowing red joints, thick sturdy legs, a big horn that doubles as a cannon and a small red emblem on its shell as team color, imposing but still cute. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the left, facing left, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### G-025 · Mecha Beetle: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e5_mecha_beetle`, Mecha Beetle. Pesado (heavy), 450 HP, ataca al de más vida.
- **Referencia a adjuntar:** `e5_mecha_beetle_ref.png`
- **Archivo de salida:** `e5_mecha_beetle_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e5_mecha_beetle_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C15, fila 1 (idle loop)

```text
Using the attached reference image (e5_mecha_beetle_ref.png) as the exact design of the character, draw an animation sprite sheet of Mecha Beetle performing the 'idle' animation.
Character identity, to stay consistent: Huge armored rhinoceros-beetle robot in dark gunmetal gray with glowing red joints, thick legs, a big horn that doubles as a cannon, small red emblem on the shell.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the body rises and sinks heavily as it breathes, the red joints pulse, the horn tilts, and the eyes blink once.
```

### G-026 · Mecha Beetle: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e5_mecha_beetle`, Mecha Beetle. Pesado (heavy), 450 HP, ataca al de más vida.
- **Referencia a adjuntar:** `e5_mecha_beetle_ref.png`
- **Archivo de salida:** `e5_mecha_beetle_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e5_mecha_beetle_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C15, fila 2 (stomp loop)

```text
Using the attached reference image (e5_mecha_beetle_ref.png) as the exact design of the character, draw an animation sprite sheet of Mecha Beetle performing the 'walk' animation.
Character identity, to stay consistent: Huge armored rhinoceros-beetle robot in dark gunmetal gray with glowing red joints, thick legs, a big horn that doubles as a cannon, small red emblem on the shell.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (stomp): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The left foot lifts and the heavy body leans onto the right side.
- Frames 7-12: The left foot stomps down: the body drops and bounces, a small dust puff.
- Frames 13-19: The right foot lifts and the body leans onto the left side.
- Frames 20-25: The right foot stomps down and the body returns to the pose of frame 1.
- Character details to keep throughout the loop: the thick legs stomp one after another, the body rocks side to side and the horn bobs.
```

### G-027 · Mecha Beetle: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e5_mecha_beetle`, Mecha Beetle. Pesado (heavy), 450 HP, ataca al de más vida.
- **Referencia a adjuntar:** `e5_mecha_beetle_ref.png`
- **Archivo de salida:** `e5_mecha_beetle_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e5_mecha_beetle_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C15, fila 3 (attack)

```text
Using the attached reference image (e5_mecha_beetle_ref.png) as the exact design of the character, draw an animation sprite sheet of Mecha Beetle performing the 'attack' animation.
Character identity, to stay consistent: Huge armored rhinoceros-beetle robot in dark gunmetal gray with glowing red joints, thick legs, a big horn that doubles as a cannon, small red emblem on the shell.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Heavy (450 HP) that targets the highest-HP unit. The horn lowers and glows red, then a charged shot fires from the horn with a strong recoil that pushes the body back. Draw only the muzzle flash, NOT the shot in flight.
Motion by frames:
- Frames 1-6: The robot beetle plants its thick legs wide and lowers its body, the horn tilts down toward the target; the red joints light up brighter.
- Frames 7-11: The horn glows deep red and charges, small red sparks run along its length, the whole body vibrates.
- Frames 12-15: A charged red blast fires from the horn tip on frame 13 (draw only the muzzle flash, no shot in flight) and a strong recoil pushes the body backward, the legs skid.
- Frames 16-19: Smoke curls from the horn, the red joints flicker, the body is rocked back.
- Frames 20-25: The horn cools and lifts back to its resting angle, the legs steady and the pose matches the idle.
```

### G-028 · Mecha Beetle: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e5_mecha_beetle`, Mecha Beetle. Pesado (heavy), 450 HP, ataca al de más vida.
- **Referencia a adjuntar:** `e5_mecha_beetle_ref.png`
- **Archivo de salida:** `e5_mecha_beetle_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e5_mecha_beetle_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C15, fila 4 (hurt)

```text
Using the attached reference image (e5_mecha_beetle_ref.png) as the exact design of the character, draw an animation sprite sheet of Mecha Beetle performing the 'hurt' animation.
Character identity, to stay consistent: Huge armored rhinoceros-beetle robot in dark gunmetal gray with glowing red joints, thick legs, a big horn that doubles as a cannon, small red emblem on the shell.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: a plate cracks with sparks.
- Frames 6-18: The body is knocked backward, the joints flicker.
- Frames 19-25: It recovers.
```

### G-029 · Mecha Beetle: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e5_mecha_beetle`, Mecha Beetle. Pesado (heavy), 450 HP, ataca al de más vida.
- **Referencia a adjuntar:** `e5_mecha_beetle_ref.png`
- **Archivo de salida:** `e5_mecha_beetle_defeat_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e5_mecha_beetle_defeat_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — caída o desarme con piezas, humo o chispas que se salen del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C15, fila 5 (defeat)

```text
Using the attached reference image (e5_mecha_beetle_ref.png) as the exact design of the character, draw an animation sprite sheet of Mecha Beetle performing the 'defeat' animation.
Character identity, to stay consistent: Huge armored rhinoceros-beetle robot in dark gunmetal gray with glowing red joints, thick legs, a big horn that doubles as a cannon, small red emblem on the shell.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The red joints go out one by one.
- Frames 9-20: The legs fold, the body crashes down with a dust puff.
- Frames 21-25: It ends still with tiny stars above. Hold this final pose still until frame 25.
```

### G-030 · Time Medic Worm: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `p5_time_medic_worm`, Time Medic Worm. Apoyo (support), cura 5%/s.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `p5_time_medic_worm_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** B15 (descripción de diseño)

```text
A small golden-yellow earthworm medic with big round dark eyes and a small blue cloth headband as team color, riding on top of a round white-and-teal hovering drone that holds a glowing golden-teal healing orb, wearing a tiny backpack marked with a gear symbol, with a calm kind smile. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, hovering in a relaxed neutral pose, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### G-031 · Time Medic Worm: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p5_time_medic_worm`, Time Medic Worm. Apoyo (support), cura 5%/s.
- **Referencia a adjuntar:** `p5_time_medic_worm_ref.png`
- **Archivo de salida:** `p5_time_medic_worm_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p5_time_medic_worm_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B15, fila 1 (idle loop)

```text
Using the attached reference image (p5_time_medic_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Time Medic Worm performing the 'idle' animation.
Character identity, to stay consistent: Golden-yellow earthworm medic, blue headband, riding a round white-and-teal hovering drone with a glowing golden-teal healing orb, tiny backpack with a gear symbol.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A calm looping idle: subtle breathing motion, the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The body drifts gently up.
- Frames 7-12: It reaches the top of the bob and the loose parts sway to one side.
- Frames 13-19: It drifts gently down and the loose parts sway the other way.
- Frames 20-25: It settles back to exactly the pose of frame 1.
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the drone hovers up and down, the healing orb pulses softly, the medic blinks once.
```

### G-032 · Time Medic Worm: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p5_time_medic_worm`, Time Medic Worm. Apoyo (support), cura 5%/s.
- **Referencia a adjuntar:** `p5_time_medic_worm_ref.png`
- **Archivo de salida:** `p5_time_medic_worm_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p5_time_medic_worm_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B15, fila 2 (fly loop)

```text
Using the attached reference image (p5_time_medic_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Time Medic Worm performing the 'walk' animation.
Character identity, to stay consistent: Golden-yellow earthworm medic, blue headband, riding a round white-and-teal hovering drone with a glowing golden-teal healing orb, tiny backpack with a gear symbol.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (fly): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The vehicle tilts forward a little and starts to glide, rising slightly.
- Frames 7-12: It reaches the top of a gentle bob while the hanging parts swing behind.
- Frames 13-19: It sinks back down a little, the hanging parts swing forward.
- Frames 20-25: It settles back to exactly the pose of frame 1.
- Character details to keep throughout the loop: the drone tilts forward and glides, a thin teal trail behind it, the backpack bouncing.
```

### G-033 · Time Medic Worm: attack = heal (curar)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p5_time_medic_worm`, Time Medic Worm. Apoyo (support), cura 5%/s.
- **Referencia a adjuntar:** `p5_time_medic_worm_ref.png`
- **Archivo de salida:** `p5_time_medic_worm_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p5_time_medic_worm_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B15, fila 3 (heal)

```text
Using the attached reference image (p5_time_medic_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Time Medic Worm performing the 'attack' animation.
Character identity, to stay consistent: Golden-yellow earthworm medic, blue headband, riding a round white-and-teal hovering drone with a glowing golden-teal healing orb, tiny backpack with a gear symbol.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single HEAL cast with anticipation, release and recovery back to the starting pose. Key moment (the ring of light expands) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Support that heals allies 5% per second. This is the HEAL animation, not an attack: both arms rise and a ring of golden-teal light expands outward around the drone (the ring may extend beyond the body).
Motion by frames:
- Frames 1-6: The drone tilts slightly back, the medic breathes in and starts to raise both arms; the healing orb begins to glow brighter.
- Frames 7-11: Both arms are raised above the head, the orb grows bigger and brighter, the backpack gear symbol glows.
- Frames 12-15: A ring of golden-teal light bursts out of the orb on frame 13 and expands outward around the drone (the ring may extend far beyond the body), with tiny sparkles along it.
- Frames 16-19: The ring keeps expanding and fades, soft sparkles fall around the drone, the medic smiles kindly.
- Frames 20-25: The arms lower, the orb shrinks back to its soft pulse and the pose matches the idle.
```

### G-034 · Time Medic Worm: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p5_time_medic_worm`, Time Medic Worm. Apoyo (support), cura 5%/s.
- **Referencia a adjuntar:** `p5_time_medic_worm_ref.png`
- **Archivo de salida:** `p5_time_medic_worm_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p5_time_medic_worm_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B15, fila 4 (hurt)

```text
Using the attached reference image (p5_time_medic_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Time Medic Worm performing the 'hurt' animation.
Character identity, to stay consistent: Golden-yellow earthworm medic, blue headband, riding a round white-and-teal hovering drone with a glowing golden-teal healing orb, tiny backpack with a gear symbol.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-18: The hit lands: the drone is knocked backward and spins slightly, the orb flickers.
- Frames 19-25: The medic holds on and recovers.
```

### G-035 · Time Medic Worm: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p5_time_medic_worm`, Time Medic Worm. Apoyo (support), cura 5%/s.
- **Referencia a adjuntar:** `p5_time_medic_worm_ref.png`
- **Archivo de salida:** `p5_time_medic_worm_defeat_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p5_time_medic_worm_defeat_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — caída o desarme con piezas, humo o chispas que se salen del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B15, fila 5 (defeat)

```text
Using the attached reference image (p5_time_medic_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Time Medic Worm performing the 'defeat' animation.
Character identity, to stay consistent: Golden-yellow earthworm medic, blue headband, riding a round white-and-teal hovering drone with a glowing golden-teal healing orb, tiny backpack with a gear symbol.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The orb goes dark.
- Frames 9-20: The drone sputters and sinks to the ground, the medic slides off.
- Frames 21-25: Everything ends still with tiny stars above. Hold this final pose still until frame 25.
```

### G-036 · Drone Fly: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `e5_drone_fly`, Drone Fly. Aéreo (air), caza unidades de apoyo.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `e5_drone_fly_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** C14 (descripción de diseño)

```text
A hovering robotic fly with a dark gray metal body, large glassy lens eyes, thin transparent propeller wings, tiny claws and a small blinking red light on its head as team color, with a mischievous look. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, hovering in a neutral pose with blurred wings, three-quarter view slightly turned toward the left, facing left, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### G-037 · Drone Fly: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e5_drone_fly`, Drone Fly. Aéreo (air), caza unidades de apoyo.
- **Referencia a adjuntar:** `e5_drone_fly_ref.png`
- **Archivo de salida:** `e5_drone_fly_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e5_drone_fly_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C14, fila 1 (hover loop)

```text
Using the attached reference image (e5_drone_fly_ref.png) as the exact design of the character, draw an animation sprite sheet of Drone Fly performing the 'idle' animation.
Character identity, to stay consistent: Hovering robotic fly with a dark gray metal body, large glassy lens eyes, thin transparent propeller wings, tiny claws, small blinking red light on the head.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the propeller wings blur in different positions, the body bobs slightly, the red light blinks, and the lens eyes flash once.
```

### G-038 · Drone Fly: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e5_drone_fly`, Drone Fly. Aéreo (air), caza unidades de apoyo.
- **Referencia a adjuntar:** `e5_drone_fly_ref.png`
- **Archivo de salida:** `e5_drone_fly_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e5_drone_fly_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C14, fila 2 (flight loop)

```text
Using the attached reference image (e5_drone_fly_ref.png) as the exact design of the character, draw an animation sprite sheet of Drone Fly performing the 'walk' animation.
Character identity, to stay consistent: Hovering robotic fly with a dark gray metal body, large glassy lens eyes, thin transparent propeller wings, tiny claws, small blinking red light on the head.
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
- Character details to keep throughout the loop: the body tilts forward, the wings spin fast, the claws tuck under the body.
```

### G-039 · Drone Fly: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e5_drone_fly`, Drone Fly. Aéreo (air), caza unidades de apoyo.
- **Referencia a adjuntar:** `e5_drone_fly_ref.png`
- **Archivo de salida:** `e5_drone_fly_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e5_drone_fly_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C14, fila 3 (attack)

```text
Using the attached reference image (e5_drone_fly_ref.png) as the exact design of the character, draw an animation sprite sheet of Drone Fly performing the 'attack' animation.
Character identity, to stay consistent: Hovering robotic fly with a dark gray metal body, large glassy lens eyes, thin transparent propeller wings, tiny claws, small blinking red light on the head.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Flying hunter of support units (fast, 55 HP). It pulls back, dives forward with claws extended to grab and swipe, then returns up.
Motion by frames:
- Frames 1-6: The drone pulls back and up, the wings blur faster, the red light blinks quickly and the claws open.
- Frames 7-11: It tilts into a dive angle with the claws spread forward, the body shakes slightly as it charges.
- Frames 12-15: It dives forward on frame 13 with the claws extended to grab and swipe, wings stretched back.
- Frames 16-19: It sweeps past in an arc, the claws closing on empty air, the red light flashes.
- Frames 20-25: The drone climbs back to its hover height, the claws tuck in and the pose matches the hover idle.
```

### G-040 · Drone Fly: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e5_drone_fly`, Drone Fly. Aéreo (air), caza unidades de apoyo.
- **Referencia a adjuntar:** `e5_drone_fly_ref.png`
- **Archivo de salida:** `e5_drone_fly_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e5_drone_fly_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C14, fila 4 (hurt)

```text
Using the attached reference image (e5_drone_fly_ref.png) as the exact design of the character, draw an animation sprite sheet of Drone Fly performing the 'hurt' animation.
Character identity, to stay consistent: Hovering robotic fly with a dark gray metal body, large glassy lens eyes, thin transparent propeller wings, tiny claws, small blinking red light on the head.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body is knocked backward and spins slightly.
- Frames 6-18: The red light flickers, a wing stutters.
- Frames 19-25: It recovers.
```

### G-041 · Drone Fly: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e5_drone_fly`, Drone Fly. Aéreo (air), caza unidades de apoyo.
- **Referencia a adjuntar:** `e5_drone_fly_ref.png`
- **Archivo de salida:** `e5_drone_fly_defeat_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e5_drone_fly_defeat_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — caída o desarme con piezas, humo o chispas que se salen del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C14, fila 5 (defeat)

```text
Using the attached reference image (e5_drone_fly_ref.png) as the exact design of the character, draw an animation sprite sheet of Drone Fly performing the 'defeat' animation.
Character identity, to stay consistent: Hovering robotic fly with a dark gray metal body, large glassy lens eyes, thin transparent propeller wings, tiny claws, small blinking red light on the head.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The wings stop.
- Frames 9-20: The light goes dark, the drone drops to the ground with a bounce.
- Frames 21-25: The Drone Fly ends still with tiny stars above. Hold this final pose still until frame 25.
```

### G-042 · Count Magpie 3000 (jefe final Era 5): referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `b5_count_magpie_3000`, Count Magpie 3000 (jefe final Era 5). Jefe pesado; roba un poder 8 s, fase 2 se teletransporta y lanza bombas.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `b5_count_magpie_3000_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** D05 (descripción de diseño)

```text
Count Magpie 3000, a giant mechanical magpie with chrome-and-indigo plating, glowing cyan eyes, a metal top hat, a gold monocle, wings made of shiny metal blades and a red cape, clutching a glowing golden Chrono Core shard in one claw, wearing a smug grin. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the left, facing left, filling most of the frame, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### G-043 · Count Magpie 3000 (jefe final Era 5): idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b5_count_magpie_3000`, Count Magpie 3000 (jefe final Era 5). Jefe pesado; roba un poder 8 s, fase 2 se teletransporta y lanza bombas.
- **Referencia a adjuntar:** `b5_count_magpie_3000_ref.png`
- **Archivo de salida:** `b5_count_magpie_3000_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `b5_count_magpie_3000_idle_x2_sheet.png` (celda 1024 px / hoja 5120x5120 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido en el cuerpo del jefe (que ya llena la celda). Lienzo normal.
- **Origen:** D05, fila 1 (idle loop)

```text
Using the attached reference image (b5_count_magpie_3000_ref.png) as the exact design of the character, draw an animation sprite sheet of Count Magpie 3000 performing the 'idle' animation.
Character identity, to stay consistent: Count Magpie 3000: giant mechanical magpie, chrome-and-indigo plating, glowing cyan eyes, metal top hat, gold monocle, shiny metal blade wings, red cape, glowing golden Chrono Core shard in one claw.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the chest puffs up and down, the blade wings flex, the shard in the claw glows and pulses, the cape sways, and the eyes blink once.
```

### G-044 · Count Magpie 3000 (jefe final Era 5): walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b5_count_magpie_3000`, Count Magpie 3000 (jefe final Era 5). Jefe pesado; roba un poder 8 s, fase 2 se teletransporta y lanza bombas.
- **Referencia a adjuntar:** `b5_count_magpie_3000_ref.png`
- **Archivo de salida:** `b5_count_magpie_3000_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `b5_count_magpie_3000_walk_x2_sheet.png` (celda 1024 px / hoja 5120x5120 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido en el cuerpo del jefe (que ya llena la celda). Lienzo normal.
- **Origen:** D05, fila 2 (walk loop)

```text
Using the attached reference image (b5_count_magpie_3000_ref.png) as the exact design of the character, draw an animation sprite sheet of Count Magpie 3000 performing the 'walk' animation.
Character identity, to stay consistent: Count Magpie 3000: giant mechanical magpie, chrome-and-indigo plating, glowing cyan eyes, metal top hat, gold monocle, shiny metal blade wings, red cape, glowing golden Chrono Core shard in one claw.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (walk): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The left leg lifts in a proud, high step with the chest puffed out and the head forward.
- Frames 7-12: The left foot lands, the head bobs down a little and the cape swings.
- Frames 13-19: The right leg lifts in a proud, high step, the head moves back.
- Frames 20-25: The right foot lands and everything returns to the pose of frame 1.
- Character details to keep throughout the loop: proud strutting steps with alternating legs, the head bobbing, the cape flowing behind.
```

### G-045 · Count Magpie 3000 (jefe final Era 5): attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b5_count_magpie_3000`, Count Magpie 3000 (jefe final Era 5). Jefe pesado; roba un poder 8 s, fase 2 se teletransporta y lanza bombas.
- **Referencia a adjuntar:** `b5_count_magpie_3000_ref.png`
- **Archivo de salida:** `b5_count_magpie_3000_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `b5_count_magpie_3000_attack_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 1024 px / hoja 5120x5120 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el golpe/aliento/ráfaga del jefe llega muy lejos del cuerpo. Recomendado lienzo doble: celda 1024 px, hoja 5120x5120 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** D05, fila 3 (attack)

```text
Using the attached reference image (b5_count_magpie_3000_ref.png) as the exact design of the character, draw an animation sprite sheet of Count Magpie 3000 performing the 'attack' animation.
Character identity, to stay consistent: Count Magpie 3000: giant mechanical magpie, chrome-and-indigo plating, glowing cyan eyes, metal top hat, gold monocle, shiny metal blade wings, red cape, glowing golden Chrono Core shard in one claw.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Final boss. The wings spread wide, the shard glows brighter, the claw swings forward and releases a golden-cyan time wave at the key moment, then the wings fold back. The game adds the wave itself.
Motion by frames:
- Frames 1-6: The Count lifts his chest and the blade wings start to spread; the claw with the Chrono Core shard rises and the shard glows brighter.
- Frames 7-11: The wings are fully spread wide, the cape billows, the cyan eyes flare and the shard in the claw pulses strongly.
- Frames 12-15: The claw swings forward and releases a golden-cyan time wave on frame 13: a bright expanding arc of light around the claw, strong enough to push the cape back.
- Frames 16-19: The time wave expands further and fades, the wings stay open, small gold sparks drift down, the monocle flashes.
- Frames 20-25: The wings fold back in one smooth motion, the claw lowers with the shard glowing softly and the pose matches the idle.
```

### G-046 · Count Magpie 3000 (jefe final Era 5): hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b5_count_magpie_3000`, Count Magpie 3000 (jefe final Era 5). Jefe pesado; roba un poder 8 s, fase 2 se teletransporta y lanza bombas.
- **Referencia a adjuntar:** `b5_count_magpie_3000_ref.png`
- **Archivo de salida:** `b5_count_magpie_3000_hurt_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `b5_count_magpie_3000_hurt_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 1024 px / hoja 5120x5120 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — salen piezas, chispas o engranes despedidos. Recomendado lienzo doble: celda 1024 px, hoja 5120x5120 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** D05, fila 4 (hurt)

```text
Using the attached reference image (b5_count_magpie_3000_ref.png) as the exact design of the character, draw an animation sprite sheet of Count Magpie 3000 performing the 'hurt' animation.
Character identity, to stay consistent: Count Magpie 3000: giant mechanical magpie, chrome-and-indigo plating, glowing cyan eyes, metal top hat, gold monocle, shiny metal blade wings, red cape, glowing golden Chrono Core shard in one claw.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the top hat flies off.
- Frames 6-18: The monocle flashes, the body is pushed backward, sparks fly.
- Frames 19-25: He recovers.
```

### G-047 · Count Magpie 3000 (jefe final Era 5): defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b5_count_magpie_3000`, Count Magpie 3000 (jefe final Era 5). Jefe pesado; roba un poder 8 s, fase 2 se teletransporta y lanza bombas.
- **Referencia a adjuntar:** `b5_count_magpie_3000_ref.png`
- **Archivo de salida:** `b5_count_magpie_3000_defeat_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `b5_count_magpie_3000_defeat_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 1024 px / hoja 5120x5120 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el jefe cae y se derrumba ocupando mucho más espacio. Recomendado lienzo doble: celda 1024 px, hoja 5120x5120 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** D05, fila 5 (defeat)

```text
Using the attached reference image (b5_count_magpie_3000_ref.png) as the exact design of the character, draw an animation sprite sheet of Count Magpie 3000 performing the 'defeat' animation.
Character identity, to stay consistent: Count Magpie 3000: giant mechanical magpie, chrome-and-indigo plating, glowing cyan eyes, metal top hat, gold monocle, shiny metal blade wings, red cape, glowing golden Chrono Core shard in one claw.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The cyan eyes flicker out.
- Frames 9-20: The wings droop, the shard falls from the claw, the body tips over with a shower of sparks.
- Frames 21-25: He ends still with tiny stars above. Hold this final pose still until frame 25.
```

### G-048 · Insignia de era: Futuro lejano
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Medalla índigo con un planeta con anillos cian y estrellitas.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Cabecera del mapa y Home en la Era 5, selector de era.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `era_5.png`
- **Origen:** G16

```text
A round deep-indigo medallion with a glowing cyan ringed planet in the center, tiny white stars around it and a sleek metallic rim with cyan light. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```
