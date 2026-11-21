#!/usr/bin/env bash
# Idempotent: prepares the project for a Gradle Android build (export_presets.cfg has use_gradle_build=true).
#  1. installs the Android build template (android/build) from the Godot export templates, the same thing
#     "Project > Install Android Build Template" does in the editor;
#  2. reports which Android plugins (.aar/.gdap in android/plugins) and addons (addons/) are present.
# Run tools/setup_android.sh first (JDK, SDK, export templates, debug keystore). Needs no network itself;
# the Gradle build later downloads Gradle, the NDK and the plugin dependencies (dl.google.com, repo1.maven.org,
# dl.google.com/dl/android/maven2, plugins.gradle.org).
# Override with env vars: GODOT_VERSION, TPL_DIR.
set -euo pipefail
cd "$(dirname "$0")/.."
GODOT_VERSION="${GODOT_VERSION:-4.6.1}"
TPL_DIR="${TPL_DIR:-$HOME/.local/share/godot/export_templates/${GODOT_VERSION}.stable}"
SRC="$TPL_DIR/android_source.zip"
log() { echo "[setup_android_gradle] $*"; }

if [ ! -f "$SRC" ]; then
  log "ERROR: $SRC not found. Run tools/setup_android.sh first (installs the Godot export templates)."
  exit 1
fi

if [ -f android/build/build.gradle ] && [ "$(cat android/.build_version 2>/dev/null)" = "${GODOT_VERSION}.stable" ]; then
  log "build template already installed (android/build, ${GODOT_VERSION}.stable)"
else
  log "installing the Android build template into android/build"
  rm -rf android/build
  mkdir -p android/build
  unzip -q "$SRC" -d android/build
  echo "${GODOT_VERSION}.stable" > android/.build_version
  touch android/build/.gdignore   # keeps Godot from importing the template as project resources
fi

mkdir -p android/plugins
plugins=$(find android/plugins -maxdepth 1 \( -name '*.aar' -o -name '*.gdap' \) | sort || true)
if [ -n "$plugins" ]; then
  log "Android plugins found in android/plugins:"; echo "$plugins" | sed 's/^/    /'
else
  log "WARNING: no Android plugins in android/plugins. The game builds and runs, but ads, purchases and Firebase"
  log "         analytics stay unavailable. See docs/ANDROID.md, section 'Plugins'."
fi
for a in addons/admob addons/GodotGooglePlayBilling; do
  if [ -d "$a" ]; then log "addon present: $a"; else log "addon missing: $a (see docs/ANDROID.md)"; fi
done
log "done. Export: godot --headless --path . --export-debug \"Android\" build/lovenwormholes-debug.apk"
