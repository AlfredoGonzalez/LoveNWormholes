# Guía de arte — Love N Wormholes

> Documento generado por `npm run art:docs` desde `tools/art-spec.ts`. Si cambian los personajes del juego, regenera.

## Cómo funciona (3 pasos)
1. **Genera** cada imagen con la IA usando el prompt de su archivo (carpeta `art-prompts/`). Pide el tamaño al menos al doble del final; el script reduce.
2. **Guarda** el resultado crudo en `art-inbox/` con el **nombre exacto** del archivo (p. ej. `stick_idle.png`, `coin.png`). Cada ícono y cada hoja de sprites va **por separado**.
3. Ejecuta `npm run art`. El script **quita el fondo**, **corta los cuadros**, **unifica el tamaño** y deja el archivo final en `public/assets/`. `npm run art:status` muestra qué ya está y qué falta.

El juego carga lo que exista y usa figuras de reemplazo para lo que falte: puedes ir entregando el arte poco a poco. Al compilar (`npm run build`) se genera solo `assets/manifest.json` con los archivos presentes, así que el juego únicamente pide lo que existe.

## Reglas del fondo
- **Magenta plano** (`#FF00FF`) es el predeterminado. Para objetos rosas/violetas/magenta (gemas, corazón, portal, logo) los prompts piden **blanco plano** (`#FFFFFF`). Si tu herramienta no obedece el color, usa el otro: el script detecta el color de fondo por las esquinas.
- Fondo **plano y liso** (sin degradado ni sombra en el piso). Si la IA añade sombra o suelo, pide de nuevo o bórralo antes.
- Los ojos blancos o vendas blancas del interior **no** se borran (solo se quita el fondo conectado con el borde de la imagen).
- Los **fondos de escenario** (`bg_*.png`) no llevan transparencia: se ajustan al tamaño.

## Hojas de sprites (personajes)
- **Una hoja por animación**: `<id>_idle.png`, `<id>_walk.png`, `<id>_attack.png`, `<id>_die.png`. Ejemplo: `stick_idle.png`, `gusanito_egipto_walk.png`.
- Cada hoja tiene **4 cuadros**. Pueden venir en **una fila** (relación 4:1) o en **cuadrícula 2×2** (cuadrada); el script lo detecta. Si tu herramienta no hace 4:1, reemplaza en el prompt la frase *"arranged in a single horizontal row (aspect ratio 4:1…)"* por *"arranged in a 2×2 grid, order left-to-right then top-to-bottom, square image"*.
- Resultado final: **1024×256 px** (4 cuadros de 256×256); el personaje queda con los pies alineados abajo y con el mismo tamaño en todos los cuadros.
- **TODOS los personajes miran a la DERECHA** (también los enemigos: el juego los voltea solo).
- Orden recomendado: primero la hoja de referencia → luego `_idle` → úsala como **imagen de referencia** para `_walk`, `_attack` y `_die` del mismo personaje (así no cambia de cara ni de colores).
- Si falta una animación, el juego usa `_idle`; si falta `_idle`, dibuja un círculo de color. Por eso la prioridad es: **idle de todos → walk → attack → die**.

## Prioridad sugerida
| Prioridad | Qué | Archivos |
|---|---|---|
| 1 | Hojas **idle** de todos los personajes (29) + íconos de moneda, gema, estrellas y logo | 34 |
| 2 | Hojas **walk**, fondos de escenario, bases y arte de la tienda | 46 |
| 3 | Hojas **attack** e íconos extra (energía, portal, cofres…) | 36 |
| 4 | Hojas **die**, efectos y candado | 35 |
| 5 | **Rediseño de interfaz (Hito 6)**: historia, título, hub, navegación, mapa, recuerdos, cartas y tienda (ver `05-screens.md`) | 71 |

Total: **222** archivos, de los cuales **60** aparecen ya en el video de tu prototipo de Unity (📦, solo hay que exportarlos y renombrarlos). Desglose: (116 hojas de sprites de 29 personajes, 68 íconos/logo, 4 fondos, 8 bases, 4 efectos). Sugerencia: trabaja **por era** (Prehistoria completa primero).

## Reutilizar el arte de tu prototipo de Unity (📦)
Todo lo marcado con 📦 se ve en tu video, así que ya lo tienes hecho. Para usarlo:
1. En tu proyecto de Unity busca cada sprite (carpeta `Assets/`; son los PNG originales, no capturas de pantalla).
2. **Cópialo a `art-inbox/` con el nombre exacto** de la lista (p. ej. `story_01.png`, `nav_shop.png`, `btn_wood.png`).
3. Ejecuta `npm run art`. Si el PNG ya trae transparencia se respeta; si trae fondo plano se quita; los fondos y paneles solo se ajustan al tamaño.
4. Si en Unity una pantalla estaba "horneada" (p. ej. el título con logo, personaje y botón en una sola imagen), necesitamos las **capas por separado** (fondo, logo, personaje, botón en blanco) porque el juego pone el texto en español/inglés y anima cada capa; si no tienes las capas, los prompts de `05-screens.md` las generan.
5. Lo que en el video tenía **texto de ejemplo** (`Dungeon Map`, `The Worm Mart`, `concept: simplify icon`, `Placeholder Item`…) debe venir **sin texto**: el juego escribe los textos en ES/EN.

## Documentos
| Archivo | Contenido |
|---|---|
| [`00-style-bible.md`](00-style-bible.md) | Estilo, paletas, proporciones y flujo de consistencia (léelo primero) |
| [`01-characters.md`](01-characters.md) | Prompts de todas las hojas de sprites, por era |
| [`02-scenery.md`](02-scenery.md) | Fondos de escenario y bases |
| [`03-ui.md`](03-ui.md) | Íconos, logo, tienda, ícono de app y capturas |
| [`04-extras.md`](04-extras.md) | Efectos, hojas de referencia e ilustraciones de historia (opcionales) |

## Negativos (si tu herramienta los admite)
`photorealistic, 3d render, blurry, text, watermark, extra limbs, cropped, gradient mesh, noisy texture, drop shadow, different art style`

## Lista de nombres de archivo
- **prehistoria** (35): `gusanito_prehistoria_idle.png`, `gusanito_prehistoria_walk.png`, `gusanito_prehistoria_attack.png`, `gusanito_prehistoria_die.png`, `stick_idle.png`, `stick_walk.png`, `stick_attack.png`, `stick_die.png`, `slinger_idle.png`, `slinger_walk.png`, `slinger_attack.png`, `slinger_die.png`, `rock_idle.png`, `rock_walk.png`, `rock_attack.png`, `rock_die.png`, `rat_idle.png`, `rat_walk.png`, `rat_attack.png`, `rat_die.png`, `bird_idle.png`, `bird_walk.png`, `bird_attack.png`, `bird_die.png`, `mammoth_idle.png`, `mammoth_walk.png`, `mammoth_attack.png`, `mammoth_die.png`, `bg_prehistoria.png`, `base_prehistoria_home.png`, `base_prehistoria_enemy.png`, `gusanita_prehistoria.png`, `hub_bg_prehistoria.png`, `map_node_prehistoria.png`, `map_boss_prehistoria.png`
- **egipto** (35): `gusanito_egipto_idle.png`, `gusanito_egipto_walk.png`, `gusanito_egipto_attack.png`, `gusanito_egipto_die.png`, `spear_idle.png`, `spear_walk.png`, `spear_attack.png`, `spear_die.png`, `archer_idle.png`, `archer_walk.png`, `archer_attack.png`, `archer_die.png`, `sarcophagus_idle.png`, `sarcophagus_walk.png`, `sarcophagus_attack.png`, `sarcophagus_die.png`, `scarab_idle.png`, `scarab_walk.png`, `scarab_attack.png`, `scarab_die.png`, `mummy_idle.png`, `mummy_walk.png`, `mummy_attack.png`, `mummy_die.png`, `scarabking_idle.png`, `scarabking_walk.png`, `scarabking_attack.png`, `scarabking_die.png`, `bg_egipto.png`, `base_egipto_home.png`, `base_egipto_enemy.png`, `gusanita_egipto.png`, `hub_bg_egipto.png`, `map_node_egipto.png`, `map_boss_egipto.png`
- **medieval** (35): `gusanito_medieval_idle.png`, `gusanito_medieval_walk.png`, `gusanito_medieval_attack.png`, `gusanito_medieval_die.png`, `sword_idle.png`, `sword_walk.png`, `sword_attack.png`, `sword_die.png`, `crossbow_idle.png`, `crossbow_walk.png`, `crossbow_attack.png`, `crossbow_die.png`, `knight_idle.png`, `knight_walk.png`, `knight_attack.png`, `knight_die.png`, `goblin_idle.png`, `goblin_walk.png`, `goblin_attack.png`, `goblin_die.png`, `skeleton_idle.png`, `skeleton_walk.png`, `skeleton_attack.png`, `skeleton_die.png`, `dragon_idle.png`, `dragon_walk.png`, `dragon_attack.png`, `dragon_die.png`, `bg_medieval.png`, `base_medieval_home.png`, `base_medieval_enemy.png`, `gusanita_medieval.png`, `hub_bg_medieval.png`, `map_node_medieval.png`, `map_boss_medieval.png`
- **oeste** (35): `gusanito_oeste_idle.png`, `gusanito_oeste_walk.png`, `gusanito_oeste_attack.png`, `gusanito_oeste_die.png`, `cowboy_idle.png`, `cowboy_walk.png`, `cowboy_attack.png`, `cowboy_die.png`, `sharp_idle.png`, `sharp_walk.png`, `sharp_attack.png`, `sharp_die.png`, `barrel_idle.png`, `barrel_walk.png`, `barrel_attack.png`, `barrel_die.png`, `coyote_idle.png`, `coyote_walk.png`, `coyote_attack.png`, `coyote_die.png`, `outlaw_idle.png`, `outlaw_walk.png`, `outlaw_attack.png`, `outlaw_die.png`, `scorpion_idle.png`, `scorpion_walk.png`, `scorpion_attack.png`, `scorpion_die.png`, `bg_oeste.png`, `base_oeste_home.png`, `base_oeste_enemy.png`, `gusanita_oeste.png`, `hub_bg_oeste.png`, `map_node_oeste.png`, `map_boss_oeste.png`
- **extras** (8): `ghost_idle.png`, `ghost_walk.png`, `ghost_attack.png`, `ghost_die.png`, `meteor.png`, `explosion.png`, `tumbleweed.png`, `ghost_portal.png`
- **ui** (67): `coin.png`, `gem.png`, `star_full.png`, `star_empty.png`, `energy.png`, `bone_coin.png`, `wormhole.png`, `heart.png`, `lock.png`, `chest_closed.png`, `chest_open.png`, `ad_play.png`, `shop_gems_s.png`, `shop_gems_m.png`, `shop_gems_l.png`, `shop_starter.png`, `shop_double_coins.png`, `logo.png`, `title_bg.png`, `title_hero.png`, `btn_wood.png`, `btn_stone.png`, `ribbon_title.png`, `popup_frame.png`, `topbar.png`, `pill.png`, `btn_round.png`, `icon_gear.png`, `icon_menu.png`, `icon_quests.png`, `navbar.png`, `nav_tile.png`, `nav_tile_active.png`, `nav_map.png`, `nav_memories.png`, `nav_battle.png`, `nav_upgrades.png`, `nav_shop.png`, `frame_map.png`, `map_node_locked.png`, `event_slot.png`, `event_hunt.png`, `event_bones.png`, `event_forge.png`, `event_campfire.png`, `frame_memories.png`, `memory_frame.png`, `memory_locked.png`, `memory_01.png`, `memory_02.png`, `memory_03.png`, `memory_04.png`, `memory_05.png`, `memory_06.png`, `frame_upgrades.png`, `card_frame.png`, `card_back.png`, `stat_attack.png`, `stat_health.png`, `stat_crit.png`, `btn_reroll.png`, `frame_shop.png`, `mart_shopkeeper.png`, `deal_potion.png`, `deal_sword.png`, `deal_bone.png`, `hud_unit_btn.png`
- **story** (7): `intro_bg.png`, `story_01.png`, `story_02.png`, `story_03.png`, `story_egipto.png`, `story_medieval.png`, `story_oeste.png`
