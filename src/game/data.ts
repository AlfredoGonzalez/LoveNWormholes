import type { Key } from '../i18n';

export interface UnitDef {
  id: string;
  nameKey: Key;
  cost: number;      // energía para invocar
  hp: number;
  damage: number;
  range: number;     // px
  speed: number;     // px/s
  cooldown: number;  // segundos entre ataques
  color: number;     // arte placeholder
  size: number;
}

export interface WaveEntry { at: number; enemy: string; count: number }

export type AnomalyKind = 'meteor' | 'sandstorm' | 'ghost' | 'stampede';
export interface AnomalyDef { kind: AnomalyKind; nameKey: Key; interval: number }

export interface LevelDef {
  id: string;
  eraId: string;
  nameKey: Key;
  laneLength: number;
  baseHp: number;       // vida del hogar
  enemyBaseHp: number;  // vida de la base enemiga
  enemyBoost: number;   // multiplicador de vida/daño de los enemigos del nivel
  coins: number; // recompensa base por estrella
  waves: WaveEntry[];
}

export interface EraDef {
  id: string;
  nameKey: Key;
  introKey: Key;      // mensaje de Gusanita al llegar
  power: number;      // factor de poder de unidades/bases de la era
  sky: number;
  ground: number;
  units: UnitDef[];   // las 4 unidades invocables de la era
  enemies: UnitDef[]; // [pequeño, mediano, jefe]
  ghost: UnitDef;     // aliado fantasma (anomalía 'ghost')
  anomaly: AnomalyDef;
  levels: LevelDef[];
}

// ---- Arquetipos (balance base de la Prehistoria; cada era los escala con `power`) ----
type Stats = Omit<UnitDef, 'id' | 'nameKey' | 'color'>;
const PLAYER: Record<'fighter' | 'ranged' | 'tank' | 'elite', Stats> = {
  fighter: { cost: 20, hp: 60, damage: 8, range: 30, speed: 55, cooldown: 0.8, size: 18 },
  ranged: { cost: 35, hp: 40, damage: 10, range: 140, speed: 45, cooldown: 1.1, size: 16 },
  tank: { cost: 60, hp: 220, damage: 12, range: 32, speed: 35, cooldown: 1.4, size: 26 },
  elite: { cost: 100, hp: 160, damage: 30, range: 45, speed: 50, cooldown: 1.0, size: 24 },
};
const ENEMY: Record<'small' | 'mid' | 'boss', Stats> = {
  small: { cost: 0, hp: 40, damage: 6, range: 28, speed: 60, cooldown: 0.8, size: 16 },
  mid: { cost: 0, hp: 55, damage: 9, range: 36, speed: 50, cooldown: 1.0, size: 18 },
  boss: { cost: 0, hp: 900, damage: 35, range: 50, speed: 22, cooldown: 1.6, size: 44 },
};

const mk = (id: string, nameKey: Key, s: Stats, color: number, power: number): UnitDef => ({
  id, nameKey, color, ...s, hp: Math.round(s.hp * power), damage: Math.round(s.damage * power),
});

export const scaleUnit = (u: UnitDef, power: number): UnitDef =>
  ({ ...u, hp: Math.round(u.hp * power), damage: Math.round(u.damage * power) });

/** Oleadas generadas: lvl 0..2 sube la dificultad dentro de la era. */
function genWaves(small: string, mid: string, boss: string, lvl: number): WaveEntry[] {
  return [
    { at: 2, enemy: small, count: 2 + lvl },
    { at: 14, enemy: small, count: 3 + lvl },
    { at: 28, enemy: mid, count: 2 + lvl },
    { at: 44, enemy: small, count: 4 + lvl },
    { at: 60, enemy: mid, count: 3 + lvl },
    { at: 80 + lvl * 5, enemy: boss, count: lvl === 2 ? 2 : 1 },
  ];
}

function levels(eraId: string, eraIdx: number, power: number, names: [Key, Key, Key], ids: [string, string, string]): LevelDef[] {
  return names.map((nameKey, i) => ({
    id: `${eraId}-${i + 1}`, eraId, nameKey, laneLength: 1000,
    baseHp: Math.round(500 * power), enemyBaseHp: Math.round((1500 + i * 700) * power), enemyBoost: [1.3, 1.6, 1.8][i], coins: 30 + eraIdx * 20 + i * 15,
    waves: genWaves(ids[0], ids[1], ids[2], i),
  }));
}

// ---- Héroe ----
export const HERO_DEF: UnitDef = {
  id: 'hero', nameKey: 'unit_chief', cost: 0, hp: 300, damage: 18, range: 40, speed: 55, cooldown: 0.7, color: 0x7ccf5a, size: 24,
};

// ---- Eras ----
const prehistoria: EraDef = {
  id: 'prehistoria', nameKey: 'era_prehistoria', introKey: 'story_intro', power: 1, sky: 0x7fb8e6, ground: 0x6b8e4e,
  units: [
    mk('stick', 'unit_stick', PLAYER.fighter, 0xf2a65a, 1),
    mk('slinger', 'unit_slinger', PLAYER.ranged, 0x7bc67e, 1),
    mk('rock', 'unit_rock', PLAYER.tank, 0x9a8f97, 1),
    mk('chief', 'unit_chief', PLAYER.elite, 0xe85d75, 1),
  ],
  enemies: [
    mk('rat', 'enemy_rat', ENEMY.small, 0x8a6d5a, 1),
    mk('bird', 'enemy_bird', ENEMY.mid, 0x5aa9e6, 1),
    mk('mammoth', 'enemy_mammoth', ENEMY.boss, 0x6b4423, 1),
  ],
  ghost: mk('ghost', 'unit_ghostknight', { cost: 0, hp: 150, damage: 25, range: 40, speed: 70, cooldown: 0.9, size: 22 }, 0xcfd8ff, 1),
  anomaly: { kind: 'meteor', nameKey: 'anom_meteor', interval: 25 },
  levels: [],
};
// Los 3 niveles de la Prehistoria tienen oleadas escritas a mano.
prehistoria.levels = [
  {
    id: 'prehistoria-1', eraId: 'prehistoria', nameKey: 'level_prehistoria_1', laneLength: 1000, baseHp: 500, enemyBaseHp: 1500, enemyBoost: 1.3, coins: 30,
    waves: [
      { at: 2, enemy: 'rat', count: 2 }, { at: 15, enemy: 'rat', count: 3 }, { at: 30, enemy: 'bird', count: 2 },
      { at: 45, enemy: 'rat', count: 4 }, { at: 60, enemy: 'bird', count: 3 }, { at: 80, enemy: 'mammoth', count: 1 },
    ],
  },
  {
    id: 'prehistoria-2', eraId: 'prehistoria', nameKey: 'level_prehistoria_2', laneLength: 1000, baseHp: 500, enemyBaseHp: 2200, enemyBoost: 1.6, coins: 45,
    waves: [
      { at: 2, enemy: 'rat', count: 3 }, { at: 12, enemy: 'bird', count: 2 }, { at: 25, enemy: 'rat', count: 5 },
      { at: 40, enemy: 'bird', count: 4 }, { at: 55, enemy: 'rat', count: 6 }, { at: 70, enemy: 'bird', count: 5 },
      { at: 90, enemy: 'mammoth', count: 1 },
    ],
  },
  {
    id: 'prehistoria-3', eraId: 'prehistoria', nameKey: 'level_prehistoria_3', laneLength: 1000, baseHp: 500, enemyBaseHp: 2900, enemyBoost: 1.3, coins: 60,
    waves: [
      { at: 2, enemy: 'bird', count: 3 }, { at: 15, enemy: 'rat', count: 6 }, { at: 30, enemy: 'mammoth', count: 1 },
      { at: 50, enemy: 'bird', count: 5 }, { at: 65, enemy: 'rat', count: 8 }, { at: 85, enemy: 'mammoth', count: 2 },
    ],
  },
];

const egipto: EraDef = {
  id: 'egipto', nameKey: 'era_egipto', introKey: 'msg_egipto', power: 1.5, sky: 0xffd98a, ground: 0xe8c37a,
  units: [
    mk('spear', 'unit_spear', PLAYER.fighter, 0xd4a017, 1.5),
    mk('archer', 'unit_archer', PLAYER.ranged, 0x2a9d8f, 1.5),
    mk('sarcophagus', 'unit_sarcophagus', PLAYER.tank, 0xb08d57, 1.5),
    mk('pharaoh', 'unit_pharaoh', PLAYER.elite, 0x3a6ea5, 1.5),
  ],
  enemies: [
    mk('scarab', 'enemy_scarab', ENEMY.small, 0x264653, 1.5),
    mk('mummy', 'enemy_mummy', ENEMY.mid, 0xe9e2c8, 1.5),
    mk('scarabking', 'enemy_scarabking', ENEMY.boss, 0xc9a227, 1.5),
  ],
  ghost: mk('ghost', 'unit_ghostknight', { cost: 0, hp: 150, damage: 25, range: 40, speed: 70, cooldown: 0.9, size: 22 }, 0xcfd8ff, 1.5),
  anomaly: { kind: 'sandstorm', nameKey: 'anom_sandstorm', interval: 30 },
  levels: [],
};
egipto.levels = levels('egipto', 1, 1.5, ['level_egipto_1', 'level_egipto_2', 'level_egipto_3'], ['scarab', 'mummy', 'scarabking']);

const medieval: EraDef = {
  id: 'medieval', nameKey: 'era_medieval', introKey: 'msg_medieval', power: 2.1, sky: 0x9bb7d4, ground: 0x7a8f5a,
  units: [
    mk('sword', 'unit_sword', PLAYER.fighter, 0x8d99ae, 2.1),
    mk('crossbow', 'unit_crossbow', PLAYER.ranged, 0x6a994e, 2.1),
    mk('knight', 'unit_knight', PLAYER.tank, 0x6c757d, 2.1),
    mk('king', 'unit_king', PLAYER.elite, 0xb23a48, 2.1),
  ],
  enemies: [
    mk('goblin', 'enemy_goblin', ENEMY.small, 0x588157, 2.1),
    mk('skeleton', 'enemy_skeleton', ENEMY.mid, 0xe0e0d1, 2.1),
    mk('dragon', 'enemy_dragon', ENEMY.boss, 0x7f5539, 2.1),
  ],
  ghost: mk('ghost', 'unit_ghostknight', { cost: 0, hp: 150, damage: 25, range: 40, speed: 70, cooldown: 0.9, size: 22 }, 0xcfd8ff, 2.1),
  anomaly: { kind: 'ghost', nameKey: 'anom_ghost', interval: 30 },
  levels: [],
};
medieval.levels = levels('medieval', 2, 2.1, ['level_medieval_1', 'level_medieval_2', 'level_medieval_3'], ['goblin', 'skeleton', 'dragon']);

const oeste: EraDef = {
  id: 'oeste', nameKey: 'era_oeste', introKey: 'msg_oeste', power: 2.8, sky: 0xf4a261, ground: 0xd9a066,
  units: [
    mk('cowboy', 'unit_cowboy', PLAYER.fighter, 0x8c4a2f, 2.8),
    mk('sharp', 'unit_sharp', PLAYER.ranged, 0x264653, 2.8),
    mk('barrel', 'unit_barrel', PLAYER.tank, 0x9c6644, 2.8),
    mk('sheriff', 'unit_sheriff', PLAYER.elite, 0xe9c46a, 2.8),
  ],
  enemies: [
    mk('coyote', 'enemy_coyote', ENEMY.small, 0xa68a64, 2.8),
    mk('outlaw', 'enemy_outlaw', ENEMY.mid, 0x588157, 2.8),
    mk('scorpion', 'enemy_scorpion', ENEMY.boss, 0x6d2e46, 2.8),
  ],
  ghost: mk('ghost', 'unit_ghostknight', { cost: 0, hp: 150, damage: 25, range: 40, speed: 70, cooldown: 0.9, size: 22 }, 0xcfd8ff, 2.8),
  anomaly: { kind: 'stampede', nameKey: 'anom_stampede', interval: 28 },
  levels: [],
};
oeste.levels = levels('oeste', 3, 2.8, ['level_oeste_1', 'level_oeste_2', 'level_oeste_3'], ['coyote', 'outlaw', 'scorpion']);

export const ERAS: EraDef[] = [prehistoria, egipto, medieval, oeste];
export const LEVELS: LevelDef[] = ERAS.flatMap(e => e.levels);

export const eraById = (id: string): EraDef => ERAS.find(e => e.id === id) ?? ERAS[0];
export const levelById = (id: string): LevelDef => LEVELS.find(l => l.id === id) ?? LEVELS[0];

/** Registro de todos los enemigos por id. */
export const ENEMY_UNITS: Record<string, UnitDef> = Object.fromEntries(ERAS.flatMap(e => e.enemies).map(u => [u.id, u]));
