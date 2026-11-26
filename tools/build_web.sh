#!/usr/bin/env bash
# Exporta la build web a build/web y copia el video de intro que reproduce la pagina (web/shell.html).
set -euo pipefail
cd "$(dirname "$0")/.."
rm -rf build/web && mkdir -p build/web
godot --headless --path . --export-release "Web" build/web/index.html
cp web/studio_intro.mp4 web/studio_intro.webm build/web/
touch build/web/.nojekyll
echo "build/web listo (sirve con: python3 -m http.server -d build/web 8000)"
