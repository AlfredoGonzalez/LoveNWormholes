/**
 * FUENTE ÚNICA de todo el arte que necesita el juego. De aquí salen:
 *  - los nombres de archivo y tamaños (tools/process-art.ts)
 *  - los prompts y listas de art-prompts/*.md (tools/gen-art-docs.ts)
 * Los ids de personajes salen de src/game/data.ts, así que nunca se desincronizan con el juego.
 */
import { ERAS } from '../src/game/data';
import { ANIMS, CELL, FRAMES_PER_ANIM, type Anim } from './art-lib';

export type Kind = 'sheet' | 'icon' | 'logo' | 'background' | 'base' | 'fx' | 'screen' | 'panel' | 'frame';
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
  tier: 1 | 2 | 3 | 4 | 5; // prioridad (5 = rediseño de interfaz, Hito 6)
  have?: boolean;      // visto en el video del prototipo de Unity: probablemente ya lo tienes
  note?: string;
}

// ---------- Personajes ----------
const HERO_COMMON = 'Gusanito, a cute chubby bright-green (#7ccf5a) worm hero with 5 body segments, big shiny eyes, small determined eyebrows, a brave smile, and his signature black baseball cap with a white letter "A" on the front';
const HERO: Record<string, string> = {
  prehistoria: `${HERO_COMMON}, wearing a tiny leopard-skin loincloth and holding a big bone club`,
  egipto: `${HERO_COMMON}, wearing a wide golden collar and gold armbands, holding a small golden curved sword`,
  medieval: `${HERO_COMMON}, wearing a small steel breastplate and a red cape, holding a little sword and a wooden shield`,
  oeste: `${HERO_COMMON}, wearing a red bandana, a leather vest and a sheriff star badge, holding a toy revolver`,
};
const GUSANITA = 'Gusanita, a cute chubby pink (#ff8fb8) worm with long wavy pink hair, round glasses, a white daisy flower on her head, big shiny eyes and a curious sweet expression';
const HAVE_CHAR = new Set(['gusanito_prehistoria']); // en el video solo se ve a Gusanito de la Prehistoria

export const GUSANITA_SUBJECT = GUSANITA;
const SUBJECT: Record<string, string> = {
  // Prehistoria
  stick: 'a small tan-orange worm warrior holding a big wooden club almost taller than itself, fur loincloth',
  slinger: 'a small green worm with a leather sling and a pebble, leaf hat, mischievous grin',
  rock: 'a big sturdy grey worm carrying a huge round rock as a shield, stone helmet, grumpy cute face',
  rat: 'a cave rat with oversized front teeth, brown, tiny stone axe, angry but cute',
  bird: 'a toothy prehistoric bird, blue, small wings, sharp beak with teeth, silly menacing look',
  mammoth: 'a giant woolly mammoth boss, brown shaggy fur, large curved tusks, grumpy eyes, wearing a tiny crown, imposing yet comical',
  // Egipto
  spear: 'a small golden-tan worm warrior with a long spear, linen kilt, kohl eyes, brave face',
  archer: 'a teal worm archer with a bow and a papyrus quiver, eye-of-Horus necklace, focused look',
  sarcophagus: 'a sturdy worm inside a half-open golden sarcophagus used as armor, only eyes and arms visible, grumpy cute',
  scarab: 'an angry dark-blue scarab beetle with tiny gold wings and little mandibles, cute but fierce',
  mummy: 'a bandaged mummy with one eye peeking out, arms stretched forward, a funny trailing bandage',
  scarabking: 'a giant golden scarab king boss, jeweled shell, tiny crown, glowing eyes, imposing yet comical',
  // Edad Media
  sword: 'a grey worm squire with a small sword and a wooden shield, tiny chainmail cap',
  crossbow: 'a green worm crossbowman in a hood, big crossbow, cheeky smile',
  knight: 'a big sturdy worm in full plate armor with a tower shield, visor slit showing eyes',
  goblin: 'a sneaky green goblin with a dagger and a stolen coin bag, big ears, mischievous grin',
  skeleton: 'a dancing skeleton with a rusty sword, floppy pose, funny not scary',
  dragon: 'a big sleepy dragon boss, brown-orange scales, half-closed eyes, small wings, tiny smoke puffs, cute and imposing',
  // Lejano Oeste
  cowboy: 'a brown worm cowboy with a lasso and a hat, bandana, determined',
  sharp: 'a dark-teal worm gunslinger with a revolver, poncho, squinting eyes',
  barrel: 'a sturdy worm wearing a wooden barrel as armor, only eyes and feet visible, grumpy cute',
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
    bg, subject, group, wired: true, tier: (i === 0 ? 1 : i + 1) as 1 | 2 | 3 | 4, note: anim, have: HAVE_CHAR.has(id) && (anim === 'idle'),
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
  prehistoria: ['a cozy worm home shaped like a giant apple built from carved grey stone bricks with cave-painting carvings (mammoth, hunters), a green leaf and a stem on top, a winding stone staircase with vines leading to a dark doorway', 'a dark cave entrance with skull decorations and glowing red eyes inside, menacing but cartoonish'],
  egipto: ['a cozy worm house made of papyrus reeds with a tiny heart flag', 'a small dark pyramid with a glowing red eye at the top'],
  medieval: ['a small stone cottage with a banner showing a heart', 'a dark tower with a purple flag and glowing windows'],
  oeste: ['a wooden saloon-style house with a heart sign', 'a rickety outlaw hideout with wanted posters and a skull sign'],
};
for (const era of ERAS) {
  add({ file: `bg_${era.id}.png`, dir: 'backgrounds', kind: 'background', size: [1080, 1120], bg: 'white', subject: BG_SUBJECT[era.id], group: `${era.id}|scenery`, wired: true, tier: 2,
    note: 'composición vertical: elementos lejanos arriba, horizonte/suelo al ~85 % de la altura, SIN personajes' });
  add({ file: `base_${era.id}_home.png`, dir: 'bases', kind: 'base', size: [512, 640], bg: 'magenta', subject: BASE_SUBJECT[era.id][0], group: `${era.id}|scenery`, wired: true, tier: 2, have: era.id === 'prehistoria', note: 'hogar del jugador: se usa en la batalla Y como casa del hub (por eso es grande)' });
  add({ file: `base_${era.id}_enemy.png`, dir: 'bases', kind: 'base', size: [512, 640], bg: 'magenta', subject: BASE_SUBJECT[era.id][1], group: `${era.id}|scenery`, wired: true, tier: 2, note: 'base enemiga' });
}

// ---------- UI ----------
const icon = (file: string, subject: string, wired: boolean, bg: Bg = 'magenta', size: number | [number, number] = 256, tier: 1 | 2 | 3 | 4 | 5 = 1, note?: string, group = 'ui|icons', have = false): void =>
  add({ file, dir: 'ui', kind: 'icon', size: Array.isArray(size) ? size : [size, size], bg, subject, group, wired, tier, note, have });

icon('coin.png', 'a round gold coin with a tiny cute worm face embossed in the center, shiny rim, small highlight', true, 'magenta', 256, 1, undefined, 'ui|icons', true);
icon('gem.png', 'a single cute purple crystal gem with facets and a small sparkle', true, 'white');
icon('star_full.png', 'a chunky golden star with a thick outline and a small highlight, happy', true);
icon('star_empty.png', 'a chunky grey-blue star, empty/unearned, thick outline, no shine', true);
icon('energy.png', 'a yellow-orange lightning bolt with a thick outline and a small highlight', false, 'magenta', 128, 3);
icon('bone_coin.png', 'a small cartoon bone used as a battle currency, slightly shiny, with a tiny highlight', false, 'magenta', 128, 3, 'moneda de batalla (huesos): se gana al derrotar enemigos y se reinicia en cada nivel');
icon('wormhole.png', 'a swirling spiral wormhole portal, purple to cyan rings, sparkles, glowing, front view', false, 'white', 256, 3);
icon('heart.png', 'a glowing pink heart with tiny wings and sparkles (used for revive)', false, 'white', 256, 3);
icon('lock.png', 'a cute padlock icon, grey-blue with a thick outline', false, 'magenta', 128, 4);
icon('chest_closed.png', 'a cute wooden treasure chest, closed, with a purple wormhole glow leaking from the seams', false, 'magenta', 256, 3);
icon('chest_open.png', 'the same cute wooden treasure chest, open, spilling coins and a purple glow', false, 'magenta', 256, 3);
icon('ad_play.png', 'a rounded orange play-video button icon with a small gift ribbon on the corner', false, 'magenta', 128, 4);
icon('shop_gems_s.png', 'a small leather pouch spilling a few purple gems', true, 'white', 256, 2, 'Small Pouch', 'ui|icons', true);
icon('shop_gems_m.png', 'a medium woven basket overflowing with purple gems', true, 'white', 256, 2, 'Medium Basket', 'ui|icons', true);
icon('shop_gems_l.png', 'a large heap / pile of purple gems in a wooden bowl, glowing', true, 'white', 256, 2, 'Large Heap', 'ui|icons', true);
icon('shop_starter.png', 'a gift box with a pink bow and a tiny worm peeking out, coins and gems around it', true, 'magenta', 256, 2);
icon('shop_double_coins.png', 'two gold coins with a big "x2" badge, shiny', true, 'magenta', 256, 2);
add({ file: 'logo.png', dir: 'ui', kind: 'logo', size: [1024, 512], bg: 'white', subject: 'game logo: the words "Love n\' Wormholes" carved in a mossy stone sign with vines and small flowers, a small portrait of the green worm with a black cap at the top-left corner and a small portrait of the pink worm with glasses and a daisy at the top-right corner', group: 'ui|logo', wired: true, tier: 1, have: true, note: 'el texto de la IA suele salir con errores: revísalo; si falla, genera solo el emblema sin texto' });


// ================== REDISEÑO DE INTERFAZ (Hito 6) — basado en el prototipo de Unity ==================
const U5 = 5 as const;
const ui = (file: string, subject: string, size: number | [number, number], opts: { bg?: Bg; tier?: 1 | 2 | 3 | 4 | 5; have?: boolean; note?: string; group?: string } = {}) =>
  icon(file, subject, false, opts.bg ?? 'magenta', size, opts.tier ?? U5, opts.note, opts.group ?? 'ui|kit', opts.have ?? false);

// Historia e intro
const STORY = 'story|panels';
const panel = (file: string, subject: string, size: [number, number], group: string, have = false, note?: string): void =>
  add({ file, dir: 'story', kind: 'panel', size, bg: 'white', subject, group, wired: false, tier: U5, have, note });
const screen = (file: string, dir: string, subject: string, group: string, have = false, note?: string): void =>
  add({ file, dir, kind: 'screen', size: [1080, 1920], bg: 'white', subject, group, wired: false, tier: U5, have, note });
const frame = (file: string, subject: string, have = false): void =>
  add({ file, dir: 'ui', kind: 'frame', size: [1080, 1920], bg: 'magenta', subject, group: 'ui|frames', wired: false, tier: U5, have });

screen('intro_bg.png', 'story', 'cream paper background with a faint tone-on-tone pattern of hand-drawn doodles: little smiling worms, apples with a door, hearts, leaves, clocks, spears, stone axes and stopwatches, very low contrast so text and panels stay readable', STORY, true);
panel('story_01.png', 'a comic panel with a leafy vine border: the green worm with a black cap with an "A" and the pink worm with long pink hair, glasses and a white daisy cuddling happily inside their cozy hollow apple house, hearts floating, warm light, a round window behind them', [1024, 640], STORY, true, 'Intro 1/3: la pareja feliz');
panel('story_02.png', 'a comic panel with a leafy vine border: the pink worm with glasses and a daisy shows the green worm with the black "A" cap a strange glowing retro handheld gadget with an antenna, the green worm looks confused with a question mark above his head, inside the apple house', [1024, 640], STORY, true, 'Intro 2/3: encuentra el aparato');
panel('story_03.png', 'a comic panel with a leafy vine border: the pink worm presses the big button of the gadget and a swirling blue-purple wormhole portal opens and starts pulling her tail, she looks scared, the green worm with the black cap reaches out toward her with a shocked face', [1024, 640], STORY, true, 'Intro 3/3: el portal se la lleva');
panel('story_egipto.png', 'a comic panel with a leafy vine border: the pink worm with glasses and a daisy lands on warm sand in ancient Egypt in front of a pyramid, a giant curious cat looming behind her, she waves for help with a speech bubble containing a heart', [1024, 640], 'story|chapters', false, 'Capítulo: llegada a Egipto');
panel('story_medieval.png', 'a comic panel with a leafy vine border: the pink worm with glasses and a daisy peeks from a castle tower window, a sleepy dragon snoring below, she calls for help', [1024, 640], 'story|chapters', false, 'Capítulo: llegada a la Edad Media');
panel('story_oeste.png', 'a comic panel with a leafy vine border: the pink worm with glasses wearing a deputy star and a tiny cowboy hat next to a scorpion wearing a sheriff hat in a dusty wild west town, she looks worried', [1024, 640], 'story|chapters', false, 'Capítulo: llegada al Lejano Oeste');
for (const e of ERAS) {
  const costume: Record<string, string> = {
    prehistoria: 'holding her strange glowing gadget, worried face, a few leaves in her hair',
    egipto: 'wearing a gold headband and a tiny golden collar, waving for help',
    medieval: 'wearing a small pointed princess hat with a veil, calling for help',
    oeste: 'wearing a tiny cowboy hat and a deputy star badge, waving a tiny flag',
  };
  add({ file: `gusanita_${e.id}.png`, dir: 'characters', kind: 'icon', size: [512, 512], bg: 'magenta', subject: `${GUSANITA}, bust portrait (head and upper body) looking at the viewer, ${costume[e.id]}`, group: `${e.id}|heroes`, wired: false, tier: U5, note: 'retrato de Gusanita para los mensajes de cada era', have: e.id === 'prehistoria' });
}

// Título
screen('title_bg.png', 'ui', 'prehistoric jungle at dusk, purple-pink twilight sky, dinosaur silhouettes in the distance, giant ferns and tree trunks framing the sides, a mossy cliff with a round stone cave entrance with a dark opening in the lower middle, NO characters and NO text, empty space at the top for a logo and at the bottom for a button', 'ui|title', true);
ui('title_hero.png', 'Gusanito, the bright-green worm with a black baseball cap with a white "A", frowning with determination, holding a big bone club on his shoulder, upper body rising from the ground, dynamic pose, facing the viewer', [768, 768], { tier: U5, have: true, group: 'ui|title', note: 'pose grande para el título' });
ui('btn_wood.png', 'a blank orange wooden sign button with a rope-tied bone-and-stick frame at the corners, rough carved texture, NO text (the text is added by the game in each language)', [512, 192], { have: true, group: 'ui|buttons', note: 'sin texto: el juego pone «JUGAR» / «PLAY»' });
ui('btn_stone.png', 'a blank grey stone slab button, rounded rectangle, carved edges, NO text', [512, 160], { group: 'ui|buttons', note: 'botón secundario' });
ui('ribbon_title.png', 'a blank title banner made of a bone with a ribbon of aged parchment wrapped around it, NO text, wide', [800, 200], { have: true, group: 'ui|buttons', note: 'encabezado de pantallas (el texto lo pone el juego)' });
ui('popup_frame.png', 'a vertical popup window panel made of aged parchment with a thick stone border and small ferns at the corners, empty inside, NO text', [800, 900], { group: 'ui|buttons', note: 'ventanas emergentes (resultados, ajustes, avisos)' });

// Hub: barra superior y navegación
screen('hub_bg_prehistoria.png', 'backgrounds', 'cream paper background with a faint tone-on-tone pattern of hand-drawn prehistoric items: stone spears, axes, bones, footprints, apples, small stone tablets, very low contrast', 'prehistoria|hub', true);
screen('hub_bg_egipto.png', 'backgrounds', 'sand-colored papyrus background with a faint tone-on-tone pattern of hand-drawn ancient Egyptian items: ankhs, scarabs, eyes of Horus, pyramids, hieroglyph bits, very low contrast', 'egipto|hub');
screen('hub_bg_medieval.png', 'backgrounds', 'pale grey-blue parchment background with a faint tone-on-tone pattern of hand-drawn medieval items: swords, shields, castles, crowns, keys, very low contrast', 'medieval|hub');
screen('hub_bg_oeste.png', 'backgrounds', 'warm sand-orange paper background with a faint tone-on-tone pattern of hand-drawn wild west items: cowboy hats, horseshoes, cacti, revolvers, stars, wanted posters, very low contrast', 'oeste|hub');
ui('topbar.png', 'a horizontal dark stone bar for a game top HUD with a chiseled edge, empty, NO text', [1080, 160], { have: true, group: 'ui|hud' });
ui('pill.png', 'a blank stone pill-shaped counter slot (rounded rectangle) used to show a currency amount, carved edges, NO text', [320, 96], { have: true, group: 'ui|hud' });
ui('btn_round.png', 'a blank round grey stone button, carved rim, empty center, NO icon', [160, 160], { have: true, group: 'ui|hud' });
ui('icon_gear.png', 'a settings gear icon carved in stone, simple and chunky', 128, { have: true, group: 'ui|hud' });
ui('icon_menu.png', 'a hamburger menu icon (three horizontal bars) carved in stone, simple and chunky', 128, { have: true, group: 'ui|hud' });
ui('icon_quests.png', 'a rolled parchment quest scroll icon with a tiny seal, simple and chunky', 128, { have: true, group: 'ui|hud' });
ui('navbar.png', 'a horizontal bottom navigation strip made of grey stone bricks with a chiseled top edge, empty, NO text', [1080, 220], { have: true, group: 'ui|nav' });
ui('nav_tile.png', 'a blank square grey stone tile with rounded corners and carved edges, empty, NO icon', 200, { have: true, group: 'ui|nav' });
ui('nav_tile_active.png', 'a raised round wooden shield badge with a stone rim, slightly larger, empty center, NO icon', 260, { have: true, group: 'ui|nav', note: 'pestaña central destacada (Batalla)' });
ui('nav_map.png', 'an icon of a dark stone cave entrance with torches on each side (the dungeon map tab)', 128, { have: true, group: 'ui|nav' });
ui('nav_memories.png', 'an icon of two small worms, one pink with glasses and one green with a cap, snuggling together (the memories tab)', 128, { have: true, group: 'ui|nav' });
ui('nav_battle.png', 'an icon of two crossed bone-swords over a round wooden shield (the battle tab)', 160, { have: true, group: 'ui|nav' });
ui('nav_upgrades.png', 'an icon of a fan of stone cards with a percent sign "%" on the front (the upgrades tab)', 128, { have: true, group: 'ui|nav' });
ui('nav_shop.png', 'an icon of a cute market stall with a red-and-white striped awning and colorful potions (the shop tab)', 128, { have: true, group: 'ui|nav' });

// Mapa de niveles
frame('frame_map.png', 'an aged parchment page frame with sketchy ink ferns and leaves in the corners and a thin ink border, the whole center rectangle (about 90% of the image) is a solid flat magenta color #FF00FF to be cut out', true);
for (const e of ERAS) {
  const node: Record<string, string> = {
    prehistoria: 'a small round stone cave entrance with a dark opening and a few bones, hand-inked map icon',
    egipto: 'a small sandstone pyramid with a dark doorway, hand-inked map icon',
    medieval: 'a small stone castle gate with a flag, hand-inked map icon',
    oeste: 'a small wooden saloon front with swinging doors, hand-inked map icon',
  };
  const boss: Record<string, string> = {
    prehistoria: 'a fierce spiky green dinosaur-lizard boss rising from a hole in the ground, roaring, hand-inked map illustration',
    egipto: 'a giant golden scarab king emerging from the sand, roaring, hand-inked map illustration',
    medieval: 'a big sleepy dragon curled on a castle tower, one eye open, hand-inked map illustration',
    oeste: 'a giant scorpion wearing a sheriff hat rising from the desert sand, hand-inked map illustration',
  };
  ui(`map_node_${e.id}.png`, node[e.id], 256, { group: `${e.id}|map`, have: e.id === 'prehistoria' });
  ui(`map_boss_${e.id}.png`, boss[e.id], 384, { group: `${e.id}|map`, have: e.id === 'prehistoria', note: 'jefe final de la era: aparece arriba del mapa' });
}
ui('map_node_locked.png', 'a small grey cave entrance sealed with a padlock and chains, hand-inked map icon', 256, { group: 'ui|map' });
ui('event_slot.png', 'a blank small parchment card with a stone border for a timed event, with an empty area for an icon and a small hourglass at the bottom, NO text', [192, 240], { have: true, group: 'ui|events' });
ui('event_hunt.png', 'a caveman hunter silhouette holding a spear, icon', 128, { have: true, group: 'ui|events' });
ui('event_bones.png', 'a crossed pair of big bones, icon', 128, { have: true, group: 'ui|events' });
ui('event_forge.png', 'a stone axe with a lashed handle, icon', 128, { have: true, group: 'ui|events' });
ui('event_campfire.png', 'a small campfire with logs and flames, icon', 128, { have: true, group: 'ui|events' });

// Recuerdos (Worm Memories)
frame('frame_memories.png', 'an aged parchment page frame decorated with big cartoon bones along the edges and tiny hearts in the corners, the whole center rectangle (about 85% of the image) is a solid flat magenta color #FF00FF to be cut out', true);
ui('memory_frame.png', 'a blank polaroid photo frame (white card with a thin shadow, slightly tilted) with an empty square picture area, NO picture, NO text', [512, 600], { have: true, group: 'ui|memories' });
ui('memory_locked.png', 'a polaroid photo frame whose picture area is a dark silhouette of two worms hugging with a small padlock in the middle, NO text', [512, 600], { have: true, group: 'ui|memories' });
const MEM: [string, string][] = [
  ['01', 'sepia ink sketch of a pink worm with glasses and a green worm with a cap meeting for the first time, both blushing, small hearts'],
  ['02', 'sepia ink sketch of the two worms on a first date sharing a berry under a tree, small hearts'],
  ['03', 'sepia ink sketch of the two worms having a small funny fight, back to back with crossed arms and puffed cheeks'],
  ['04', 'sepia ink sketch of the two worms reuniting with a big hug, joyful, hearts and sparkles'],
  ['05', 'sepia ink sketch of the two worms exploring a deep underground burrow with a tiny lantern'],
  ['06', 'sepia ink sketch of the two worms hunting together as a couple, one with a club and one with a slingshot, funny poses'],
];
for (const [n, d] of MEM) panel(`memory_${n}.png`, d, [480, 480], 'ui|memories', true, `recuerdo ${n}/06 (se desbloquea con el Medidor de Amor)`);

// Mejoras (cartas)
frame('frame_upgrades.png', 'a carved grey stone slab frame with fern leaves and small bones at the corners and a banner at the top, the whole center rectangle (about 80% of the image) is a solid flat magenta color #FF00FF to be cut out', true);
ui('card_frame.png', 'a blank upgrade card: parchment center with a stone border, an empty area for an illustration at the top and an empty area for text at the bottom, NO text', [256, 360], { have: true, group: 'ui|cards' });
ui('card_back.png', 'an unknown card slot: a dashed-outline parchment card with a big question mark "?" in the middle', [256, 360], { have: true, group: 'ui|cards' });
ui('stat_attack.png', 'a stone sword icon, chunky, simple', 128, { have: true, group: 'ui|cards' });
ui('stat_health.png', 'a red heart icon with a thick outline, simple', 128, { have: true, group: 'ui|cards', bg: 'white' });
ui('stat_crit.png', 'a golden star icon with a thick outline, simple', 128, { have: true, group: 'ui|cards' });
ui('btn_reroll.png', 'a round stone button with a circular double-arrow "reroll" symbol and a tiny gold coin at the bottom, NO text', 192, { have: true, group: 'ui|cards' });

// Tienda (The Worm Mart)
frame('frame_shop.png', 'an aged parchment page frame with a wooden plank border tied with vines and little leaves, the whole center rectangle (about 88% of the image) is a solid flat magenta color #FF00FF to be cut out', true);
ui('mart_shopkeeper.png', 'a friendly worm shopkeeper wearing a hat made of a bone and leaves, smiling, waving, bust portrait, with an empty speech bubble area NOT drawn', 512, { have: true, group: 'ui|shop' });
ui('deal_potion.png', 'a round glass potion bottle with a cork and a glowing orange liquid, ink-sketch style item icon', 256, { have: true, group: 'ui|shop', note: 'oferta diaria: poción de energía' });
ui('deal_sword.png', 'a prehistoric stone sword with a lashed handle, ink-sketch style item icon', 256, { have: true, group: 'ui|shop', note: 'oferta diaria: carta de ataque' });
ui('deal_bone.png', 'a big carved bone with runes, ink-sketch style item icon', 256, { have: true, group: 'ui|shop', note: 'oferta diaria: paquete de monedas' });

// Batalla (HUD)
ui('hud_unit_btn.png', 'a stone slab summon button with an empty circular area at the top for a unit portrait and a small empty badge at the bottom-right for the energy cost, NO text', [252, 200], { tier: 3, group: 'ui|hud', note: 'botón de invocar unidades en batalla' });

// ---------- Efectos (aún sin integrar) ----------
const fx = (file: string, subject: string, size: [number, number], bg: Bg = 'magenta'): void =>
  add({ file, dir: 'fx', kind: 'fx', size, bg, subject, group: 'extras|fx', wired: false, tier: 4 });
fx('meteor.png', 'a flaming meteor falling diagonally with a fire trail, cartoon', [256, 256]);
fx('explosion.png', 'a cartoon impact explosion burst, orange and yellow, comic style', [256, 256]);
fx('tumbleweed.png', 'a cute rolling tumbleweed with tiny eyes', [128, 128]);
fx('ghost_portal.png', 'a small purple-cyan wormhole opening with sparkles', [256, 256], 'white');

// Archivos que el juego ya carga (Hito 6a): título, intro, hub y navegación.
const WIRED = new Set([
  'story_01.png', 'story_02.png', 'story_03.png', 'intro_bg.png', 'title_bg.png', 'title_hero.png', 'btn_wood.png', 'btn_stone.png',
  'topbar.png', 'pill.png', 'btn_round.png', 'icon_gear.png', 'navbar.png', 'nav_tile.png', 'nav_tile_active.png',
  'nav_map.png', 'nav_memories.png', 'nav_battle.png', 'nav_upgrades.png', 'nav_shop.png', 'bone_coin.png',
  ...ERAS.flatMap(e => [`hub_bg_${e.id}.png`, `map_boss_${e.id}.png`]),
]);
for (const a of assets) if (WIRED.has(a.file)) a.wired = true;

export const byFile = new Map(assets.map(a => [`${a.dir}/${a.file}`, a]));
export const spec = { assets };
