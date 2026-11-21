# Android debug build

## How it works
- `export_presets.cfg` holds the "Android" preset (package `com.am23studios.wormwarriors`, app name "Love 'n Wormholes", arm64-v8a + armeabi-v7a, debug output `build/lovenwormholes-debug.apk`). It contains no secrets or keystore paths.
- `tools/setup_android.sh` (idempotent) installs JDK 17, the Android SDK, the Godot export templates, creates `~/.android/debug.keystore` (outside the repo) and writes the SDK/JDK/keystore paths into `~/.config/godot/editor_settings-4.6.tres`.
- Export: run `tools/setup_android_gradle.sh` once, then `godot --headless --path . --export-debug "Android" build/lovenwormholes-debug.apk` (`build/` is git-ignored).
- CI: `.github/workflows/android-debug.yml` (manual `workflow_dispatch`) does the same and uploads the APK as an artifact.

## Pinned versions
| Item | Version |
|---|---|
| Godot + export templates | 4.6.1 stable |
| JDK | 17 (system openjdk-17 if present, else Temurin 17.0.13+11 into `/opt/jdk-17`) |
| Android cmdline-tools | 11076708 (11.0) |
| build-tools / platform | 35.0.1 / android-35 (the template's compileSdk) |
| Gradle template | AGP 8.6.1, NDK 28.1.13356709, Java 17 (from Godot 4.6.1) |
| Debug keystore | alias `androiddebugkey`, pass `android` (debug only, never for release) |

Override with env vars (`BUILD_TOOLS`, `PLATFORM`, `ANDROID_SDK_ROOT`, ...). Network hosts needed: `github.com` (Godot templates, Temurin), `dl.google.com` (SDK), `repo1.maven.org`/`dl.google.com/dl/android/maven2` (only for gradle builds).

## Gradle build (ON since Phase 3)
`export_presets.cfg`: `use_gradle_build=true`, `min_sdk="26"`, `target_sdk="36"`, permissions INTERNET and ACCESS_NETWORK_STATE.
- Godot 4.6.1's Android template defaults to compileSdk/targetSdk 35 (`config.gradle` inside `android_source.zip`: AGP 8.6.1, build-tools 35.0.1, NDK 28.1.13356709, Java 17). Google Play requires new apps and updates to target API 36 from 2026-08-31, so the preset sets 36. compileSdk stays 35 (the template's), which Gradle accepts with a warning. If Godot or Gradle rejects 36, set `target_sdk=""` (template default) and report it; before the first Play upload check the current requirement in Play Console.
- BILLING: there is no checkbox for it in Godot; the Play Billing library (inside the billing plugin AAR) merges `com.android.vending.BILLING` into the manifest. AdMob's library merges `com.google.android.gms.permission.AD_ID`. Verify the final list after the first gradle build: `$ANDROID_SDK_ROOT/build-tools/35.0.1/aapt2 dump permissions build/lovenwormholes-debug.apk` must show INTERNET, ACCESS_NETWORK_STATE, BILLING, AD_ID and nothing else.
- Install the template (once per machine and per Godot version): `tools/setup_android_gradle.sh` (unzips `android_source.zip` into `android/build`, writes `android/.build_version`; `android/build/` is git-ignored). In the editor it is Project > Install Android Build Template.
- The first Gradle build downloads Gradle, the NDK and the plugin dependencies (hosts: `dl.google.com`, `repo1.maven.org`, `plugins.gradle.org`). Only the first build is slow.
- Sandbox note: the environment this was prepared in blocks `dl.google.com` (HTTP 403 through the proxy), so the Android SDK could not be downloaded and **no Gradle APK was built there**. `tools/setup_android.sh`, `tools/setup_android_gradle.sh` and the CI workflow are ready; run them on a machine with normal internet. The template installer was tested locally (it unzips fine).

## Plugins (ads, purchases, analytics)
The game compiles and runs headless without any of them (`src/platform/android/*` looks classes and singletons up by name at
runtime, see `AddonBridge`). On Android with a plugin missing, ads never become ready, purchases fail with
`billing_unavailable` and analytics are not sent; the game never falls back to mock rewards. Mocks are used only off Android
(`PlatformFactory`), or on a device when the env var `LNW_MOCK_SERVICES` is set.

| Need | Plugin (decision by Alfredo, see PENDIENTES) | Adapter in the repo |
|---|---|---|
| Rewarded ads + UMP | poing-studios "Godot AdMob" v4+ (addon `addons/admob` + Android plugin `PoingGodotAdMob`) | `AdMobAdProvider`, `UmpConsentProvider` |
| Purchases | Official "Godot Google Play Billing" for Godot 4.2+ (addon `addons/GodotGooglePlayBilling`, singleton `GodotGooglePlayBilling`) | `PlayBillingProvider` |
| Analytics | A Firebase Analytics plugin exposing `logEvent(name, params)` and `setAnalyticsCollectionEnabled(bool)` (there is no official one) | `FirebaseAnalyticsProvider` (singleton names in `FIREBASE_SINGLETONS`) |

Install steps (each plugin):
1. Download the release that matches Godot 4.6 from the plugin's releases page. Check its README for its exact version.
2. Copy its `addons/<name>` folder into `addons/` and its `.aar` + `.gdap` files into `android/plugins/` (commit them: CI has no other source).
3. Enable the GDScript addon (Project Settings > Plugins) and, in Project > Export > Android, tick the plugin under "Plugins". The editor then writes `plugins/<Name>=true` into `export_presets.cfg`; commit it.
4. AdMob App ID: set it in the addon's settings (it injects `com.google.android.gms.ads.APPLICATION_ID` into the manifest). Use Google's test App ID `ca-app-pub-3940256099942544~3347511713` for debug and Alfredo's real one only for release. Do not add the meta-data by hand as well (duplicate manifest entries break the merge).
5. Firebase: put `google-services.json` where the chosen plugin says (never commit a real one unless Alfredo agrees; it is not secret but is project-specific).
6. Run `tools/setup_android_gradle.sh`; it lists which plugins and addons it found.

The adapter code follows each plugin's documented API but could not be exercised in the sandbox. First on-device pass:
- [ ] Debug build with the test App ID: `adb logcat -s godot` shows no "addon missing" warning.
- [ ] After clearing stage 3 and accepting consent, a rewarded test ad loads; tapping an ad button shows a Google test ad; closing early gives nothing; finishing gives the reward exactly once.
- [ ] Airplane mode: buttons show "Not available right now"; nothing blocks the game.
- [ ] Kill the app while an ad is on screen: no reward. Kill it right after the reward callback: the reward arrives on the next start (pending_rewards).
- [ ] Internal test track: buy `gems_80` with a licensed tester; gems granted once; kill before acknowledge and reopen: not granted twice; Restore purchases returns non-consumables.
- [ ] Decline consent: ads still load as non-personalized and no analytics reach Firebase DebugView.

Ad ids: `config/ads.json` -> `debug_test_ids` holds ONLY Google's official sample ids (app `ca-app-pub-3940256099942544~3347511713`, rewarded `ca-app-pub-3940256099942544/5224354917`; re-check the AdMob docs at build time). Debug builds and any release without `config/ads.prod.json` use them, so a missing production file can never serve real ads by accident. For release, create the untracked `config/ads.prod.json`:
```json
{
  "app_id_android": "ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY",
  "rewarded_android": "ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ",
  "placements_android": { "double_coins": "ca-app-pub-XXXXXXXXXXXXXXXX/AAAAAAAAAA" }
}
```
(`placements_android` is optional: one unit per placement; otherwise `rewarded_android` is used for all.)

## Known limits
- Portrait orientation comes from `project.godot` (`display/window/handheld/orientation`), owned by the lead; check it is `portrait` (1).
- Release builds (AAB, real keystore): `gradle_build/export_format=1` plus the upload key, a separate phase; never commit keystores or `ads.prod.json`.
- Debug builds are not "debuggable" for Play; never upload them.

## Install on a phone
1. Enable Developer options and USB debugging (or just allow "install unknown apps" for sideloading).
2. USB: `adb install -r build/lovenwormholes-debug.apk`
3. Sideload: copy the APK to the phone (Drive, cable) and open it, accepting the unknown-sources prompt.

## Measuring fps (checklist)
- [ ] Install on the lowest-end target device; close other apps, battery saver off, device not hot.
- [ ] Enable the in-game FPS overlay (or `Engine.get_frames_per_second()` label) in the debug build.
- [ ] Play a full battle with many units and effects on screen; note min/avg fps over 2 minutes.
- [ ] `adb logcat -s godot` to capture errors and warnings during the run.
- [ ] Optional: `adb shell dumpsys gfxinfo com.am23studios.wormwarriors framestats` for frame times.
- [ ] Record device model, Android version, renderer (Mobile vs Compatibility), fps results.
- [ ] Target: steady 60 fps on the low-end device; if not, compare Compatibility vs Mobile renderer.
