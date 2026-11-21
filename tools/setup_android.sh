#!/usr/bin/env bash
# Idempotent Android debug-export setup for Linux (local dev box or CI).
# Installs: JDK 17, Android SDK (cmdline-tools, platform-tools, build-tools, platform),
# Godot export templates, a debug keystore (outside the repo) and Godot editor settings.
# Override with env vars: GODOT_VERSION, ANDROID_SDK_ROOT, JDK_DIR, BUILD_TOOLS, PLATFORM, CMDLINE_TOOLS.
set -euo pipefail

GODOT_VERSION="${GODOT_VERSION:-4.6.1}"
BUILD_TOOLS="${BUILD_TOOLS:-35.0.1}"
PLATFORM="${PLATFORM:-35}"
CMDLINE_TOOLS="${CMDLINE_TOOLS:-11076708}"
SDK="${ANDROID_SDK_ROOT:-/opt/android-sdk}"
JDK_DIR="${JDK_DIR:-/opt/jdk-17}"
TEMURIN_URL="${TEMURIN_URL:-https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.13%2B11/OpenJDK17U-jdk_x64_linux_hotspot_17.0.13_11.tar.gz}"
TPL_URL="https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_export_templates.tpz"
TPL_DIR="$HOME/.local/share/godot/export_templates/${GODOT_VERSION}.stable"
KEYSTORE="$HOME/.android/debug.keystore"
SETTINGS_DIR="$HOME/.config/godot"
SETTINGS="$SETTINGS_DIR/editor_settings-${GODOT_VERSION%.*}.tres"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
SUDO=""; [ "$(id -u)" -ne 0 ] && SUDO="sudo"
log() { echo "[setup_android] $*"; }

# ---- 1. JDK 17 -------------------------------------------------------------
java_major() { "$1" -version 2>&1 | sed -n 's/.*version "\([0-9]*\).*/\1/p' | head -1; }
JAVA_HOME_DIR=""
for cand in "${JAVA_HOME:-}" /usr/lib/jvm/java-17-openjdk-amd64 "$JDK_DIR"; do
  if [ -n "$cand" ] && [ -x "$cand/bin/java" ] && [ "$(java_major "$cand/bin/java")" = "17" ] && [ -x "$cand/bin/jarsigner" ]; then
    JAVA_HOME_DIR="$cand"; break
  fi
done
if [ -z "$JAVA_HOME_DIR" ]; then
  log "installing JDK 17 into $JDK_DIR (Temurin)"
  $SUDO mkdir -p "$JDK_DIR"
  curl -fsSL -o "$TMP/jdk.tgz" "$TEMURIN_URL"
  $SUDO tar -xzf "$TMP/jdk.tgz" -C "$JDK_DIR" --strip-components=1
  JAVA_HOME_DIR="$JDK_DIR"
fi
log "JDK 17 at $JAVA_HOME_DIR"
export JAVA_HOME="$JAVA_HOME_DIR" PATH="$JAVA_HOME_DIR/bin:$PATH"

# ---- 2. Android SDK --------------------------------------------------------
sdk_ok() { [ -x "$SDK/platform-tools/adb" ] && [ -d "$SDK/build-tools/$BUILD_TOOLS" ] && [ -d "$SDK/platforms/android-$PLATFORM" ] && [ -x "$SDK/cmdline-tools/latest/bin/sdkmanager" ]; }
if ! sdk_ok; then
  log "installing Android SDK into $SDK"
  $SUDO mkdir -p "$SDK/cmdline-tools"; $SUDO chown -R "$(id -u):$(id -g)" "$SDK"
  if [ ! -x "$SDK/cmdline-tools/latest/bin/sdkmanager" ]; then
    curl -fsSL -o "$TMP/cmdline.zip" "https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS}_latest.zip"
    unzip -q "$TMP/cmdline.zip" -d "$TMP/cl"
    rm -rf "$SDK/cmdline-tools/latest"; mv "$TMP/cl/cmdline-tools" "$SDK/cmdline-tools/latest"
  fi
  yes | "$SDK/cmdline-tools/latest/bin/sdkmanager" --sdk_root="$SDK" --licenses >/dev/null || true
  "$SDK/cmdline-tools/latest/bin/sdkmanager" --sdk_root="$SDK" \
    "platform-tools" "build-tools;$BUILD_TOOLS" "platforms;android-$PLATFORM"
fi
log "Android SDK ok at $SDK"

# ---- 3. Godot export templates ---------------------------------------------
if [ ! -f "$TPL_DIR/android_debug.apk" ] && [ ! -f "$TPL_DIR/android_source.zip" ]; then
  log "installing Godot $GODOT_VERSION export templates"
  curl -fsSL -o "$TMP/templates.tpz" "$TPL_URL"
  unzip -q "$TMP/templates.tpz" -d "$TMP/tpl"
  mkdir -p "$TPL_DIR"; cp -r "$TMP/tpl/templates/." "$TPL_DIR/"
fi
log "export templates at $TPL_DIR"

# ---- 4. Debug keystore (outside the repo) ----------------------------------
if [ ! -f "$KEYSTORE" ]; then
  log "creating debug keystore $KEYSTORE"
  mkdir -p "$(dirname "$KEYSTORE")"
  keytool -genkeypair -v -keystore "$KEYSTORE" -storepass android -keypass android \
    -alias androiddebugkey -keyalg RSA -keysize 2048 -validity 10000 \
    -dname "CN=Android Debug,O=Android,C=US" >/dev/null
fi

# ---- 5. Godot editor settings ----------------------------------------------
mkdir -p "$SETTINGS_DIR"
[ -f "$SETTINGS" ] || printf '[gd_resource type="EditorSettings" format=3]\n\n[resource]\n' > "$SETTINGS"
set_setting() { # key value(already godot-quoted)
  if grep -q "^$1 = " "$SETTINGS"; then sed -i "s|^$1 = .*|$1 = $2|" "$SETTINGS"; else printf '%s = %s\n' "$1" "$2" >> "$SETTINGS"; fi
}
set_setting export/android/android_sdk_path "\"$SDK\""
set_setting export/android/java_sdk_path "\"$JAVA_HOME_DIR\""
set_setting export/android/debug_keystore "\"$KEYSTORE\""
set_setting export/android/debug_keystore_user "\"androiddebugkey\""
set_setting export/android/debug_keystore_pass "\"android\""
set_setting export/android/force_system_user "false"
set_setting export/android/shutdown_adb_on_exit "true"
log "editor settings written to $SETTINGS"
log "done. Export: godot --headless --path . --export-debug \"Android\" build/lovenwormholes-debug.apk"
