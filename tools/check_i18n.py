#!/usr/bin/env python3
"""Validates i18n/strings.csv and the string keys referenced by data/*.json and config/*.json.

Fails (exit 1) when:
  - a key is missing or empty in en or es
  - a key appears twice
  - a {0}-style placeholder set differs between en and es
  - a "*_key" field (name_key, desc_key, ...) in data/config JSON points to an unknown key
  - a desc_key's highest placeholder does not match the length of the entry's desc_args
Usage: python3 tools/check_i18n.py [repo_root]
"""
import csv
import json
import re
import sys
from pathlib import Path

PLACEHOLDER = re.compile(r"\{(\d+)\}")


def load_strings(csv_path: Path, errors: list):
    rows = {}
    with open(csv_path, encoding="utf-8", newline="") as f:
        reader = csv.reader(f)
        header = next(reader, None)
        if header is None or [h.strip() for h in header[:3]] != ["key", "en", "es"]:
            errors.append(f"{csv_path}: header must be key,en,es (got {header})")
            return rows
        for lineno, row in enumerate(reader, start=2):
            if not row or all(not c.strip() for c in row):
                continue
            if len(row) != 3:
                errors.append(f"{csv_path}:{lineno}: expected 3 columns, got {len(row)} ({row[:1]})")
                continue
            key, en, es = row
            key = key.strip()
            if not key:
                errors.append(f"{csv_path}:{lineno}: empty key")
                continue
            if key in rows:
                errors.append(f"{csv_path}:{lineno}: duplicate key '{key}'")
                continue
            if not en.strip():
                errors.append(f"{csv_path}:{lineno}: key '{key}' has empty en")
            if not es.strip():
                errors.append(f"{csv_path}:{lineno}: key '{key}' has empty es")
            pe, ps = sorted(set(PLACEHOLDER.findall(en))), sorted(set(PLACEHOLDER.findall(es)))
            if pe != ps:
                errors.append(f"{csv_path}:{lineno}: key '{key}' placeholders differ en={pe} es={ps}")
            rows[key] = (en, es)
    return rows


def walk(node, path, out):
    """Collect (path, entry_dict, field, value) for every *_key string."""
    if isinstance(node, dict):
        for k, v in node.items():
            if k.endswith("_key") and isinstance(v, str):
                out.append((path, node, k, v))
            else:
                walk(v, f"{path}.{k}", out)
    elif isinstance(node, list):
        for i, v in enumerate(node):
            walk(v, f"{path}[{i}]", out)


def check_json_refs(root: Path, strings: dict, errors: list):
    files = sorted((root / "data").glob("*.json")) + sorted((root / "config").glob("*.json"))
    for jf in files:
        try:
            data = json.loads(jf.read_text(encoding="utf-8"))
        except Exception as e:  # noqa: BLE001
            errors.append(f"{jf}: invalid JSON ({e})")
            continue
        refs = []
        walk(data, jf.name, refs)
        for path, entry, field, key in refs:
            if key not in strings:
                errors.append(f"{path}.{field}: unknown string key '{key}'")
                continue
            if field in ("desc_key", "name_key"):
                args = entry.get("desc_args", [])
                want = len(args) if field == "desc_key" or "desc_args" in entry else 0
                got_set = {int(x) for x in PLACEHOLDER.findall(strings[key][0])}
                got = (max(got_set) + 1) if got_set else 0
                if field == "desc_key" and got != want:
                    errors.append(f"{path}.{field}: '{key}' uses {got} placeholders but desc_args has {want}")
                if field == "name_key" and got_set and "desc_args" not in entry:
                    errors.append(f"{path}.{field}: '{key}' has placeholders but the entry has no desc_args")


def main() -> int:
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parent.parent
    errors: list = []
    csv_path = root / "i18n" / "strings.csv"
    if not csv_path.exists():
        print(f"FAIL: {csv_path} not found")
        return 1
    strings = load_strings(csv_path, errors)
    check_json_refs(root, strings, errors)
    if errors:
        print("check_i18n FAILED:")
        for e in errors:
            print("  - " + e)
        return 1
    print(f"check_i18n OK ({len(strings)} keys, en+es complete, JSON references valid)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
