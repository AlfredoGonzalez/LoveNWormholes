# Android debug build

## How it works
- `export_presets.cfg` holds the "Android" preset (package `com.am23studios.wormwarriors`, app name "Love 'n Wormholes", arm64-v8a + armeabi-v7a, debug output `build/lovenwormholes-debug.apk`). It contains no secrets or keystore paths.
- `tools/setup_android.sh` (idempotent) installs JDK 17, the Android SDK, the Godot export templates, creates `~/.android/debug.keystore` (outside the repo) and writes the SDK/JDK/keystore paths into `~/.config/godot/editor_settings-4.6.tres`.
- Export: `godot --headless --path . --export-debug "Android" build/lovenwormholes-debug.apk` (`build/` is git-ignored).
- CI: `.github/workflows/android-debug.yml` (manual `workflow_dispatch`) does the same and uploads the APK as an artifact.

## Pinned versions
| Item | Version |
|---|---|
| Godot + export templates | 4.6.1 stable |
| JDK | 17 (system openjdk-17 if present, else Temurin 17.0.13+11 into `/opt/jdk-17`) |
| Android cmdline-tools | 11076708 (11.0) |
| build-tools / platform | 35.0.1 / android-35 |
| Debug keystore | alias `androiddebugkey`, pass `android` (debug only, never for release) |

Override with env vars (`BUILD_TOOLS`, `PLATFORM`, `ANDROID_SDK_ROOT`, ...). Network hosts needed: `github.com` (Godot templates, Temurin), `dl.google.com` (SDK), `repo1.maven.org`/`dl.google.com/dl/android/maven2` (only for gradle builds).

## Known limits
- Gradle build is OFF. With gradle off the min SDK is the template default (24, Android 7); the "Min SDK 26" setting only applies when gradle build is ON. Phase 3 AdMob/Billing plugins need gradle build ON (then set `gradle_build/use_gradle_build=true`, `gradle_build/min_sdk="26"`, install the Android build template, and the setup script must also provide Gradle dependencies).
- Portrait orientation comes from `project.godot` (`display/window/handheld/orientation`), owned by the lead; check it is `portrait` (1).
- Release builds (AAB, real keystore) are a separate phase; never commit keystores.

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
