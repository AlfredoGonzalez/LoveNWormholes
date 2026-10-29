/** Genera art-prompts/*.md a partir de tools/art-spec.ts:  npm run art:docs  (no edites los .md generados a mano) */
import { mkdirSync, writeFileSync } from 'node:fs';
import path from 'node:path';
import { ERAS } from '../src/game/data';
import { dictionaries } from '../src/i18n';
import { assets, poseText, type Asset } from './art-spec';
import { ANIMS, CELL, FRAMES_PER_ANIM } from './art-lib';

const OUT = path.resolve(import.meta.dirname, '../art-prompts');
mkdirSync(OUT, { recursive: true });
const es = dictionaries.es;

const STYLE = 'cute cartoon 2D game asset, thick clean dark-plum outline (#3b2a3f), flat two-tone shading with a small highlight, saturated warm colors, mobile game sticker style, friendly and humorous';
const NEG = 'photorealistic, 3d render, blurry, text, watermark, extra limbs, cropped, gradient mesh, noisy texture, drop shadow';
const BG = {
  magenta: 'isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground',
  white: 'isolated on a plain, solid, flat pure white background (#FFFFFF), no gradient, no shadow on the ground',
};
const bgName = (a: Asset) => (a.bg === 'magenta' ? 'magenta #FF00FF' : 'blanco #FFFFFF');

const [sw, sh] = [CELL * FRAMES_PER_ANIM, CELL];

function sheetPrompt(a: Asset, anim: (typeof ANIMS)[number]) {
  return `${STYLE}. Sprite sheet of ${a.subject}. ${poseText(anim)}. ${FRAMES_PER_ANIM} frames arranged in a single horizontal row (aspect ratio 4:1, final ${sw}×${sh} px, each frame ${CELL}×${CELL} px). The SAME character in every frame with identical proportions, colors and scale, side view FACING RIGHT, full body visible and nothing cut off, all feet on the same ground line, frames evenly spaced with empty background between them. ${BG[a.bg]}. No text, no watermark.`;
}
const iconPrompt = (a: Asset) => `${STYLE}. Game icon: ${a.subject}. A single object centered and filling about 85% of the frame, square image (1:1, final ${a.size[0]}×${a.size[1]} px). ${BG[a.bg]}. No text, no watermark.`;
const basePrompt = (a: Asset) => `${STYLE}. Game building: ${a.subject}. Front view, the whole building visible and centered, standing on a flat ground line at the bottom of the image, aspect ratio 4:5 (final ${a.size[0]}×${a.size[1]} px). ${BG[a.bg]}. No text, no watermark.`;
const bgPrompt = (a: Asset) => `cute cartoon 2D game background, flat two-tone shading, saturated warm colors, soft painted look, no thick outlines, friendly and humorous. ${a.subject}. Vertical composition, aspect ratio 27:28 (final ${a.size[0]}×${a.size[1]} px). Distant elements at the top, the horizon and flat ground at about 85% of the height, the bottom 15% is plain ground. No characters, no text, no UI.`;
const logoPrompt = (a: Asset) => `${STYLE}. ${a.subject}. Aspect ratio 2:1 (final ${a.size[0]}×${a.size[1]} px). ${BG[a.bg]}.`;
const fxPrompt = (a: Asset) => `${STYLE}. Visual effect sprite: ${a.subject}. Single object centered, square image (1:1, final ${a.size[0]}×${a.size[1]} px). ${BG[a.bg]}. No text.`;

function prompt(a: Asset): string {
  switch (a.kind) {
    case 'sheet': return sheetPrompt(a, a.note as (typeof ANIMS)[number]);
    case 'icon': return iconPrompt(a);
    case 'base': return basePrompt(a);
    case 'background': return bgPrompt(a);
    case 'logo': return logoPrompt(a);
    case 'fx': return fxPrompt(a);
  }
}

const meta = (a: Asset) =>
  `**Archivo:** \`${a.file}\` → \`public/assets/${a.dir}/\` · **Tamaño final:** ${a.size[0]}×${a.size[1]} px` +
  (a.kind === 'background' ? '' : ` · **Fondo al generar:** ${bgName(a)}`) + ` · ${a.wired ? '✅ el juego ya lo usa' : '🕓 aún no integrado'}` +
  (a.note && a.kind !== 'sheet' ? `\n\n> ${a.note}` : '');

const block = (a: Asset, extra = '') => `${meta(a)}\n${extra}\n\`\`\`text\n${prompt(a)}\n\`\`\`\n`;

const eraTitle = (id: string) => es[`era_${id}` as keyof typeof es] as string;
const unitName = (id: string): string => {
  for (const e of ERAS) for (const u of [...e.units, ...e.enemies]) if (u.id === id) return es[u.nameKey] as string;
  return id;
};

// ================= README =================
const sheets = assets.filter(a => a.kind === 'sheet');
const chars = new Set(sheets.map(a => a.file.replace(/_(idle|walk|attack|die)\.png$/, '')));
const count = (f: (a: Asset) => boolean) => assets.filter(f).length;
const tierLine = (n: number, text: string, c: number) => `| ${n} | ${text} | ${c} |`;

writeFileSync(path.join(OUT, 'README.md'), `# Guía de arte — Love N Wormholes

> Documento generado por \`npm run art:docs\` desde \`tools/art-spec.ts\`. Si cambian los personajes del juego, regenera.

## Cómo funciona (3 pasos)
1. **Genera** cada imagen con la IA usando el prompt de su archivo (carpeta \`art-prompts/\`). Pide el tamaño al menos al doble del final; el script reduce.
2. **Guarda** el resultado crudo en \`art-inbox/\` con el **nombre exacto** del archivo (p. ej. \`stick_idle.png\`, \`coin.png\`). Cada ícono y cada hoja de sprites va **por separado**.
3. Ejecuta \`npm run art\`. El script **quita el fondo**, **corta los cuadros**, **unifica el tamaño** y deja el archivo final en \`public/assets/\`. \`npm run art:status\` muestra qué ya está y qué falta.

El juego carga lo que exista y usa figuras de reemplazo para lo que falte: puedes ir entregando el arte poco a poco.

## Reglas del fondo
- **Magenta plano** (\`#FF00FF\`) es el predeterminado. Para objetos rosas/violetas/magenta (gemas, corazón, portal, logo) los prompts piden **blanco plano** (\`#FFFFFF\`). Si tu herramienta no obedece el color, usa el otro: el script detecta el color de fondo por las esquinas.
- Fondo **plano y liso** (sin degradado ni sombra en el piso). Si la IA añade sombra o suelo, pide de nuevo o bórralo antes.
- Los ojos blancos o vendas blancas del interior **no** se borran (solo se quita el fondo conectado con el borde de la imagen).
- Los **fondos de escenario** (\`bg_*.png\`) no llevan transparencia: se ajustan al tamaño.

## Hojas de sprites (personajes)
- **Una hoja por animación**: \`<id>_idle.png\`, \`<id>_walk.png\`, \`<id>_attack.png\`, \`<id>_die.png\`. Ejemplo: \`stick_idle.png\`, \`gusanito_egipto_walk.png\`.
- Cada hoja tiene **${FRAMES_PER_ANIM} cuadros**. Pueden venir en **una fila** (relación 4:1) o en **cuadrícula 2×2** (cuadrada); el script lo detecta. Si tu herramienta no hace 4:1, reemplaza en el prompt la frase *"arranged in a single horizontal row (aspect ratio 4:1…)"* por *"arranged in a 2×2 grid, order left-to-right then top-to-bottom, square image"*.
- Resultado final: **${sw}×${sh} px** (${FRAMES_PER_ANIM} cuadros de ${CELL}×${CELL}); el personaje queda con los pies alineados abajo y con el mismo tamaño en todos los cuadros.
- **TODOS los personajes miran a la DERECHA** (también los enemigos: el juego los voltea solo).
- Orden recomendado: primero la hoja de referencia → luego \`_idle\` → úsala como **imagen de referencia** para \`_walk\`, \`_attack\` y \`_die\` del mismo personaje (así no cambia de cara ni de colores).
- Si falta una animación, el juego usa \`_idle\`; si falta \`_idle\`, dibuja un círculo de color. Por eso la prioridad es: **idle de todos → walk → attack → die**.

## Prioridad sugerida
| Prioridad | Qué | Archivos |
|---|---|---|
${tierLine(1, 'Hojas **idle** de todos los personajes (${chars.size}) + íconos de moneda, gema, estrellas y logo'.replace('${chars.size}', String(chars.size)), count(a => a.tier === 1))}
${tierLine(2, 'Hojas **walk**, fondos de escenario, bases y arte de la tienda', count(a => a.tier === 2))}
${tierLine(3, 'Hojas **attack** e íconos extra (energía, portal, cofres…)', count(a => a.tier === 3))}
${tierLine(4, 'Hojas **die**, efectos y candado', count(a => a.tier === 4))}

Total: **${assets.length}** archivos (${sheets.length} hojas de sprites de ${chars.size} personajes, ${count(a => a.kind === 'icon' || a.kind === 'logo')} íconos/logo, ${count(a => a.kind === 'background')} fondos, ${count(a => a.kind === 'base')} bases, ${count(a => a.kind === 'fx')} efectos). Sugerencia: trabaja **por era** (Prehistoria completa primero).

## Documentos
| Archivo | Contenido |
|---|---|
| [\`00-style-bible.md\`](00-style-bible.md) | Estilo, paletas, proporciones y flujo de consistencia (léelo primero) |
| [\`01-characters.md\`](01-characters.md) | Prompts de todas las hojas de sprites, por era |
| [\`02-scenery.md\`](02-scenery.md) | Fondos de escenario y bases |
| [\`03-ui.md\`](03-ui.md) | Íconos, logo, tienda, ícono de app y capturas |
| [\`04-extras.md\`](04-extras.md) | Efectos, hojas de referencia e ilustraciones de historia (opcionales) |

## Negativos (si tu herramienta los admite)
\`${NEG}\`

## Lista de nombres de archivo
${[...new Set(assets.map(a => a.group.split('|')[0]))].map(g => {
  const names = assets.filter(a => a.group.startsWith(g + '|')).map(a => a.file);
  return `- **${g}** (${names.length}): ${names.map(n => '`' + n + '`').join(', ')}`;
}).join('\n')}
`);

// ================= 01 personajes =================
let md = `# 01 · Personajes (hojas de sprites)

Cada personaje tiene **4 hojas** (${ANIMS.join(', ')}). Lee antes el README (reglas de fondo, orientación a la derecha y flujo de referencias).
Plantilla ya incluida en cada prompt; solo cópialos. Para \`_walk\`, \`_attack\` y \`_die\`: **adjunta como referencia la hoja \`_idle\` aprobada** del mismo personaje.

`;
const eraGroups = [...ERAS.map(e => e.id), 'extras'];
for (const eg of eraGroups) {
  const gs = assets.filter(a => a.kind === 'sheet' && a.group.startsWith(eg + '|'));
  if (!gs.length) continue;
  md += `\n---\n\n## ${eg === 'extras' ? 'Extras' : eraTitle(eg)}\n`;
  const ids = [...new Set(gs.map(a => a.file.replace(/_(idle|walk|attack|die)\.png$/, '')))];
  for (const id of ids) {
    const first = gs.find(a => a.file.startsWith(id + '_idle'))!;
    const label = id.startsWith('gusanito_') ? `Gusanito (${eraTitle(id.replace('gusanito_', ''))})` : id === 'ghost' ? 'Caballero fantasma (aliado de la anomalía)' : unitName(id);
    const role = first.group.split('|')[1];
    md += `\n### ${label} · \`${id}\` ${role === 'enemies' ? '· enemigo' : role === 'allies' ? '· aliado' : ''}\n`;
    md += `\n_Descripción:_ ${first.subject}\n\n`;
    for (const anim of ANIMS) {
      const a = gs.find(x => x.file === `${id}_${anim}.png`)!;
      md += `#### \`${a.file}\`\n${block(a, anim === 'idle' ? '' : `\n_Adjunta \`${id}_idle.png\` como referencia._\n`)}\n`;
    }
  }
}
writeFileSync(path.join(OUT, '01-characters.md'), md);

// ================= 02 escenarios =================
md = `# 02 · Fondos de escenario y bases

El juego es **vertical (540×960)**. Cada fondo cubre la zona de combate (parte superior, ~540×560 en pantalla); el suelo se pinta por código debajo. Las bases se colocan a los extremos del carril: **hogar a la izquierda, base enemiga a la derecha** (ambas de frente).
`;
for (const era of ERAS) {
  md += `\n---\n\n## ${eraTitle(era.id)}\n\n`;
  for (const a of assets.filter(x => x.group === `${era.id}|scenery`)) md += `### \`${a.file}\`\n${block(a)}\n`;
}
writeFileSync(path.join(OUT, '02-scenery.md'), md);

// ================= 03 UI =================
md = `# 03 · Íconos, logo y tienda

Cada ícono es **un archivo independiente** (no hojas). Objeto único, centrado, ocupando ~85 % del cuadro. Los botones, paneles y barras se dibujan por código (no necesitan arte).

`;
for (const a of assets.filter(x => x.kind === 'icon' || x.kind === 'logo')) md += `### \`${a.file}\`\n${block(a)}\n`;
md += `---

## Para las tiendas (no pasan por \`npm run art\`)
| Pieza | Tamaño | Notas |
|---|---|---|
| Ícono de la app | **1024×1024**, sin transparencia ni esquinas redondeadas | Cara de Gusanito sobre el portal violeta |
| Gráfico destacado Google Play | **1024×500** | Los dos gusanos + portal + logo |
| Capturas Android | **1080×1920** | Pantallas reales del juego |
| Capturas iPhone 6.7" | **1290×2796** | Pantallas reales del juego |

\`\`\`text
${STYLE}. App icon: the happy face of Gusanito (a cute chubby pink-salmon worm with big shiny eyes) in front of a swirling purple-to-cyan wormhole, bold and simple, readable at small sizes. Square image 1:1, final 1024×1024 px, full-bleed colored background with no transparency and no rounded corners. No text.
\`\`\`
`;
writeFileSync(path.join(OUT, '03-ui.md'), md);

// ================= 04 extras =================
md = `# 04 · Extras (opcionales)

## Hojas de referencia (para mantener la consistencia; NO pasan por el script)
Genera estas dos primero y úsalas como imagen de referencia en todo lo demás. Guárdalas donde quieras (p. ej. \`art-inbox/referencias/\`, que no se sube a git).

### \`ref_gusanito.png\`
\`\`\`text
${STYLE}. Character reference sheet of Gusanito, a cute chubby pink-salmon (#ff8fa3) worm hero with 5 body segments, big shiny eyes, a brave smile and small determined eyebrows, no clothes. Three views side by side: front view, side view facing right, and a 3/4 view, same size, standing on the same ground line. ${BG.white}. No text.
\`\`\`

### \`ref_gusanita.png\`
\`\`\`text
${STYLE}. Character reference sheet of Gusanita, a cute chubby lilac (#c9a7ff) worm with 5 body segments, long eyelashes, big shiny eyes, a small flower bow on her head and a curious mischievous expression. Three views side by side: front view, side view facing right, and a 3/4 view, same size, same ground line. ${BG.white}. No text.
\`\`\`

## Efectos (aún no integrados en el juego)
`;
for (const a of assets.filter(x => x.kind === 'fx')) md += `### \`${a.file}\`\n${block(a)}\n`;
md += `
## Ilustraciones de historia (opcionales; para una intro o pantallas de cómic)
Fondo permitido (escena completa). Formato vertical 3:4. No pasan por \`npm run art\`.

| Panel | Prompt |
|---|---|
| \`story_01_button\` | \`${STYLE}. Comic panel, vertical 3:4: Gusanita (lilac worm with a flower bow) pressing a strange glowing gadget with a big button, a swirling purple-cyan wormhole starting to open around her, surprised happy face, prehistoric jungle clearing, Gusanito watching in the background.\` |
| \`story_02_vanish\` | \`${STYLE}. Comic panel, vertical 3:4: Gusanita being sucked into a swirling purple-cyan wormhole with sparkles, waving, Gusanito (pink-salmon worm) reaching out with a shocked face.\` |
| \`story_03_chase\` | \`${STYLE}. Comic panel, vertical 3:4: Gusanito running determined toward a swirling purple wormhole, dust cloud, dramatic but funny.\` |
| \`story_04_message\` | \`${STYLE}. Comic panel, vertical 3:4: Gusanita, in a different era, waving and calling for help with a speech bubble containing a small heart, a giant curious cat looming behind her.\` |
`;
writeFileSync(path.join(OUT, '04-extras.md'), md);
console.log(`Generados 5 documentos en art-prompts/ (${assets.length} archivos de arte).`);
