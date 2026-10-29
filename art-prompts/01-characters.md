# Personajes — Prehistoria (era 1)

Usa la plantilla base de `00-style-bible.md`. Reemplaza `[SUJETO]`.

## Héroes
1. **Hoja de referencia Gusanito** — `Gusanito, a cute chubby pink-salmon worm hero with 5 segments, big shiny eyes, brave smile, small determined eyebrows, wearing a tiny leopard-skin loincloth and a bone headband; character reference sheet: front view and side view`
2. **Hoja de referencia Gusanita** — `Gusanita, a cute chubby lilac worm with long lashes and a small flower bow, curious mischievous expression, wearing a leaf skirt; character reference sheet: front view and side view`
3. **Gusanita atrapada en el portal** (ilustración de historia, fondo sí permitido) — `Gusanita pressing a glowing button on a strange glowing gadget, a swirling purple-cyan wormhole opening around her, surprised happy face, prehistoric jungle clearing, comic panel style`
4. **Gusanito corriendo hacia el portal** — `Gusanito running determined toward a swirling purple wormhole, comic panel style, dust cloud, dramatic but funny`

## Unidades aliadas (todas son gusanos con distintos atuendos)
| id | Sujeto |
|---|---|
| `stick` | `a small worm warrior holding a big wooden club almost taller than itself, tan color #f2a65a, fur loincloth` |
| `slinger` | `a small green worm (#7bc67e) with a leather sling and a pebble, leaf hat, mischievous grin` |
| `rock` | `a big sturdy grey worm (#9a8f97) carrying a huge round rock as a shield, stone helmet, grumpy cute face` |
| `chief` | `a worm tribe chief, red-pink (#e85d75), huge feathered headdress, bone necklace, holding a carved totem staff, proud expression` |

## Enemigos
| id | Sujeto |
|---|---|
| `rat` | `a cave rat with oversized front teeth, brown (#8a6d5a), tiny stone axe, angry but cute` |
| `bird` | `a toothy prehistoric bird (#5aa9e6), small wings, sharp beak with teeth, silly menacing look` |
| `mammoth` (jefe) | `a giant woolly mammoth boss, brown shaggy fur (#6b4423), large curved tusks, grumpy eyes, wearing a tiny crown, imposing yet comical` — generar 1024 px de alto |

## Animaciones (por personaje)
Con la imagen de referencia, genera cada pose por separado: `idle` (respirando), `walk` (2 poses de paso alternas), `attack` (preparar → golpe), `die` (aplastado/estrellitas). Si tu herramienta lo permite, pide `sprite sheet, 6 frames in a row, same character, consistent size`. Mínimo viable: **idle ×1, walk ×2, attack ×2, die ×1** — el juego interpola con tweens.

## Especificaciones
PNG transparente, personajes ~512 px lado largo, jefes 1024 px. Pies alineados a la misma línea base (deja ~5% de margen inferior).
