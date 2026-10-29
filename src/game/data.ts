import type { Key } from '../i18n';

export interface UnitDef {
  id: string;
  nameKey: Key;
  cost: number;      // energy to summon
  hp: number;
  damage: number;
  range: number;     // px
  speed: number;     // px/s
  cooldown: number;  // seconds between attacks
  color: number;     // placeholder art
  size: number;
}

export const PLAYER_UNITS: UnitDef[] = [
  { id: 'stick', nameKey: 'unit_stick', cost: 20, hp: 60, damage: 8, range: 30, speed: 55, cooldown: 0.8, color: 0xf2a65a, size: 18 },
  { id: 'slinger', nameKey: 'unit_slinger', cost: 35, hp: 40, damage: 10, range: 140, speed: 45, cooldown: 1.1, color: 0x7bc67e, size: 16 },
  { id: 'rock', nameKey: 'unit_rock', cost: 60, hp: 220, damage: 12, range: 32, speed: 35, cooldown: 1.4, color: 0x9a8f97, size: 26 },
  { id: 'chief', nameKey: 'unit_chief', cost: 100, hp: 160, damage: 30, range: 45, speed: 50, cooldown: 1.0, color: 0xe85d75, size: 24 },
];

export const ENEMY_UNITS: Record<string, UnitDef> = {
  rat: { id: 'rat', nameKey: 'enemy_rat', cost: 0, hp: 40, damage: 6, range: 28, speed: 60, cooldown: 0.8, color: 0x8a6d5a, size: 16 },
  bird: { id: 'bird', nameKey: 'enemy_bird', cost: 0, hp: 55, damage: 9, range: 36, speed: 50, cooldown: 1.0, color: 0x5aa9e6, size: 18 },
  mammoth: { id: 'mammoth', nameKey: 'enemy_mammoth', cost: 0, hp: 900, damage: 35, range: 50, speed: 22, cooldown: 1.6, color: 0x6b4423, size: 44 },
};

export interface WaveEntry { at: number; enemy: string; count: number }

export const HERO_DEF: UnitDef = {
  id: 'hero', nameKey: 'unit_chief', cost: 0, hp: 300, damage: 18, range: 40, speed: 55, cooldown: 0.7, color: 0xff7bac, size: 24,
};

export interface LevelDef {
  id: string;
  eraId: string;
  nameKey: Key;
  laneLength: number;
  baseHp: number;
  coins: number; // recompensa base por estrella
  waves: WaveEntry[];
}

export const LEVELS: LevelDef[] = [
  {
    id: 'prehistoria-1', eraId: 'prehistoria', nameKey: 'level_prehistoria_1', laneLength: 1000, baseHp: 500, coins: 30,
    waves: [
      { at: 2, enemy: 'rat', count: 2 },
      { at: 15, enemy: 'rat', count: 3 },
      { at: 30, enemy: 'bird', count: 2 },
      { at: 45, enemy: 'rat', count: 4 },
      { at: 60, enemy: 'bird', count: 3 },
      { at: 80, enemy: 'mammoth', count: 1 },
    ],
  },
  {
    id: 'prehistoria-2', eraId: 'prehistoria', nameKey: 'level_prehistoria_2', laneLength: 1000, baseHp: 500, coins: 45,
    waves: [
      { at: 2, enemy: 'rat', count: 3 },
      { at: 12, enemy: 'bird', count: 2 },
      { at: 25, enemy: 'rat', count: 5 },
      { at: 40, enemy: 'bird', count: 4 },
      { at: 55, enemy: 'rat', count: 6 },
      { at: 70, enemy: 'bird', count: 5 },
      { at: 90, enemy: 'mammoth', count: 1 },
    ],
  },
  {
    id: 'prehistoria-3', eraId: 'prehistoria', nameKey: 'level_prehistoria_3', laneLength: 1000, baseHp: 500, coins: 60,
    waves: [
      { at: 2, enemy: 'bird', count: 3 },
      { at: 15, enemy: 'rat', count: 6 },
      { at: 30, enemy: 'mammoth', count: 1 },
      { at: 50, enemy: 'bird', count: 5 },
      { at: 65, enemy: 'rat', count: 8 },
      { at: 85, enemy: 'mammoth', count: 2 },
    ],
  },
];

export const levelById = (id: string): LevelDef => LEVELS.find(l => l.id === id) ?? LEVELS[0];
