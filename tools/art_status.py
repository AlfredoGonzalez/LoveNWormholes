#!/usr/bin/env python3
"""Genera docs/ART_STATUS.md: una fila por prompt de docs/art-prompts/fase-*.md con su estado.

Estados: integrado (ya esta en assets/ o en el manifest), en inbox (art-inbox/ lo tiene, falta procesar),
pendiente (aun no generado). Cada prompt declara su archivo esperado en la linea `- **Archivo de salida:**`
y, si aplica, una variante (lienzo normal o doble `_x2`) en `- **Archivo con lienzo ...:**`; vale cualquiera.
Las referencias `<id>_ref.png` no entran al juego: cuentan como "en inbox" si estan en art-inbox/ y como
"integrado" si estan en art-refs/ (o en cualquier carpeta de assets/).
Uso: python3 tools/art_status.py
"""
import glob
import json
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PROMPT_DIR = os.path.join(ROOT, "docs", "art-prompts")
HEAD = re.compile(r"^### ([A-H]-\d{3}) · (.*)$")
FIELD = re.compile(r"^- \*\*([^:*]+):\*\* (.*)$")
FILE_RE = re.compile(r"`([^`]+\.(?:png|jpg|jpeg|webp))`")
SHEET_RE = re.compile(r"^(.*)_(idle|walk|attack|hurt|defeat|cast_slam|cast_power|celebrate)(?:_x2)?_sheet$")
PHASE_TITLES = {}


def stems_under(*rel_dirs, skip=()):
    names = set()
    for rel in rel_dirs:
        for base, dirs, files in os.walk(os.path.join(ROOT, rel)):
            dirs[:] = [d for d in dirs if d not in skip]
            for f in files:
                names.add(os.path.splitext(f)[0].lower())
    return names


def load_manifest():
    try:
        return json.load(open(os.path.join(ROOT, "assets", "manifest.json"), encoding="utf-8")).get("sprites", {})
    except (OSError, ValueError):
        return {}


def parse_prompts():
    items = []
    for path in sorted(glob.glob(os.path.join(PROMPT_DIR, "fase-*.md"))):
        phase = None
        cur = None
        for line in open(path, encoding="utf-8"):
            line = line.rstrip("\n")
            if line.startswith("# Fase "):
                phase = line[len("# Fase "):len("# Fase ") + 1]
                PHASE_TITLES[phase] = line.split(":", 1)[1].strip() if ":" in line else ""
            m = HEAD.match(line)
            if m:
                cur = {"id": m.group(1), "title": m.group(2), "phase": m.group(1)[0], "files": [], "type": ""}
                items.append(cur)
                continue
            if cur is None:
                continue
            f = FIELD.match(line)
            if not f:
                continue
            name, val = f.groups()
            if name == "Tipo":
                cur["type"] = val
            elif name == "Archivo de salida" or name.startswith("Archivo con lienzo"):
                cur["files"] += FILE_RE.findall(val)
    return items


def kind_of(it):
    t = it["type"].lower()
    if t.startswith("referencia"):
        return "ref"
    if t.startswith("hoja"):
        return "hoja"
    return "estático"


def state_of(it, assets, inbox, refs, manifest):
    stems = [os.path.splitext(f)[0].lower() for f in it["files"]]
    k = kind_of(it)
    if k == "ref":
        if any(s in refs or s in assets for s in stems):
            return "integrado"
        return "en inbox" if any(s in inbox for s in stems) else "pendiente"
    for s in stems:
        if s in assets:
            return "integrado"
        m = SHEET_RE.match(s)
        if m and m.group(1) in manifest and ('"%s"' % m.group(2)) in json.dumps(manifest[m.group(1)]):
            return "integrado"
    return "en inbox" if any(s in inbox for s in stems) else "pendiente"


def main() -> None:
    items = parse_prompts()
    assets = stems_under("assets/sprites", "assets/images")
    inbox = stems_under("art-inbox", skip=("legacy",))
    refs = stems_under("art-refs") if os.path.isdir(os.path.join(ROOT, "art-refs")) else set()
    manifest = load_manifest()
    for it in items:
        it["state"] = state_of(it, assets, inbox, refs, manifest)
        it["file"] = it["files"][0] if it["files"] else "?"
    phases = sorted({it["phase"] for it in items})
    done = sum(1 for it in items if it["state"] != "pendiente")
    out = ["# Estado del arte", "",
           "Generado por `python3 tools/art_status.py`. Prompts en `docs/art-prompts/` (ver su `README.md`).", "",
           "**%d de %d piezas listas o en inbox.**" % (done, len(items)), "",
           "| Fase | Contenido | Total | Integrado | En inbox | Pendiente |", "|---|---|---|---|---|---|"]
    tot = [0, 0, 0, 0]
    for ph in phases:
        sub = [i for i in items if i["phase"] == ph]
        c = [len(sub)] + [sum(1 for i in sub if i["state"] == s) for s in ("integrado", "en inbox", "pendiente")]
        tot = [a + b for a, b in zip(tot, c)]
        out.append("| %s | %s | %d | %d | %d | %d |" % (ph, PHASE_TITLES.get(ph, ""), *c))
    out.append("| | **Total** | **%d** | **%d** | **%d** | **%d** |" % tuple(tot))
    for ph in phases:
        out += ["", "## Fase %s: %s" % (ph, PHASE_TITLES.get(ph, "")), "",
                "| ID | Tipo | Pieza | Archivo esperado | Estado |", "|---|---|---|---|---|"]
        for it in items:
            if it["phase"] == ph:
                out.append("| %s | %s | %s | `%s` | %s |" % (it["id"], kind_of(it), it["title"], it["file"], it["state"]))
    open(os.path.join(ROOT, "docs", "ART_STATUS.md"), "w", encoding="utf-8").write("\n".join(out) + "\n")
    print("%d piezas, %d listas o en inbox -> docs/ART_STATUS.md" % (len(items), done))
    for ph in phases:
        sub = [i for i in items if i["phase"] == ph]
        print("  fase %s: %d piezas, %d listas o en inbox" % (ph, len(sub), sum(1 for i in sub if i["state"] != "pendiente")))


if __name__ == "__main__":
    main()
