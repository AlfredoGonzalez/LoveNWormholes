# Guía de desarrollo

- Pruebas: `tools/check.sh` (importa, corre `tests/test_*.gd`, smoke). Debe terminar en `ALL OK`.
- Textos: `i18n/strings.csv` + `i18n/strings_<módulo>.tsv` (tab: key, en, es). `python3 tools/check_i18n.py`.
- Capturas de pantalla (revisión visual, con xvfb):
  `xvfb-run -a -s "-screen 0 540x960x24" godot --path . --rendering-method gl_compatibility --rendering-driver opengl3 --script res://tools/screenshots.gd`
  → `build/shots/*.png`.
- Simulador de balance: ver `docs/BALANCE.md`. Procesar arte: `docs/ART_PIPELINE.md`. APK de debug: `docs/ANDROID.md`.
