import { describe, expect, it } from 'vitest';
import { Battle } from '../src/game/sim';
import { LEVELS, PLAYER_UNITS } from '../src/game/data';
const LEVEL_PREHISTORIA_1 = LEVELS[0];
import { dictionaries } from '../src/i18n';

const run = (b: Battle, secs: number, step = 0.05) => { for (let t = 0; t < secs; t += step) b.update(step); };

describe('Battle', () => {
  it('regenera energía y respeta el costo al invocar', () => {
    const b = new Battle(LEVEL_PREHISTORIA_1);
    const before = b.energy;
    expect(b.summon(PLAYER_UNITS[3])).toBe(false); // cuesta 100
    b.update(1);
    expect(b.energy).toBeGreaterThan(before);
    expect(b.summon(PLAYER_UNITS[0])).toBe(true);
  });

  it('las unidades pelean y mueren', () => {
    const b = new Battle(LEVEL_PREHISTORIA_1);
    run(b, 30);
    expect(b.units.some(u => u.side === 'enemy')).toBe(true);
    expect(b.units.some(u => u.isHero)).toBe(true);
  });

  it('el agujero de gusano daña a todos los enemigos y tiene cooldown', () => {
    const b = new Battle(LEVEL_PREHISTORIA_1);
    run(b, 3);
    const enemies = b.units.filter(u => u.side === 'enemy').length;
    expect(enemies).toBeGreaterThan(0);
    expect(b.castWormhole()).toBe(true);
    expect(b.castWormhole()).toBe(false);
    expect(b.units.filter(u => u.side === 'enemy').length).toBeLessThan(enemies);
  });

  it('pierde si nadie defiende', () => {
    const b = new Battle(LEVEL_PREHISTORIA_1);
    b.units = b.units.filter(u => !u.isHero);
    b.update(0.1);
    expect(b.outcome).toBe('lose');
  });

  it('un jugador activo puede ganar el nivel 1', () => {
    const b = new Battle(LEVEL_PREHISTORIA_1);
    const cheap = PLAYER_UNITS[0], rock = PLAYER_UNITS[2];
    for (let i = 0; i < 4000 && b.outcome === 'playing'; i++) {
      b.update(0.05);
      if (!b.summon(rock)) b.summon(cheap);
      if (b.wormholeCd === 0 && b.units.filter(u => u.side === 'enemy').length >= 3) b.castWormhole();
    }
    expect(b.outcome).toBe('win');
  });
});

describe('i18n', () => {
  it('ES y EN tienen las mismas claves', () => {
    expect(Object.keys(dictionaries.es).sort()).toEqual(Object.keys(dictionaries.en).sort());
  });
});

import { applyWin, buyUpgrade, claimDaily, isUnlocked, modsFrom, starsFor } from '../src/game/economy';
import { defaultSave, loadSave, migrate, writeSave } from '../src/services/save';

const bot = (b: Battle) => {
  const cheap = PLAYER_UNITS[0], rock = PLAYER_UNITS[2];
  for (let i = 0; i < 6000 && b.outcome === 'playing'; i++) {
    b.update(0.05);
    if (!b.summon(rock)) b.summon(cheap);
    if (b.wormholeCd === 0 && b.units.filter(u => u.side === 'enemy').length >= 3) b.castWormhole();
  }
  return b.outcome;
};

describe('niveles', () => {
  it.each(LEVELS.map(l => [l.id, l] as const))('%s es ganable con un bot sin mejoras', (_, l) => {
    expect(bot(new Battle(l))).toBe('win');
  });
  it('las mejoras aumentan la vida del hogar', () => {
    const b = new Battle(LEVELS[0], modsFrom({ base: 5 }));
    expect(b.playerBaseMax).toBeGreaterThan(LEVELS[0].baseHp);
  });
});

describe('economía', () => {
  it('estrellas según vida restante', () => {
    expect([starsFor(1), starsFor(0.5), starsFor(0.1)]).toEqual([3, 2, 1]);
  });
  it('paga solo estrellas nuevas y desbloquea el siguiente nivel', () => {
    const s = defaultSave();
    expect(isUnlocked(s, LEVELS[1])).toBe(false);
    const first = applyWin(s, LEVELS[0], 2);
    expect(first).toBe(2 * LEVELS[0].coins);
    expect(isUnlocked(s, LEVELS[1])).toBe(true);
    expect(applyWin(s, LEVELS[0], 2)).toBeLessThan(first); // repetir paga poco
    expect(s.stars[LEVELS[0].id]).toBe(2);
  });
  it('compra mejoras con monedas y respeta el máximo', () => {
    const s = defaultSave();
    expect(buyUpgrade(s, 'energy')).toBe(false);
    s.coins = 100000;
    for (let i = 0; i < 5; i++) expect(buyUpgrade(s, 'energy')).toBe(true);
    expect(buyUpgrade(s, 'energy')).toBe(false);
  });
  it('regalo diario una vez al día', () => {
    const s = defaultSave();
    expect(claimDaily(s, '2026-01-01')).toBeGreaterThan(0);
    expect(claimDaily(s, '2026-01-01')).toBe(0);
    expect(claimDaily(s, '2026-01-02')).toBeGreaterThan(0);
  });
});

describe('guardado', () => {
  it('ida y vuelta y migración de datos incompletos', () => {
    const mem: Record<string, string> = {};
    const kv = { getItem: (k: string) => mem[k] ?? null, setItem: (k: string, v: string) => { mem[k] = v; } };
    const s = defaultSave('en'); s.coins = 42; s.stars['prehistoria-1'] = 3;
    writeSave(kv, s);
    expect(loadSave(kv)).toEqual(s);
    expect(migrate({ coins: 7 }).stars).toEqual({});
    expect(loadSave({ getItem: () => '{roto', setItem: () => {} }).coins).toBe(0);
  });
});
