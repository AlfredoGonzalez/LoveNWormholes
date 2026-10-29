// Uso: node tools/pack-atlas.mjs <carpeta_de_frames> <salida_sin_extension>
// Une PNGs en una sola hoja + JSON (formato "JSON Hash" que Phaser carga con load.atlas).
// Requiere: npm i -D sharp
import { readdir, writeFile } from 'node:fs/promises';
import path from 'node:path';
import sharp from 'sharp';

const [dir, out] = process.argv.slice(2);
if (!dir || !out) { console.error('Uso: node tools/pack-atlas.mjs <frames_dir> <out_sin_ext>'); process.exit(1); }

const files = (await readdir(dir)).filter(f => f.endsWith('.png')).sort();
const imgs = await Promise.all(files.map(async f => {
  const buf = await sharp(path.join(dir, f)).toBuffer();
  const m = await sharp(buf).metadata();
  return { name: f.replace(/\.png$/, ''), buf, w: m.width, h: m.height };
}));

const pad = 2, maxW = 2048;
let x = pad, y = pad, rowH = 0;
const frames = {};
const comps = [];
for (const i of imgs) {
  if (x + i.w + pad > maxW) { x = pad; y += rowH + pad; rowH = 0; }
  frames[i.name] = {
    frame: { x, y, w: i.w, h: i.h }, rotated: false, trimmed: false,
    spriteSourceSize: { x: 0, y: 0, w: i.w, h: i.h }, sourceSize: { w: i.w, h: i.h },
  };
  comps.push({ input: i.buf, left: x, top: y });
  x += i.w + pad; rowH = Math.max(rowH, i.h);
}
const H = y + rowH + pad;
await sharp({ create: { width: maxW, height: H, channels: 4, background: { r: 0, g: 0, b: 0, alpha: 0 } } })
  .composite(comps).png().toFile(`${out}.png`);
await writeFile(`${out}.json`, JSON.stringify({ frames, meta: { image: path.basename(out) + '.png', size: { w: maxW, h: H }, scale: 1 } }, null, 2));
console.log(`OK: ${files.length} frames → ${out}.png/.json`);
