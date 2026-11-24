#!/usr/bin/env python3
"""Genera docs/ART_STATUS.md: una fila por prompt de docs/ART_PROMPTS.md con su estado.

Estados: integrado (ya existe en assets/ con el nombre final), en inbox (art-inbox/ lo tiene, falta procesar),
pendiente (aun no generado). Uso: python3 tools/art_status.py
"""
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LINE = re.compile(r"^([A-H]\d{2}) · (SPRITE SHEET 5x5|SPRITE|IMAGE) · (.*?)\. Save as (\S+?)\.?(?:\s|$)")


def have(rel: str) -> bool:
    return os.path.exists(os.path.join(ROOT, rel))


def inbox_names() -> set:
    names = set()
    for base, dirs, files in os.walk(os.path.join(ROOT, "art-inbox")):
        dirs[:] = [d for d in dirs if d != "legacy"]
        for f in files:
            names.add(os.path.splitext(f)[0].lower())
    return names


def main() -> None:
    inbox = inbox_names()
    rows = []
    for line in open(os.path.join(ROOT, "docs", "ART_PROMPTS.md"), encoding="utf-8"):
        m = LINE.match(line)
        if not m:
            continue
        aid, kind, title, path = m.groups()
        stem = os.path.splitext(os.path.basename(path))[0]
        if have(path) or have(path.replace("assets/sprites/", "assets/sprites/atlas/")):
            state = "integrado"
        elif stem.lower() in inbox:
            state = "en inbox"
        else:
            state = "pendiente"
        rows.append((aid, kind, title, path, state))
    done = sum(1 for r in rows if r[4] != "pendiente")
    out = ["# Estado del arte", "", "Generado por `python3 tools/art_status.py`. Prompts en `docs/ART_PROMPTS.md`.",
           "", "**%d de %d piezas listas o en inbox.**" % (done, len(rows)), "",
           "| ID | Tipo | Pieza | Guardar como | Estado |", "|---|---|---|---|---|"]
    for aid, kind, title, path, state in rows:
        out.append("| %s | %s | %s | `%s` | %s |" % (aid, kind.replace("SPRITE SHEET 5x5", "hoja 5x5").lower(), title, path, state))
    open(os.path.join(ROOT, "docs", "ART_STATUS.md"), "w", encoding="utf-8").write("\n".join(out) + "\n")
    print("%d piezas, %d listas o en inbox -> docs/ART_STATUS.md" % (len(rows), done))


if __name__ == "__main__":
    main()
