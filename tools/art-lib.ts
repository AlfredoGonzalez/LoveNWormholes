/** Utilidades puras (sin sharp) del procesador de arte; se prueban en tests/art.test.ts */

export const CELL = 256;
export const ANIMS = ['idle', 'walk', 'attack', 'die'] as const;
export type Anim = (typeof ANIMS)[number];
export const FRAMES_PER_ANIM = 4;

export interface Layout { cols: number; rows: number }

/** Deduce cómo vienen acomodados los cuadros: fila (4×1), columna o cuadrícula (2×2), según la proporción de la imagen. */
export function detectLayout(w: number, h: number, frames: number): Layout {
  const ratio = w / h;
  let best: Layout = { cols: frames, rows: 1 };
  let bestErr = Infinity;
  for (let cols = 1; cols <= frames; cols++) {
    if (frames % cols) continue;
    const rows = frames / cols;
    const err = Math.abs(Math.log(ratio / (cols / rows)));
    if (err < bestErr) { bestErr = err; best = { cols, rows }; }
  }
  return best;
}

export type RGB = [number, number, number];
export const colorDist = (a: RGB, b: RGB) => Math.hypot(a[0] - b[0], a[1] - b[1], a[2] - b[2]);

/** Color de fondo = mediana por canal de los píxeles de las 4 esquinas. */
export function detectBackground(rgba: Uint8Array, w: number, h: number, patch = 6): RGB {
  const ch: number[][] = [[], [], []];
  const corners: [number, number][] = [[0, 0], [w - patch, 0], [0, h - patch], [w - patch, h - patch]];
  for (const [cx, cy] of corners)
    for (let y = cy; y < cy + patch; y++)
      for (let x = cx; x < cx + patch; x++) {
        const i = (y * w + x) * 4;
        for (let c = 0; c < 3; c++) ch[c].push(rgba[i + c]);
      }
  const med = (a: number[]) => a.sort((p, q) => p - q)[a.length >> 1];
  return [med(ch[0]), med(ch[1]), med(ch[2])];
}

/**
 * Hace transparente el fondo: solo los píxeles parecidos al fondo que estén CONECTADOS con el borde (o todos, con `everywhere`)
 * (así los ojos blancos o las vendas blancas del interior no se borran). Modifica `rgba` en sitio.
 */
export function keyBackground(rgba: Uint8Array, w: number, h: number, bg: RGB, t0 = 50, t1 = 110, everywhere = false): void {
  const n = w * h;
  const seen = new Uint8Array(n);
  const queue = new Int32Array(n);
  let head = 0, tail = 0;
  const d = (p: number): number => colorDist([rgba[p * 4], rgba[p * 4 + 1], rgba[p * 4 + 2]], bg);
  const push = (p: number) => { if (!seen[p] && d(p) < t1) { seen[p] = 1; queue[tail++] = p; } };
  if (everywhere) {
    // Marcos: el hueco del centro NO toca el borde, así que se quita el color de fondo en TODA la imagen.
    for (let p = 0; p < n; p++) push(p);
    head = tail;
  }
  for (let x = 0; x < w; x++) { push(x); push((h - 1) * w + x); }
  for (let y = 0; y < h; y++) { push(y * w); push(y * w + w - 1); }
  while (head < tail) {
    const p = queue[head++];
    const x = p % w, y = (p / w) | 0;
    if (x > 0) push(p - 1);
    if (x < w - 1) push(p + 1);
    if (y > 0) push(p - w);
    if (y < h - 1) push(p + w);
  }
  for (let p = 0; p < n; p++) {
    if (!seen[p]) continue;
    const a = Math.max(0, Math.min(1, (d(p) - t0) / (t1 - t0)));
    rgba[p * 4 + 3] = Math.round(rgba[p * 4 + 3] * a);
  }
}

export interface Box { x0: number; y0: number; x1: number; y1: number } // x1/y1 exclusivos

/** Caja que contiene los píxeles no transparentes dentro de una región; null si está vacía. */
export function alphaBBox(rgba: Uint8Array, w: number, region: Box, threshold = 24): Box | null {
  let x0 = Infinity, y0 = Infinity, x1 = -1, y1 = -1;
  for (let y = region.y0; y < region.y1; y++)
    for (let x = region.x0; x < region.x1; x++) {
      if (rgba[(y * w + x) * 4 + 3] > threshold) {
        if (x < x0) x0 = x; if (x > x1) x1 = x; if (y < y0) y0 = y; if (y > y1) y1 = y;
      }
    }
  return x1 < 0 ? null : { x0, y0, x1: x1 + 1, y1: y1 + 1 };
}

/** Escala común para que TODOS los cuadros de una animación mantengan su tamaño relativo. */
export function commonScale(boxes: Box[], cell = CELL, margin = 0.92): number {
  const maxW = Math.max(...boxes.map(b => b.x1 - b.x0));
  const maxH = Math.max(...boxes.map(b => b.y1 - b.y0));
  return Math.min((cell * margin) / maxW, (cell * margin) / maxH);
}
