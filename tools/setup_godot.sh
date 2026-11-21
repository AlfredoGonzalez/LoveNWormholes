#!/usr/bin/env bash
# Installs the pinned Godot version (headless-capable) into /opt/godot and links it as `godot`.
set -euo pipefail
V="${GODOT_VERSION:-4.6.1}"
mkdir -p /opt/godot && cd /opt/godot
curl -sSL -o g.zip "https://github.com/godotengine/godot/releases/download/${V}-stable/Godot_v${V}-stable_linux.x86_64.zip"
unzip -qo g.zip && rm g.zip
ln -sf "/opt/godot/Godot_v${V}-stable_linux.x86_64" /usr/local/bin/godot
godot --headless --version
