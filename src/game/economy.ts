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
  const base = newStars * level.coins + (newStars === 0 ? Math.round(level.coins / 3) : 0);
  const coins = hasDoubleCoins(save) ? base * 2 : base;
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

// ---- Tienda y monetización ----
export type ProductId = 'gems_s' | 'gems_m' | 'gems_l' | 'starter' | 'double_coins';
export interface ProductDef { id: ProductId; titleKey: Key; priceLabel: string; gems: number; coins: number; nonConsumable: boolean }

/** `priceLabel` es de referencia; las tiendas reales devuelven el precio localizado. */
export const PRODUCTS: ProductDef[] = [
  { id: 'gems_s', titleKey: 'prod_gems_s', priceLabel: '$0.99', gems: 100, coins: 0, nonConsumable: false },
  { id: 'gems_m', titleKey: 'prod_gems_m', priceLabel: '$4.99', gems: 600, coins: 0, nonConsumable: false },
  { id: 'gems_l', titleKey: 'prod_gems_l', priceLabel: '$9.99', gems: 1500, coins: 0, nonConsumable: false },
  { id: 'starter', titleKey: 'prod_starter', priceLabel: '$2.99', gems: 50, coins: 500, nonConsumable: true },
  { id: 'double_coins', titleKey: 'prod_double', priceLabel: '$3.99', gems: 0, coins: 0, nonConsumable: true },
];

export const hasDoubleCoins = (save: SaveData) => save.owned.includes('double_coins');

/** Entrega la compra al jugador. false si ya la tenía (no consumibles) o el id no existe. */
export function applyPurchase(save: SaveData, id: string): boolean {
  const p = PRODUCTS.find(x => x.id === id);
  if (!p || (p.nonConsumable && save.owned.includes(p.id))) return false;
  save.gems += p.gems; save.coins += p.coins;
  if (p.nonConsumable) save.owned.push(p.id);
  return true;
}

/** Restaurar: marca como poseídos los no consumibles, sin volver a pagar monedas/gemas. */
export function restoreOwned(save: SaveData, ids: string[]) {
  for (const id of ids) {
    const p = PRODUCTS.find(x => x.id === id);
    if (p?.nonConsumable && !save.owned.includes(id)) save.owned.push(id);
  }
}

export const EXCHANGE = { gems: 10, coins: 300 };
export function exchangeGems(save: SaveData): boolean {
  if (save.gems < EXCHANGE.gems) return false;
  save.gems -= EXCHANGE.gems; save.coins += EXCHANGE.coins;
  return true;
}

export const REVIVE_GEMS = 10;
export function spendGems(save: SaveData, n: number): boolean {
  if (save.gems < n) return false;
  save.gems -= n; return true;
}

/** Duplica la recompensa ya pagada (anuncio opcional). Devuelve las monedas extra. */
export function doubleReward(save: SaveData, coins: number): number { save.coins += coins; return coins; }

export const CHEST_COOLDOWN_MS = 4 * 60 * 60 * 1000;
export const chestRemainingMs = (save: SaveData, now = Date.now()) => Math.max(0, save.chestReadyAt - now);

/** Abre el cofre gratis (tras ver el anuncio). `rand` en [0,1) para poder probarlo. */
export function openChest(save: SaveData, now = Date.now(), rand = Math.random()): { coins: number; gems: number } | null {
  if (chestRemainingMs(save, now) > 0) return null;
  const coins = 50 + Math.floor(rand * 101); // 50-150
  const gems = rand > 0.8 ? 5 : 0;           // 20 % de probabilidad de gemas
  save.coins += coins; save.gems += gems;
  save.chestReadyAt = now + CHEST_COOLDOWN_MS;
  return { coins, gems };
}
