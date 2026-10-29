/**
 * Procesa el arte "crudo" que generas con IA y lo deja listo para el juego.
 *
 *   npm run art            → procesa todo lo que haya en art-inbox/ → public/assets/
 *   npm run art:status     → muestra qué archivos ya existen y cuáles faltan
 *
 * Reglas: el archivo crudo debe llamarse IGUAL que el final (p. ej. stick_idle.png, coin.png, bg_egipto.png);
 * acepta png/jpg/webp, en cualquier subcarpeta de art-inbox/. El fondo debe ser magenta plano o blanco plano
 * (se detecta solo por las esquinas). Los nombres exactos están en art-prompts/README.md.
 */
import sharp, { type OverlayOptions } from 'sharp';
import { existsSync, mkdirSync, readdirSync, statSync } from 'node:fs';
import path from 'node:path';
import { assets, type Asset } from './art-spec';
import { alphaBBox, CELL, commonScale, detectBackground, detectLayout, keyBackground, type Box } from './art-lib';

const ROOT = path.resolve(import.meta.dirname, '..');
const args = process.argv.slice(2);
const flag = (n: string) => args.includes(n);
const opt = (n: string, d: string) => { const i = args.indexOf(n); return i >= 0 ? args[i + 1] : d; };
const INBOX = path.resolve(ROOT, opt('--inbox', 'art-inbox'));
const OUT = path.resolve(ROOT, opt('--out', 'public/assets'));

const outPath = (a: Asset) => path.join(OUT, a.dir, a.file);

function walk(dir: string): string[] {
  if (!existsSync(dir)) return [];
  return readdirSync(dir).flatMap(f => {
    const p = path.join(dir, f);
    return statSync(p).isDirectory() ? walk(p) : [p];
  });
}

interface Raw { data: Uint8Array; w: number; h: number }
async function readRaw(file: string): Promise<Raw> {
  const { data, info } = await sharp(file).ensureAlpha().raw().toBuffer({ resolveWithObject: true });
  return { data: new Uint8Array(data), w: info.width, h: info.height };
}
const toSharp = (r: Raw) => sharp(Buffer.from(r.data), { raw: { width: r.w, height: r.h, channels: 4 } });

/** Quita el fondo salvo que el archivo ya venga con transparencia. */
function removeBackground(r: Raw) {
  const cornerAlpha = r.data[3];
  if (cornerAlpha < 250) return; // ya trae transparencia
  keyBackground(r.data, r.w, r.h, detectBackground(r.data, r.w, r.h));
}

async function crop(r: Raw, b: Box, scale: number) {
  const w = b.x1 - b.x0, h = b.y1 - b.y0;
  const rw = Math.max(1, Math.round(w * scale)), rh = Math.max(1, Math.round(h * scale));
  const buf = await toSharp(r).extract({ left: b.x0, top: b.y0, width: w, height: h }).resize(rw, rh, { kernel: 'lanczos3' }).png().toBuffer();
  return { buf, rw, rh };
}

async function processSheet(a: Asset, r: Raw) {
  removeBackground(r);
  const n = a.frames ?? 4;
  const { cols, rows } = detectLayout(r.w, r.h, n);
  const cw = Math.floor(r.w / cols), ch = Math.floor(r.h / rows);
  const regions: Box[] = [];
  for (let i = 0; i < n; i++) {
    const c = i % cols, rw = Math.floor(i / cols);
    regions.push({ x0: c * cw, y0: rw * ch, x1: (c + 1) * cw, y1: (rw + 1) * ch });
  }
  const boxes = regions.map((reg, i) => {
    const b = alphaBBox(r.data, r.w, reg);
    if (!b) throw new Error(`el cuadro ${i + 1} está vacío (¿se borró el personaje o el fondo no es plano?)`);
    return b;
  });
  const scale = commonScale(boxes);
  const comps: OverlayOptions[] = [];
  for (let i = 0; i < n; i++) {
    const { buf, rw, rh } = await crop(r, boxes[i], scale);
    comps.push({ input: buf, left: i * CELL + Math.round((CELL - rw) / 2), top: CELL - rh - 8 });
  }
  await sharp({ create: { width: CELL * n, height: CELL, channels: 4, background: { r: 0, g: 0, b: 0, alpha: 0 } } })
    .composite(comps).png().toFile(outPath(a));
  return `${cols}×${rows} → ${n} cuadros`;
}

async function processFitted(a: Asset, r: Raw, align: 'center' | 'bottom') {
  removeBackground(r);
  const box = alphaBBox(r.data, r.w, { x0: 0, y0: 0, x1: r.w, y1: r.h });
  if (!box) throw new Error('imagen vacía tras quitar el fondo');
  const [W, H] = a.size;
  const scale = Math.min((W * 0.94) / (box.x1 - box.x0), (H * 0.94) / (box.y1 - box.y0));
  const { buf, rw, rh } = await crop(r, box, scale);
  const top = align === 'bottom' ? H - rh - Math.round(H * 0.02) : Math.round((H - rh) / 2);
  await sharp({ create: { width: W, height: H, channels: 4, background: { r: 0, g: 0, b: 0, alpha: 0 } } })
    .composite([{ input: buf, left: Math.round((W - rw) / 2), top }]).png().toFile(outPath(a));
  return 'recortado y centrado';
}

async function processBackground(a: Asset, file: string) {
  await sharp(file).resize(a.size[0], a.size[1], { fit: 'cover' }).png({ compressionLevel: 9 }).toFile(outPath(a));
  return 'ajustado a tamaño';
}

function lev(a: string, b: string): number {
  const d = Array.from({ length: a.length + 1 }, (_, i) => [i, ...Array(b.length).fill(0)]);
  for (let j = 1; j <= b.length; j++) d[0][j] = j;
  for (let i = 1; i <= a.length; i++) for (let j = 1; j <= b.length; j++)
    d[i][j] = Math.min(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + (a[i - 1] === b[j - 1] ? 0 : 1));
  return d[a.length][b.length];
}

function status() {
  const groups = new Map<string, { have: number; total: number; missing: string[] }>();
  for (const a of assets) {
    const key = `${a.wired ? 'EN EL JUEGO' : 'opcional/por integrar'} · ${a.group.replace('|', ' · ')}`;
    const g = groups.get(key) ?? { have: 0, total: 0, missing: [] };
    g.total++;
    if (existsSync(outPath(a))) g.have++; else g.missing.push(a.file);
    groups.set(key, g);
  }
  let have = 0, total = 0;
  for (const [k, g] of [...groups].sort()) {
    have += g.have; total += g.total;
    console.log(`${g.have === g.total ? '✅' : g.have ? '🟡' : '⬜'} ${k}: ${g.have}/${g.total}`);
  }
  console.log(`\nTotal: ${have}/${total} archivos listos en ${path.relative(ROOT, OUT)}`);
}

async function main() {
  if (flag('--status')) return status();
  const inbox = walk(INBOX).filter(f => /\.(png|jpe?g|webp)$/i.test(f));
  const byName = new Map(inbox.map(f => [path.basename(f).replace(/\.[^.]+$/, '').toLowerCase(), f]));
  const known = new Set(assets.map(a => a.file.replace(/\.png$/, '').toLowerCase()));
  let ok = 0, failed = 0;
  for (const a of assets) {
    const src = byName.get(a.file.replace(/\.png$/, '').toLowerCase());
    if (!src) continue;
    try {
      mkdirSync(path.dirname(outPath(a)), { recursive: true });
      const detail =
        a.kind === 'sheet' ? await processSheet(a, await readRaw(src))
        : a.kind === 'background' ? await processBackground(a, src)
        : a.kind === 'base' ? await processFitted(a, await readRaw(src), 'bottom')
        : await processFitted(a, await readRaw(src), 'center');
      console.log(`✔ ${a.dir}/${a.file}  (${detail})`);
      ok++;
    } catch (e) { console.error(`✖ ${a.file}: ${(e as Error).message}`); failed++; }
  }
  for (const [name, f] of byName) {
    if (known.has(name)) continue;
    const near = [...known].sort((x, y) => lev(name, x) - lev(name, y))[0];
    console.warn(`? ${path.relative(ROOT, f)}: nombre desconocido. ¿Quisiste decir "${near}"?`);
  }
  console.log(`\n${ok} procesados, ${failed} con error. Siguiente: npm run art:status`);
}

main().catch(e => { console.error(e); process.exit(1); });
