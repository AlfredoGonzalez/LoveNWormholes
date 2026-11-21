# Arquitectura (contrato entre módulos)

Todo es GDScript construido por código. Las reglas están en `docs/spec.md`; los números en `data/*.json`
(`DataDB`); los textos en `i18n/strings.csv` (`Localization`, siempre vía `Game.t("clave")`).

## Capas
| Capa | Dónde | Qué |
|---|---|---|
| Datos | `data/`, `config/`, `src/core/data_db.gd` | JSON + fórmulas de escalado (`unit_stats`, `enemy_stats`, `boss_stats`, `power_params`, recompensas) |
| Núcleo de batalla | `src/core/battle/` | `BattleSim` (determinista, 30 Hz, sin nodos), `SimUnit`, `BattleSetup` |
| Servicios | `src/core/*_service.gd`, `economy.gd`, `src/platform/mock/` | Guardado, economía, anuncios, compras, analítica, audio. Detrás de interfaces (`src/core/services/`) |
| Autoload | `src/autoload/game.gd` (`Game`) | Crea y expone los servicios, `Game.nav`, `Game.last_sim`, `Game.t()` |
| UI | `src/ui/` | `Screen` (base), `Navigator`, `UI` (estilo del mockup), `SpriteFactory`, `StudioIntro` |
| Pantallas | `src/meta/`, `src/battle/` | Una clase por pantalla, extienden `Screen`, registradas en `Navigator.SCREENS` |

## Reglas de oro
- Nada de números de balance en el código: siempre `DataDB.bal_f("ruta")` o funciones de `DataDB`.
- Nada de textos fijos: `Game.t("clave")`; toda clave nueva va a `i18n/strings.csv` en EN y ES (`tools/check_i18n.py`).
- La simulación (`BattleSim`) no toca nodos ni `Game`; la pantalla de batalla solo la lee y le manda entradas.
- Recompensas de anuncios solo desde `Game.ads.reward_granted`; compras solo desde `Game.billing.purchase_granted`.
- Sin arte real: `SpriteFactory.make_animated(id)` devuelve un rectángulo marcado. Nunca se rompe por falta de arte.
- Tamaño de viewport 540x960 (vertical). Áreas táctiles >= 48 px (`UI.MIN_TOUCH`). Español puede ser 30% más largo.
- Pruebas: `tools/check.sh` (importa, corre `tests/test_*.gd`, smoke). Cada módulo trae sus pruebas.

## Navegación y parámetros
`Game.nav.go(nombre, params)` reemplaza la pantalla; `Game.nav.push(overlay)` / `pop()` para superposiciones.

| Pantalla | Archivo | `params` de entrada | Siguiente |
|---|---|---|---|
| `title` | `src/meta/title_screen.gd` | – | `home` |
| `home` | `src/meta/home_screen.gd` | – | `prebattle`, `levels` (mapa), `squad`, `upgrades`, `settings` |
| `levels` | `src/meta/level_select_screen.gd` | – (Mapa Mundial) | `prebattle {era, stage}`, `home` |
| `prebattle` | `src/meta/pre_battle_screen.gd` | `{era, stage}` | `battle {era, stage, squad: [ids], powers: [ids], food_boost: bool}` |
| `battle` | `src/battle/battle_screen.gd` | `{era, stage, squad, powers, food_boost, resume: bool}` | `result` |
| `result` | `src/meta/result_screen.gd` | `{result: "win"/"lose", era, stage, stats: Dictionary, time: float}` | `levels`, `battle` (reintentar / Segundo Aliento con `resume: true`), `prebattle` |
| `upgrades` | `src/meta/upgrades_screen.gd` | – | `levels` |
| `settings` | `src/meta/settings_screen.gd` | – | atrás (`levels` o `title`) |

- La pantalla de batalla arma el `BattleSim` con `BattleSetup.make(stage_def, opts)` y, al terminar, guarda el
  sim en `Game.last_sim` y navega a `result`. Con `resume: true` continúa `Game.last_sim` con la base del jugador
  al 25 % (Segundo Aliento) en vez de crear uno nuevo.
- `result` es quien llama `Game.economy.settle_battle(era, stage, won, stars, coin_multiplier)`; la batalla NO paga.
- `stage_def` sale de `DataDB.stage(era, stage)` (lee `data/stages.json`; esquema en `docs/DATA_SCHEMA.md`).

## Estados de sesión
`Game.save.profile` (ver `SaveService.default_profile`). Se guarda en cada recompensa (`Economy` ya lo hace).

---
# Fase 2 — meta-juego (contrato)

Guardado **v2** (`SaveService.CURRENT_VERSION = 2`, migración `_migrate_1_to_2`): añade `quests`, `stats`, `seen` y 2 presets de escuadrón.

## Pantallas y rutas nuevas
| Ruta | Archivo | Dueño | Notas |
|---|---|---|---|
| `home` | `src/meta/home_screen.gd` | agente Home | Hub: Squirmy sobre la madriguera, JUGAR (siguiente etapa), barra de monedas, insignia de recompensa diaria, popup de granja offline, navegación inferior Escuadrón / Mejoras / Cápsulas / Tienda / Mapa. El Título ahora va a `home` |
| `levels` | `src/meta/level_select_screen.gd` | agente Home | Es el **Mapa Mundial** (mockup WorldMap). Sigue con la ruta `levels` |
| `squad` | `src/meta/squad_screen.gd` | agente Escuadrón | Colección de todas las unidades desbloqueadas, presets, gráfico de contrarrestos |
| `prebattle` | `src/meta/pre_battle_screen.gd` | agente Escuadrón | Selector de Time Squad (4 slots, 5.º tras el jefe de la Era 2) y de poderes |

## Servicios / módulos nuevos
- `Squad` (`src/core/squad.gd`, agente Escuadrón): `unlocked_units(profile)` (todas las unidades de eras desbloqueadas, `Progress.is_era_unlocked`), `slots(profile)`, `active(profile)`, `set_preset(profile, idx, ids)`, `unlocked_powers(profile)` (poderes por jefe: `powers.json unlock`), `power_slots(profile)`, `equipped_powers(profile)`. Valida y completa con valores por defecto; la pantalla de batalla y pre-batalla solo usan esta API.
- `Quests` (`src/core/quests.gd`, agente Home): misiones diarias (`data/quests.json`), `Game.quests`. Se alimenta de `Game.economy.battle_settled` y de `stats` del resultado (`units_spawned`, `powers_used`).
- Granja offline y login diario: ya están en `Economy` (`offline_pending`, `claim_offline`, `can_claim_daily`, `claim_daily`); el agente Home solo los muestra y conecta.

## Reglas de Era 2 en la simulación (agente Sim)
`stage_def.rule` = `{"type": "none" | "sand_patch" | ...}`; `BattleSetup` pasa la regla a `BattleSim`; la vista la dibuja (`src/battle`).

## Fase 3 – Cápsulas
Cápsulas del Tiempo, reliquias y Polvo Crono (spec 7.4). Sin tienda: la UI de compra es de otro agente; aquí solo hay lógica y las pantallas de apertura y colección.

| Pieza | Archivo | Resumen |
|---|---|---|
| `Capsules` | `src/core/capsules.gd` | Lógica pura. `open_one()`, `open_many(n)` (un solo guardado), `buy_with_gems(bundle)` (60 / 540 por 10, de `shop.json`), `craft(relic_id)` (Polvo), `request_bonus_ad(ads, quests)`, `pity()`, `rarity_odds()`, `dust_cost/dust_on_duplicate(rareza)`. `pick_rarity` y `next_counters` son estáticas y puras |
| `Relics` | `src/core/relics.gd` | Estática sobre el perfil: `modifiers(profile)` (fracción por atributo de las reliquias **equipadas**, con tope +25% de `DataDB.relic_bonus`), `equip/unequip/equipped`, `slots()` |
| `CapsuleScreen` | `src/meta/capsule_screen.gd` | Ruta `capsules` (ya enlazada en el Home). Animación placeholder (sacudida + fundido), revelación, botones Abrir 1 / Abrir N, comprar con Gemas, anuncio de cápsula extra, y siempre visibles: probabilidades, contadores de pity, conversión y precios de Polvo |
| `RelicsScreen` | `src/meta/relics_screen.gd` | Ruta `relics`. Colección, equipar/quitar, crear o subir de nivel con Polvo, bonos activos |
| Textos | `i18n/strings_capsules.tsv` | Claves nuevas; las de `capsules.*`, `relic.*`, `rarity.*` ya estaban en `strings.csv` |

**Reglas.** Pity duro: la cápsula nº `pity_rare_every` (5) desde la última Rara+ es Rara o mejor y la nº `pity_epic_every` (20) desde la última Épica es Épica (Épica gana; una Épica también reinicia el contador de Rara). Un duplicado sube de nivel hasta el máximo de su rareza; al máximo se convierte en Polvo (5/15/50). El Polvo compra una reliquia elegida (30/90/250) o le sube un nivel; no se puede comprar por encima del máximo. Una reliquia nueva se equipa sola si hay un espacio libre.

**Determinismo y guardado.** `Capsules.new(economy, rng)`: con un `RandomNumberGenerator` inyectado (tests, simulador) se usa tal cual. Sin él, cada apertura siembra un generador local con `profile.pity.rng_state` y guarda la siguiente semilla (50 bits, exacta en JSON), así que cerrar la app no reinicia ni el pity (`since_rare`, `since_epic`) ni la secuencia. El esquema sigue en v2: `loadout.equipped_relics` (nuevo) se rellena con `[]` en perfiles viejos mediante `_merge_defaults`, y `Relics.equipped` tolera su ausencia.

**Efectos en combate.** `BattleSetup.make(stage, opts)` acepta `opts.relics = Relics.modifiers(profile)` (sin la clave no cambia nada; `BattleScreen._make_opts` la envía): `food_income`, `base_hp`, `unit_hp`, `unit_damage` (solo tus unidades), `spawn_cooldown` y `power_cooldown` (reducciones). `coins` lo aplica `Economy.settle_battle` solo (antes del multiplicador del anuncio, así `revert_loss` sigue siendo coherente).

**balance.json (claves nuevas, en `proposed_keys`).** `capsule.relic_slots` = 4 (el spec no fija un límite de equipables: todas las reliquias se aplican con tope +25%; pon 12 para el comportamiento literal del spec) y `capsule.open_many` = 10 (botón "Abrir N").

**Reglas de la tienda.** Probabilidades, pity y conversión a Polvo se muestran siempre en `CapsuleScreen`; los anuncios son opcionales y la cápsula gratis tiene camino sin anuncio (login diario, jefes). Sin temporizadores ni cuentas atrás.
