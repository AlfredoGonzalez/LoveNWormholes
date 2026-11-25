#!/usr/bin/env python3
"""Revisa una hoja 5x5 (una animacion) y avisa de problemas tipicos. Uso: python3 tools/review_sheet.py <png> [--save-preview out.png]

Mide: transparencia, tamano de celda, caja del personaje por fotograma, tocar bordes, deriva de los pies,
variacion de tamano, cantidad de movimiento entre fotogramas y si el ultimo fotograma enlaza con el primero.
"""
import argparse
import sys

import numpy as np
from PIL import Image


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("png")
    ap.add_argument("--save-preview")
    ap.add_argument("--loop", action="store_true", help="la animacion es un ciclo (idle, walk, celebrate)")
    args = ap.parse_args()
    im = Image.open(args.png).convert("RGBA")
    a = np.array(im)
    W, H = im.size
    notes, warns = [], []
    transp = float((a[:, :, 3] < 250).mean())
    notes.append("tamano %dx%d, celda %dx%d, transparente %.0f%%" % (W, H, W // 5, H // 5, transp * 100))
    if transp < 0.1:
        warns.append("el fondo NO es transparente (%.0f%% transparente): hay que regenerar con magenta plano o transparente" % (transp * 100))
    if W % 5 or H % 5 or W != H:
        warns.append("la hoja no es cuadrada o no divide en 5x5 exacto")
    cw, ch = W // 5, H // 5
    boxes, cells = [], []
    for r in range(5):
        for c in range(5):
            al = a[r * ch:(r + 1) * ch, c * cw:(c + 1) * cw, 3] > 20
            ys, xs = np.where(al)
            cells.append(a[r * ch:(r + 1) * ch, c * cw:(c + 1) * cw].astype(np.int16))
            if len(xs) == 0:
                boxes.append(None)
                warns.append("fotograma %d vacio" % (r * 5 + c + 1))
                continue
            boxes.append((xs.min(), xs.max(), ys.min(), ys.max()))
            if xs.min() <= 1 or ys.min() <= 1 or xs.max() >= cw - 2 or ys.max() >= ch - 2:
                warns.append("fotograma %d toca el borde de su celda (recortado o necesita lienzo x2)" % (r * 5 + c + 1))
    ok = [b for b in boxes if b]
    feet = [b[3] for b in ok]
    hs = [b[3] - b[2] for b in ok]
    notes.append("pies (y): min %d max %d, deriva %d px (%.1f%% de la celda)" % (min(feet), max(feet), max(feet) - min(feet), 100.0 * (max(feet) - min(feet)) / ch))
    if (max(feet) - min(feet)) / ch > 0.04:
        warns.append("los pies se mueven mas de 4%% de la celda: el personaje va a 'flotar' o saltar (si es un salto, esta bien)")
    notes.append("alto del personaje: min %d max %d (variacion %.0f%%)" % (min(hs), max(hs), 100.0 * (max(hs) - min(hs)) / max(hs)))
    if (max(hs) - min(hs)) / max(hs) > 0.25:
        warns.append("el tamano cambia mucho entre fotogramas (>25%)")
    diffs = []
    for i in range(24):
        d = np.abs(cells[i][:, :, 3] - cells[i + 1][:, :, 3]).astype(np.float32)
        rgb = np.abs(cells[i][:, :, :3] - cells[i + 1][:, :, :3]).sum(axis=2).astype(np.float32) / 3.0
        m = (cells[i][:, :, 3] > 20) | (cells[i + 1][:, :, 3] > 20)
        diffs.append(float(((d / 255.0) + (rgb / 255.0 * (cells[i][:, :, 3] > 20))).sum() / max(1, m.sum())))
    total = float(np.mean(diffs))
    notes.append("movimiento medio entre fotogramas: %.3f (0 = imagen fija)" % total)
    if total < 0.02:
        warns.append("casi no hay movimiento (%.3f): se vera como imagen fija en el juego" % total)
    d_loop = float(np.abs(cells[24][:, :, 3] - cells[0][:, :, 3]).sum() / 255.0 / max(1, (cells[0][:, :, 3] > 20).sum()))
    notes.append("diferencia fotograma 25 vs 1: %.3f" % d_loop)
    if args.loop and d_loop > 0.25:
        warns.append("es un ciclo pero el fotograma 25 no enlaza con el 1 (salto al repetir)")
    jumps = [(i + 1, round(v, 3)) for i, v in enumerate(diffs) if v > 4 * max(np.median(diffs), 0.02)]
    if jumps:
        warns.append("saltos bruscos entre fotogramas: " + ", ".join("%d->%d" % (i, i + 1) for i, _ in jumps))
    print("\n".join("  " + n for n in notes))
    print(("AVISOS:\n" + "\n".join("  - " + w for w in warns)) if warns else "Sin avisos.")
    if args.save_preview:
        bg = Image.new("RGBA", im.size, (70, 70, 90, 255))
        bg.alpha_composite(im)
        bg.convert("RGB").resize((1400, 1400), Image.LANCZOS).save(args.save_preview)
    return 1 if warns else 0


if __name__ == "__main__":
    sys.exit(main())
