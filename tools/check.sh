#!/usr/bin/env bash
# Runs unit tests and the smoke test headless. Fails on any non-zero exit or engine error output.
set -u
cd "$(dirname "$0")/.."
GODOT="${GODOT:-godot}"
status=0
run() {
  local out; out=$("$GODOT" --headless --path . "$@" 2>&1); local rc=$?
  echo "$out"
  if [ $rc -ne 0 ] || echo "$out" | grep -qE "^(ERROR|SCRIPT ERROR|USER ERROR)|Parse Error"; then status=1; fi
}
echo "== import"; run --import --quit
echo "== unit tests"; run --script res://tools/run_tests.gd
echo "== smoke"; run --script res://tools/smoke_test.gd
if python3 -c "import PIL, numpy, pytest" >/dev/null 2>&1; then
  echo "== sprite pipeline (python)"
  out=$(python3 -m pytest -q -p no:cacheprovider tools/tests_py 2>&1) || status=1
  echo "$out" | tail -3
else
  echo "== sprite pipeline (python): skipped (pip install pillow numpy pytest)"
fi
[ $status -eq 0 ] && echo "ALL OK" || echo "CHECK FAILED"
exit $status
