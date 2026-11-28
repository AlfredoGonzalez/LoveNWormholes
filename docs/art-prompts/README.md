# Prompts de arte para Gemini (formato nuevo)

Sustituye a `docs/ART_PROMPTS_ORIGINAL.md` (los 89 prompts originales, que se conservan sin tocar). Generado por
`python3 tools/gen_art_prompts.py`, que lee el original para los textos de diseño y las filas de animación.
El estado de cada pieza (pendiente, en inbox, integrado) lo genera `python3 tools/art_status.py` en `docs/ART_STATUS.md`.

**Total: 324 prompts** (39 referencias de personaje, 195 hojas de animación, 90 imágenes y sprites estáticos),
repartidos en 8 fases (más la fase I, a mano: `fase-i-home.md`, marcos e iconos de Home). Los prompts de Gemini están en inglés; todo lo demás, en español.

## Qué cambia respecto al original

1. **Una hoja = una animación.** Antes cada hoja 5x5 juntaba 5 animaciones (una por fila). Ahora cada animación
   (idle, walk, attack, hurt, defeat; el héroe: idle, cast_slam, cast_power, hurt, celebrate) es un prompt aparte con
   25 fotogramas de la misma animación (orden izquierda→derecha, arriba→abajo), mucho más fluida. Las animaciones en
   bucle (idle, walk) deben enlazar el último fotograma con el primero.
2. **Una referencia por personaje.** Cada personaje tiene un prompt de pose estática (`<id>_ref.png`, 1024 px) con toda
   su descripción de diseño. Esa imagen se adjunta en Gemini en cada una de sus animaciones, así el prompt de
   animación solo habla del movimiento (más una línea de identidad: color y rasgo clave).
3. **Cada imagen estática dice dónde se usa** en el juego (pantalla o elemento), su tamaño y qué referencia adjuntar.
4. **Sin referencias cruzadas:** cada prompt se entiende solo. Los nombres de archivo son los que espera el pipeline.

## Cómo usar

1. Abre la fase en curso (empieza por la A) y trabaja **en el orden de los identificadores**: dentro de cada fase lo
   imprescindible va primero.
2. Para un personaje: genera su `referencia` y elige el mejor resultado; guárdalo como `<id>_ref.png`. Después abre un
   chat de Gemini (uno por era, para que el estilo sea consistente), **adjunta `<id>_ref.png`**, pega el prompt de una
   animación y genera. Repite con las otras 4 animaciones en el mismo chat.
3. Copia el bloque de código completo (el cuerpo en inglés) y pégalo. El resto de campos (lista con viñetas) son para ti.
4. Guarda el resultado con el **nombre de archivo exacto** del campo *Archivo de salida* en `art-inbox/` (ver
   `docs/ART_PIPELINE.md`) y ejecuta `python3 tools/art_status.py` para ver el avance.
5. Si una hoja sale mal (fotogramas con tamaño distinto, un miembro cortado, magenta en el cuerpo, la cuadrícula no es
   5x5 exacta): regenera la hoja completa en el mismo chat, o pide a Gemini que redibuje solo las filas con problema.
   Una hoja 5x5 = 25 celdas iguales: si Gemini devuelve 4x4 o 6x6, regenera.

## Convención de nombres

| Qué | Nombre | Ejemplo |
|---|---|---|
| Referencia de personaje | `<id>_ref.png` | `p1_club_worm_ref.png` |
| Hoja de animación (lienzo normal) | `<id>_<anim>_sheet.png` | `p1_club_worm_attack_sheet.png` |
| Hoja de animación (lienzo doble) | `<id>_<anim>_x2_sheet.png` | `p1_club_worm_attack_x2_sheet.png` |
| Imagen o sprite estático | el nombre de siempre | `base_p1.png`, `proj_stone.png`, `icon_coin.png`, `bg_era1.png` |

- `<id>`: `squirmy`, `squirmy_skin_<pirate|knight|astronaut>`, unidades `p<era>_<nombre>_worm`, enemigos `e<era>_<nombre>`,
  jefes `b<era>_<nombre>`.
- `<anim>` de unidades, enemigos y jefes: `idle`, `walk`, `attack`, `hurt`, `defeat`. Del héroe y sus skins: `idle`,
  `cast_slam`, `cast_power`, `hurt`, `celebrate`.
- Los voladores usan `walk` para el vuelo; los de apoyo (Time Medic Worm, Mummy Moth) usan `attack` para la curación.
- Wormina, Count Magpie y el Núcleo Crono son estáticos: su sprite (`wormina.png`, `count_magpie.png`, `chrono_core.png`)
  es a la vez su referencia; no tienen `_ref.png` ni animaciones.

## Tamaños

| Tipo | Lienzo normal | Lienzo doble (`_x2`) |
|---|---|---|
| Unidades y enemigos | celda 256 px, hoja 1280x1280 | celda 512, hoja 2560x2560 |
| Jefes | celda 512 px, hoja 2560x2560 | celda 1024, hoja 5120x5120 |
| Héroe, skins | celda 384 px, hoja 1920x1920 | celda 768, hoja 3840x3840 |
| Referencia de personaje | 1024x1024 | |
| Bases, proyectiles, iconos | 1024x1024 de origen (final: base 512 px de ancho, iconos máx. 128 px) | |
| Fondos de batalla, Home, mapa | 9:16, 1080x1920 | |
| Paneles de historia | 16:9, 1920x1080 | |
| Icono de app | 1024x1024 (se exporta a 512) | |
| Feature graphic | 2:1, 1024x500 finales | |

Gemini rara vez devuelve exactamente esos píxeles; son tamaños objetivo (pide la proporción y reescala después, o usa
el tamaño más grande que te dé). Todas las hojas son 1:1 con cuadrícula 5x5; fondo magenta `#FF00FF`
(Wormina: azul `#0000FF`). Mirada a la **derecha** en el héroe y las unidades propias; a la **izquierda** en enemigos y jefes.

### Lienzo doble (`_x2`)

Cada prompt de animación tiene la línea **¿Puede sobresalir de la celda?**. Si dice **sí**, genera con el lienzo doble:
el personaje se dibuja a la misma escala pero ocupando solo la mitad central de cada celda, así los golpes largos, saltos,
poderes, explosiones, caídas o proyectiles no se cortan ni invaden la celda vecina. El archivo lleva el sufijo `_x2` antes de
`_sheet` y el pipeline lo reduce a la escala normal. Si dice **no**, usa el lienzo normal. Hoy hay **65** hojas marcadas
como lienzo doble. El prompt ya incluye la instrucción de margen cuando corresponde.

## Fases

| Fase | Contenido | IDs | Refs | Animaciones | Estáticos | Total |
|---|---|---|---|---|---|---|
| A | [Era 1 jugable](fase-a-era1.md) | A-001 a A-058 | 8 | 40 | 10 | **58** |
| B | [Menús y Home](fase-b-menus.md) | B-001 a B-016 | 0 | 0 | 16 | **16** |
| C | [Era 2 (Egipto)](fase-c-era2.md) | C-001 a C-048 | 7 | 35 | 6 | **48** |
| D | [Tienda, cápsulas y reliquias](fase-d-tienda.md) | D-001 a D-040 | 3 | 15 | 22 | **40** |
| E | [Era 3 (Medieval)](fase-e-era3.md) | E-001 a E-049 | 7 | 35 | 7 | **49** |
| F | [Era 4 (Industrial)](fase-f-era4.md) | F-001 a F-049 | 7 | 35 | 7 | **49** |
| G | [Era 5 (Futuro lejano)](fase-g-era5.md) | G-001 a G-048 | 7 | 35 | 6 | **48** |
| H | [Historia y tienda de Play](fase-h-historia-tienda-play.md) | H-001 a H-016 | 0 | 0 | 16 | **16** |
| | **Total** | | **39** | **195** | **90** | **324** |

Por qué este orden:

- **Fase A, Era 1 jugable:** Primer combate completo de la Era 1 (Squirmy, unidades y enemigos de la Era 1, Rexy, bases, proyectiles, iconos esenciales y fondo). Sin esto no hay nada que probar con arte real.
- **Fase B, Menús y Home:** Lo que ve el jugador al abrir el juego: logo, Home, mapa, textura de papel, iconos de la barra superior, Wormina, Núcleo Crono, intro de historia y Count Magpie. Se mueve aquí la intro de 3 paneles (se muestra en la primera partida) y el icono de la app.
- **Fase C, Era 2 (Egipto):** Todo lo de la Era 2: 3 unidades, 3 enemigos, Pharaoh Scarab, bases, flecha, insignia, icono de Rewind y fondo.
- **Fase D, Tienda, cápsulas y reliquias:** Arte de cápsulas y reliquias (12 iconos, 3 insignias de rareza, cápsula abierta), tarjetas de la Tienda y las 3 skins del héroe (cada skin = referencia + 5 animaciones). Va antes que las eras avanzadas porque la economía y la tienda se juegan desde la Era 1.
- **Fase E, Era 3 (Medieval):** Todo lo de la Era 3, incluyendo Sir Sizzle, proyectiles de estrella mágica y bola de estiércol y el icono de Dirt Shield.
- **Fase F, Era 4 (Industrial):** Todo lo de la Era 4, incluyendo la Clockwork Queen, bola de cañón y bomba, e icono de Fast-Forward.
- **Fase G, Era 5 (Futuro lejano):** Todo lo de la Era 5, incluyendo a Count Magpie 3000 (jefe final) y los láseres.
- **Fase H, Historia y tienda de Play:** 14 paneles de historia (aperturas y cierres de era y final), gráfico de funciones y el portal opcional. Las capturas de pantalla de Play NO son prompts: se sacan del juego con tools/screenshots.gd cuando el arte real esté integrado.

El criterio general: primero lo que hace falta para jugar un combate de la Era 1 con arte real (A), luego lo que se ve al
abrir el juego (B), luego una era completa de ejemplo (C), luego la economía y la tienda, que están activas desde la
primera partida (D), luego las eras 3 a 5 (E, F, G) y por último la historia y la ficha de la tienda de Play (H).
Los iconos de poder se piden en la fase de la era cuyo jefe los desbloquea (Time Freeze en B, justo al acabar A).

39 personajes con animación: 1 héroe + 3 skins, 15 unidades, 15 enemigos y 5 jefes. Cada uno son 6 prompts (referencia + 5 animaciones).

## Mapa original → nuevo

Los identificadores del original (`A01`, `B01`...) se conservan en el campo **Origen** de cada prompt. Cambios:

- `A01` Squirmy, `A06` a `A08` skins, `B01` a `B15` unidades, `C01` a `C15` enemigos y `D01` a `D05` jefes: cada hoja de 5 filas
  pasa a 1 referencia + 5 hojas de animación (6 prompts). Los movimientos salen de las filas originales ampliadas a 25 fotogramas.
  El movimiento de Squirmy (héroe base) está reescrito a mano; las skins parten de sus filas originales.
- `A03`, `A04`, `A05` (Wormina, Count Magpie, Núcleo) y `E`/`F`/`G`/`H` (bases, proyectiles, iconos, fondos, logo, textura, icono de app, feature graphic) se
  mantienen como estáticos con el mismo nombre de archivo.
- `H08` logo: el texto pasa de "Worm Warriors" a "Love 'n Wormholes" (nombre del juego desde el 2026-11-21; ver ambigüedades).
- `H09` a `H12` (4 paneles de historia): el juego usa 17 paneles (`data/story.json`) con otros nombres, así que `H09` pasa a
  `story_intro_2`, `H10` a `story_intro_3` y `H12` a `story_end_3`; `H11` (el portal con las eras) queda como pieza **opcional**
  `story_03_portal.png`. Se añaden 13 paneles nuevos.
- Piezas **nuevas** que el juego necesita y el original no tenía: proyectiles `proj_acid`, `proj_dung_ball`, `proj_bomb`, `proj_laser_red`;
  `icon_capsule_open`; 3 insignias de rareza; 12 iconos de reliquia; 6 iconos de la Tienda. Marcadas como "nuevo" en el campo Origen.

## Ambigüedades y decisiones a confirmar

1. **Nombre en el logo:** el original dice "Worm Warriors / Lost in Time"; el juego se llama "Love 'n Wormholes" (decisión del 2026-11-21).
   El prompt del logo (B) usa el nombre nuevo. Cámbialo si prefieres otro.
2. **Referencias de personajes estáticos:** Wormina, Count Magpie y Núcleo Crono no llevan `_ref.png`; su sprite estático hace de referencia.
   El pipeline de sprites trata `wormina.png`, `chrono_core.png` y `count_magpie.png` como "personajes" estáticos.
3. **Dónde se guardan las referencias `_ref.png`:** no entran al juego. El estado las cuenta como "en inbox" si están en `art-inbox/` o "integrado" si están en `art-refs/`.
4. **Lienzo doble:** los marcados `_x2` son recomendación; si Gemini no entrega esa resolución se puede generar en lienzo normal
   (el nombre alternativo está en cada prompt) y aceptar un recorte mayor. Las hojas de jefe en lienzo doble (5120 px) probablemente superen lo que Gemini entrega: generar al máximo posible y reescalar.
5. **Fotograma del golpe:** en cada ataque el momento clave (daño o disparo) está en el fotograma 13 (poderes del héroe: 18 y 17).
   En el pipeline actual `hit_frame` es el 3.º de la fila (índice 2); la implementación nueva debe usar el 13.
6. **Proyectiles en hojas de ataque:** los prompts piden NO dibujar el proyectil en vuelo; el juego usa los sprites `proj_*`.
7. **Pipeline actual:** `tools/process_sprites.py` clasifica `era_N.png`, `power_*.png` y `fx_impact.png` como "personaje" (384 px de alto)
   porque no empiezan por `icon_`/`proj_`; pendiente de ajustar por el agente que implementa el pipeline (los iconos deberían quedar en 128 px).
8. **Panel de la Era 1 con Rexy y las hojas de Count Magpie 3000:** los paneles de historia adjuntan las referencias de los jefes; genera esas referencias antes (fases A y G).
9. **Capturas de Play:** no son prompts; se sacan con `tools/screenshots.gd` cuando haya arte real.
10. **Cosméticos `starter_cap` y `golden_cap`** (contenido de packs de la tienda): no hay arte definido; no se han incluido prompts.
11. **Mapa del mundo:** el original lo trae como un solo 9:16; si `level_select_screen.gd` acaba haciendo scroll vertical por era, habría que pedir una imagen más alta por era.
12. **Unidades y retratos:** las tarjetas de Squad/Upgrades/HUD usan hoy placeholders; no se piden retratos aparte, se supone un fotograma del `idle`.

## Regenerar

```
python3 tools/gen_art_prompts.py   # reescribe docs/art-prompts/*
python3 tools/art_status.py        # reescribe docs/ART_STATUS.md
```
