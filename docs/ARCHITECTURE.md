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
| `title` | `src/meta/title_screen.gd` | – | `levels` |
| `levels` | `src/meta/level_select_screen.gd` | – | `prebattle {era, stage}`, `upgrades`, `settings` |
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
