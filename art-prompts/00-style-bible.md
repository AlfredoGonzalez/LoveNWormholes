# Biblia de estilo — Love N Wormholes

Pégala (o su resumen) al inicio de **cada** prompt para mantener consistencia.

## Dirección
Estilo **libro de cuentos entintado** (el del prototipo de Unity): contorno grueso marrón muy oscuro (`#2e2024`, no negro), sombreado *cel* con brillos suaves, colores saturados y cálidos, ambiente prehistórico de **piedra, madera y pergamino**. Fondos de papel crema con garabatos tenues. Sin texturas fotorrealistas ni degradados complejos.

## Los gusanos (personajes principales)
- **Gusanito**: gusano **verde brillante** (`#7ccf5a`), cuerpo segmentado corto y regordete, ojos grandes con brillo, cejas decididas y sonrisa valiente. **Siempre lleva su gorra negra con una «A» blanca** (su sello); cambia el resto del atuendo por era (garrote de hueso, collar dorado, peto y capa, bandana y estrella de sheriff).
- **Gusanita**: gusano **rosa** (`#ff8fb8`) con **cabello largo ondulado rosa**, **lentes redondos** y una **flor blanca (margarita)** en la cabeza; ojos grandes, expresión dulce y curiosa.
- Proporción: cabeza ≈ 40 % del cuerpo, ojos ≈ 1/3 de la cara. Cuerpo de 4-5 segmentos. Vista lateral, **todos los personajes miran a la DERECHA** (aliados y enemigos); el juego voltea a los enemigos por código.

## Paletas por era
| Era | Cielo | Suelo | Acentos |
|---|---|---|---|
| Prehistoria | `#7fb8e6` | `#6b8e4e` | `#f2a65a`, `#9a8f97` |
| Antiguo Egipto | `#ffd98a` | `#e8c37a` | `#2a9d8f`, `#d4a017` |
| Edad Media | `#9bb7d4` | `#7a8f5a` | `#b23a48`, `#8d99ae` |
| Lejano Oeste | `#f4a261` | `#d9a066` | `#8c4a2f`, `#e9c46a` |

## Interfaz
Piezas de **piedra tallada, madera atada con cuerda y pergamino envejecido**, con el mismo contorno marrón. Los botones, píldoras, marcos y ventanas se entregan **en blanco (sin texto)**; el juego escribe los textos en español e inglés. Lista completa en `05-screens.md`.

## Wormhole (motivo recurrente)
Portal en espiral violeta/cian (`#6a2cdc` → `#3de0ff`), anillos concéntricos, chispas. Aparece en cada era como "anomalía" y en la UI.

## Plantilla de prompt base
```
[SUJETO], cute cartoon 2D game asset in a hand-inked storybook style,
thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors,
prehistoric stone-and-wood mood, friendly and humorous, side view,
isolated on a plain solid magenta (#ff00ff) background, centered, full body visible,
no text, no watermark, no shadow on the ground
```
(Los prompts de los demás documentos ya traen esta plantilla incorporada y adaptada a cada archivo.)

**Negativos** (si la herramienta los admite): `photorealistic, 3d render, blurry, text, watermark, extra limbs, background scene, cropped, gradient mesh, noisy texture`.

## Flujo para consistencia
1. Genera primero las **hojas de referencia** de Gusanito y Gusanita (prompts en `04-extras.md`). Guarda las mejores.
2. Para cada personaje nuevo usa esa imagen como **referencia de personaje/estilo** (image-to-image, "character reference" o IP-Adapter según la herramienta) y fija el **seed** cuando se pueda.
3. De cada personaje genera primero `<id>_idle`; ya aprobada, úsala como referencia para `_walk`, `_attack` y `_die`.
4. Genera de 4 en 4 y elige la mejor. **No hace falta quitar el fondo ni recortar**: deja el fondo plano (magenta o blanco) y ejecuta `npm run art`.

## Nombres, tamaños y pipeline
Todo está en [`README.md`](README.md) (nombres exactos de archivo, tamaños finales, reglas de fondo y prioridades). Los prompts por archivo ya incluyen este estilo.
