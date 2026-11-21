# Pendientes que dependen de Alfredo

| Fase | Pendiente | Estado |
|---|---|---|
| 0 | Probar el APK de debug en un Android real y medir fps (cuando haya APK) | abierto |
| 3 | Cuenta de AdMob, App ID e IDs de unidad rewarded de producción (`config/ads.prod.json`, sin versionar; formato en `docs/ANDROID.md`). Mientras tanto la app usa solo los IDs de prueba de Google | abierto |
| 3 | Cuenta de Google Play Console, app creada y productos dados de alta (`gems_80`, `gems_450`, `gems_1000`, `gems_2200`, `starter_pack`, `golden_pass`) | abierto |
| 3 | Elegir y descargar los plugins de Android (AdMob de poing-studios, Godot Google Play Billing y un plugin de Firebase Analytics), copiarlos a `addons/` y `android/plugins/` (pasos en `docs/ANDROID.md`) | abierto |
| 3 | Crear el proyecto Firebase y bajar `google-services.json` (analítica) | abierto |
| 3 | Correr `tools/setup_android.sh` y `tools/setup_android_gradle.sh` en una máquina con internet normal (el entorno de desarrollo bloquea `dl.google.com`, así que no se pudo compilar el APK con Gradle ahí) y hacer la lista de verificación en dispositivo (anuncios de prueba, compra de prueba, consentimiento) | abierto |
| 3 | Confirmar el `target_sdk` que exige Google Play al subir (el preset usa 36) | abierto |
| 3 | Revisar el texto de consentimiento (`i18n/strings_consent.tsv`) y la declaración de Data safety (tabla en `docs/ANALYTICS.md`) | abierto |
| 3 | URL de la política de privacidad: ponerla en `config/app_links.json` (`privacy_policy_url`); mientras esté vacía los botones de política se ocultan | abierto |
| 4 | Arte final de Gemini (hojas 5x5, fondos, bases, UI) en lotes | abierto |
| 4 | Elegir música y efectos finales entre los candidatos CC0 | abierto |
| 5 | Política de privacidad y sitio con app-ads.txt | abierto |
| 5 | Llave de subida (upload key), subir el AAB, pruebas cerradas | abierto |
| 6 | Mac o CI macOS y cuenta Apple Developer | abierto |
