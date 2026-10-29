# Publicar en Android e iOS

## Estado actual (Hito 5)
- Proyectos nativos listos: `android/` y `ios/` (Capacitor 8), orientación **vertical** bloqueada en ambos.
- Servicios reales implementados (`src/services/native/`): **AdMob** (anuncios recompensados + consentimiento UMP + ATT en iOS) y **RevenueCat** (compras). En navegador siguen los simulados.
- Hoy están configurados **IDs de PRUEBA** de Google; sin la clave de RevenueCat las compras siguen simuladas.
- CI: `android.yml` compila un APK de depuración; `ios.yml` compila para simulador sin firmar; `pages.yml` publica la demo web.
- Política de privacidad (borrador): `public/privacy.html` → `https://alfredogonzalez.github.io/LoveNWormholes/privacy.html`. **Reemplaza `[TU-CORREO-DE-CONTACTO]`.**

## Lo que necesitas hacer tú (no lo puedo hacer yo)
1. **Cuentas**: Google Play Console (25 USD, una vez) y Apple Developer Program (99 USD/año). La verificación puede tardar días.
2. **Identificador de la app**: hoy `com.lovenwormholes.game` (en `capacitor.config.ts`, `android/app/build.gradle` y el proyecto Xcode). Cámbialo ANTES del primer envío si quieres otro; después no se puede.
3. **AdMob** (admob.google.com): crea la app Android y la iOS, y un bloque de anuncios *Recompensado* en cada una. Copia:
   - IDs de aplicación → `AndroidManifest.xml` (`com.google.android.gms.ads.APPLICATION_ID`) y `Info.plist` (`GADApplicationIdentifier`).
   - IDs de bloque → `.env.production`: `VITE_ADMOB_REWARDED_ANDROID=...`, `VITE_ADMOB_REWARDED_IOS=...`, `VITE_ADS_TESTING=false`.
   - Configura el mensaje de consentimiento (UMP) en AdMob → Privacidad y mensajería.
4. **RevenueCat** (revenuecat.com, plan gratuito): crea el proyecto, conecta las dos tiendas y agrega los 5 productos de `docs/MONETIZATION.md` (mismos ids en ambas tiendas; `gems_*` consumibles, `starter` y `double_coins` no consumibles). Pon las claves públicas en `.env.production`: `VITE_RC_KEY_ANDROID=goog_...`, `VITE_RC_KEY_IOS=appl_...`.
5. **Firma**:
   - Android: genera un keystore (`keytool`) y guárdalo a salvo (¡si lo pierdes no podrás actualizar la app!). Usa Play App Signing.
   - iOS: certificado de distribución y perfil de aprovisionamiento en Apple Developer; o `fastlane match`.
   Cuando tengas esto puedo añadir workflows de *release* que suban a Play (pista interna) y TestFlight con los secretos en GitHub.
6. **Fichas de tienda**: textos ES/EN, capturas verticales (iOS 1290×2796, Android 1080×1920), ícono 1024×1024, gráfico 1024×500 (Play), URL de privacidad, cuestionario de clasificación por edad y **declaración de anuncios/compras** (Data safety en Play, App Privacy en App Store).
7. **Público objetivo**: el juego es «tierno» y puede atraer niños. Si lo declaras para menores de 13 aplican las políticas de Familias/COPPA (anuncios y datos muy restringidos). La política actual asume **13+**; decide esto antes de rellenar los cuestionarios.

## Comandos útiles
```bash
npm run cap:sync          # compila la web y copia a android/ e ios/
npx cap open android      # abre Android Studio
npx cap open ios          # abre Xcode (solo macOS)
cd android && ./gradlew assembleDebug   # APK de depuración (necesita Android SDK)
```

## Pruebas en dispositivo (con IDs de prueba)
- Android: instala el APK de depuración (artefacto del workflow *Android build*). Los anuncios mostrarán «Test Ad». Las compras requieren la clave de RevenueCat + productos creados en Play Console y la app en una pista de pruebas.
- iOS: necesita Xcode + cuenta (aunque sea gratuita para probar en tu iPhone) o TestFlight.

## Pendientes conocidos
- Íconos y *splash* de la app (hoy los de Capacitor): cuando tengas el arte, `npx @capacitor/assets generate`.
- Analítica real (Firebase) requiere `google-services.json` / `GoogleService-Info.plist`; hoy se registra en memoria.
- Guardado en la nube / restaurar progreso al cambiar de dispositivo: no incluido todavía.
