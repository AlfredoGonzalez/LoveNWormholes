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
