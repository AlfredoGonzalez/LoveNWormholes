/** Genera art-prompts/*.md a partir de tools/art-spec.ts:  npm run art:docs  (no edites los .md generados a mano) */
import { mkdirSync, writeFileSync } from 'node:fs';
import path from 'node:path';
import { ERAS } from '../src/game/data';
import { dictionaries } from '../src/i18n';
import { assets, GUSANITA_SUBJECT, poseText, type Asset } from './art-spec';
import { ANIMS, CELL, FRAMES_PER_ANIM } from './art-lib';

const OUT = path.resolve(import.meta.dirname, '../art-prompts');
mkdirSync(OUT, { recursive: true });
const es = dictionaries.es;

const STYLE = 'cute cartoon 2D game asset in a hand-inked storybook style, thick dark-brown outline (#2e2024), cel shading with soft highlights, saturated warm colors, prehistoric stone-and-wood mood, friendly and humorous';
const NEG = 'photorealistic, 3d render, blurry, text, watermark, extra limbs, cropped, gradient mesh, noisy texture, drop shadow, different art style';
const BG = {
  magenta: 'isolated on a plain, solid, flat magenta background (#FF00FF), no gradient, no shadow on the ground',
  white: 'isolated on a plain, solid, flat pure white background (#FFFFFF), no gradient, no shadow on the ground',
};
const bgName = (a: Asset) => (a.bg === 'magenta' ? 'magenta #FF00FF' : 'blanco #FFFFFF');

const [sw, sh] = [CELL * FRAMES_PER_ANIM, CELL];

function sheetPrompt(a: Asset, anim: (typeof ANIMS)[number]) {
  return `${STYLE}. Sprite sheet of ${a.subject}. ${poseText(anim)}. ${FRAMES_PER_ANIM} frames arranged in a single horizontal row (aspect ratio 4:1, final ${sw}×${sh} px, each frame ${CELL}×${CELL} px). The SAME character in every frame with identical proportions, colors and scale, side view FACING RIGHT, full body visible and nothing cut off, all feet on the same ground line, frames evenly spaced with empty background between them. ${BG[a.bg]}. No text, no watermark.`;
}
const gcd = (x: number, y: number): number => (y ? gcd(y, x % y) : x);
const ratio = (a: Asset) => { const g = gcd(a.size[0], a.size[1]); return `${a.size[0] / g}:${a.size[1] / g}`; };
const iconPrompt = (a: Asset) => `${STYLE}. Game icon: ${a.subject}. A single object centered and filling about 85% of the frame, ${a.size[0] === a.size[1] ? 'square image (1:1' : `aspect ratio ${ratio(a)} (`}final ${a.size[0]}×${a.size[1]} px). ${BG[a.bg]}. No text, no watermark.`;
const screenPrompt = (a: Asset) => `${STYLE}. Full-screen game background: ${a.subject}. Vertical composition, aspect ratio 9:16 (final ${a.size[0]}×${a.size[1]} px). Keep the center calm and uncluttered so UI can sit on top. No characters unless stated, no text, no UI.`;
const panelPrompt = (a: Asset) => `${STYLE}. Illustration: ${a.subject}. Aspect ratio ${ratio(a)} (final ${a.size[0]}×${a.size[1]} px). Background allowed (full scene). No text, no speech-bubble text.`;
const framePrompt = (a: Asset) => `${STYLE}. Full-screen decorative frame: ${a.subject}. Vertical composition, aspect ratio 9:16 (final ${a.size[0]}×${a.size[1]} px). The magenta area must be one flat uniform color with no shading. No text.`;
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
    case 'screen': return screenPrompt(a);
    case 'panel': return panelPrompt(a);
    case 'frame': return framePrompt(a);
  }
  return '';
}

const meta = (a: Asset) =>
  `**Archivo:** \`${a.file}\` → \`public/assets/${a.dir}/\` · **Tamaño final:** ${a.size[0]}×${a.size[1]} px` +
  (['background', 'screen', 'panel'].includes(a.kind) ? '' : ` · **Fondo al generar:** ${bgName(a)}`) + ` · ${a.wired ? '✅ el juego ya lo usa' : '🕓 aún no integrado'}${a.have ? ' · 📦 probablemente ya lo tienes (video de Unity)' : ''}` +
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
${tierLine(5, '**Rediseño de interfaz (Hito 6)**: historia, título, hub, navegación, mapa, recuerdos, cartas y tienda (ver `05-screens.md`)', count(a => a.tier === 5))}

Total: **${assets.length}** archivos, de los cuales **${count(a => !!a.have)}** aparecen ya en el video de tu prototipo de Unity (📦, solo hay que exportarlos y renombrarlos). Desglose: (${sheets.length} hojas de sprites de ${chars.size} personajes, ${count(a => a.kind === 'icon' || a.kind === 'logo')} íconos/logo, ${count(a => a.kind === 'background')} fondos, ${count(a => a.kind === 'base')} bases, ${count(a => a.kind === 'fx')} efectos). Sugerencia: trabaja **por era** (Prehistoria completa primero).

## Reutilizar el arte de tu prototipo de Unity (📦)
Todo lo marcado con 📦 se ve en tu video, así que ya lo tienes hecho. Para usarlo:
1. En tu proyecto de Unity busca cada sprite (carpeta \`Assets/\`; son los PNG originales, no capturas de pantalla).
2. **Cópialo a \`art-inbox/\` con el nombre exacto** de la lista (p. ej. \`story_01.png\`, \`nav_shop.png\`, \`btn_wood.png\`).
3. Ejecuta \`npm run art\`. Si el PNG ya trae transparencia se respeta; si trae fondo plano se quita; los fondos y paneles solo se ajustan al tamaño.
4. Si en Unity una pantalla estaba "horneada" (p. ej. el título con logo, personaje y botón en una sola imagen), necesitamos las **capas por separado** (fondo, logo, personaje, botón en blanco) porque el juego pone el texto en español/inglés y anima cada capa; si no tienes las capas, los prompts de \`05-screens.md\` las generan.
5. Lo que en el video tenía **texto de ejemplo** (\`Dungeon Map\`, \`The Worm Mart\`, \`concept: simplify icon\`, \`Placeholder Item\`…) debe venir **sin texto**: el juego escribe los textos en ES/EN.

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
for (const a of assets.filter(x => x.group === 'ui|icons' || x.group === 'ui|logo')) md += `### \`${a.file}\`\n${block(a)}\n`;
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

> Las ilustraciones de historia ahora son parte del flujo principal: ver \`05-screens.md\`.

## Hojas de referencia (para mantener la consistencia; NO pasan por el script)
Genera estas dos primero y úsalas como imagen de referencia en todo lo demás. Guárdalas donde quieras (p. ej. \`art-inbox/referencias/\`, que no se sube a git).

### \`ref_gusanito.png\`
\`\`\`text
${STYLE}. Character reference sheet of Gusanito, a cute chubby bright-green (#7ccf5a) worm hero with 5 body segments, big shiny eyes, small determined eyebrows, a brave smile, and his signature black baseball cap with a white letter "A" on the front, no other clothes. Three views side by side: front view, side view facing right, and a 3/4 view, same size, standing on the same ground line. ${BG.magenta}. No text.
\`\`\`

### \`ref_gusanita.png\`
\`\`\`text
${STYLE}. Character reference sheet of ${GUSANITA_SUBJECT}, no other clothes. Three views side by side: front view, side view facing right, and a 3/4 view, same size, same ground line. ${BG.magenta}. No text.
\`\`\`

## Efectos (aún no integrados en el juego)
`;
for (const a of assets.filter(x => x.kind === 'fx')) md += `### \`${a.file}\`\n${block(a)}\n`;
md += `
`;
writeFileSync(path.join(OUT, '04-extras.md'), md);
// ================= 05 pantallas =================
const SECTIONS: [string, (a: Asset) => boolean, string][] = [
  ['Intro y capítulos de historia', a => a.group.startsWith('story|') || a.file.startsWith('intro_bg'), 'Al abrir el juego por primera vez se muestran 3 paneles de cómic que van apareciendo sobre el fondo de papel (toca para continuar). Al llegar a una era nueva, aparece su panel de capítulo. Los paneles NO llevan texto: los diálogos los escribe el juego en ES/EN.'],
  ['Pantalla de título', a => a.group === 'ui|title' || a.group === 'ui|logo' || a.file === 'logo.png', 'Capas separadas: fondo de selva, logo, Gusanito en pose y botón de madera en blanco (el juego escribe «JUGAR»/«PLAY»).'],
  ['Botones y ventanas', a => a.group === 'ui|buttons', 'Piezas en blanco y reutilizables (sin texto).'],
  ['Hub: fondos por era', a => a.group.endsWith('|hub'), 'Fondo de papel con patrón muy tenue (cambia con la era). La casa de piedra del centro es `base_<era>_home.png` y Gusanito es su hoja `_idle`.'],
  ['Hub: barra superior y navegación', a => a.group === 'ui|hud' || a.group === 'ui|nav', 'Barra superior (monedas, gemas, título del nivel, ajustes, menú, misiones) y barra inferior de 5 pestañas: Mapa · Recuerdos · **Batalla** (centro, destacada) · Mejoras · Tienda.'],
  ['Marcos de pantalla', a => a.group === 'ui|frames', 'Marcos a pantalla completa con el centro en **magenta plano** (el script lo vuelve transparente). Se dibujan sobre `parchment`/fondos de cada pantalla.'],
  ['Mapa de niveles', a => a.group.endsWith('|map') || a.group === 'ui|events', 'Los caminos punteados y las estrellas se dibujan por código; aquí solo los iconos de cada nivel, el jefe final de la era y los eventos temporales.'],
  ['Recuerdos de los gusanos', a => a.group === 'ui|memories', 'Álbum de fotos tipo polaroid que se desbloquea con el Medidor de Amor (barra dibujada por código).'],
  ['Mejoras (cartas)', a => a.group === 'ui|cards', 'Tres ranuras de cartas equipables, estadísticas (ataque, vida, crítico) y botón para volver a sacar cartas.'],
  ['Tienda (The Worm Mart)', a => a.group === 'ui|shop', 'Tendero, ofertas diarias y paquetes de gemas (los iconos de paquetes están en `03-ui.md`: `shop_gems_*`).'],
  ['Retratos de Gusanita', a => a.file.startsWith('gusanita_'), 'Aparecen en los mensajes de cada era.'],
  ['Batalla (interfaz)', a => a.group === 'ui|hud' && a.file.startsWith('hud_'), 'Marco de los botones de invocar unidades.'],
];
md = `# 05 · Rediseño de interfaz (Hito 6)

Basado en tu prototipo de Unity. Detalle del recorrido y las pantallas: [\`docs/DESIGN.md\`](../docs/DESIGN.md). Todo lo marcado con 📦 se ve en tu video.
**Importante:** nada de esto lleva texto incrustado (los textos los pone el juego en español e inglés).
`;
const used = new Set<string>();
for (const [title, pick, intro] of SECTIONS) {
  const list = assets.filter(a => pick(a) && !used.has(a.file) && ['screen', 'panel', 'frame', 'icon', 'logo'].includes(a.kind) && !(a.group === 'ui|icons') && !(a.file === 'logo.png' && title !== 'Pantalla de título'));
  if (!list.length) continue;
  md += `\n---\n\n## ${title}\n\n${intro}\n\n`;
  for (const a of list) { used.add(a.file); md += `### \`${a.file}\`\n${block(a)}\n`; }
}
writeFileSync(path.join(OUT, '05-screens.md'), md);
console.log(`Generados 6 documentos en art-prompts/ (${assets.length} archivos de arte).`);
