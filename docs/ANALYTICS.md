# Analytics (spec 8.6, 8.7)

All events go through `AnalyticsService.log_event(name, params)` (`src/core/analytics_service.gd`). Only the names in
`AnalyticsService.EVENTS` pass; anything else is dropped and recorded in `rejected`. Parameter keys that look personal
(`email`, `name`, `user_id`, `advertising_id`, `device_id`, ...) are dropped in `PII_KEYS` and recorded in
`dropped_keys`. The game never sends any of them: no account, name, email, contacts, location or device id.

Providers (`src/core/services/analytics_provider.gd`): `MockAnalyticsProvider` (memory; desktop, editor, tests) and
`FirebaseAnalyticsProvider` (`src/platform/android`, selected by `PlatformFactory` on Android when the feature flag
`native_services` is on; it flattens values to scalars, names <= 40 chars, string values <= 100 chars, no arrays).
The `analytics` feature flag (`config/feature_flags.json`) turns the whole service off.

## Consent gate
`ConsentService` -> `Game._on_consent_changed` -> `analytics.set_collection_allowed(accepted)`. When the player declines
(or has not chosen yet) the Firebase provider stops collecting (`setAnalyticsCollectionEnabled(false)`). The mock keeps
recording so tests can assert on events.

## Events
`ad_completed` in the product wording is the spec event `ad_rewarded` (it fires only from the SDK's earned-reward callback).

| Event | Params | Emitted from | When |
|---|---|---|---|
| `session_start` | `first_session` (bool), `lang` | `Game.start_services` | App start |
| `consent_set` (extra) | `state` (accepted / declined) | `ConsentService` | The player chooses or changes consent |
| `tutorial_step` | `step`, `index` | `tutorial_director.gd` via `AnalyticsService.tutorial_step` | Each tutorial step shown (`index` = position in `data/tutorial.json`); `step` = `skip` when the player skips it |
| `stage_start` | `stage`, `squad`, `powers`, `tries`, `food_boost` | `battle_screen.gd` | A battle starts (not on a Second Wind resume) |
| `stage_end` | `stage`, `result`, `duration`, `squad`, `tries`, `quit?` | `battle_screen.gd` | A battle ends or is quit |
| `power_used` | `power`, `stage`, `time` | `battle_screen.gd` | A hero power is cast |
| `unit_upgrade` | `kind` (unit / base / burrow / power), `id`, `level` | `Game._connect_analytics` (Economy signals) | Any Coin upgrade is bought |
| `ad_offered` | `placement` | `AdService.note_offered` via `MetaUI.refresh_ad_button` | An active ad button is shown (once per availability window) |
| `ad_started` | `placement` | `AdService.show_ad` | The player tapped the button and the ad is requested |
| `ad_rewarded` | `placement` | `AdService` (`rewarded` signal) | The reward was earned (persisted first) |
| `ad_failed` | `placement`, `reason` | `AdService` | The ad failed to show (no reward, nothing penalized) |
| `iap_view` | `product` | `shop_screen.gd` | The Shop opens: one event per real-money product shown (not logged on purchase) |
| `iap_purchase` | `product` | `BillingService` | A purchase was granted (once per purchase token) |
| `capsule_open` | `rarity`, `pity` | `capsule_screen.gd` (`AnalyticsService.capsule_open`) | A Time Capsule is opened |
| `era_unlocked` | `era` | `Game._connect_analytics` (after `battle_settled`) | The Era boss is cleared and the next Era unlocks |
| `daily_claim` (extra) | `streak` | `Game._connect_analytics` | Daily login claimed |
| `offline_claim` (extra) | `coins` | `Game._connect_analytics` | Worm Farm offline claim |

Placements: `double_coins`, `food_boost`, `second_wind`, `bonus_capsule`, `double_farm`.

Stuck-stage analysis (spec 8.6): `stage_end` with `tries` > 4 and `result` = lose.

## Play Data safety form (what to declare)
Keep the form consistent with this table and with `docs/spec.md` 8.7.

| Data | Collected | Why | Shared with |
|---|---|---|---|
| Device or other IDs (Advertising ID) | Yes, if consent accepted | Ads (AdMob), personalization | Google (AdMob) |
| App interactions (the events above) | Yes, if consent accepted | Analytics | Google (Firebase) |
| Purchase history | Yes | Play Billing handles purchases | Google Play |
| Crash logs / diagnostics | Only if Crashlytics is added later | Stability | Google |
| Name, email, location, contacts, files, photos | No | | |

Data is encrypted in transit; users can delete local data in Settings ("Delete my local data"); no account exists, so
there is no server-side data to delete. Audience 13+, not designed for children. Privacy policy URL: `config/app_links.json`.
