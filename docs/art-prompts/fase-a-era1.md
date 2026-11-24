# Fase A: Era 1 jugable

Primer combate completo de la Era 1 (Squirmy, unidades y enemigos de la Era 1, Rexy, bases, proyectiles, iconos esenciales y fondo). Sin esto no hay nada que probar con arte real.

**58 prompts** (8 referencias de personaje, 40 hojas de animación, 10 imágenes o sprites estáticos). Antes de empezar lee `README.md` (convenciones, tamaños, qué hacer si la cuadrícula sale mal). Genera cada referencia primero y luego sus animaciones en el mismo chat de Gemini, adjuntando `<id>_ref.png`.

---
### A-001 · Squirmy (héroe): referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `squirmy`, Squirmy (héroe). Héroe del jugador (Home, batalla, resultado).
- **Referencia a adjuntar:** hoja oficial de personaje de Squirmy hecha por Alfredo (adjuntarla si la tienes; la gorra con la A y los colores deben salir idénticos)
- **Archivo de salida:** `squirmy_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia para sus 5 animaciones, paneles de historia, logo, icono de app y banner. No entra al juego.
- **Origen:** A01 (descripción de diseño)

```text
Squirmy, a small cheerful bright-green earthworm with a lighter yellow-green segmented belly, big round brown eyes with white highlights, soft peach-pink blushing cheeks, two small simple hands, a black baseball cap worn slightly tilted with a small stylized letter A on the front, and a friendly confident smile. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin dark-green ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### A-002 · Squirmy (héroe): idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy`, Squirmy (héroe). Héroe del jugador (Home, batalla, resultado).
- **Referencia a adjuntar:** `squirmy_ref.png`
- **Archivo de salida:** `squirmy_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `squirmy_idle_x2_sheet.png` (celda 768 px / hoja 3840x3840 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 384 px / hoja 1920x1920 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** A01, fila 1 (idle loop) (movimiento reescrito a mano)

```text
Using the attached reference image (squirmy_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'idle' animation.
Character identity, to stay consistent: Squirmy: small bright-green earthworm, lighter yellow-green belly, big round brown eyes, peach-pink cheeks, black baseball cap with a letter A.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A calm looping idle: Squirmy stands upright like a friendly question mark and breathes; he stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: Standing tall, the whole body slowly rises (inhale), the cap brim lifts a little.
- Frames 7-13: Highest point of the breath, then the body starts to sink (exhale); the right little hand gives a tiny wave around frames 9-12.
- Frames 14-19: Body at its lowest, a very small weight shift to one side, the cap brim bobs down.
- Frames 20-25: The eyes blink once (about 2 frames closed), the body rises back to exactly the pose of frame 1.
```

### A-003 · Squirmy (héroe): cast_slam (poder Squirm Slam)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy`, Squirmy (héroe). Héroe del jugador (Home, batalla, resultado).
- **Referencia a adjuntar:** `squirmy_ref.png`
- **Archivo de salida:** `squirmy_cast_slam_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `squirmy_cast_slam_sheet.png` (celda 384 px / hoja 1920x1920 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 768 px / hoja 3840x3840 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el cuerpo se estira hacia arriba y el golpe al suelo suelta chispas y grietas. Recomendado lienzo doble: celda 768 px, hoja 3840x3840 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** A01, fila 2 (casting Squirm Slam) (movimiento reescrito a mano)

```text
Using the attached reference image (squirmy_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'cast_slam' animation.
Character identity, to stay consistent: Squirmy: small bright-green earthworm, lighter yellow-green belly, big round brown eyes, peach-pink cheeks, black baseball cap with a letter A.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: Casting Squirm Slam: Squirmy coils like a spring, rises high and slams his front half into the ground. Key moment (impact) on frame 18. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: Anticipation: the head leans back, both hands rise beside the head.
- Frames 6-10: The body coils like a spring, the lower body compresses, the cap tilts back.
- Frames 11-15: The whole front half rises high and stretches upward (tallest pose at frame 15), hands up.
- Frames 16-20: The front half slams down toward the ground with the cap tipping forward; impact at frame 18 with golden sparks and a small crack in the ground.
- Frames 21-25: Golden sparks fade, the body unwinds and returns to the idle standing pose of the first frame.
```

### A-004 · Squirmy (héroe): cast_power (poder genérico)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy`, Squirmy (héroe). Héroe del jugador (Home, batalla, resultado).
- **Referencia a adjuntar:** `squirmy_ref.png`
- **Archivo de salida:** `squirmy_cast_power_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `squirmy_cast_power_sheet.png` (celda 384 px / hoja 1920x1920 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 768 px / hoja 3840x3840 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el remolino de luz dorada y turquesa con engranes crece alrededor del héroe. Recomendado lienzo doble: celda 768 px, hoja 3840x3840 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** A01, fila 3 (casting a generic power) (movimiento reescrito a mano)

```text
Using the attached reference image (squirmy_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'cast_power' animation.
Character identity, to stay consistent: Squirmy: small bright-green earthworm, lighter yellow-green belly, big round brown eyes, peach-pink cheeks, black baseball cap with a letter A.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: Casting a generic power: Squirmy calls on a swirl of golden and teal light. Key moment (light burst) on frame 17. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The head tilts up, he takes a breath, the little hands rise from his sides.
- Frames 6-10: Both hands stretch toward the sky with a determined open-mouth battle cry, the cap stays on.
- Frames 11-15: A swirl of golden and teal light with tiny gears grows around his body, getting bigger each frame.
- Frames 16-20: The swirl reaches its biggest size and bursts outward at frame 17 with a bright pulse, the body stays stretched up.
- Frames 21-25: The light and gears fade away, the hands lower, the body returns to the idle standing pose.
```

### A-005 · Squirmy (héroe): hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy`, Squirmy (héroe). Héroe del jugador (Home, batalla, resultado).
- **Referencia a adjuntar:** `squirmy_ref.png`
- **Archivo de salida:** `squirmy_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `squirmy_hurt_x2_sheet.png` (celda 768 px / hoja 3840x3840 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 384 px / hoja 1920x1920 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** A01, fila 4 (getting hurt) (movimiento reescrito a mano)

```text
Using the attached reference image (squirmy_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'hurt' animation.
Character identity, to stay consistent: Squirmy: small bright-green earthworm, lighter yellow-green belly, big round brown eyes, peach-pink cheeks, black baseball cap with a letter A.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: Getting hurt: a short flinch and a wobbling recovery; he stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-4: The hit lands: the body flinches backward sharply, the eyes squeeze shut, the cap tips down over one eye.
- Frames 5-10: The body leans back and wobbles, the little hands flail slightly.
- Frames 11-18: The body sways forward a little (smaller motion), the cap is pushed back up.
- Frames 19-25: He recovers to the idle standing pose with the eyes open again.
```

### A-006 · Squirmy (héroe): celebrate (celebrar)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy`, Squirmy (héroe). Héroe del jugador (Home, batalla, resultado).
- **Referencia a adjuntar:** `squirmy_ref.png`
- **Archivo de salida:** `squirmy_celebrate_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `squirmy_celebrate_sheet.png` (celda 384 px / hoja 1920x1920 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 768 px / hoja 3840x3840 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — hay un salto con giro y los brazos arriba. Recomendado lienzo doble: celda 768 px, hoja 3840x3840 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** A01, fila 5 (celebrating) (movimiento reescrito a mano)

```text
Using the attached reference image (squirmy_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'celebrate' animation.
Character identity, to stay consistent: Squirmy: small bright-green earthworm, lighter yellow-green belly, big round brown eyes, peach-pink cheeks, black baseball cap with a letter A.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: Celebrating: a happy jump with a fist pump, a spin and a cap tip. Key moment (top of the jump) around frame 12. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: Anticipation: the body crouches and squashes down, one fist gathers beside him.
- Frames 6-11: He bounces up into a happy jump, one fist pumped in the air, the cap stays on.
- Frames 12-17: At the top he does a small spin in the air, body stretched.
- Frames 18-22: He descends and lands with a squash, a cheerful bounce.
- Frames 23-25: He straightens and gives a tiny tip of the cap, ending in the idle standing pose.
```

### A-007 · Club Worm: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `p1_club_worm`, Club Worm. Luchador (fighter), cuerpo a cuerpo.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `p1_club_worm_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** B01 (descripción de diseño)

```text
A small golden-yellow earthworm soldier with a cream-colored segmented belly, big round dark eyes, a small blue cloth headband as team color, wearing a tiny brown animal-fur tunic and gripping a thick wooden club. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### A-008 · Club Worm: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p1_club_worm`, Club Worm. Luchador (fighter), cuerpo a cuerpo.
- **Referencia a adjuntar:** `p1_club_worm_ref.png`
- **Archivo de salida:** `p1_club_worm_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p1_club_worm_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B01, fila 1 (idle loop)

```text
Using the attached reference image (p1_club_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Club Worm performing the 'idle' animation.
Character identity, to stay consistent: Golden-yellow earthworm soldier, cream belly, blue cloth headband, brown fur tunic, thick wooden club.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the body gently rises and sinks, the club rests on the shoulder, the headband tails sway, and the eyes blink once.
```

### A-009 · Club Worm: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p1_club_worm`, Club Worm. Luchador (fighter), cuerpo a cuerpo.
- **Referencia a adjuntar:** `p1_club_worm_ref.png`
- **Archivo de salida:** `p1_club_worm_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p1_club_worm_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B01, fila 2 (walk loop)

```text
Using the attached reference image (p1_club_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Club Worm performing the 'walk' animation.
Character identity, to stay consistent: Golden-yellow earthworm soldier, cream belly, blue cloth headband, brown fur tunic, thick wooden club.
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
- Character details to keep throughout the loop: the worm moves like an inchworm, the body arches up in the middle and stretches forward again, the club bobs on the shoulder.
```

### A-010 · Club Worm: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p1_club_worm`, Club Worm. Luchador (fighter), cuerpo a cuerpo.
- **Referencia a adjuntar:** `p1_club_worm_ref.png`
- **Archivo de salida:** `p1_club_worm_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p1_club_worm_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B01, fila 3 (attack)

```text
Using the attached reference image (p1_club_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Club Worm performing the 'attack' animation.
Character identity, to stay consistent: Golden-yellow earthworm soldier, cream belly, blue cloth headband, brown fur tunic, thick wooden club.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Fighter, melee. A heavy overhead club smash: the club lands on the ground just in front of the worm at the key moment.
Motion by frames:
- Frames 1-6: The body shifts its weight backward and the head leans back; the club lifts off the shoulder and rises behind the head, both little hands gripping it.
- Frames 7-11: The body coils back like a spring, the tail end tightens, the club reaches its highest point behind the head and the face turns into a determined grin.
- Frames 12-15: The front of the body whips forward and the club swings down in a fast arc, hitting the ground just in front of the worm on frame 13 with a small puff of dust.
- Frames 16-19: The club rests low on the ground after the hit, the body is stretched forward, the headband tails whip forward.
- Frames 20-25: The body pulls back upright, the club returns to the shoulder, the headband tails settle and the pose of frame 25 matches the idle.
```

### A-011 · Club Worm: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p1_club_worm`, Club Worm. Luchador (fighter), cuerpo a cuerpo.
- **Referencia a adjuntar:** `p1_club_worm_ref.png`
- **Archivo de salida:** `p1_club_worm_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p1_club_worm_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B01, fila 4 (hurt)

```text
Using the attached reference image (p1_club_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Club Worm performing the 'hurt' animation.
Character identity, to stay consistent: Golden-yellow earthworm soldier, cream belly, blue cloth headband, brown fur tunic, thick wooden club.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body flinches backward.
- Frames 6-18: The eyes squeeze shut, the club drops low, the headband flies forward.
- Frames 19-25: The worm recovers.
```

### A-012 · Club Worm: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p1_club_worm`, Club Worm. Luchador (fighter), cuerpo a cuerpo.
- **Referencia a adjuntar:** `p1_club_worm_ref.png`
- **Archivo de salida:** `p1_club_worm_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p1_club_worm_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B01, fila 5 (defeat)

```text
Using the attached reference image (p1_club_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Club Worm performing the 'defeat' animation.
Character identity, to stay consistent: Golden-yellow earthworm soldier, cream belly, blue cloth headband, brown fur tunic, thick wooden club.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The body wobbles.
- Frames 9-20: The Club Worm droops, slides down flat to the ground with the club falling beside him.
- Frames 21-25: The Club Worm ends lying still with tiny stars above his head. Hold this final pose still until frame 25.
```

### A-013 · Ant Clubber: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `e1_ant_clubber`, Ant Clubber. Luchador (fighter), ataca al más cercano.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `e1_ant_clubber_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** C01 (descripción de diseño)

```text
A small black ant warrior with big round eyes and a comically angry snarl, a red cloth band tied around its head as team color, wearing a rough leather loincloth and carrying a heavy stone club. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the left, facing left, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### A-014 · Ant Clubber: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e1_ant_clubber`, Ant Clubber. Luchador (fighter), ataca al más cercano.
- **Referencia a adjuntar:** `e1_ant_clubber_ref.png`
- **Archivo de salida:** `e1_ant_clubber_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e1_ant_clubber_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C01, fila 1 (idle loop)

```text
Using the attached reference image (e1_ant_clubber_ref.png) as the exact design of the character, draw an animation sprite sheet of Ant Clubber performing the 'idle' animation.
Character identity, to stay consistent: Small black ant warrior, red cloth band on the head, angry snarl, leather loincloth, heavy stone club.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the body bobs up and down, the antennae twitch, the club rests on the shoulder, and the eyes blink once.
```

### A-015 · Ant Clubber: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e1_ant_clubber`, Ant Clubber. Luchador (fighter), ataca al más cercano.
- **Referencia a adjuntar:** `e1_ant_clubber_ref.png`
- **Archivo de salida:** `e1_ant_clubber_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e1_ant_clubber_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C01, fila 2 (walk loop)

```text
Using the attached reference image (e1_ant_clubber_ref.png) as the exact design of the character, draw an animation sprite sheet of Ant Clubber performing the 'walk' animation.
Character identity, to stay consistent: Small black ant warrior, red cloth band on the head, angry snarl, leather loincloth, heavy stone club.
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
- Character details to keep throughout the loop: the six legs step in alternating pairs, the body bobs, the club bounces on the shoulder.
```

### A-016 · Ant Clubber: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e1_ant_clubber`, Ant Clubber. Luchador (fighter), ataca al más cercano.
- **Referencia a adjuntar:** `e1_ant_clubber_ref.png`
- **Archivo de salida:** `e1_ant_clubber_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e1_ant_clubber_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C01, fila 3 (attack)

```text
Using the attached reference image (e1_ant_clubber_ref.png) as the exact design of the character, draw an animation sprite sheet of Ant Clubber performing the 'attack' animation.
Character identity, to stay consistent: Small black ant warrior, red cloth band on the head, angry snarl, leather loincloth, heavy stone club.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Rushes the nearest unit. A furious overhead stone-club smash with a snarl.
Motion by frames:
- Frames 1-6: The ant rears up on its hind legs and leans back, the stone club lifts off the shoulder with both front legs gripping it.
- Frames 7-11: The club reaches its highest point over the head, the body leans far back, the mandibles open in a snarl.
- Frames 12-15: The club swings down and forward in a heavy arc on frame 13, smashing the ground in front of the ant with a dust puff.
- Frames 16-19: The ant is bent forward with the club low on the ground, the antennae whip forward.
- Frames 20-25: The club is hauled back to the shoulder, the ant drops back onto all its legs and the pose matches the idle.
```

### A-017 · Ant Clubber: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e1_ant_clubber`, Ant Clubber. Luchador (fighter), ataca al más cercano.
- **Referencia a adjuntar:** `e1_ant_clubber_ref.png`
- **Archivo de salida:** `e1_ant_clubber_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e1_ant_clubber_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C01, fila 4 (hurt)

```text
Using the attached reference image (e1_ant_clubber_ref.png) as the exact design of the character, draw an animation sprite sheet of Ant Clubber performing the 'hurt' animation.
Character identity, to stay consistent: Small black ant warrior, red cloth band on the head, angry snarl, leather loincloth, heavy stone club.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body flinches backward.
- Frames 6-18: The eyes squeeze shut, the antennae flatten, the club slips.
- Frames 19-25: The ant recovers.
```

### A-018 · Ant Clubber: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e1_ant_clubber`, Ant Clubber. Luchador (fighter), ataca al más cercano.
- **Referencia a adjuntar:** `e1_ant_clubber_ref.png`
- **Archivo de salida:** `e1_ant_clubber_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e1_ant_clubber_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C01, fila 5 (defeat)

```text
Using the attached reference image (e1_ant_clubber_ref.png) as the exact design of the character, draw an animation sprite sheet of Ant Clubber performing the 'defeat' animation.
Character identity, to stay consistent: Small black ant warrior, red cloth band on the head, angry snarl, leather loincloth, heavy stone club.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-20: The legs wobble, the ant flips onto its back with the legs curled up and the club falling beside it.
- Frames 21-25: The Ant Clubber ends still with tiny stars above. Hold this final pose still until frame 25.
```

### A-019 · Fondo de batalla, Era 1 (Edad de Piedra)
- **Tipo:** Imagen final (se usa tal cual)
- **Descripción de la imagen:** Valle prehistórico soleado con helechos gigantes, volcán lejano y camino de tierra horizontal al 55-62% de la altura; luz de mañana.
- **Tamaño / proporción:** 9:16 vertical, 1080x1920 px (si Gemini devuelve otra proporción, recortar a 9:16)
- **Datos técnicos:** imagen completa sin fondo recortable; sin texto, logos ni interfaz
- **Dónde se usa:** Fondo de la pantalla de batalla (`BattleBackground`, src/battle/battle_background.gd) en las etapas de la Era 1 y el jefe Rexy; sustituye las capas de color. El carril de combate cae a ~58% de la altura (lane_y 557 de 960).
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `bg_era1.png`
- **Origen:** H01

```text
A sunny prehistoric jungle valley with giant ferns, tall palm-like trees, a smoking volcano far in the distance, a calm blue sky with soft clouds, a few gentle dinosaur silhouettes very far away and a flat packed-dirt path running horizontally across the middle of the image, warm morning light. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. Tall 9:16 portrait image with no characters, no text, no logos and no UI. Place the horizontal path at about 55 to 62 percent of the image height, keep the top 12 percent calm for the game HUD, and keep the bottom 30 percent calm and low-contrast so game buttons stay readable.
```

### A-020 · Base del jugador, Era 1 (madriguera)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Madriguera prehistórica: montículo de tierra con entrada redonda, techo de hojas, valla de huesos, fogata, helechos y bandera azul.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline recorta y deja 512 px de ancho)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Base del jugador al extremo izquierdo del carril de batalla (`BaseView`, barra de vida encima) y madriguera de la pantalla Home (home_screen.gd, hoy un rectángulo 210x170).
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `base_p1.png`
- **Origen:** E01

```text
A cozy prehistoric worm burrow base: a big round dirt mound with a dark round hole as the entrance, a thatched leaf roof on top, a small bone fence, a little campfire, big green ferns at its sides and a small blue cloth flag on a wooden stick. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing right, centered with a wide empty margin, with only a small patch of ground directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### A-021 · Base enemiga, Era 1 (hormiguero)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Hormiguero fortaleza marrón con túnel oscuro, pinchos de madera y hueso, marcas tribales y bandera roja; mira a la izquierda.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline recorta y deja 512 px de ancho)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Base enemiga al extremo derecho del carril de batalla (`BaseView`), mirando a la izquierda.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `base_e1.png`
- **Origen:** E06

```text
A tall brown anthill fortress with a dark tunnel entrance, sharp wooden and bone spikes around it, simple tribal paint marks on the dirt and a red cloth flag on a bone pole at the top. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing left, centered with a wide empty margin, with only a small patch of ground directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### A-022 · Icono de moneda
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Moneda dorada brillante con una carita de gusano sonriente grabada.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Chip de monedas de la barra superior (todas las pantallas), recompensa de la pantalla de Victoria y precios de Upgrades.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_coin.png`
- **Origen:** G01

```text
A shiny round gold coin with a tiny smiling worm face embossed in the center, a raised rim and a small white sparkle on one edge. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### A-023 · Icono de comida (manzana)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Manzana roja jugosa con hoja verde y un pequeño mordisco.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** HUD de batalla: contador de comida y coste de cada tarjeta de unidad.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_food.png`
- **Origen:** G02

```text
A shiny juicy red apple with a short brown stem, one green leaf and a tiny bite mark on one side, with a small white highlight. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### A-024 · Efecto de impacto
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Estallido de impacto estilo cómic con centro amarillo, anillo naranja y chispas blancas.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Efecto que aparece donde un golpe o proyectil impacta (src/battle/battle_effects.gd).
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `fx_impact.png`
- **Origen:** F06

```text
A single comic-style impact burst shaped like a rounded starburst with a bright yellow center, an orange outer ring and a few small white sparks flying outward. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single small object, front view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### A-025 · Proyectil: piedra
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Piedra gris redonda con grietas y una pequeña estela de movimiento.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Proyectil del Slinger Worm (Era 1) en el carril de batalla.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `proj_stone.png`
- **Origen:** F01

```text
A single round gray stone with a few small cracks and a tiny motion swoosh behind it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single small object, side view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### A-026 · Icono de poder: Squirm Slam
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Cabeza naranja de gusano estrellándose contra el suelo con onda expansiva, grietas y tierra volando.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Botón de poder del HUD de batalla y selector de poderes en Pre-batalla/Upgrades (poder inicial, ya desbloqueado).
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `power_squirm_slam.png`
- **Origen:** G06

```text
The round orange head of a cute worm slamming into the ground with a big starburst shockwave, cracks spreading in the dirt and small chunks of earth flying up. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### A-027 · Icono de poder: Apple Rain
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Tres manzanas rojas con hojas cayendo en diagonal con líneas de movimiento.
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Botón de poder del HUD de batalla y selector de Pre-batalla/Upgrades (poder inicial, ya desbloqueado).
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `power_apple_rain.png`
- **Origen:** G07

```text
Three shiny red apples with green leaves falling diagonally from the top with small motion lines and tiny sparkles. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### A-028 · Slinger Worm: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `p1_slinger_worm`, Slinger Worm. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `p1_slinger_worm_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** B02 (descripción de diseño)

```text
A small golden-yellow earthworm soldier with a cream-colored segmented belly, big round dark eyes, a small blue cloth headband as team color, wearing a tiny brown animal-fur tunic and holding a leather sling with a round gray stone. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### A-029 · Slinger Worm: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p1_slinger_worm`, Slinger Worm. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** `p1_slinger_worm_ref.png`
- **Archivo de salida:** `p1_slinger_worm_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p1_slinger_worm_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B02, fila 1 (idle loop)

```text
Using the attached reference image (p1_slinger_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Slinger Worm performing the 'idle' animation.
Character identity, to stay consistent: Golden-yellow earthworm soldier, cream belly, blue cloth headband, brown fur tunic, leather sling with a round gray stone.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the body gently rises and sinks, the sling swings a little in the hand, and the eyes blink once.
```

### A-030 · Slinger Worm: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p1_slinger_worm`, Slinger Worm. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** `p1_slinger_worm_ref.png`
- **Archivo de salida:** `p1_slinger_worm_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p1_slinger_worm_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B02, fila 2 (walk loop)

```text
Using the attached reference image (p1_slinger_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Slinger Worm performing the 'walk' animation.
Character identity, to stay consistent: Golden-yellow earthworm soldier, cream belly, blue cloth headband, brown fur tunic, leather sling with a round gray stone.
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
- Character details to keep throughout the loop: the worm moves like an inchworm, arching up in the middle and stretching forward, the sling bouncing at his side.
```

### A-031 · Slinger Worm: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p1_slinger_worm`, Slinger Worm. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** `p1_slinger_worm_ref.png`
- **Archivo de salida:** `p1_slinger_worm_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p1_slinger_worm_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B02, fila 3 (attack)

```text
Using the attached reference image (p1_slinger_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Slinger Worm performing the 'attack' animation.
Character identity, to stay consistent: Golden-yellow earthworm soldier, cream belly, blue cloth headband, brown fur tunic, leather sling with a round gray stone.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Shooter. The stone leaves the sling at the key moment and the hand ends empty. Do NOT draw the stone flying away: the game spawns it as a separate projectile sprite.
Motion by frames:
- Frames 1-6: One eye squints to aim; the arm with the sling lifts above the head and the stone rests in the leather pouch.
- Frames 7-11: The sling spins in fast circles above the head (the loop is drawn in 3 or 4 distinct positions), the body leans slightly back for balance.
- Frames 12-15: The arm snaps forward in a whip and the stone leaves the sling on frame 13 (draw the arm fully extended and the empty open sling; no stone in flight).
- Frames 16-19: The arm follows through across the body, the sling swings loosely forward, the body leans forward from the effort.
- Frames 20-25: The arm returns down, the body relaxes and straightens, the empty sling hangs at the side, ready for idle.
```

### A-032 · Slinger Worm: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p1_slinger_worm`, Slinger Worm. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** `p1_slinger_worm_ref.png`
- **Archivo de salida:** `p1_slinger_worm_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p1_slinger_worm_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B02, fila 4 (hurt)

```text
Using the attached reference image (p1_slinger_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Slinger Worm performing the 'hurt' animation.
Character identity, to stay consistent: Golden-yellow earthworm soldier, cream belly, blue cloth headband, brown fur tunic, leather sling with a round gray stone.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body flinches backward.
- Frames 6-18: The eyes squeeze shut, the sling tangles around the hand.
- Frames 19-25: The worm recovers.
```

### A-033 · Slinger Worm: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p1_slinger_worm`, Slinger Worm. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** `p1_slinger_worm_ref.png`
- **Archivo de salida:** `p1_slinger_worm_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p1_slinger_worm_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B02, fila 5 (defeat)

```text
Using the attached reference image (p1_slinger_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Slinger Worm performing the 'defeat' animation.
Character identity, to stay consistent: Golden-yellow earthworm soldier, cream belly, blue cloth headband, brown fur tunic, leather sling with a round gray stone.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The body wobbles.
- Frames 9-20: The Slinger Worm droops, slides down flat to the ground with the sling falling beside him.
- Frames 21-25: The Slinger Worm ends lying still with tiny stars above his head. Hold this final pose still until frame 25.
```

### A-034 · Ant Spitter: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `e1_ant_spitter`, Ant Spitter. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `e1_ant_spitter_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** C02 (descripción de diseño)

```text
A small black ant with big round eyes and puffed cheeks, a red cloth band tied around its head as team color, holding a long bone blowpipe to its mouth with a glowing drop of green acid at the tip. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the left, facing left, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### A-035 · Ant Spitter: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e1_ant_spitter`, Ant Spitter. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** `e1_ant_spitter_ref.png`
- **Archivo de salida:** `e1_ant_spitter_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e1_ant_spitter_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C02, fila 1 (idle loop)

```text
Using the attached reference image (e1_ant_spitter_ref.png) as the exact design of the character, draw an animation sprite sheet of Ant Spitter performing the 'idle' animation.
Character identity, to stay consistent: Small black ant, red cloth band on the head, puffed cheeks, long bone blowpipe with a glowing green acid drop at the tip.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the body bobs up and down, the antennae twitch, the green drop wobbles at the tip of the blowpipe, and the eyes blink once.
```

### A-036 · Ant Spitter: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e1_ant_spitter`, Ant Spitter. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** `e1_ant_spitter_ref.png`
- **Archivo de salida:** `e1_ant_spitter_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e1_ant_spitter_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C02, fila 2 (walk loop)

```text
Using the attached reference image (e1_ant_spitter_ref.png) as the exact design of the character, draw an animation sprite sheet of Ant Spitter performing the 'walk' animation.
Character identity, to stay consistent: Small black ant, red cloth band on the head, puffed cheeks, long bone blowpipe with a glowing green acid drop at the tip.
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
- Character details to keep throughout the loop: the six legs step in alternating pairs with the blowpipe held at the side.
```

### A-037 · Ant Spitter: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e1_ant_spitter`, Ant Spitter. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** `e1_ant_spitter_ref.png`
- **Archivo de salida:** `e1_ant_spitter_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e1_ant_spitter_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C02, fila 3 (attack)

```text
Using the attached reference image (e1_ant_spitter_ref.png) as the exact design of the character, draw an animation sprite sheet of Ant Spitter performing the 'attack' animation.
Character identity, to stay consistent: Small black ant, red cloth band on the head, puffed cheeks, long bone blowpipe with a glowing green acid drop at the tip.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Ranged. Cheeks puff, the blowpipe lifts, and an acid glob is spat at the key moment. Do NOT draw the glob in flight (separate projectile).
Motion by frames:
- Frames 1-6: The ant rears up on its hind legs and the blowpipe lifts toward its mouth; the green drop at the tip grows.
- Frames 7-11: The cheeks puff up like balloons, the body leans back, the antennae stand up.
- Frames 12-15: The cheeks deflate in one blast on frame 13 and the green acid glob is spat out of the blowpipe (draw only the burst at the tip, no glob in flight); the ant recoils backward.
- Frames 16-19: The ant's body bends from the recoil, the blowpipe shakes, a thin green drip hangs at its tip.
- Frames 20-25: The blowpipe lowers to the side, the cheeks return to normal, the ant drops back onto all its legs and the pose matches the idle.
```

### A-038 · Ant Spitter: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e1_ant_spitter`, Ant Spitter. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** `e1_ant_spitter_ref.png`
- **Archivo de salida:** `e1_ant_spitter_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e1_ant_spitter_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C02, fila 4 (hurt)

```text
Using the attached reference image (e1_ant_spitter_ref.png) as the exact design of the character, draw an animation sprite sheet of Ant Spitter performing the 'hurt' animation.
Character identity, to stay consistent: Small black ant, red cloth band on the head, puffed cheeks, long bone blowpipe with a glowing green acid drop at the tip.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the body flinches backward.
- Frames 6-18: The blowpipe jerks, the cheeks deflate with a squeak.
- Frames 19-25: The ant recovers.
```

### A-039 · Ant Spitter: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e1_ant_spitter`, Ant Spitter. Tirador (shooter), a distancia.
- **Referencia a adjuntar:** `e1_ant_spitter_ref.png`
- **Archivo de salida:** `e1_ant_spitter_defeat_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e1_ant_spitter_defeat_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C02, fila 5 (defeat)

```text
Using the attached reference image (e1_ant_spitter_ref.png) as the exact design of the character, draw an animation sprite sheet of Ant Spitter performing the 'defeat' animation.
Character identity, to stay consistent: Small black ant, red cloth band on the head, puffed cheeks, long bone blowpipe with a glowing green acid drop at the tip.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-20: The legs wobble, the ant flips onto its back with the blowpipe falling beside it.
- Frames 21-25: The Ant Spitter ends still with tiny stars above. Hold this final pose still until frame 25.
```

### A-040 · Proyectil: gota de ácido
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Gota verde de ácido brillante con dos goteos detrás; apunta a la izquierda. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Proyectil del Ant Spitter (Era 1). NUEVO: el original no lo traía; se añade porque el ataque del Ant Spitter lanza una gota que no se dibuja en su hoja.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `proj_acid.png`
- **Origen:** nuevo (no estaba en el original)

```text
A single glowing green acid glob shaped like a rounded teardrop with a shiny white highlight and two tiny drips trailing behind it, pointing left. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single small object, side view pointing left, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
```

### A-041 · Dino Rider Worm: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `p1_dino_rider_worm`, Dino Rider Worm. Pesado (heavy), montura.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `p1_dino_rider_worm_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** B03 (descripción de diseño)

```text
A small golden-yellow earthworm rider with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, riding on the back of a chubby friendly baby triceratops with a green body, three small horns and a tan frill, holding a short bone lance. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing on its four legs in a relaxed neutral pose, rider upright, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### A-042 · Dino Rider Worm: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p1_dino_rider_worm`, Dino Rider Worm. Pesado (heavy), montura.
- **Referencia a adjuntar:** `p1_dino_rider_worm_ref.png`
- **Archivo de salida:** `p1_dino_rider_worm_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p1_dino_rider_worm_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B03, fila 1 (idle loop)

```text
Using the attached reference image (p1_dino_rider_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Dino Rider Worm performing the 'idle' animation.
Character identity, to stay consistent: Golden-yellow worm rider with blue headband on a chubby green baby triceratops with three small horns and a tan frill, holding a short bone lance.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the dinosaur breathes with its sides rising and falling and its tail swaying, the rider rocks slightly and blinks once.
```

### A-043 · Dino Rider Worm: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p1_dino_rider_worm`, Dino Rider Worm. Pesado (heavy), montura.
- **Referencia a adjuntar:** `p1_dino_rider_worm_ref.png`
- **Archivo de salida:** `p1_dino_rider_worm_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p1_dino_rider_worm_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B03, fila 2 (walk loop)

```text
Using the attached reference image (p1_dino_rider_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Dino Rider Worm performing the 'walk' animation.
Character identity, to stay consistent: Golden-yellow worm rider with blue headband on a chubby green baby triceratops with three small horns and a tan frill, holding a short bone lance.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (walk): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The front-left and rear-right legs lift and step while the body leans forward.
- Frames 7-12: Both stepping feet plant with a heavy bounce, the body sinks and the rider bounces down.
- Frames 13-19: The front-right and rear-left legs lift and step, the body rises.
- Frames 20-25: Both feet plant and the body returns to the pose of frame 1.
- Character details to keep throughout the loop: the dinosaur stomps with alternating legs, the body bobbing up and down, the rider bouncing on its back and the lance tip bobbing.
```

### A-044 · Dino Rider Worm: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p1_dino_rider_worm`, Dino Rider Worm. Pesado (heavy), montura.
- **Referencia a adjuntar:** `p1_dino_rider_worm_ref.png`
- **Archivo de salida:** `p1_dino_rider_worm_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p1_dino_rider_worm_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B03, fila 3 (attack)

```text
Using the attached reference image (p1_dino_rider_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Dino Rider Worm performing the 'attack' animation.
Character identity, to stay consistent: Golden-yellow worm rider with blue headband on a chubby green baby triceratops with three small horns and a tan frill, holding a short bone lance.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Heavy mount. The triceratops lowers its head and lunges forward while the rider levels and thrusts the bone lance; the whole group shifts forward and back.
Motion by frames:
- Frames 1-6: The triceratops steps back slightly and lowers its head so the horns point forward; the rider crouches low on its back and brings the bone lance back.
- Frames 7-11: The dinosaur's haunches sink like a spring and its tail lifts for balance; the rider's lance is pulled to the back of its hand.
- Frames 12-15: The dinosaur lunges forward with its horns low and the rider thrusts the lance straight ahead; the point of the lance and the horns meet the target on frame 13, with dust kicked up under the feet.
- Frames 16-19: The dinosaur's momentum carries it a little further forward, head still low, the rider leaning with the lance extended.
- Frames 20-25: Both settle back: the dinosaur lifts its head and steps back to its standing line, the rider straightens and lowers the lance.
```

### A-045 · Dino Rider Worm: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p1_dino_rider_worm`, Dino Rider Worm. Pesado (heavy), montura.
- **Referencia a adjuntar:** `p1_dino_rider_worm_ref.png`
- **Archivo de salida:** `p1_dino_rider_worm_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `p1_dino_rider_worm_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** B03, fila 4 (hurt)

```text
Using the attached reference image (p1_dino_rider_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Dino Rider Worm performing the 'hurt' animation.
Character identity, to stay consistent: Golden-yellow worm rider with blue headband on a chubby green baby triceratops with three small horns and a tan frill, holding a short bone lance.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-18: The hit lands: the dinosaur rears back with a surprised face, the rider tilts backward and the lance wobbles.
- Frames 19-25: Both recover.
```

### A-046 · Dino Rider Worm: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `p1_dino_rider_worm`, Dino Rider Worm. Pesado (heavy), montura.
- **Referencia a adjuntar:** `p1_dino_rider_worm_ref.png`
- **Archivo de salida:** `p1_dino_rider_worm_defeat_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `p1_dino_rider_worm_defeat_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — caída o desarme con piezas, humo o chispas que se salen del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** B03, fila 5 (defeat)

```text
Using the attached reference image (p1_dino_rider_worm_ref.png) as the exact design of the character, draw an animation sprite sheet of Dino Rider Worm performing the 'defeat' animation.
Character identity, to stay consistent: Golden-yellow worm rider with blue headband on a chubby green baby triceratops with three small horns and a tan frill, holding a short bone lance.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-20: The dinosaur sits down with its legs folding, the rider slides off its back.
- Frames 21-25: Both end lying still with tiny stars above their heads. Hold this final pose still until frame 25.
```

### A-047 · Stone Beetle: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `e1_stone_beetle`, Stone Beetle. Pesado (heavy), lento (velocidad 40).
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `e1_stone_beetle_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** C03 (descripción de diseño)

```text
A chunky brown beetle with a thick shell made of gray rock slabs with patches of green moss, small grumpy eyes, and a red cloth band tied around one horn as team color. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the left, facing left, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### A-048 · Stone Beetle: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e1_stone_beetle`, Stone Beetle. Pesado (heavy), lento (velocidad 40).
- **Referencia a adjuntar:** `e1_stone_beetle_ref.png`
- **Archivo de salida:** `e1_stone_beetle_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e1_stone_beetle_idle_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C03, fila 1 (idle loop)

```text
Using the attached reference image (e1_stone_beetle_ref.png) as the exact design of the character, draw an animation sprite sheet of Stone Beetle performing the 'idle' animation.
Character identity, to stay consistent: Chunky brown beetle with a thick gray rock-slab shell with green moss, small grumpy eyes, red cloth band on one horn.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the heavy shell rises and sinks as it breathes, the horn tilts, and the eyes blink once.
```

### A-049 · Stone Beetle: walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e1_stone_beetle`, Stone Beetle. Pesado (heavy), lento (velocidad 40).
- **Referencia a adjuntar:** `e1_stone_beetle_ref.png`
- **Archivo de salida:** `e1_stone_beetle_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e1_stone_beetle_walk_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C03, fila 2 (walk loop)

```text
Using the attached reference image (e1_stone_beetle_ref.png) as the exact design of the character, draw an animation sprite sheet of Stone Beetle performing the 'walk' animation.
Character identity, to stay consistent: Chunky brown beetle with a thick gray rock-slab shell with green moss, small grumpy eyes, red cloth band on one horn.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (walk): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The left foot lifts and the heavy body leans onto the right side.
- Frames 7-12: The left foot stomps down: the body drops and bounces, a small dust puff.
- Frames 13-19: The right foot lifts and the body leans onto the left side.
- Frames 20-25: The right foot stomps down and the body returns to the pose of frame 1.
- Character details to keep throughout the loop: the short legs stomp slowly one after another and the shell rocks side to side like a walking boulder.
```

### A-050 · Stone Beetle: attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e1_stone_beetle`, Stone Beetle. Pesado (heavy), lento (velocidad 40).
- **Referencia a adjuntar:** `e1_stone_beetle_ref.png`
- **Archivo de salida:** `e1_stone_beetle_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e1_stone_beetle_attack_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — golpe, proyectil, destello o efecto que se extiende fuera del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C03, fila 3 (attack)

```text
Using the attached reference image (e1_stone_beetle_ref.png) as the exact design of the character, draw an animation sprite sheet of Stone Beetle performing the 'attack' animation.
Character identity, to stay consistent: Chunky brown beetle with a thick gray rock-slab shell with green moss, small grumpy eyes, red cloth band on one horn.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Slow tank. A long slow wind-up (rears back, lowers the horn), then a heavy ram with a dust puff at impact.
Motion by frames:
- Frames 1-6: The beetle shifts its weight backward on its heavy legs and starts to lower its head; moss patches on the shell tilt.
- Frames 7-11: A long, slow wind-up: it rears back with the front legs off the ground, the horn lowered and pointing forward, the shell creaking.
- Frames 12-15: It drops and rams forward on frame 13: the horn hits low and forward with a heavy thud and a dust puff, the shell slabs rattle.
- Frames 16-19: The momentum drags the beetle forward a little with the horn still low, small pebbles bounce off the shell.
- Frames 20-25: It slowly pulls back, lifts its head and settles onto its standing line; the pose matches the idle.
```

### A-051 · Stone Beetle: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e1_stone_beetle`, Stone Beetle. Pesado (heavy), lento (velocidad 40).
- **Referencia a adjuntar:** `e1_stone_beetle_ref.png`
- **Archivo de salida:** `e1_stone_beetle_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `e1_stone_beetle_hurt_x2_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 256 px / hoja 1280x1280 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** C03, fila 4 (hurt)

```text
Using the attached reference image (e1_stone_beetle_ref.png) as the exact design of the character, draw an animation sprite sheet of Stone Beetle performing the 'hurt' animation.
Character identity, to stay consistent: Chunky brown beetle with a thick gray rock-slab shell with green moss, small grumpy eyes, red cloth band on one horn.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the shell cracks with a small dust puff.
- Frames 6-18: The body is knocked back, the eyes squeeze shut.
- Frames 19-25: It recovers.
```

### A-052 · Stone Beetle: defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `e1_stone_beetle`, Stone Beetle. Pesado (heavy), lento (velocidad 40).
- **Referencia a adjuntar:** `e1_stone_beetle_ref.png`
- **Archivo de salida:** `e1_stone_beetle_defeat_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `e1_stone_beetle_defeat_sheet.png` (celda 256 px / hoja 1280x1280 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — caída o desarme con piezas, humo o chispas que se salen del cuerpo. Recomendado lienzo doble: celda 512 px, hoja 2560x2560 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** C03, fila 5 (defeat)

```text
Using the attached reference image (e1_stone_beetle_ref.png) as the exact design of the character, draw an animation sprite sheet of Stone Beetle performing the 'defeat' animation.
Character identity, to stay consistent: Chunky brown beetle with a thick gray rock-slab shell with green moss, small grumpy eyes, red cloth band on one horn.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The legs give way.
- Frames 9-20: The body drops, the shell breaks into slabs.
- Frames 21-25: It ends flat on the ground with tiny stars above. Hold this final pose still until frame 25.
```

### A-053 · Rexy the T-Rex (jefe Era 1): referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `b1_rexy`, Rexy the T-Rex (jefe Era 1). Jefe pesado; telegrafía pisotón (aturde 1 s), fase 2 rugido.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `b1_rexy_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la izquierda; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.
- **Origen:** D01 (descripción de diseño)

```text
Rexy, a big chubby green T-Rex with a cream belly, comically tiny arms, a huge goofy toothy grin and small round eyes, a red cloth bandana tied around his neck and a necklace of colorful stones. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the left, facing left, filling most of the frame, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### A-054 · Rexy the T-Rex (jefe Era 1): idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b1_rexy`, Rexy the T-Rex (jefe Era 1). Jefe pesado; telegrafía pisotón (aturde 1 s), fase 2 rugido.
- **Referencia a adjuntar:** `b1_rexy_ref.png`
- **Archivo de salida:** `b1_rexy_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `b1_rexy_idle_x2_sheet.png` (celda 1024 px / hoja 5120x5120 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido en el cuerpo del jefe (que ya llena la celda). Lienzo normal.
- **Origen:** D01, fila 1 (idle loop)

```text
Using the attached reference image (b1_rexy_ref.png) as the exact design of the character, draw an animation sprite sheet of Rexy the T-Rex performing the 'idle' animation.
Character identity, to stay consistent: Rexy: big chubby green T-Rex, cream belly, comically tiny arms, huge goofy toothy grin, red bandana, necklace of colorful stones.
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
- Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): the belly rises and sinks as he breathes, the tail sways, the tiny arms twitch, and the eyes blink once.
```

### A-055 · Rexy the T-Rex (jefe Era 1): walk (desplazamiento)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b1_rexy`, Rexy the T-Rex (jefe Era 1). Jefe pesado; telegrafía pisotón (aturde 1 s), fase 2 rugido.
- **Referencia a adjuntar:** `b1_rexy_ref.png`
- **Archivo de salida:** `b1_rexy_walk_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `b1_rexy_walk_x2_sheet.png` (celda 1024 px / hoja 5120x5120 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido en el cuerpo del jefe (que ya llena la celda). Lienzo normal.
- **Origen:** D01, fila 2 (walk loop)

```text
Using the attached reference image (b1_rexy_ref.png) as the exact design of the character, draw an animation sprite sheet of Rexy the T-Rex performing the 'walk' animation.
Character identity, to stay consistent: Rexy: big chubby green T-Rex, cream belly, comically tiny arms, huge goofy toothy grin, red bandana, necklace of colorful stones.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A looping move cycle (walk): it stays in place inside the cell (no travel across the cell, the game moves the sprite). It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: The left foot lifts and the heavy body leans onto the right side.
- Frames 7-12: The left foot stomps down: the body drops and bounces, a small dust puff.
- Frames 13-19: The right foot lifts and the body leans onto the left side.
- Frames 20-25: The right foot stomps down and the body returns to the pose of frame 1.
- Character details to keep throughout the loop: heavy stomps with alternating legs, the body bobbing, the tail swinging and the necklace bouncing.
```

### A-056 · Rexy the T-Rex (jefe Era 1): attack (ataque)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b1_rexy`, Rexy the T-Rex (jefe Era 1). Jefe pesado; telegrafía pisotón (aturde 1 s), fase 2 rugido.
- **Referencia a adjuntar:** `b1_rexy_ref.png`
- **Archivo de salida:** `b1_rexy_attack_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `b1_rexy_attack_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 1024 px / hoja 5120x5120 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el golpe/aliento/ráfaga del jefe llega muy lejos del cuerpo. Recomendado lienzo doble: celda 1024 px, hoja 5120x5120 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** D01, fila 3 (attack)

```text
Using the attached reference image (b1_rexy_ref.png) as the exact design of the character, draw an animation sprite sheet of Rexy the T-Rex performing the 'attack' animation.
Character identity, to stay consistent: Rexy: big chubby green T-Rex, cream belly, comically tiny arms, huge goofy toothy grin, red bandana, necklace of colorful stones.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Specific to this character: Boss. He rears back, takes a big breath and lunges with a roaring chomp; one heavy foot stamps once as he lunges (stomp feel). The game draws its stomp shockwave separately.
Motion by frames:
- Frames 1-6: Rexy lifts his head and takes a big breath, the chest swelling; one heavy foot lifts off the ground and the tiny arms curl in.
- Frames 7-11: The head rears far back and up, the mouth closes tight and the body coils backward, the tail swings the other way for balance.
- Frames 12-15: The foot stomps hard and the whole body lunges forward as the head snaps down and the jaws chomp with a loud roar on frame 13; a ring of dust bursts around the foot.
- Frames 16-19: The head stays low and forward with the jaws open mid-roar, the tail swings back and the necklace bounces.
- Frames 20-25: He straightens slowly, closes the mouth into the goofy grin and the pose matches the idle.
```

### A-057 · Rexy the T-Rex (jefe Era 1): hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b1_rexy`, Rexy the T-Rex (jefe Era 1). Jefe pesado; telegrafía pisotón (aturde 1 s), fase 2 rugido.
- **Referencia a adjuntar:** `b1_rexy_ref.png`
- **Archivo de salida:** `b1_rexy_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `b1_rexy_hurt_x2_sheet.png` (celda 1024 px / hoja 5120x5120 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 512 px / hoja 2560x2560 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido en el cuerpo del jefe (que ya llena la celda). Lienzo normal.
- **Origen:** D01, fila 4 (hurt)

```text
Using the attached reference image (b1_rexy_ref.png) as the exact design of the character, draw an animation sprite sheet of Rexy the T-Rex performing the 'hurt' animation.
Character identity, to stay consistent: Rexy: big chubby green T-Rex, cream belly, comically tiny arms, huge goofy toothy grin, red bandana, necklace of colorful stones.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A short flinch from a hit and a recovery to the idle pose; the character stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The hit lands: the head jerks back.
- Frames 6-18: The eyes squeeze shut, the tiny arms flail, the body staggers.
- Frames 19-25: He recovers.
```

### A-058 · Rexy the T-Rex (jefe Era 1): defeat (derrota)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `b1_rexy`, Rexy the T-Rex (jefe Era 1). Jefe pesado; telegrafía pisotón (aturde 1 s), fase 2 rugido.
- **Referencia a adjuntar:** `b1_rexy_ref.png`
- **Archivo de salida:** `b1_rexy_defeat_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `b1_rexy_defeat_sheet.png` (celda 512 px / hoja 2560x2560 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la izquierda, celda 1024 px / hoja 5120x5120 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el jefe cae y se derrumba ocupando mucho más espacio. Recomendado lienzo doble: celda 1024 px, hoja 5120x5120 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** D01, fila 5 (defeat)

```text
Using the attached reference image (b1_rexy_ref.png) as the exact design of the character, draw an animation sprite sheet of Rexy the T-Rex performing the 'defeat' animation.
Character identity, to stay consistent: Rexy: big chubby green T-Rex, cream belly, comically tiny arms, huge goofy toothy grin, red bandana, necklace of colorful stones.
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: it starts from the neutral standing pose of frame 1 and ends still.
Motion by frames:
- Frames 1-8: The legs wobble.
- Frames 9-20: He sits down with a thud, topples onto his side with his tongue out.
- Frames 21-25: Rexy ends still with tiny stars above. Hold this final pose still until frame 25.
```
