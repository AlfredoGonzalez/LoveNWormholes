# Esquema de datos (Phase 0.2C)

Todos los números de balance viven en `data/balance.json`; el código los lee con `DataDB` (`src/core/data_db.gd`, API estática, sin autoload). Los textos viven en `i18n/strings.csv` y se leen con `Localization` (`src/core/localization.gd`). Los ids son `snake_case` en minúsculas y coinciden con los nombres de assets (`assets/sprites/<carpeta>/<sprite>_sheet.png`).

Convención `proposed`: un campo `"proposed": true` (con `proposed_fields` cuando aplica) o una entrada en `proposed_keys` marca valores que NO están en el spec y son propuesta nuestra. Hay que confirmarlos con Alfredo.

JSON de Godot devuelve todos los números como `float`; `DataDB` convierte `era` a `int` y expone `bal_i`/`bal_f`.

## data/balance.json
Secciones (ruta con puntos, p. ej. `DataDB.bal_f("upgrades.unit.cost_growth")`):

| Sección | Contenido | Spec |
|---|---|---|
| `sim` | `ticks_per_second` 30, `lane_length_px` 1000, `range_unit_px` 40 (1 unidad de alcance = 40 px), `max_catchup_ticks` (propuesto) | 8.4, 5.4 |
| `battle` | `food_start`, `food_income_base`, `food_cap_base`, `kill_food_return` 0.25, `counter_strong_mult` 1.5, `counter_weak_mult` 0.75, `overtime_after_seconds`, `overtime_attack_mult`, `pop_cap_per_side`, `speed_toggle_mult`, `player_base_hp_era1`, `player_base_hp_era_mult` (propuesto) | 4.1, 4.2, 4.4, 5.4 |
| `squad` | slots 4..5, presets 2..3, slots de poder 2..3 | 4.3, 4.5 |
| `campaign` | 5 eras x 10 etapas, `echo_stage` 5, `boss_stage` 10, desbloqueos de slot 5 / poder 3, desbloqueo de pantallas tras etapas 2/3/4/5 | 3, 4.3, 9.2 |
| `scaling` | `era_hp_damage_mult` 1.6, `era_cost_mult` 1.5, `time_sync_per_era` 0.40, `unit_level_step` 0.10, `unit_level_max` 20, `enemy_stage_step` 0.05, `enemy_base_hp_start` 1000, `enemy_base_hp_step` 0.15, `target_avg_level_step` 0.25 | 6.3 |
| `upgrades` | `unit`, `burrow`, `base`, `power`: `max_level`, `cost_start`, `cost_growth` y el efecto por nivel | 6.2 |
| `rewards` | `win_coins_base` 30, `win_coins_growth` 1.06, `first_clear_*`, `boss_first_clear_*`, `loss_fraction` 0.40 | 6.4 |
| `underdog` | `losses_to_trigger` 2, `food_per_stack`, `base_hp_per_stack`, `max_stacks` 3 | 6.4 |
| `offline` | `coins_per_min_base` 2, `coins_per_min_per_stage` 0.4, `cap_hours_base` 3, `cap_hours_per_boss` 1, `cap_hours_max` 8, `golden_pass_bonus_hours` 2 | 6.5, 7.3 |
| `daily` | `login_capsules`, `login_gems`, `streak_day` 7, bonos de racha (propuestos), `quests_per_day` | 6.6 |
| `capsule` | `pity_rare_every` 5, `pity_epic_every` 20, `relic_bonus_cap` 0.25 | 7.4 |
| `ads` | recompensas de los 5 placements (x2 monedas, +30% comida, 25% vida de base, 1 capsula/dia, x2 granja) y `first_ad_after_stage_cleared` 3 | 7.1 |
| `era_rules` | constantes de reglas de era: arena -30% velocidad, murallas (20% de HP de base a la mitad), vapor +25% velocidad de ataque. Pozos de gravedad: sin numeros en el spec, falta definir | 4.6 |
| `boss` | `hp_mult` 6 (propuesto), `telegraph_interval_s` 10, `telegraph_warning_s` 1.5, `phase2_hp_fraction` 0.5 | 4.7, 5.3 |
| `roles` | tabla 5.4 por rol: `cost, hp, damage, interval, range, speed, spawn_cooldown` (rango en unidades de 40 px, velocidad en px/s) + `strong_against`, `weak_against` (`"any"` = todos), `can_hit_air`, `is_air` | 4.4, 5.4 |
| `proposed_keys` | lista legible de lo propuesto | |

Interpretaciones: el costo de subir al nivel L es `round(inicio x crecimiento^(L-2))` (el primer upgrade, a L2, cuesta `cost_start`) para unidad, madriguera, base y poder. El poder sube `effect_per_level` sobre sus `scaled_params` y baja el cooldown `cooldown_per_level` por nivel, ambos lineales (`1 + 0.12 x (L-1)`, `1 - 0.04 x (L-1)`). Underdog: `stacks = clamp(derrotas seguidas - 2, 0, 3)` (lectura literal de "tras 2 derrotas, cada derrota extra suma un stack"). Tope offline: `min(3 + jefes, 8)` horas y el Golden Pass suma 2 encima.

## data/units.json
`{ "version", "units": [ ... ] }`, 15 entradas (3 por era).

| Campo | Descripcion |
|---|---|
| `id` | `p<era>_<nombre>_worm`, ej. `p1_club_worm` |
| `era` | 1..5 |
| `role` | `fighter`, `shooter`, `heavy`, `support`, `air` |
| `sprite` | igual al `id` (hoja `<sprite>_sheet.png`) |
| `name_key`, `desc_key` | claves de i18n |
| `desc_args` | `[[ruta, escala], ...]` para rellenar `{0}`, `{1}` de la descripcion (ruta con puntos dentro de la entrada, o `balance.x.y`). `DataDB.describe(entry)` lo resuelve |
| `flags` | solo los `true` de `air, splash, slow, heal, buff`; `DataDB` completa los 5 |
| `abilities` | parametros numericos de la habilidad firma (`block_ranged_fraction`, `slow_fraction`, `first_hit_bonus`, `damage_aura`, `heal_fraction_per_sec`, `splash_radius_units`) |
| `overrides` | stats distintos de la tabla del rol (`cost, hp, damage, interval, range, speed, spawn_cooldown`). Si no hay override, el valor es el del rol |
| `proposed`, `proposed_fields` | valores inventados (ver arriba) |

`DataDB.unit(id)` devuelve la entrada ya fusionada con los stats BASE (equivalente a era 1, sin escalar). Escalado en runtime: `unit_stats(id, level, current_era)` = HP y dano x `1.6^(era-1) x (1 + 0.40 x (era actual - era unidad)) x (1 + 0.10 x (nivel-1))`, costo x `1.5^(era-1)`; intervalo, alcance, velocidad y cooldown no escalan. No volver a escalar los valores devueltos.

## data/enemies.json
Igual que units, con `id` `e<era>_...`, mas `behavior` (texto libre para el director/IA). `enemy_stats(id, era, stage)` aplica `1.6^(e-1) x (1 + 0.05 x (s-1))` a HP y dano y `1.5^(e-1)` al costo (el costo da `kill_food`).

## data/bosses.json
`id` `b<era>_...`, `role: heavy`, `telegraph` (ataque cada `boss.telegraph_interval_s`, aviso `telegraph_warning_s`) con `id` de ataque y sus parametros, `phase2` (al `boss.phase2_hp_fraction`), `escorts` `[{enemy, count}]`. TODO el bloque de stats es propuesto (`proposed: true`): base = Heavy con HP x `boss.hp_mult`; `boss_stats(id, stage=10)` aplica el multiplicador de enemigo de etapa 10. Ataques: `stomp`, `summon`, `fire_breath`, `steam_burst`, `steal_power`; fase 2: `roar`, `sandstorm`, `take_flight`, `spawn_cogs`, `teleport_bombs`.

## data/powers.json
`id, name_key, desc_key, desc_args, cooldown (s), unlock {type: "start"} | {type: "boss", era: N}, effect {...parametros de nivel 1}, scaled_params [...] (reciben +12% por nivel), param_caps {param: maximo}`. `power_params(id, level)` devuelve efecto y cooldown escalados. Poderes: squirm_slam, apple_rain, time_freeze, rewind, dirt_shield, fast_forward.

## data/relics.json
`rarities`: `common|rare|epic` con `odds` (0.70/0.25/0.05), `max_level`, `dust_on_duplicate`, `dust_cost`. `relics[]`: `id, rarity, stat, bonus, name_key, desc_key, desc_args`. `stat` en `food_income, coins, base_hp, unit_damage, unit_hp, spawn_cooldown, power_cooldown` (los dos ultimos son reducciones). Cada nivel suma `bonus`; `DataDB.relic_bonus(stat, {relic_id: nivel})` aplica el tope `capsule.relic_bonus_cap`.

## data/shop.json
`products[]` (`id, type consumable|non_consumable, price_usd, name_key, desc_key, contents, one_time?`), `capsules` (`gem_price_single` 60, `gem_price_bundle` 540, `bundle_count` 10), `gem_items` (slot de preajuste, precio propuesto), `free_daily` (regalo diario que toma sus gemas de `balance.daily.login_gems`).

## data/quests.json
`quests[]`: `id, name_key (con {0} = target), event, target, reward {coins, gems}, desc_args`. Montos propuestos. Se eligen `balance.daily.quests_per_day`.

## config/ads.json
`rewarded_only`, `placements[]` (`id, enabled, where, name_key, desc_key, desc_args`) para `double_coins, food_boost, second_wind, bonus_capsule, double_farm`; `debug_test_ids` (IDs de prueba de Google, verificar al compilar). Los IDs de produccion van en `config/ads.prod.json` (no versionado). `DataDB.ad_placement_enabled(id)` combina este flag con `feature_flags.ads`.

## config/feature_flags.json
`flags: {nombre: bool}`; nombres propuestos. `DataDB.feature_enabled(name)`.

## data/stages.json (futuro, lo genera otra fase; NO existe aun)
```json
{ "version": 1,
  "stages": [
    { "id": "1-1", "era": 1, "index": 1,
      "enemy_base_hp": 1000, "food_budget": 600,
      "waves": [ { "t": 5.0, "enemy": "e1_ant_clubber", "count": 3, "interval": 1.5 } ],
      "rule": { "type": "none" },
      "rewards": { "coins": 30, "first_clear_gems": 5, "boss": false, "echo": false, "shard": false } } ] }
```
**Regla de era (`rule`)**, generada por `tools/gen_stages.py` (Fases 1-2: Era 1 = `none`, Era 2 = arenas desde la etapa 3; ids `"<era>-<index>"`, p. ej. `"2-3"`):

```json
"rule": { "type": "none" }
"rule": { "type": "sand_patch", "patches": [ { "x": 420, "w": 160 }, { "x": 600, "w": 140 } ] }
```
- `sand_patch`: `patches[]` con `x` = borde izquierdo y `w` = ancho, ambos en px del carril (0..`sim.lane_length_px` = 1000, el mismo eje que `SimUnit.x`; la base del jugador esta en x = 0, la enemiga en x = 1000). Un parche cubre `x <= unit.x <= x + w`. Cualquier unidad (de ambos bandos) que este sobre uno pierde `balance.era_rules.sand_patch.slow_fraction` (0.30) de velocidad de movimiento; no afecta la velocidad de ataque. Se combina multiplicando con la aura de lentitud de la Cobra y con la Tormenta de Arena.
- `BattleSetup.make` copia `stage_def.rule` a `setup["rule"]`. `BattleSim` expone para la vista: `sim.rule` (el diccionario completo, `{"type": "none"}` si falta) y `sim.patches` (`Array` de `{x: float, w: float}`, vacio si la regla no es `sand_patch`), y por unidad `SimUnit.in_sand` (bool, se refresca cada tick). La vista debe dibujar `sim.patches` como franjas de ancho `w` a partir de `x` (mismo mapeo lane-px a pantalla que las unidades).
- Eventos nuevos del sim (`drain_events()`): `jump_back {uid, x, to}` (Locust Archer salta atras tras disparar). El resto de los eventos de jefe (`phase2 {id: "sandstorm"}`, `telegraph`, `boss_attack {id: "summon"}`) ya existian.
- Tormenta de Arena (fase 2 de Pharaoh Scarab, `bosses.json phase2.slow_fraction` 0.3): "ralentiza todo el carril" se interpreta como TODAS las unidades de ambos bandos (spec 5.3); termina cuando muere el Faraon.

`index` = 1..10 dentro de la era (n = (era-1) x 10 + index); `enemy_base_hp` = `DataDB.enemy_base_hp(n)`; `waves[]` usa ids de `enemies.json`/`bosses.json` y `food_budget` es lo que gasta el director; `rule.type` en `none, sand_patch, walls, steam_vent, gravity_well` con parametros tomados de `balance.era_rules`; `rewards` se calcula con las formulas de `DataDB` (`win_coins`, etc.). `echo` en la etapa 5 y `boss` en la 10. Los nombres de etapa (ej. "Ant Patrol") iran en `i18n/strings.csv`.

## i18n/strings.csv
Columnas `key,en,es`, UTF-8. Marcadores `{0}`, `{1}` iguales en ambos idiomas; `\n` literal = salto de linea. Nombres de claves: `ui.*`, `nav.*`, `role.<rol>` / `role.<rol>.plural`, `era.<n>.*`, `unit.<id>.name|desc`, `enemy.*`, `boss.*`, `power.*`, `relic.*`, `product.*`, `quest.*`, `ads.*`, y una familia por pantalla (`title, home, offline, map, prebattle, battle, pause, victory, defeat, upgrades, squad, shop, capsules, settings, story, consent, studio`). `tools/check_i18n.py` valida faltantes, duplicados, marcadores y que todo `*_key` de `data/` y `config/` exista. El archivo `i18n/strings.csv.import` (`importer="keep"`, versionado con `git add -f`) evita que Godot lo convierta en `.translation` y asi el CSV viaja tal cual en el export (ademas hay que incluir `*.json,*.csv` en el filtro de export de recursos no importados).
