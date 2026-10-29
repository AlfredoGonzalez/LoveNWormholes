import type { Key } from '../i18n';
import type { Mods } from './sim';
import { LEVELS, type LevelDef } from './data';
import type { SaveData } from '../services/save';

export interface UpgradeDef { id: string; nameKey: Key; max: number; baseCost: number; perLevel: number; mod: keyof Mods }

export const UPGRADES: UpgradeDef[] = [
  { id: 'energy', nameKey: 'up_energy', max: 5, baseCost: 60, perLevel: 0.12, mod: 'energyRegen' },
  { id: 'base', nameKey: 'up_base', max: 5, baseCost: 50, perLevel: 0.15, mod: 'baseHp' },
  { id: 'hero', nameKey: 'up_hero', max: 5, baseCost: 80, perLevel: 0.15, mod: 'heroDamage' },
];

export const upgradeCost = (u: UpgradeDef, level: number) => Math.round(u.baseCost * 1.7 ** level);

export function modsFrom(upgrades: Record<string, number>): Mods {
  const m: Mods = { energyRegen: 1, baseHp: 1, heroDamage: 1 };
  for (const u of UPGRADES) m[u.mod] = 1 + u.perLevel * (upgrades[u.id] ?? 0);
  return m;
}

/** Compra una mejora; devuelve true si se pudo. */
export function buyUpgrade(save: SaveData, id: string): boolean {
  const u = UPGRADES.find(x => x.id === id);
  if (!u) return false;
  const lvl = save.upgrades[id] ?? 0;
  const cost = upgradeCost(u, lvl);
  if (lvl >= u.max || save.coins < cost) return false;
  save.coins -= cost;
  save.upgrades[id] = lvl + 1;
  return true;
}

/** Estrellas según la vida que le queda al hogar. */
export const starsFor = (baseHpPct: number) => (baseHpPct >= 0.8 ? 3 : baseHpPct >= 0.4 ? 2 : 1);

/**
 * Aplica el resultado de una victoria. Paga la recompensa por estrellas nuevas
 * (no se puede "farmear" estrellas ya ganadas, pero repetir da un pequeño premio).
 */
export function applyWin(save: SaveData, level: LevelDef, stars: number): number {
  const prev = save.stars[level.id] ?? 0;
  const newStars = Math.max(0, stars - prev);
  const coins = newStars * level.coins + (newStars === 0 ? Math.round(level.coins / 3) : 0);
  save.stars[level.id] = Math.max(prev, stars);
  save.coins += coins;
  return coins;
}

export const isUnlocked = (save: SaveData, level: LevelDef) => {
  const i = LEVELS.indexOf(level);
  return i <= 0 || (save.stars[LEVELS[i - 1].id] ?? 0) > 0;
};

export const DAILY_COINS = 100;
export const todayStr = (d = new Date()) =>
  `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;

/** Reclama el regalo diario; devuelve las monedas (0 si ya se reclamó hoy). */
export function claimDaily(save: SaveData, today = todayStr()): number {
  if (save.lastDaily === today) return 0;
  save.lastDaily = today;
  save.coins += DAILY_COINS;
  return DAILY_COINS;
}
