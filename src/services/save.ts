import { setLang, type Lang } from '../i18n';
import type { ConsentState } from './types';

export interface SaveData {
  v: number;
  coins: number;
  gems: number;
  lang: Lang;
  stars: Record<string, number>;      // levelId -> mejores estrellas (0-3)
  upgrades: Record<string, number>;   // upgradeId -> nivel
  lastDaily: string;                  // YYYY-MM-DD
  tutorialDone: boolean;
  owned: string[];                    // compras no consumibles
  chestReadyAt: number;               // ms epoch en que el cofre gratis vuelve a estar listo
  consent: ConsentState;
  introSeen: boolean;
}

export const SAVE_VERSION = 1;
const KEY = 'lnw.save';

export interface KV { getItem(k: string): string | null; setItem(k: string, v: string): void }

export const defaultSave = (lang: Lang = 'es'): SaveData => ({
  v: SAVE_VERSION, coins: 0, gems: 0, lang, stars: {}, upgrades: {}, lastDaily: '', tutorialDone: false, owned: [], chestReadyAt: 0, consent: 'unknown', introSeen: false,
});

/** Rellena campos faltantes y migra versiones antiguas. */
export function migrate(raw: unknown, lang: Lang = 'es'): SaveData {
  const base = defaultSave(lang);
  if (!raw || typeof raw !== 'object') return base;
  const r = raw as Partial<SaveData>;
  return { ...base, ...r, stars: { ...r.stars }, upgrades: { ...r.upgrades }, owned: [...(r.owned ?? [])], v: SAVE_VERSION };
}

export function loadSave(kv: KV | null, lang: Lang = 'es'): SaveData {
  try {
    const txt = kv?.getItem(KEY);
    return migrate(txt ? JSON.parse(txt) : null, lang);
  } catch { return defaultSave(lang); }
}

export function writeSave(kv: KV | null, data: SaveData) {
  try { kv?.setItem(KEY, JSON.stringify(data)); } catch { /* sin almacenamiento: seguimos en memoria */ }
}

const browserKv = (): KV | null => { try { return typeof localStorage !== 'undefined' ? localStorage : null; } catch { return null; } };

/** Estado global del juego (singleton simple). */
export const game = { save: defaultSave(), eraIdx: 0 };
export function initGame(defaultLang: Lang) {
  game.save = loadSave(browserKv(), defaultLang);
  setLang(game.save.lang);
}
export const persist = () => writeSave(browserKv(), game.save);
