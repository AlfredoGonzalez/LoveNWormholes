# Biblia de estilo — Love N Wormholes

Pégala (o su resumen) al inicio de **cada** prompt para mantener consistencia.

## Dirección
Cartoon 2D tierno y cómico, estilo "sticker" de juego móvil: contorno grueso y limpio (color marrón oscuro `#3b2a3f`, no negro), colores saturados pero cálidos, sombreado plano de 2 tonos (base + sombra) y un brillo pequeño. Sin texturas fotorrealistas, sin degradados complejos.

## Los gusanos (personajes principales)
- **Gusanito**: gusano rosa-salmón (`#ff8fa3`), cuerpo segmentado corto y regordete, ojos grandes con brillo, sonrisa valiente, una pequeña ceja decidida. Lleva un accesorio por era (taparrabos, tocado egipcio, casco, sombrero vaquero…).
- **Gusanita**: gusano lila (`#c9a7ff`), mismas proporciones, pestañas, moño/flor en la cabeza. Siempre con expresión curiosa/traviesa.
- Proporción: cabeza = ~40% del cuerpo, ojos = 1/3 de la cara. Cuerpo de 4-5 segmentos. Vista lateral (3/4 hacia la derecha para aliados, hacia la izquierda para enemigos — se puede espejar el sprite).

## Paletas por era
| Era | Cielo | Suelo | Acentos |
|---|---|---|---|
| Prehistoria | `#7fb8e6` | `#6b8e4e` | `#f2a65a`, `#9a8f97` |
| Antiguo Egipto | `#ffd98a` | `#e8c37a` | `#2a9d8f`, `#d4a017` |
| Edad Media | `#9bb7d4` | `#7a8f5a` | `#b23a48`, `#8d99ae` |
| Lejano Oeste | `#f4a261` | `#d9a066` | `#8c4a2f`, `#e9c46a` |

## Wormhole (motivo recurrente)
Portal en espiral violeta/cian (`#6a2cdc` → `#3de0ff`), anillos concéntricos, chispas. Aparece en cada era como "anomalía" y en la UI.

## Plantilla de prompt base
```
[SUJETO], cute cartoon 2D game asset, thick clean dark-plum outline (#3b2a3f),
flat two-tone shading with a small highlight, saturated warm colors,
mobile game sticker style, friendly and humorous, side view,
isolated on a plain solid magenta (#ff00ff) background, centered, full body visible,
no text, no watermark, no shadow on the ground
```
**Negativos** (si la herramienta los admite): `photorealistic, 3d render, blurry, text, watermark, extra limbs, background scene, cropped, gradient mesh, noisy texture`.

## Flujo para consistencia
1. Genera primero la **hoja de referencia** de Gusanito y Gusanita (vista frontal + lateral). Guarda la mejor.
2. Para cada pose/variante usa esa imagen como **referencia de personaje/estilo** (image-to-image, "character reference" o IP-Adapter según la herramienta) y fija el **seed** cuando se pueda.
3. Genera de 4 en 4 y elige la mejor. Quita el fondo magenta (chroma key) o usa una herramienta de "remove background".
4. Exporta **PNG transparente**, lado más largo 512 px para personajes (se reducen en el juego).

## Convenciones de archivos
`assets/characters/<id>/<anim>_<NN>.png` — p. ej. `assets/characters/hero/walk_01.png`. Animaciones: `idle` (4), `walk` (6), `attack` (5), `die` (5). Luego `npm run pack-atlas` los junta en un atlas.
Fondos: `assets/backgrounds/<era>/{far,mid,near}.png`. UI: `assets/ui/<nombre>.png`.
