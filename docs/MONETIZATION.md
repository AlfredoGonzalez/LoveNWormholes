# Monetización: diseño y cómo conectar lo real

## Principios
- **Cero anuncios forzados.** Solo hay anuncios *recompensados* que el jugador inicia tocando un botón. No hay interstitials ni banners.
- Sin pay-to-win agresivo: las gemas compran comodidad (revivir, cambiar por monedas); lo cosmético llegará con el Álbum.

## Dónde aparece cada cosa
| Placement | Dónde | Recompensa |
|---|---|---|
| `double_reward` | Pantalla de victoria | Duplica las monedas ganadas |
| `revive` | Pantalla de derrota (1 vez por batalla) | Hogar al 50 %, héroe de vuelta, enemigos cercanos despejados |
| `energy_boost` | Botón en batalla (1 vez por batalla) | Energía x2 durante 30 s |
| `free_chest` | Tienda (cada 4 h) | 50-150 monedas, 20 % de 5 gemas |

Alternativa sin anuncio: revivir con 💎10, cambiar 💎10 → 🪙300.

## Productos IAP (ids a crear en App Store Connect / Google Play / RevenueCat)
| id | Tipo | Contenido | Precio ref. |
|---|---|---|---|
| `gems_s` | Consumible | 100 💎 | $0.99 |
| `gems_m` | Consumible | 600 💎 | $4.99 |
| `gems_l` | Consumible | 1500 💎 | $9.99 |
| `starter` | No consumible | 500 🪙 + 50 💎 (una vez) | $2.99 |
| `double_coins` | No consumible | Monedas x2 en victorias, para siempre | $3.99 |

Los precios de `src/game/economy.ts` (`PRODUCTS`) son solo de referencia: en producción se muestran los precios localizados de la tienda.

## Arquitectura
`src/services/types.ts` define `Ads`, `IAP`, `Consent`, `Analytics`. `src/services/index.ts` exporta `services` (hoy simulados, en `src/services/mock/`). Las escenas solo usan `services.*`; el estado de compra vive en el guardado (`owned`, `gems`, `chestReadyAt`, `consent`) y la lógica de entrega es pura y está probada (`applyPurchase`, `restoreOwned`, `openChest`, …).

## Hito 5: conectar lo real (cuando existan las cuentas)
1. `npm i @capacitor/core @capacitor/cli @capacitor-community/admob @revenuecat/purchases-capacitor` y `npx cap add android ios`.
2. **Ads** (`@capacitor-community/admob`): `AdMob.initialize()`, `prepareRewardVideoAd({adId})` → `showRewardVideoAd()`; resolver `true` solo al recibir el evento `Rewarded`. Usar los **IDs de prueba de Google** durante el desarrollo.
3. **IAP** (`@revenuecat/purchases-capacitor`): `Purchases.configure({apiKey})`; `purchase(id)` → `Purchases.purchaseStoreProduct`/`purchasePackage`; `restore()` → `Purchases.restorePurchases()` y devolver los entitlements activos. Crear los productos con los ids de la tabla.
4. **Consentimiento**: Android/UE con UMP (`AdMob.requestConsentInfo` / `showConsentForm`); iOS con ATT (`AdMob.requestTrackingAuthorization`). Mapear a `ConsentState` (`personalized` si se permite seguimiento, `limited` si no).
5. **Analytics**: Firebase Analytics (`@capacitor-firebase/analytics`) implementando `Analytics.track`.
6. En `src/main.ts`: `if (Capacitor.isNativePlatform()) setServices(createNativeServices())`.
7. Política de privacidad pública (URL), cuestionario de clasificación por edad y declaración de anuncios/IAP en ambas tiendas.
