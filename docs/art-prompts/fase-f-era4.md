# Fase F: Era 4 (Industrial)

Todo lo de la Era 4, incluyendo la Clockwork Queen, bola de cañón y bomba, e icono de Fast-Forward.

**49 prompts** (7 referencias de personaje, 35 hojas de animación, 7 imágenes o sprites estáticos). Antes de empezar lee `README.md` (convenciones, tamaños, qué hacer si la cuadrícula sale mal). Genera cada referencia primero y luego sus animaciones en el mismo chat de Gemini, adjuntando `<id>_ref.png`.

---
### F-001 · Fondo de batalla, Era 4 (Industrial)
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Ciudad industrial de vapor al anochecer con torres de latón, tuberías, engranajes en el cielo y globos; camino de adoquín de hierro.
- **Tamaño / proporción:** 9:16 vertical, 1080x1920 px (si Gemini devuelve otra proporción, recortar a 9:16)
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Fondo de la batalla en las etapas de la Era 4 y la jefa Clockwork Queen.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `bg_era4.png`
- **Origen:** H04

```text
An industrial steam city at dusk with tall brass towers, giant pipes, chimneys puffing white and teal smoke, big gears hanging in the sky, a few hot-air balloons far away, glowing warm orange windows and a flat iron-plated cobblestone path running horizontally across the middle of the image. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Tall 9:16 portrait image with no characters, no text, no logos and no UI. Place the horizontal path at about 55 to 62 percent of the image height, keep the top 12 percent calm for the game HUD, and keep the bottom 30 percent calm and low-contrast so game buttons stay readable.
```

### F-002 · Base del jugador, Era 4
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Fortaleza de vapor de latón y cobre con dos torres remachadas, chimeneas, engranajes y puerta de horno brillante.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline recorta y deja 512 px de ancho)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Base del jugador (izquierda del carril) en la Era 4.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `base_p4.png`
- **Origen:** E04

```text
A brass-and-copper steam fortress with two round riveted towers, tall chimneys puffing white steam, big turning gears on the walls, a glowing furnace-door entrance and a blue flag on top. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing right, centered with a wide empty margin, with only a small iron platform directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### F-003 · Base enemiga, Era 4
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Fortaleza-fábrica de hierro sucia con chimeneas humeantes, engranajes gigantes, luces rojas y bandera roja.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline recorta y deja 512 px de ancho)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Base enemiga (derecha del carril, mirando a la izquierda) en la Era 4.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `base_e4.png`
- **Origen:** E09

```text
A grimy iron factory fortress with tall smokestacks pouring dark gray smoke, giant gears on the front wall, pipes, small glowing red lights, a heavy riveted iron gate and a red flag on the roof. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing left, centered with a wide empty margin, with only a small iron platform directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### F-004 · Gear Gunner Worm: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `p4_gear_gunner_worm`, Gear Gunner Worm. Tirador (shooter), cadencia alta.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `p4_gear_gunner_worm_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** B10 (descripción de diseño)

```text
A small golden-yellow earthworm gunner with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing brass goggles on his forehead and a small leather vest, holding a copper steam rifle. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### F-005 · Gear Gunner Worm: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p4_gear_gunner_worm`, Gear Gunner Worm. Tirador (shooter), cadencia alta.
- **Referencia a adjuntar:** `p4_gear_gunner_worm_ref.png`
- **Archivo de salida:** `p4_gear_gunner_worm_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p4_gear_gunner_worm_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B10, fila 1 (idle loop)

```text
Using the attached reference image (p4_gear_gunner_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Gear Gunner Worm performing the 'idle' animation.
Character identity, to stay consistent: Golden-yellow earthworm gunner, blue headband, brass goggles on the forehead, small leather vest, copper steam rifle.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the body gently rises and sinks, small puffs of white steam rise from the rifle, the goggles glint, and the eyes blink once.
```

### F-006 · Gear Gunner Worm: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p4_gear_gunner_worm`, Gear Gunner Worm. Tirador (shooter), cadencia alta.
- **Referencia a adjuntar:** `p4_gear_gunner_worm_ref.png`
- **Archivo de salida:** `p4_gear_gunner_worm_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p4_gear_gunner_worm_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B10, fila 2 (walk loop)

```text
Using the attached reference image (p4_gear_gunner_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Gear Gunner Worm performing the 'walk' animation.
Character identity, to stay consistent: Golden-yellow earthworm gunner, blue headband, brass goggles on the forehead, small leather vest, copper steam rifle.
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
- Character details to keep throughout the loop: the worm moves like an inchworm with the rifle on his shoulder, the goggles bouncing.
```

### F-007 · Gear Gunner Worm: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p4_gear_gunner_worm`, Gear Gunner Worm. Tirador (shooter), cadencia alta.
- **Referencia a adjuntar:** `p4_gear_gunner_worm_ref.png`
- **Archivo de salida:** `p4_gear_gunner_worm_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p4_gear_gunner_worm_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B10, fila 3 (attack)

```text
Using the attached reference image (p4_gear_gunner_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Gear Gunner Worm performing the 'attack' animation.
Character identity, to stay consistent: Golden-yellow earthworm gunner, blue headband, brass goggles on the forehead, small leather vest, copper steam rifle.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Fast shooter, rapid fire. TWO quick steam-rifle bursts in the sequence (first puff around frame 12, second around frame 16) each with a small recoil. Do NOT draw bullets.
Motion by frames:
- Frames 1-6: The rifle comes off the shoulder and is raised and aimed with a cocky grin; the goggles glint.
- Frames 7-11: The body braces, the rifle steadies, a small curl of steam gathers at the muzzle.
- Frames 12-15: First puff: a bright white steam burst shoots from the muzzle on frame 13 with a small recoil kick. A quicker second burst follows right behind it by frame 16, with another kick (no bullets drawn).
- Frames 16-19: The rifle shakes from the recoil, the steam clouds drift forward and thin out, the goggles slip a little.
- Frames 20-25: The rifle lowers back to the shoulder, the steam fades, the grin relaxes and the pose matches the idle.
```

### F-008 · Gear Gunner Worm: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p4_gear_gunner_worm`, Gear Gunner Worm. Tirador (shooter), cadencia alta.
- **Referencia a adjuntar:** `p4_gear_gunner_worm_ref.png`
- **Archivo de salida:** `p4_gear_gunner_worm_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p4_gear_gunner_worm_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B10, fila 4 (hurt)

```text
Using the attached reference image (p4_gear_gunner_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Gear Gunner Worm performing the 'hurt' animation.
Character identity, to stay consistent: Golden-yellow earthworm gunner, blue headband, brass goggles on the forehead, small leather vest, copper steam rifle.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body flinches backward.
- Frames 6-18: The goggles slip down over the eyes, the rifle sputters steam.
- Frames 19-25: The worm recovers.
```

### F-009 · Gear Gunner Worm: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p4_gear_gunner_worm`, Gear Gunner Worm. Tirador (shooter), cadencia alta.
- **Referencia a adjuntar:** `p4_gear_gunner_worm_ref.png`
- **Archivo de salida:** `p4_gear_gunner_worm_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p4_gear_gunner_worm_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B10, fila 5 (defeat)

```text
Using the attached reference image (p4_gear_gunner_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Gear Gunner Worm performing the 'defeat' animation.
Character identity, to stay consistent: Golden-yellow earthworm gunner, blue headband, brass goggles on the forehead, small leather vest, copper steam rifle.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The rifle drops.
- Frames 9-20: The worm droops and slides down flat, steam fizzles out.
- Frames 21-25: He ends lying still with tiny stars above his head. Hold this final pose still until frame 25.
```

### F-010 · Cog Roach: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `e4_cog_roach`, Cog Roach. Luchador (fighter), corredor rápido.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `e4_cog_roach_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** C10 (descripción de diseño)

```text
A clockwork cockroach with brass body plates, visible gears and rivets on its back, big round eyes, a red cloth band tied around its head as team color, carrying a big iron wrench over its shoulder with a cheeky grin. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the left, facing left, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### F-011 · Cog Roach: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e4_cog_roach`, Cog Roach. Luchador (fighter), corredor rápido.
- **Referencia a adjuntar:** `e4_cog_roach_ref.png`
- **Archivo de salida:** `e4_cog_roach_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e4_cog_roach_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C10, fila 1 (idle loop)

```text
Using the attached reference image (e4_cog_roach_ref.png) as the exact design of the character, draw an animation sprite sheet of Cog Roach performing the 'idle' animation.
Character identity, to stay consistent: Clockwork cockroach with brass plates, visible gears and rivets on its back, red cloth band on the head, cheeky grin, big iron wrench.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the back gears turn slowly, the body bobs, the antennae twitch, and the eyes blink once.
```

### F-012 · Cog Roach: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e4_cog_roach`, Cog Roach. Luchador (fighter), corredor rápido.
- **Referencia a adjuntar:** `e4_cog_roach_ref.png`
- **Archivo de salida:** `e4_cog_roach_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e4_cog_roach_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C10, fila 2 (run loop)

```text
Using the attached reference image (e4_cog_roach_ref.png) as the exact design of the character, draw an animation sprite sheet of Cog Roach performing the 'walk' animation.
Character identity, to stay consistent: Clockwork cockroach with brass plates, visible gears and rivets on its back, red cloth band on the head, cheeky grin, big iron wrench.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (run): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The first group of legs (front and rear on one side, middle on the other) steps forward while the others push back; the body dips a little.
- Frames 7-12: Weight passes over the planted legs, the body rises to its highest point.
- Frames 13-19: The second group of legs steps forward while the first pushes back; the body dips again.
- Frames 20-25: Weight passes again and the legs return to the exact positions of frame 1.
- Character details to keep throughout the loop: the six legs run in fast alternating pairs, the body leaning forward, the wrench bouncing on the shoulder.
```

### F-013 · Cog Roach: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e4_cog_roach`, Cog Roach. Luchador (fighter), corredor rápido.
- **Referencia a adjuntar:** `e4_cog_roach_ref.png`
- **Archivo de salida:** `e4_cog_roach_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e4_cog_roach_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C10, fila 3 (attack)

```text
Using the attached reference image (e4_cog_roach_ref.png) as the exact design of the character, draw an animation sprite sheet of Cog Roach performing the 'attack' animation.
Character identity, to stay consistent: Clockwork cockroach with brass plates, visible gears and rivets on its back, red cloth band on the head, cheeky grin, big iron wrench.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Fast rusher (speed 80). The wrench is lifted behind the head and swung down and forward in a quick, snappy strike.
Motion by frames:
- Frames 1-6: The roach rears back on its hind legs and lifts the iron wrench off the shoulder; gears on its back spin faster.
- Frames 7-11: The wrench rises behind the head, the body coils like a spring, a cheeky grin.
- Frames 12-15: The wrench swings down and forward in a quick snappy arc on frame 13 with a small spark at the contact.
- Frames 16-19: The wrench rests low in front, the body bends forward, a gear pops slightly loose.
- Frames 20-25: The roach hauls the wrench back to the shoulder, drops onto all its legs and the pose matches the idle.
```

### F-014 · Cog Roach: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e4_cog_roach`, Cog Roach. Luchador (fighter), corredor rápido.
- **Referencia a adjuntar:** `e4_cog_roach_ref.png`
- **Archivo de salida:** `e4_cog_roach_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e4_cog_roach_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C10, fila 4 (hurt)

```text
Using the attached reference image (e4_cog_roach_ref.png) as the exact design of the character, draw an animation sprite sheet of Cog Roach performing the 'hurt' animation.
Character identity, to stay consistent: Clockwork cockroach with brass plates, visible gears and rivets on its back, red cloth band on the head, cheeky grin, big iron wrench.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body flinches backward.
- Frames 6-18: A gear pops off, sparks fly.
- Frames 19-25: It recovers.
```

### F-015 · Cog Roach: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e4_cog_roach`, Cog Roach. Luchador (fighter), corredor rápido.
- **Referencia a adjuntar:** `e4_cog_roach_ref.png`
- **Archivo de salida:** `e4_cog_roach_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e4_cog_roach_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C10, fila 5 (defeat)

```text
Using the attached reference image (e4_cog_roach_ref.png) as the exact design of the character, draw an animation sprite sheet of Cog Roach performing the 'defeat' animation.
Character identity, to stay consistent: Clockwork cockroach with brass plates, visible gears and rivets on its back, red cloth band on the head, cheeky grin, big iron wrench.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The gears slow and stop.
- Frames 9-20: The legs fold, the roach flips onto its back with the wrench falling beside it.
- Frames 21-25: The Cog Roach ends still with tiny stars above. Hold this final pose still until frame 25.
```

### F-016 · Boiler Tank Worm: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `p4_boiler_tank_worm`, Boiler Tank Worm. Pesado (heavy), daño en área.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `p4_boiler_tank_worm_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** B11 (descripción de diseño)

```text
A small golden-yellow earthworm driver with big round dark eyes and a small blue cloth headband as team color, peeking out of the hatch of a chunky round copper-and-brass steam tank with rivets, a tall chimney puffing white steam, small treads and a stubby cannon. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing still on its treads, chimney puffing a little steam, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### F-017 · Boiler Tank Worm: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p4_boiler_tank_worm`, Boiler Tank Worm. Pesado (heavy), daño en área.
- **Referencia a adjuntar:** `p4_boiler_tank_worm_ref.png`
- **Archivo de salida:** `p4_boiler_tank_worm_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p4_boiler_tank_worm_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B11, fila 1 (idle loop)

```text
Using the attached reference image (p4_boiler_tank_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Boiler Tank Worm performing the 'idle' animation.
Character identity, to stay consistent: Golden-yellow worm driver with blue headband peeking from the hatch of a chunky round copper-and-brass steam tank with rivets, tall chimney and stubby cannon.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the tank body shudders gently, steam puffs rise from the chimney, and the driver blinks once.
```

### F-018 · Boiler Tank Worm: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p4_boiler_tank_worm`, Boiler Tank Worm. Pesado (heavy), daño en área.
- **Referencia a adjuntar:** `p4_boiler_tank_worm_ref.png`
- **Archivo de salida:** `p4_boiler_tank_worm_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p4_boiler_tank_worm_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B11, fila 2 (drive loop)

```text
Using the attached reference image (p4_boiler_tank_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Boiler Tank Worm performing the 'walk' animation.
Character identity, to stay consistent: Golden-yellow worm driver with blue headband peeking from the hatch of a chunky round copper-and-brass steam tank with rivets, tall chimney and stubby cannon.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (drive): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The treads roll and the whole machine bounces up a little, the chimney puffs.
- Frames 7-12: The machine settles down, the body leans slightly forward.
- Frames 13-19: The treads roll on and it bounces up again with a bigger steam puff.
- Frames 20-25: It settles back to exactly the pose of frame 1.
- Character details to keep throughout the loop: the treads roll, the tank bounces up and down as it moves, the chimney puffs faster, the driver holds on.
```

### F-019 · Boiler Tank Worm: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p4_boiler_tank_worm`, Boiler Tank Worm. Pesado (heavy), daño en área.
- **Referencia a adjuntar:** `p4_boiler_tank_worm_ref.png`
- **Archivo de salida:** `p4_boiler_tank_worm_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p4_boiler_tank_worm_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B11, fila 3 (attack)

```text
Using the attached reference image (p4_boiler_tank_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Boiler Tank Worm performing the 'attack' animation.
Character identity, to stay consistent: Golden-yellow worm driver with blue headband peeking from the hatch of a chunky round copper-and-brass steam tank with rivets, tall chimney and stubby cannon.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Heavy with splash damage. The cannon fires one big blast with a wide round smoke puff and a small shock ring at the muzzle; the tank rocks back.
Motion by frames:
- Frames 1-6: The tank rocks back on its treads and the cannon rises slightly; the chimney puffs a bigger cloud and the driver ducks lower into the hatch.
- Frames 7-11: The cannon barrel slides back into the body to load, the whole tank compresses like a spring, the rivets rattle.
- Frames 12-15: The cannon fires on frame 13: a flash and a big round puff of smoke at the muzzle, a small shock ring, and the whole tank rocks backward on its treads.
- Frames 16-19: The smoke spreads, the tank settles forward again with a bounce, the driver peeks out of the hatch.
- Frames 20-25: The barrel slides forward to its resting place, the chimney puffs normally again and the pose matches the idle.
```

### F-020 · Boiler Tank Worm: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p4_boiler_tank_worm`, Boiler Tank Worm. Pesado (heavy), daño en área.
- **Referencia a adjuntar:** `p4_boiler_tank_worm_ref.png`
- **Archivo de salida:** `p4_boiler_tank_worm_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p4_boiler_tank_worm_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B11, fila 4 (hurt)

```text
Using the attached reference image (p4_boiler_tank_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Boiler Tank Worm performing the 'hurt' animation.
Character identity, to stay consistent: Golden-yellow worm driver with blue headband peeking from the hatch of a chunky round copper-and-brass steam tank with rivets, tall chimney and stubby cannon.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the tank rocks back.
- Frames 6-18: The driver ducks into the hatch and peeks out, a few rivets pop and sparks fly.
- Frames 19-25: It recovers.
```

### F-021 · Boiler Tank Worm: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p4_boiler_tank_worm`, Boiler Tank Worm. Pesado (heavy), daño en área.
- **Referencia a adjuntar:** `p4_boiler_tank_worm_ref.png`
- **Archivo de salida:** `p4_boiler_tank_worm_defeat_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p4_boiler_tank_worm_defeat_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — caída o desarme con piezas, humo o chispas que se salen del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B11, fila 5 (defeat)

```text
Using the attached reference image (p4_boiler_tank_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Boiler Tank Worm performing the 'defeat' animation.
Character identity, to stay consistent: Golden-yellow worm driver with blue headband peeking from the hatch of a chunky round copper-and-brass steam tank with rivets, tall chimney and stubby cannon.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The chimney bends.
- Frames 9-20: Steam leaks out in puffs, the tank tilts and sinks, the driver slumps out of the hatch.
- Frames 21-25: It ends still with tiny stars above. Hold this final pose still until frame 25.
```

### F-022 · Proyectil: bola de cañón de vapor
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Bola de cañón de hierro con banda de latón y remaches y una nube de vapor.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Proyectil de la Boiler Tank Worm (Era 4) y, reducido, de la Gear Gunner Worm.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `proj_cannonball.png`
- **Origen:** F03

```text
A single round iron cannonball with a brass band and small rivets, trailing a small puff of white steam behind it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single small object, side view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### F-023 · Clank Crab: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `e4_clank_crab`, Clank Crab. Pesado (heavy), armadura frontal 25%.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `e4_clank_crab_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** C12 (descripción de diseño)

```text
A heavy steam-powered crab with riveted iron shell plates, brass pipes releasing puffs of white steam, two big riveted claws, small angry round eyes on stalks and a small red flag on its back as team color. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the left, facing left, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### F-024 · Clank Crab: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e4_clank_crab`, Clank Crab. Pesado (heavy), armadura frontal 25%.
- **Referencia a adjuntar:** `e4_clank_crab_ref.png`
- **Archivo de salida:** `e4_clank_crab_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e4_clank_crab_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C12, fila 1 (idle loop)

```text
Using the attached reference image (e4_clank_crab_ref.png) as the exact design of the character, draw an animation sprite sheet of Clank Crab performing the 'idle' animation.
Character identity, to stay consistent: Heavy steam-powered crab with riveted iron shell plates, brass pipes puffing white steam, two big riveted claws, eyes on stalks, small red flag on its back.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the claws open and close slowly, the steam puffs from the pipes, the eye stalks wobble, and the eyes blink once.
```

### F-025 · Clank Crab: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e4_clank_crab`, Clank Crab. Pesado (heavy), armadura frontal 25%.
- **Referencia a adjuntar:** `e4_clank_crab_ref.png`
- **Archivo de salida:** `e4_clank_crab_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e4_clank_crab_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C12, fila 2 (scuttle loop)

```text
Using the attached reference image (e4_clank_crab_ref.png) as the exact design of the character, draw an animation sprite sheet of Clank Crab performing the 'walk' animation.
Character identity, to stay consistent: Heavy steam-powered crab with riveted iron shell plates, brass pipes puffing white steam, two big riveted claws, eyes on stalks, small red flag on its back.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (scuttle): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The first group of legs (front and rear on one side, middle on the other) steps forward while the others push back; the body dips a little.
- Frames 7-12: Weight passes over the planted legs, the body rises to its highest point.
- Frames 13-19: The second group of legs steps forward while the first pushes back; the body dips again.
- Frames 20-25: Weight passes again and the legs return to the exact positions of frame 1.
- Character details to keep throughout the loop: the legs step in quick alternating pairs, the body shakes from side to side, the steam puffs faster.
```

### F-026 · Clank Crab: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e4_clank_crab`, Clank Crab. Pesado (heavy), armadura frontal 25%.
- **Referencia a adjuntar:** `e4_clank_crab_ref.png`
- **Archivo de salida:** `e4_clank_crab_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e4_clank_crab_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C12, fila 3 (attack)

```text
Using the attached reference image (e4_clank_crab_ref.png) as the exact design of the character, draw an animation sprite sheet of Clank Crab performing the 'attack' animation.
Character identity, to stay consistent: Heavy steam-powered crab with riveted iron shell plates, brass pipes puffing white steam, two big riveted claws, eyes on stalks, small red flag on its back.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Heavy with 25% frontal armor. Both claws are raised high and slammed down and forward with a clank and a small steam puff.
Motion by frames:
- Frames 1-6: The crab rears up on its back legs and lifts both big claws high, steam hissing from the pipes.
- Frames 7-11: Both claws reach their highest point, the body leans back, the eye stalks tilt up.
- Frames 12-15: Both claws slam down and forward together on frame 13 with a loud clank, a flash of sparks and a puff of steam at the impact.
- Frames 16-19: The claws stay pressed down for a moment, the body bends forward, the shell plates rattle.
- Frames 20-25: The claws lift and pull back to the guard position in front, the crab lowers onto its legs and the pose matches the idle.
```

### F-027 · Clank Crab: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e4_clank_crab`, Clank Crab. Pesado (heavy), armadura frontal 25%.
- **Referencia a adjuntar:** `e4_clank_crab_ref.png`
- **Archivo de salida:** `e4_clank_crab_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e4_clank_crab_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C12, fila 4 (hurt)

```text
Using the attached reference image (e4_clank_crab_ref.png) as the exact design of the character, draw an animation sprite sheet of Clank Crab performing the 'hurt' animation.
Character identity, to stay consistent: Heavy steam-powered crab with riveted iron shell plates, brass pipes puffing white steam, two big riveted claws, eyes on stalks, small red flag on its back.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the shell dents with a spark.
- Frames 6-18: The body is knocked backward, the eye stalks droop.
- Frames 19-25: It recovers.
```

### F-028 · Clank Crab: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e4_clank_crab`, Clank Crab. Pesado (heavy), armadura frontal 25%.
- **Referencia a adjuntar:** `e4_clank_crab_ref.png`
- **Archivo de salida:** `e4_clank_crab_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e4_clank_crab_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C12, fila 5 (defeat)

```text
Using the attached reference image (e4_clank_crab_ref.png) as the exact design of the character, draw an animation sprite sheet of Clank Crab performing the 'defeat' animation.
Character identity, to stay consistent: Heavy steam-powered crab with riveted iron shell plates, brass pipes puffing white steam, two big riveted claws, eyes on stalks, small red flag on its back.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: A pipe bursts with steam.
- Frames 9-20: The legs fold, the crab sinks flat and tips over.
- Frames 21-25: The Clank Crab ends still with tiny stars above. Hold this final pose still until frame 25.
```

### F-029 · Balloon Bomber Worm: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `p4_balloon_bomber_worm`, Balloon Bomber Worm. Aéreo (air), bombardea con daño en área.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `p4_balloon_bomber_worm_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** B12 (descripción de diseño)

```text
A small golden-yellow earthworm bomber with a cream-colored segmented belly, big round dark eyes, a small blue cloth headband as team color and brass goggles, hanging from a small wicker basket under a patched teal-and-cream hot-air balloon, holding a round black bomb with a lit sparking fuse. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, floating in a relaxed neutral pose, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### F-030 · Balloon Bomber Worm: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p4_balloon_bomber_worm`, Balloon Bomber Worm. Aéreo (air), bombardea con daño en área.
- **Referencia a adjuntar:** `p4_balloon_bomber_worm_ref.png`
- **Archivo de salida:** `p4_balloon_bomber_worm_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p4_balloon_bomber_worm_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B12, fila 1 (idle loop)

```text
Using the attached reference image (p4_balloon_bomber_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Balloon Bomber Worm performing the 'idle' animation.
Character identity, to stay consistent: Golden-yellow earthworm bomber, blue headband and brass goggles, hanging from a wicker basket under a patched teal-and-cream hot-air balloon, holding a black bomb with a lit fuse.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the balloon floats up and down gently, the basket sways below it, the bomb fuse sparkles, and the worm blinks once.
```

### F-031 · Balloon Bomber Worm: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p4_balloon_bomber_worm`, Balloon Bomber Worm. Aéreo (air), bombardea con daño en área.
- **Referencia a adjuntar:** `p4_balloon_bomber_worm_ref.png`
- **Archivo de salida:** `p4_balloon_bomber_worm_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p4_balloon_bomber_worm_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B12, fila 2 (fly loop)

```text
Using the attached reference image (p4_balloon_bomber_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Balloon Bomber Worm performing the 'walk' animation.
Character identity, to stay consistent: Golden-yellow earthworm bomber, blue headband and brass goggles, hanging from a wicker basket under a patched teal-and-cream hot-air balloon, holding a black bomb with a lit fuse.
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
- Character details to keep throughout the loop: the balloon tilts forward and drifts, the basket swings behind it, the ropes stretch and relax, the worm grins.
```

### F-032 · Balloon Bomber Worm: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p4_balloon_bomber_worm`, Balloon Bomber Worm. Aéreo (air), bombardea con daño en área.
- **Referencia a adjuntar:** `p4_balloon_bomber_worm_ref.png`
- **Archivo de salida:** `p4_balloon_bomber_worm_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p4_balloon_bomber_worm_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B12, fila 3 (attack)

```text
Using the attached reference image (p4_balloon_bomber_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Balloon Bomber Worm performing the 'attack' animation.
Character identity, to stay consistent: Golden-yellow earthworm bomber, blue headband and brass goggles, hanging from a wicker basket under a patched teal-and-cream hot-air balloon, holding a black bomb with a lit fuse.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Air unit with splash damage. The worm lifts the bomb over the basket edge and drops it straight down at the key moment; the bomb falls out of the frame (it is a separate sprite) and the balloon bobs up lighter.
Motion by frames:
- Frames 1-6: The worm leans over the basket edge, lifts the bomb with both hands and the fuse sparks brighter; the balloon tilts slightly toward him.
- Frames 7-11: He winds up, the bomb swings back beside the basket, the basket tilts and the ropes stretch.
- Frames 12-15: He drops the bomb straight down on frame 13 with a mischievous grin (draw the bomb leaving his hands and falling out of the cell bottom, no explosion); the balloon jumps up lighter.
- Frames 16-19: The balloon rises a little and wobbles, the basket swings, the worm looks down over the edge.
- Frames 20-25: The balloon settles back to its floating height, the worm straightens, the basket stops swinging and the pose matches the idle.
```

### F-033 · Balloon Bomber Worm: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p4_balloon_bomber_worm`, Balloon Bomber Worm. Aéreo (air), bombardea con daño en área.
- **Referencia a adjuntar:** `p4_balloon_bomber_worm_ref.png`
- **Archivo de salida:** `p4_balloon_bomber_worm_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p4_balloon_bomber_worm_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B12, fila 4 (hurt)

```text
Using the attached reference image (p4_balloon_bomber_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Balloon Bomber Worm performing the 'hurt' animation.
Character identity, to stay consistent: Golden-yellow earthworm bomber, blue headband and brass goggles, hanging from a wicker basket under a patched teal-and-cream hot-air balloon, holding a black bomb with a lit fuse.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the balloon squashes sideways.
- Frames 6-18: The basket swings wildly, a small patch rips and puffs of air escape.
- Frames 19-25: The worm holds on and recovers.
```

### F-034 · Balloon Bomber Worm: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p4_balloon_bomber_worm`, Balloon Bomber Worm. Aéreo (air), bombardea con daño en área.
- **Referencia a adjuntar:** `p4_balloon_bomber_worm_ref.png`
- **Archivo de salida:** `p4_balloon_bomber_worm_defeat_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p4_balloon_bomber_worm_defeat_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — caída o desarme con piezas, humo o chispas que se salen del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B12, fila 5 (defeat)

```text
Using the attached reference image (p4_balloon_bomber_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Balloon Bomber Worm performing the 'defeat' animation.
Character identity, to stay consistent: Golden-yellow earthworm bomber, blue headband and brass goggles, hanging from a wicker basket under a patched teal-and-cream hot-air balloon, holding a black bomb with a lit fuse.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The balloon deflates and wrinkles.
- Frames 9-20: The basket drops down, the worm waves a tiny white flag.
- Frames 21-25: Everything ends still on the ground with tiny stars above. Hold this final pose still until frame 25.
```

### F-035 · Proyectil: bomba
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Bomba negra redonda con mecha encendida, chispas y banda de latón. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Bomba que suelta la Balloon Bomber Worm (Era 4). NUEVO: el original no lo traía.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `proj_bomb.png`
- **Origen:** nuevo (no estaba en el original)

```text
A single round black bomb with a short lit fuse throwing tiny orange sparks, a small white highlight and a thin brass band. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single small object, front view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### F-036 · Spark Fly: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `e4_spark_fly`, Spark Fly. Aéreo (air), rayo en cadena a 2 objetivos más.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `e4_spark_fly_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** C11 (descripción de diseño)

```text
A mechanical firefly with a copper body, tiny propeller wings, big round eyes and a glass-lantern abdomen crackling with blue-white electricity, a red cloth ribbon tied to one antenna as team color, with a playful grin. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, hovering in a neutral pose with blurred propellers, three-quarter view slightly turned toward the left, facing left, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### F-037 · Spark Fly: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e4_spark_fly`, Spark Fly. Aéreo (air), rayo en cadena a 2 objetivos más.
- **Referencia a adjuntar:** `e4_spark_fly_ref.png`
- **Archivo de salida:** `e4_spark_fly_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e4_spark_fly_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C11, fila 1 (hover loop)

```text
Using the attached reference image (e4_spark_fly_ref.png) as the exact design of the character, draw an animation sprite sheet of Spark Fly performing the 'idle' animation.
Character identity, to stay consistent: Mechanical firefly with a copper body, tiny propeller wings, glass-lantern abdomen crackling with blue-white electricity, red ribbon on one antenna.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the propellers spin in blurry positions, the body bobs, the lantern glow pulses, and the eyes blink once.
```

### F-038 · Spark Fly: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e4_spark_fly`, Spark Fly. Aéreo (air), rayo en cadena a 2 objetivos más.
- **Referencia a adjuntar:** `e4_spark_fly_ref.png`
- **Archivo de salida:** `e4_spark_fly_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e4_spark_fly_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C11, fila 2 (flight loop)

```text
Using the attached reference image (e4_spark_fly_ref.png) as the exact design of the character, draw an animation sprite sheet of Spark Fly performing the 'walk' animation.
Character identity, to stay consistent: Mechanical firefly with a copper body, tiny propeller wings, glass-lantern abdomen crackling with blue-white electricity, red ribbon on one antenna.
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
- Character details to keep throughout the loop: the body tilts forward, the propellers spin fast, the ribbon streams behind, small sparks trail.
```

### F-039 · Spark Fly: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e4_spark_fly`, Spark Fly. Aéreo (air), rayo en cadena a 2 objetivos más.
- **Referencia a adjuntar:** `e4_spark_fly_ref.png`
- **Archivo de salida:** `e4_spark_fly_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e4_spark_fly_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C11, fila 3 (attack)

```text
Using the attached reference image (e4_spark_fly_ref.png) as the exact design of the character, draw an animation sprite sheet of Spark Fly performing the 'attack' animation.
Character identity, to stay consistent: Mechanical firefly with a copper body, tiny propeller wings, glass-lantern abdomen crackling with blue-white electricity, red ribbon on one antenna.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Flying chain-lightning unit. The lantern glows brighter, then one short zig-zag bolt of blue-white electricity zaps forward from the lantern (about one body length only; the chain jump is a separate game effect).
Motion by frames:
- Frames 1-6: The firefly curls its body back, the propellers slow down and the lantern abdomen begins to glow brighter.
- Frames 7-11: The lantern reaches its brightest white-blue, tiny sparks crackle around it, the body curls tight.
- Frames 12-15: A short zig-zag bolt of blue-white electricity zaps forward from the lantern on frame 13 (about one body length only), the body snaps forward.
- Frames 16-19: The bolt flickers out, sparks drift down, the lantern dims and the body floats back up.
- Frames 20-25: The propellers speed back up, the body returns to its hover height and the pose matches the hover idle.
```

### F-040 · Spark Fly: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e4_spark_fly`, Spark Fly. Aéreo (air), rayo en cadena a 2 objetivos más.
- **Referencia a adjuntar:** `e4_spark_fly_ref.png`
- **Archivo de salida:** `e4_spark_fly_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e4_spark_fly_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C11, fila 4 (hurt)

```text
Using the attached reference image (e4_spark_fly_ref.png) as the exact design of the character, draw an animation sprite sheet of Spark Fly performing the 'hurt' animation.
Character identity, to stay consistent: Mechanical firefly with a copper body, tiny propeller wings, glass-lantern abdomen crackling with blue-white electricity, red ribbon on one antenna.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body is knocked backward.
- Frames 6-18: The lantern flickers, sparks fly.
- Frames 19-25: It recovers.
```

### F-041 · Spark Fly: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e4_spark_fly`, Spark Fly. Aéreo (air), rayo en cadena a 2 objetivos más.
- **Referencia a adjuntar:** `e4_spark_fly_ref.png`
- **Archivo de salida:** `e4_spark_fly_defeat_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e4_spark_fly_defeat_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — caída o desarme con piezas, humo o chispas que se salen del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C11, fila 5 (defeat)

```text
Using the attached reference image (e4_spark_fly_ref.png) as the exact design of the character, draw an animation sprite sheet of Spark Fly performing the 'defeat' animation.
Character identity, to stay consistent: Mechanical firefly with a copper body, tiny propeller wings, glass-lantern abdomen crackling with blue-white electricity, red ribbon on one antenna.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height line (hover height) in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-20: The lantern goes dark, the propellers slow and stop.
- Frames 21-25: The firefly drops to the ground and ends still with tiny stars above. Hold this final pose still until frame 25.
```

### F-042 · The Clockwork Queen (jefe Era 4): referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `b4_clockwork_queen`, The Clockwork Queen (jefe Era 4). Jefe pesado; ráfaga de vapor (ralentiza), fase 2 genera Cog Roach.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `b4_clockwork_queen_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** D04 (descripción de diseño)

```text
The Clockwork Queen, a large mechanical spider with a brass-and-copper body, a small golden crown, visible gears and rivets, six thin jointed legs, a glass-dome abdomen full of swirling white steam, glowing red eyes and a red silk sash across her body. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the left, facing left, filling most of the frame, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### F-043 · The Clockwork Queen (jefe Era 4): idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b4_clockwork_queen`, The Clockwork Queen (jefe Era 4). Jefe pesado; ráfaga de vapor (ralentiza), fase 2 genera Cog Roach.
- **Referencia a adjuntar:** `b4_clockwork_queen_ref.png`
- **Archivo de salida:** `b4_clockwork_queen_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `b4_clockwork_queen_idle_x2_sheet.png` (celda 1024 px / hoja 5120x5120 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido en el cuerpo del jefe (que ya llena la celda). Lienzo normal.
- **Origen:** D04, fila 1 (idle loop)

```text
Using the attached reference image (b4_clockwork_queen_ref.png) as the exact design of the character, draw an animation sprite sheet of The Clockwork Queen performing the 'idle' animation.
Character identity, to stay consistent: The Clockwork Queen: large mechanical spider, brass-and-copper body, small golden crown, visible gears and rivets, six thin jointed legs, glass-dome abdomen with swirling white steam, glowing red eyes, red silk sash.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the steam swirls in the dome, the gears turn, the legs shift slightly, and the red eyes blink once.
```

### F-044 · The Clockwork Queen (jefe Era 4): walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b4_clockwork_queen`, The Clockwork Queen (jefe Era 4). Jefe pesado; ráfaga de vapor (ralentiza), fase 2 genera Cog Roach.
- **Referencia a adjuntar:** `b4_clockwork_queen_ref.png`
- **Archivo de salida:** `b4_clockwork_queen_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `b4_clockwork_queen_walk_x2_sheet.png` (celda 1024 px / hoja 5120x5120 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido en el cuerpo del jefe (que ya llena la celda). Lienzo normal.
- **Origen:** D04, fila 2 (walk loop)

```text
Using the attached reference image (b4_clockwork_queen_ref.png) as the exact design of the character, draw an animation sprite sheet of The Clockwork Queen performing the 'walk' animation.
Character identity, to stay consistent: The Clockwork Queen: large mechanical spider, brass-and-copper body, small golden crown, visible gears and rivets, six thin jointed legs, glass-dome abdomen with swirling white steam, glowing red eyes, red silk sash.
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
- Character details to keep throughout the loop: the thin legs step in alternating groups, the body rising and sinking, the sash fluttering.
```

### F-045 · The Clockwork Queen (jefe Era 4): attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b4_clockwork_queen`, The Clockwork Queen (jefe Era 4). Jefe pesado; ráfaga de vapor (ralentiza), fase 2 genera Cog Roach.
- **Referencia a adjuntar:** `b4_clockwork_queen_ref.png`
- **Archivo de salida:** `b4_clockwork_queen_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `b4_clockwork_queen_attack_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 1024 px / hoja 5120x5120 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el golpe/aliento/ráfaga del jefe llega muy lejos del cuerpo. Recomendado lienzo doble: celda 1024 px, hoja 5120x5120 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** D04, fila 3 (attack)

```text
Using the attached reference image (b4_clockwork_queen_ref.png) as the exact design of the character, draw an animation sprite sheet of The Clockwork Queen performing the 'attack' animation.
Character identity, to stay consistent: The Clockwork Queen: large mechanical spider, brass-and-copper body, small golden crown, visible gears and rivets, six thin jointed legs, glass-dome abdomen with swirling white steam, glowing red eyes, red silk sash.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Boss. The front legs rise, the dome glows, a burst of hot steam is released forward and the front legs stab down at the key moment. The game adds the steam area separately.
Motion by frames:
- Frames 1-6: The Queen raises her two front legs high and the glass dome starts to glow; the gears spin faster and the steam inside swirls.
- Frames 7-11: The dome glows bright white-orange, the body squats on the rear legs, the crown tilts back and the red eyes flare.
- Frames 12-15: The front legs stab down hard on frame 13 and a burst of hot steam jets forward out of the dome in a thick white cloud.
- Frames 16-19: The steam keeps pouring forward and spreads, the front legs stay planted, the sash flutters wildly.
- Frames 20-25: The steam thins out, the front legs lift and return, the dome calms to its slow swirl and the pose matches the idle.
```

### F-046 · The Clockwork Queen (jefe Era 4): hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b4_clockwork_queen`, The Clockwork Queen (jefe Era 4). Jefe pesado; ráfaga de vapor (ralentiza), fase 2 genera Cog Roach.
- **Referencia a adjuntar:** `b4_clockwork_queen_ref.png`
- **Archivo de salida:** `b4_clockwork_queen_hurt_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `b4_clockwork_queen_hurt_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 1024 px / hoja 5120x5120 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — salen piezas, chispas o engranes despedidos. Recomendado lienzo doble: celda 1024 px, hoja 5120x5120 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** D04, fila 4 (hurt)

```text
Using the attached reference image (b4_clockwork_queen_ref.png) as the exact design of the character, draw an animation sprite sheet of The Clockwork Queen performing the 'hurt' animation.
Character identity, to stay consistent: The Clockwork Queen: large mechanical spider, brass-and-copper body, small golden crown, visible gears and rivets, six thin jointed legs, glass-dome abdomen with swirling white steam, glowing red eyes, red silk sash.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the crown tilts.
- Frames 6-18: The body is pushed backward, gears spit out, sparks fly.
- Frames 19-25: She recovers.
```

### F-047 · The Clockwork Queen (jefe Era 4): defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b4_clockwork_queen`, The Clockwork Queen (jefe Era 4). Jefe pesado; ráfaga de vapor (ralentiza), fase 2 genera Cog Roach.
- **Referencia a adjuntar:** `b4_clockwork_queen_ref.png`
- **Archivo de salida:** `b4_clockwork_queen_defeat_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `b4_clockwork_queen_defeat_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 1024 px / hoja 5120x5120 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el jefe cae y se derrumba ocupando mucho más espacio. Recomendado lienzo doble: celda 1024 px, hoja 5120x5120 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** D04, fila 5 (defeat)

```text
Using the attached reference image (b4_clockwork_queen_ref.png) as the exact design of the character, draw an animation sprite sheet of The Clockwork Queen performing the 'defeat' animation.
Character identity, to stay consistent: The Clockwork Queen: large mechanical spider, brass-and-copper body, small golden crown, visible gears and rivets, six thin jointed legs, glass-dome abdomen with swirling white steam, glowing red eyes, red silk sash.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The glow in the dome fades.
- Frames 9-20: The legs fold one by one, the crown rolls off, the body sinks with a puff of steam.
- Frames 21-25: She ends still with tiny stars above. Hold this final pose still until frame 25.
```

### F-048 · Insignia de era: Industrial
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Medalla de cobre con dos engranajes de latón entrelazados y una nube de vapor.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Cabecera del mapa y Home en la Era 4, selector de era.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `era_4.png`
- **Origen:** G15

```text
A round copper medallion with two interlocking brass gears in the center, a small puff of white steam rising from the top and a riveted rim. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### F-049 · Icono de poder: Fast-Forward
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Dos chevrones dorados hacia la derecha delante de un reloj con líneas de velocidad.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Botón de poder del HUD y selector de poderes; se desbloquea tras el jefe de la Era 4.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `power_fast_forward.png`
- **Origen:** G11

```text
Two bold golden chevron arrows pointing right in front of a small round clock face, with speed lines trailing behind them and a few sparkles. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```
