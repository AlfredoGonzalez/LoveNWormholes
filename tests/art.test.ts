import { describe, expect, it } from 'vitest';
import { alphaBBox, colorDist, commonScale, detectBackground, detectLayout, keyBackground } from '../tools/art-lib';
import { assets } from '../tools/art-spec';
import { ERAS } from '../src/game/data';

describe('art-lib', () => {
  it('detecta el acomodo de los cuadros', () => {
    expect(detectLayout(1024, 256, 4)).toEqual({ cols: 4, rows: 1 });
    expect(detectLayout(1024, 1024, 4)).toEqual({ cols: 2, rows: 2 });
    expect(detectLayout(256, 1024, 4)).toEqual({ cols: 1, rows: 4 });
    expect(detectLayout(1200, 400, 4)).toEqual({ cols: 4, rows: 1 });
  });

  const img = (w: number, h: number, bg: number[]) => {
    const d = new Uint8Array(w * h * 4);
    for (let i = 0; i < w * h; i++) d.set([...bg, 255], i * 4);
    return d;
  };
  const paint = (d: Uint8Array, w: number, x0: number, y0: number, x1: number, y1: number, c: number[]) => {
    for (let y = y0; y < y1; y++) for (let x = x0; x < x1; x++) d.set([...c, 255], (y * w + x) * 4);
  };

  it('quita el fondo conectado con el borde pero conserva el blanco interior', () => {
    const w = 40, h = 40, d = img(w, h, [255, 255, 255]);
    paint(d, w, 10, 10, 30, 30, [200, 40, 40]);   // cuerpo rojo
    paint(d, w, 18, 18, 22, 22, [255, 255, 255]); // "ojo" blanco interior
    const bg = detectBackground(d, w, h);
    expect(bg).toEqual([255, 255, 255]);
    keyBackground(d, w, h, bg);
    const a = (x: number, y: number) => d[(y * w + x) * 4 + 3];
    expect(a(2, 2)).toBe(0);      // fondo → transparente
    expect(a(12, 12)).toBe(255);  // cuerpo → opaco
    expect(a(20, 20)).toBe(255);  // ojo blanco interior → se conserva
  });

  it('funciona con fondo magenta y calcula la caja y la escala', () => {
    const w = 40, h = 40, d = img(w, h, [255, 0, 255]);
    paint(d, w, 5, 10, 15, 30, [0, 120, 200]);
    keyBackground(d, w, h, detectBackground(d, w, h));
    const box = alphaBBox(d, w, { x0: 0, y0: 0, x1: w, y1: h })!;
    expect(box).toEqual({ x0: 5, y0: 10, x1: 15, y1: 30 });
    expect(commonScale([box, { x0: 0, y0: 0, x1: 20, y1: 10 }])).toBeCloseTo((256 * 0.92) / 20, 5);
    expect(colorDist([0, 0, 0], [3, 4, 0])).toBe(5);
  });
});

describe('especificación de arte', () => {
  it('no repite archivos', () => {
    const keys = assets.map(a => `${a.dir}/${a.file}`);
    expect(new Set(keys).size).toBe(keys.length);
  });
  it('cubre todos los personajes del juego con las 4 animaciones', () => {
    const files = new Set(assets.map(a => a.file));
    for (const e of ERAS) {
      for (const id of [`gusanito_${e.id}`, ...e.units.map(u => u.id), ...e.enemies.map(u => u.id)])
        for (const anim of ['idle', 'walk', 'attack', 'die']) expect(files.has(`${id}_${anim}.png`), `${id}_${anim}`).toBe(true);
      expect(files.has(`bg_${e.id}.png`)).toBe(true);
    }
    expect(files.has('ghost_idle.png')).toBe(true);
  });
  it('todos los personajes tienen descripción', () => {
    for (const a of assets) expect(a.subject, a.file).toBeTruthy();
  });
});
