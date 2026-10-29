/**
 * FUENTE ÚNICA de todo el arte que necesita el juego. De aquí salen:
 *  - los nombres de archivo y tamaños (tools/process-art.ts)
 *  - los prompts y listas de art-prompts/*.md (tools/gen-art-docs.ts)
 * Los ids de personajes salen de src/game/data.ts, así que nunca se desincronizan con el juego.
 */
import { ERAS } from '../src/game/data';
import { ANIMS, CELL, FRAMES_PER_ANIM, type Anim } from './art-lib';

export type Kind = 'sheet' | 'icon' | 'logo' | 'background' | 'base' | 'fx';
export type Bg = 'magenta' | 'white';

export interface Asset {
  file: string;        // nombre de archivo final (y nombre que debe tener tu imagen cruda)
  dir: string;         // carpeta dentro de public/assets
  kind: Kind;
  size: [number, number]; // tamaño final en px
  frames?: number;     // solo hojas
  bg: Bg;              // fondo recomendado para generar
  subject: string;     // descripción en inglés para el prompt
  group: string;       // para agrupar en los .md
  wired: boolean;      // ¿el juego ya lo usa?
  tier: 1 | 2 | 3 | 4; // prioridad
  note?: string;
}

// ---------- Personajes ----------
const HERO_COMMON = 'Gusanito, a cute chubby pink-salmon (#ff8fa3) worm hero with 5 body segments, big shiny eyes, a brave smile and small determined eyebrows';
const HERO: Record<string, string> = {
  prehistoria: `${HERO_COMMON}, wearing a tiny leopard-skin loincloth and a bone headband`,
  egipto: `${HERO_COMMON}, wearing a blue-and-gold nemes headdress, a wide golden collar and kohl-lined eyes`,
  medieval: `${HERO_COMMON}, wearing a small knight helmet with a feather, a red cape and holding a toy sword`,
  oeste: `${HERO_COMMON}, wearing a cowboy hat, a red bandana and a small sheriff star`,
};

const SUBJECT: Record<string, string> = {
  // Prehistoria
  stick: 'a small tan-orange worm warrior holding a big wooden club almost taller than itself, fur loincloth',
  slinger: 'a small green worm with a leather sling and a pebble, leaf hat, mischievous grin',
  rock: 'a big sturdy grey worm carrying a huge round rock as a shield, stone helmet, grumpy cute face',
  chief: 'a worm tribe chief, red-pink, huge feathered headdress, bone necklace, holding a carved totem staff, proud expression',
  rat: 'a cave rat with oversized front teeth, brown, tiny stone axe, angry but cute',
  bird: 'a toothy prehistoric bird, blue, small wings, sharp beak with teeth, silly menacing look',
  mammoth: 'a giant woolly mammoth boss, brown shaggy fur, large curved tusks, grumpy eyes, wearing a tiny crown, imposing yet comical',
  // Egipto
  spear: 'a small golden-tan worm warrior with a long spear, linen kilt, kohl eyes, brave face',
  archer: 'a teal worm archer with a bow and a papyrus quiver, eye-of-Horus necklace, focused look',
  sarcophagus: 'a sturdy worm inside a half-open golden sarcophagus used as armor, only eyes and arms visible, grumpy cute',
  pharaoh: 'a blue worm pharaoh with a tall double crown, golden crook and flail, regal and slightly pompous',
  scarab: 'an angry dark-blue scarab beetle with tiny gold wings and little mandibles, cute but fierce',
  mummy: 'a bandaged mummy with one eye peeking out, arms stretched forward, a funny trailing bandage',
  scarabking: 'a giant golden scarab king boss, jeweled shell, tiny crown, glowing eyes, imposing yet comical',
  // Edad Media
  sword: 'a grey worm squire with a small sword and a wooden shield, tiny chainmail cap',
  crossbow: 'a green worm crossbowman in a hood, big crossbow, cheeky smile',
  knight: 'a big sturdy worm in full plate armor with a tower shield, visor slit showing eyes',
  king: 'a red-robed worm king with a golden crown and an ermine cape, holding a scepter, proud',
  goblin: 'a sneaky green goblin with a dagger and a stolen coin bag, big ears, mischievous grin',
  skeleton: 'a dancing skeleton with a rusty sword, floppy pose, funny not scary',
  dragon: 'a big sleepy dragon boss, brown-orange scales, half-closed eyes, small wings, tiny smoke puffs, cute and imposing',
  // Lejano Oeste
  cowboy: 'a brown worm cowboy with a lasso and a hat, bandana, determined',
  sharp: 'a dark-teal worm gunslinger with a revolver, poncho, squinting eyes',
  barrel: 'a sturdy worm wearing a wooden barrel as armor, only eyes and feet visible, grumpy cute',
  sheriff: 'a golden worm sheriff with a big star badge, long mustache, cowboy hat',
  coyote: 'a bandit coyote with a mask and a bandana, sneaky grin, small pistol',
  outlaw: 'an outlaw cactus with a tiny hat and an angry face, spiky arms',
  scorpion: 'a giant scorpion boss wearing a sheriff hat and a star badge, big claws, purple-maroon shell, comical menace',
  // Extra
  ghost: 'a translucent ghost-knight worm from the future, glowing cyan-white, futuristic armor with a visor and a small energy sword, wispy tail, friendly',
};

const POSE: Record<Anim, string> = {
  idle: 'IDLE loop (calm breathing): frame 1 neutral, frame 2 body slightly stretched up, frame 3 neutral, frame 4 body slightly squashed down',
  walk: 'WALK cycle (worm inching forward, facing right): frame 1 body compressed, frame 2 front stretching forward, frame 3 fully stretched, frame 4 back pulling forward',
  attack: 'ATTACK: frame 1 wind-up (leaning back), frame 2 strike at full extension, frame 3 follow-through with a small impact spark, frame 4 recovery',
  die: 'DEFEAT: frame 1 hit flinch, frame 2 dizzy with little stars, frame 3 flattened on the ground, frame 4 fading away with sparkles',
};
export const poseText = (a: Anim) => POSE[a];

export const assets: Asset[] = [];
const add = (a: Asset): void => { assets.push(a); };

const sheetSize: [number, number] = [CELL * FRAMES_PER_ANIM, CELL];
function addCharacter(id: string, subject: string, group: string, bg: Bg = 'magenta') {
  ANIMS.forEach((anim, i) => add({
    file: `${id}_${anim}.png`, dir: 'characters', kind: 'sheet', size: sheetSize, frames: FRAMES_PER_ANIM,
    bg, subject, group, wired: true, tier: (i === 0 ? 1 : i + 1) as 1 | 2 | 3 | 4, note: anim,
  }));
}

for (const era of ERAS) {
  addCharacter(`gusanito_${era.id}`, HERO[era.id], `${era.id}|heroes`);
  for (const u of [...era.units, ...era.enemies]) addCharacter(u.id, SUBJECT[u.id], `${era.id}|${era.enemies.includes(u) ? 'enemies' : 'allies'}`);
}
addCharacter('ghost', SUBJECT.ghost, 'extras|ghost');

// ---------- Fondos y bases ----------
const BG_SUBJECT: Record<string, string> = {
  prehistoria: 'prehistoric landscape: soft blue sky with fluffy clouds, a smoking volcano and misty mountains far away, giant ferns and prehistoric trees on the sides, grassy ground',
  egipto: 'ancient Egypt landscape: golden sky with a big sun, pyramids and obelisks in the distance, palm trees, sand dunes',
  medieval: 'medieval landscape: blue-grey sky, a castle on a hill in the distance, a stone wall, trees, flowers and a grassy ground',
  oeste: 'wild west landscape at sunset: orange sky, red mesas far away, cacti, a water tower and a wooden wagon, sandy ground',
};
const BASE_SUBJECT: Record<string, [string, string]> = {
  prehistoria: ['a cozy worm home made of a giant hollow fruit with a leaf roof, warm light in the doorway and a tiny heart flag', 'a dark cave entrance with skull decorations and glowing red eyes inside, menacing but cartoonish'],
  egipto: ['a cozy worm house made of papyrus reeds with a tiny heart flag', 'a small dark pyramid with a glowing red eye at the top'],
  medieval: ['a small stone cottage with a banner showing a heart', 'a dark tower with a purple flag and glowing windows'],
  oeste: ['a wooden saloon-style house with a heart sign', 'a rickety outlaw hideout with wanted posters and a skull sign'],
};
for (const era of ERAS) {
  add({ file: `bg_${era.id}.png`, dir: 'backgrounds', kind: 'background', size: [1080, 1120], bg: 'white', subject: BG_SUBJECT[era.id], group: `${era.id}|scenery`, wired: true, tier: 2,
    note: 'composición vertical: elementos lejanos arriba, horizonte/suelo al ~85 % de la altura, SIN personajes' });
  add({ file: `base_${era.id}_home.png`, dir: 'bases', kind: 'base', size: [256, 320], bg: 'magenta', subject: BASE_SUBJECT[era.id][0], group: `${era.id}|scenery`, wired: true, tier: 2, note: 'hogar del jugador' });
  add({ file: `base_${era.id}_enemy.png`, dir: 'bases', kind: 'base', size: [256, 320], bg: 'magenta', subject: BASE_SUBJECT[era.id][1], group: `${era.id}|scenery`, wired: true, tier: 2, note: 'base enemiga' });
}

// ---------- UI ----------
const icon = (file: string, subject: string, wired: boolean, bg: Bg = 'magenta', size = 256, tier: 1 | 2 | 3 | 4 = 1, note?: string): void =>
  add({ file, dir: 'ui', kind: 'icon', size: [size, size], bg, subject, group: 'ui|icons', wired, tier, note });

icon('coin.png', 'a round gold coin with a tiny cute worm face (Gusanito) embossed in the center, shiny rim, small highlight', true);
icon('gem.png', 'a single cute purple crystal gem with facets and a small sparkle', true, 'white');
icon('star_full.png', 'a chunky golden star with a thick outline and a small highlight, happy', true);
icon('star_empty.png', 'a chunky grey-blue star, empty/unearned, thick outline, no shine', true);
icon('energy.png', 'a yellow-orange lightning bolt with a thick outline and a small highlight', false, 'magenta', 128, 3);
icon('wormhole.png', 'a swirling spiral wormhole portal, purple to cyan rings, sparkles, glowing, front view', false, 'white', 256, 3);
icon('heart.png', 'a glowing pink heart with tiny wings and sparkles (used for revive)', false, 'white', 256, 3);
icon('lock.png', 'a cute padlock icon, grey-blue with a thick outline', false, 'magenta', 128, 4);
icon('chest_closed.png', 'a cute wooden treasure chest, closed, with a purple wormhole glow leaking from the seams', false, 'magenta', 256, 3);
icon('chest_open.png', 'the same cute wooden treasure chest, open, spilling coins and a purple glow', false, 'magenta', 256, 3);
icon('ad_play.png', 'a rounded orange play-video button icon with a small gift ribbon on the corner', false, 'magenta', 128, 4);
icon('shop_gems_s.png', 'a small cloth pouch spilling a few purple gems', true, 'white', 256, 2);
icon('shop_gems_m.png', 'a medium sack overflowing with purple gems', true, 'white', 256, 2);
icon('shop_gems_l.png', 'a wooden treasure chest overflowing with purple gems and glowing', true, 'white', 256, 2);
icon('shop_starter.png', 'a gift box with a pink bow and a tiny worm peeking out, coins and gems around it', true, 'magenta', 256, 2);
icon('shop_double_coins.png', 'two gold coins with a big "x2" badge, shiny', true, 'magenta', 256, 2);
add({ file: 'logo.png', dir: 'ui', kind: 'logo', size: [1024, 512], bg: 'white', subject: 'game logo: the words "Love N Wormholes" in bold playful lettering with two cute worms (one pink, one lilac) hugging inside a swirling purple wormhole, sticker style', group: 'ui|logo', wired: true, tier: 1, note: 'el texto de la IA suele salir con errores: revísalo; si falla, genera solo el emblema sin texto' });

// ---------- Efectos (aún sin integrar) ----------
const fx = (file: string, subject: string, size: [number, number], bg: Bg = 'magenta'): void =>
  add({ file, dir: 'fx', kind: 'fx', size, bg, subject, group: 'extras|fx', wired: false, tier: 4 });
fx('meteor.png', 'a flaming meteor falling diagonally with a fire trail, cartoon', [256, 256]);
fx('explosion.png', 'a cartoon impact explosion burst, orange and yellow, comic style', [256, 256]);
fx('tumbleweed.png', 'a cute rolling tumbleweed with tiny eyes', [128, 128]);
fx('ghost_portal.png', 'a small purple-cyan wormhole opening with sparkles', [256, 256], 'white');

export const byFile = new Map(assets.map(a => [`${a.dir}/${a.file}`, a]));
export const spec = { assets };
