export type Lang = 'es' | 'en';

const dict = {
  es: {
    title: 'Love N Wormholes',
    era_prehistoria: 'Prehistoria',
    boss_prehistoria: 'Gran Mamut Peludo',
    energy: 'Energía',
    wormhole: 'Agujero de gusano',
    base_player: 'Hogar',
    base_enemy: 'Cueva enemiga',
    win: '¡Gusanita está a salvo... por ahora!',
    lose: 'Gusanito fue derrotado',
    retry: 'Reintentar',
    unit_stick: 'Gusano garrote',
    unit_slinger: 'Gusano honda',
    unit_rock: 'Gusano roca',
    unit_chief: 'Jefe de la tribu',
    enemy_rat: 'Rata cavernaria',
    enemy_bird: 'Pájaro dientes',
    enemy_mammoth: 'Mamut peludo',
    story_intro: 'Gusanita tocó un botón raro... ¡y desapareció! Gusanito: "¡Voy por ti, mi amor!"',
  },
  en: {
    title: 'Love N Wormholes',
    era_prehistoria: 'Prehistoric',
    boss_prehistoria: 'Great Woolly Mammoth',
    energy: 'Energy',
    wormhole: 'Wormhole',
    base_player: 'Home',
    base_enemy: 'Enemy cave',
    win: 'Gusanita is safe... for now!',
    lose: 'Gusanito was defeated',
    retry: 'Retry',
    unit_stick: 'Club worm',
    unit_slinger: 'Sling worm',
    unit_rock: 'Rock worm',
    unit_chief: 'Tribe chief',
    enemy_rat: 'Cave rat',
    enemy_bird: 'Toothy bird',
    enemy_mammoth: 'Woolly mammoth',
    story_intro: 'Gusanita pressed a weird button... and vanished! Gusanito: "I\'m coming for you, my love!"',
  },
} as const;

export type Key = keyof typeof dict.es;

let lang: Lang = typeof navigator !== 'undefined' && navigator.language?.startsWith('es') ? 'es' : 'en';

export const setLang = (l: Lang) => { lang = l; };
export const getLang = () => lang;
export const t = (k: Key): string => dict[lang][k];
export const dictionaries = dict;
