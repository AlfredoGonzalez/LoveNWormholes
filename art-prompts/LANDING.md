# Empieza aquí: arte del landing (intro + título)

Objetivo: que lo primero que vea el jugador (la **intro en cómic** y la **pantalla de título**) ya tenga el arte final. El juego ya está programado para usar estas imágenes: en cuanto las proceses, aparecen.

## Antes de empezar
1. Abre [`00-style-bible.md`](00-style-bible.md) (estilo y cómo son Gusanito y Gusanita).
2. Usa **la misma herramienta de IA** para todo el landing (cambiar de herramienta cambia el estilo).
3. Pide siempre **el doble del tamaño final** (ya va indicado) y **formato PNG**.

## Orden recomendado
**Paso 0 — Referencias (no se suben al juego).** Genera y guarda las mejores; las **adjuntarás** a los demás prompts.
- `ref_gusanito`
```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Character reference sheet of Gusanito, a cute chubby bright-green (#7ccf5a) worm hero with 5 body segments, big shiny eyes, small determined eyebrows, a brave smile, and his signature black baseball cap with a white letter "A" on the front, no other clothes. Three views side by side: front view, side view facing right, and a 3/4 view, same size, standing on the same ground line. isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text.
```
- `ref_gusanita`
```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Character reference sheet of Gusanita, a cute chubby pink (#ff8fb8) worm with long wavy pink hair, round glasses, a white daisy flower on her head, big shiny eyes and a curious sweet expression, no other clothes. Three views side by side: front view, side view facing right, and a 3/4 view, same size, same ground line. isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text.
```
Revisa que Gusanito tenga: **verde, gorra negra con una «A» blanca**; y Gusanita: **rosa, cabello largo ondulado, lentes redondos y margarita blanca**.

## Paso 1 — `title_hero.png` · Gusanito en pose de título
**Tamaño final:** 768×768 px · **Pídelo en:** 1536×1536 (relación 1:1) · **Fondo al generar:** magenta #FF00FF · **Adjunta como referencia:** `ref_gusanito`

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: Gusanito, the bright-green worm with a black baseball cap with a white "A", frowning with determination, holding a big bone club on his shoulder, upper body rising from the ground, dynamic pose, facing the viewer. A single object centered and filling about 85% of the frame, square image (1:1final 768×768 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```
> Debe verse **enojado-decidido pero tierno**, con el garrote de hueso al hombro. El fondo plano (magenta) no debe tocar los bordes de la imagen con sombras.

## Paso 2 — `logo.png` · Logo
**Tamaño final:** 1024×512 px · **Pídelo en:** 2048×1024 (relación 2:1) · **Fondo al generar:** blanco #FFFFFF · **Adjunta como referencia:** `ref_gusanito` y `ref_gusanita` (para los dos retratos pequeños)

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. game logo: the words "Love n' Wormholes" carved in a mossy stone sign with vines and small flowers, a small portrait of the green worm with a black cap at the top-left corner and a small portrait of the pink worm with glasses and a daisy at the top-right corner. Aspect ratio 2:1 (final 1024×512 px). isolated on a plain, solid, flat pure white background (#FFFFFF), no gradient, no shadow on the ground.
```
> La IA suele escribir mal el texto. Revisa que diga exactamente **Love n' Wormholes**; si no sale, genera varias veces o pide solo el **letrero de piedra sin letras** y avísame: puedo hacer que el juego escriba el nombre encima.

## Paso 3 — `title_bg.png` · Fondo del título (selva al anochecer)
**Tamaño final:** 1080×1920 px · **Pídelo en:** 2160×3840 (relación 9:16) · **Fondo:** escena completa · **Adjunta como referencia:** ninguna

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Full-screen game background: prehistoric jungle at dusk, purple-pink twilight sky, dinosaur silhouettes in the distance, giant ferns and tree trunks framing the sides, a mossy cliff with a round stone cave entrance with a dark opening in the lower middle, NO characters and NO text, empty space at the top for a logo and at the bottom for a button. Vertical composition, aspect ratio 9:16 (final 1080×1920 px). Keep the center calm and uncluttered so UI can sit on top. No characters unless stated, no text, no UI.
```
> Deja **vacío** el espacio superior (logo) y el inferior (botón). La cueva debe quedar abajo al centro, porque Gusanito se coloca delante.

## Paso 4 — `btn_wood.png` · Botón de madera en blanco
**Tamaño final:** 512×192 px · **Pídelo en:** 2048×768 (relación 8:3) · **Fondo al generar:** magenta #FF00FF · **Adjunta como referencia:** ninguna

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Game icon: a blank orange wooden sign button with a rope-tied bone-and-stick frame at the corners, rough carved texture, NO text (the text is added by the game in each language). A single object centered and filling about 85% of the frame, aspect ratio 8:3 (final 512×192 px). isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground. No text, no watermark.
```
> Sin texto: el juego escribe «JUGAR» o «PLAY». Debe ser casi un rectángulo ancho y bajo.

## Paso 5 — `intro_bg.png` · Fondo de papel de la intro
**Tamaño final:** 1080×1920 px · **Pídelo en:** 2160×3840 (relación 9:16) · **Fondo:** escena completa · **Adjunta como referencia:** ninguna

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Full-screen game background: cream paper background with a faint tone-on-tone pattern of hand-drawn doodles: little smiling worms, apples with a door, hearts, leaves, clocks, spears, stone axes and stopwatches, very low contrast so text and panels stay readable. Vertical composition, aspect ratio 9:16 (final 1080×1920 px). Keep the center calm and uncluttered so UI can sit on top. No characters unless stated, no text, no UI.
```
> Los garabatos deben ser **muy tenues** para que los paneles se lean encima.

## Paso 6 — `story_01.png` · Intro 1/3 — la pareja feliz
**Tamaño final:** 1024×640 px · **Pídelo en:** 2048×1280 (relación 8:5) · **Fondo:** escena completa · **Adjunta como referencia:** `ref_gusanito` y `ref_gusanita`

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Illustration: a comic panel with a leafy vine border: the green worm with a black cap with an "A" and the pink worm with long pink hair, glasses and a white daisy cuddling happily inside their cozy hollow apple house, hearts floating, warm light, a round window behind them. Aspect ratio 8:5 (final 1024×640 px). Background allowed (full scene). No text, no speech-bubble text.
```
> Los dos gusanos juntos, felices, en su casita de manzana. Sin globos de texto.

## Paso 7 — `story_02.png` · Intro 2/3 — el aparato misterioso
**Tamaño final:** 1024×640 px · **Pídelo en:** 2048×1280 (relación 8:5) · **Fondo:** escena completa · **Adjunta como referencia:** `ref_gusanito` y `ref_gusanita`

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Illustration: a comic panel with a leafy vine border: the pink worm with glasses and a daisy shows the green worm with the black "A" cap a strange glowing retro handheld gadget with an antenna, the green worm looks confused with a question mark above his head, inside the apple house. Aspect ratio 8:5 (final 1024×640 px). Background allowed (full scene). No text, no speech-bubble text.
```
> Gusanita enseña el aparato y Gusanito pone cara de confusión (signo «?»).

## Paso 8 — `story_03.png` · Intro 3/3 — el portal se la lleva
**Tamaño final:** 1024×640 px · **Pídelo en:** 2048×1280 (relación 8:5) · **Fondo:** escena completa · **Adjunta como referencia:** `ref_gusanito` y `ref_gusanita`

```text
cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous. Illustration: a comic panel with a leafy vine border: the pink worm presses the big button of the gadget and a swirling blue-purple wormhole portal opens and starts pulling her tail, she looks scared, the green worm with the black cap reaches out toward her with a shocked face. Aspect ratio 8:5 (final 1024×640 px). Background allowed (full scene). No text, no speech-bubble text.
```
> El agujero de gusano (azul-morado) jala a Gusanita; Gusanito intenta alcanzarla. Es el momento más dramático.

## Cuando tengas las imágenes
1. Guárdalas **crudas** en `art-inbox/` con el nombre exacto (`title_hero.png`, `logo.png`, `title_bg.png`, `btn_wood.png`, `intro_bg.png`, `story_01.png`, `story_02.png`, `story_03.png`).
2. Ejecuta `npm run art` (quita fondos y ajusta tamaños) y luego `npm run art:status`.
3. Mírala en el juego: `npm run dev`. La intro se repite desde **⚙ Ajustes → Ver historia**; el título aparece al terminarla.
4. Si algo se ve mal, cámbialo y vuelve a correr `npm run art`; **no hay que tocar código**.

## Problemas típicos
| Síntoma | Qué hacer |
|---|---|
| Gusanito se ve distinto en cada imagen | Adjunta `ref_gusanito` en **todas** y repite el detalle «black cap with a white A» en el prompt |
| Los ojos o la gorra quedan transparentes | El fondo no era plano; vuelve a generar con fondo liso (o cambia entre magenta y blanco) |
| Quedó un borde rosa/blanco alrededor | Pide la imagen con fondo **magenta puro**; si el personaje es muy rosa usa **blanco** |
| La IA agrega texto o globos | Añade «no text, no speech bubbles» y vuelve a generar |
| El panel de cómic sale con proporción rara | Se recorta/ajusta solo a 1024×640; deja margen alrededor de lo importante |

## Lo que sigue después del landing
El **hub** necesita: `gusanito_prehistoria_idle`, `base_prehistoria_home`, `hub_bg_prehistoria`, la barra superior/inferior y los íconos (ver [`05-screens.md`](05-screens.md)).
