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
| `consent` | `src/meta/consent_screen.gd` | `{next, next_params, from}` | `title` (arranque), `settings` (re-abrir) |
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

---
# Fase 3 – Tienda

| Pieza | Archivo | Notas |
|---|---|---|
| `Shop` | `src/core/shop.gd` (`Game.shop`) | Lógica sin UI: catálogo (`data/shop.json`), `price_text(id)` (precio localizado del provider; si viene vacío, referencia USD de `price_usd`), `buy`, `restore`, `apply_grants`, `golden_pass_active()`/`ads_removed()`, `offline_extra_hours()`, `buy_gem_item()` |
| `ShopScreen` | `src/meta/shop_screen.gd` (ruta `shop`) | Destacados (Starter Pack, Golden Pass), hueco de Cápsulas, packs de gemas, ítems de gemas, skins, gratis (regalo diario, Cápsula Extra), Restaurar compras. Params: `{from}` |

- **Flujo de compra**: `Shop.buy` → `BillingService.purchase` → el provider emite `purchased(id, token)` (o `failed(id, "pending")` si queda pendiente) →
  `BillingService` registra el token en `purchases_granted` (y `owned_products` si es no consumible) → emite `purchase_granted` → `Shop`
  suma el contenido (monedas vía `Economy.add_bundle` sin guardar; `cosmetics`/`skins`/`entitlements` como listas únicas en el perfil) →
  `BillingService` guarda y recién entonces hace `acknowledge`. Un token ya registrado solo se reconoce (nunca se concede dos veces),
  así que la re-entrega tras un cierre es idempotente. `Game.start_services` llama `billing.start()` (initialize + restore).
- **Pendiente**: `Shop.pending[id]` mientras el store lo reporta; la tarjeta muestra "Compra pendiente..." y no se puede volver a comprar.
  Al completarse llega el `purchased` normal.
- **Errores**: `failed` con motivo de cancelación -> "cancelled", de red (`network_error`, `service_unavailable`, ...) -> "network", resto -> "failed";
  `Shop.purchase_error(id, kind)` y la pantalla muestra el mensaje ("No se te cobró"). Nunca se concede nada.
- **Reembolso**: nuevo `BillingProvider.refunded(id)` / `BillingService.purchase_refunded`: el no consumible deja de estar en `owned_products`
  (el Golden Pass se apaga); las gemas/cápsulas ya entregadas no se retiran y los tokens se conservan.
- **Restaurar**: `Shop.restore()` / botón de la tienda (y de Ajustes): concede una vez cada no consumible poseído (token `restored:<id>`).
- **"Quitar anuncios"**: el spec no tiene esa compra (no hay banners ni interstitials, R11). El equivalente es el **Golden Pass**:
  los bonos de anuncios recompensados se aplican sin ver el anuncio, los botones de anuncio se sustituyen por un reclamo directo
  (hoy: Cápsula Extra en la Tienda, 1 por día) y +`offline.golden_pass_bonus_hours` h al tope de la Granja (Home ya lo usa vía `Game.shop.offline_extra_hours()`).
- **Gemas**: el único ítem es el espacio extra de preajuste de escuadrón (`gem_items`, 200 gemas, hasta `squad.presets_max`). Las Cápsulas por gemas pertenecen a la pantalla `capsules`.
- **Cápsulas**: la tienda deja `_build_capsules_slot()`, que solo dibuja la tarjeta si `Navigator.can_go("capsules")` y navega a `capsules` con `{from: "shop"}`.
- **Navegación**: Home ya traía el botón Tienda (se desbloquea tras la etapa 4); la pantalla de Resultado añade un atajo "Tienda" tras la etapa 4.
- Textos nuevos en `i18n/strings_shop.tsv` (los de producto ya estaban en `strings.csv`).
- `MockBillingProvider`: `prices` (id -> texto localizado, vacío por defecto => precio de referencia), `refund(id)`.

**Golden Pass en los 5 puntos de anuncio**: todos los botones llaman a `Game.claim_bonus(placement, reward)`; con el pase llama a `AdService.grant_without_ad` (mismo flujo persistir-primero/entrega única, sin anuncio ni límites de anuncio) y si no, a `show_ad`. `MetaUI.refresh_ad_button` muestra el botón activo con ★ aunque no haya anuncio cargado. `double_farm` lleva `extra_hours` en el reward y `Quests.apply_reward` lo usa. `iap_view` se emite al abrir la Tienda (por producto mostrado), no al comprar.

Pendiente: mostrar skins/gorras equipados (solo se guardan en `profile.skins` / `profile.cosmetics`); proveedores reales de Android/iOS.
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
# Fase 3 — anuncios, consentimiento, analítica y Android (contrato)

- Orden de arranque: intro del estudio, `consent` (solo si `Game.consent.needs_prompt()`), `title`. Re-abrir desde Ajustes > Opciones de privacidad.
- `ConsentService` (`Game.consent`, estado en `profile.consent`: `unknown | accepted | declined`, `version`, `updated_at`) sobre `ConsentProvider` (mock / `UmpConsentProvider`). Los anuncios no se inicializan ni cargan hasta que el estado esté resuelto (`Game._try_start_ads`).
- Selección de implementaciones: `PlatformFactory` (`src/platform/platform_factory.gd`): mock salvo en Android con el flag `native_services` (adaptadores en `src/platform/android/`, sin referencias estáticas a plugins; compilan en headless).
- `AdService`: solo rewarded; límites `daily_cap` / `cooldown_s` por colocación y `global_cooldown_s` (`config/ads.json`), contadores en `profile.seen.ad_limits`; `note_offered` registra `ad_offered`.
- Analítica: tabla de eventos y Data safety en `docs/ANALYTICS.md`. Android: `docs/ANDROID.md`.

## Audio

`AudioService` (`src/core/audio_service.gd`, child of the `Game` autoload) reads the catalog `data/audio.json`
(id -> file, bus, volume, cooldown, duck_db; plus `music_map` screen/era -> track). Missing files fall back to
sounds synthesized in code (SFX recipes and 10 music recipes: menu, map, battle_1..5, boss, victory, defeat), so
nothing is mute. Buses `Music`/`SFX` are created at runtime and follow the Settings volumes and mute. Music
crossfades on screen change (`Game.nav.changed`), era battle start and boss spawn; stingers and boss warnings duck
the music; SFX use a pool of `max_voices` slots with per-id cooldowns. `UI.button` plays `ui_tap`. How to swap in
real files: `docs/AUDIO_CANDIDATES.md`.
# Fase 4 – Historia, tutorial y créditos
| Pieza | Archivo | Notas |
|---|---|---|
| `Story` | `src/core/story.gd`, `data/story.json` | Secuencias de paneles (`intro`, `era_N_open`, `era_N_close`, `ending`), flags en `profile.seen["story"]`, rutas `route` / `before_battle` / `after_battle`, `replay_ids` sin spoilers |
| `StoryScreen` | `src/meta/story_screen.gd` (ruta `story`) | Params `{seq, next, next_params}`; `seq: "replay"` reproduce lo desbloqueado (Ajustes > Ver historia). Saltar siempre visible. Arte: cada panel tiene `art` (id del manifest, p. ej. `story_intro_1`); sin arte muestra color + caption |
| `Tutorial` | `src/core/tutorial.gd`, `data/tutorial.json` | Pasos de 1-1..1-3 y flags en `profile.seen["tutorial"] = {armed, skipped, steps}`. Se arma al ver/saltar la intro; no se muestra en etapas ya superadas |
| `TutorialDirector` / `TutorialOverlay` | `src/battle/tutorial_director.gd`, `tutorial_overlay.gd` | Capa de UI sobre la batalla: solo LEE `BattleSim`; bloquea el reloj con `BattleScreen.tutorial_hold` y usa `press_card/press_power`. Analítica `tutorial_step` |
| `CreditsScreen` | `src/meta/credits_screen.gd` (ruta `credits`) | Ajustes > Créditos; lista de licencias de `assets/audio/CREDITS.md` |

Flujo: Título > (consentimiento) > intro > Home. Comic de apertura al empezar la etapa 1 de cada era (`PreBattleScreen.start_battle`), comic de cierre tras ganar el jefe (antes de `result`, en `BattleScreen._finish`), final cuando `profile.progress.game_completed` (lo comprueba `HomeScreen._ready`; tolerante si el flag no existe). Los comics de era solo se activan si el perfil ya pasó por la intro (`profile.seen` tiene `story`).
