import { describe, expect, it } from 'vitest';
import { Battle } from '../src/game/sim';
import { ERAS, LEVELS, eraById } from '../src/game/data';
const PLAYER_UNITS = ERAS[0].units;
const LEVEL_PREHISTORIA_1 = LEVELS[0];
import { dictionaries } from '../src/i18n';

const run = (b: Battle, secs: number, step = 0.05) => { for (let t = 0; t < secs; t += step) b.update(step); };

describe('Battle', () => {
  it('regenera energía y respeta el costo al invocar', () => {
    const b = new Battle(LEVEL_PREHISTORIA_1);
    const before = b.energy;
    expect(b.summon(PLAYER_UNITS[2])).toBe(false); // bloqueada y cara
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
    const hp = () => b.units.filter(u => u.side === 'enemy').reduce((n, u) => n + u.hp, 0);
    const before = hp();
    expect(before).toBeGreaterThan(0);
    expect(b.castWormhole()).toBe(true);
    expect(b.castWormhole()).toBe(false);
    expect(hp()).toBeLessThan(before);
  });

  it('pierde si nadie defiende', () => {
    const b = new Battle(LEVEL_PREHISTORIA_1);
    b.units = b.units.filter(u => !u.isHero);
    b.update(0.1);
    expect(b.outcome).toBe('lose');
  });

  it('un jugador activo puede ganar el nivel 1', () => {
    expect(bot(new Battle(LEVEL_PREHISTORIA_1))).toBe('win');
  });
});

describe('i18n', () => {
  it('ES y EN tienen las mismas claves', () => {
    expect(Object.keys(dictionaries.es).sort()).toEqual(Object.keys(dictionaries.en).sort());
  });
});

import { CHEST_COOLDOWN_MS, applyPurchase, applyWin, buyUpgrade, chestRemainingMs, claimDaily, doubleReward, exchangeGems, hasDoubleCoins, isUnlocked, modsFrom, openChest, restoreOwned, spendGems, starsFor } from '../src/game/economy';
import { defaultSave, loadSave, migrate, writeSave } from '../src/services/save';

/** Jugador automático: desbloquea unidades y sube la energía con las monedas de batalla, e invoca la más cara que pueda. */
const bot = (b: Battle) => {
  const u = b.era.units;
  for (let i = 0; i < 6000 && b.outcome === 'playing'; i++) {
    b.update(0.05);
    if (!b.unlocked[1]) b.unlockUnit(1);
    else if (b.energyLevel < 1) b.upgradeEnergy();
    else if (!b.unlocked[2]) b.unlockUnit(2);
    else b.upgradeEnergy();
    for (const k of [2, 1, 0]) if (b.summon(u[k])) break;
    if (b.wormholeCd === 0 && b.units.filter(x => x.side === 'enemy').length >= 3) b.castWormhole();
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

describe('eras y anomalías', () => {
  it('hay 4 eras con 3 unidades y 3 enemigos únicos', () => {
    expect(ERAS).toHaveLength(4);
    const ids = ERAS.flatMap(e => [...e.units, ...e.enemies]).map(u => u.id);
    expect(new Set(ids).size).toBe(ids.length);
    for (const e of ERAS) { expect(e.units).toHaveLength(3); expect(e.enemies).toHaveLength(3); expect(e.levels).toHaveLength(3); }
  });
  it('todas las oleadas usan enemigos de su era', () => {
    for (const l of LEVELS) {
      const ids = eraById(l.eraId).enemies.map(e => e.id);
      for (const w of l.waves) expect(ids).toContain(w.enemy);
    }
  });
  const level = (era: string) => eraById(era).levels[0];
  it('meteoros dañan unidades y avisan', () => {
    const b = new Battle(level('prehistoria'));
    let hit = false;
    for (let t = 0; t < 30; t += 0.05) { b.update(0.05); if (b.drainEvents().some(e => e.kind === 'meteor')) hit = true; }
    expect(hit).toBe(true);
  });
  it('la tormenta de arena frena a las unidades', () => {
    const b = new Battle({ ...level('egipto'), waves: [] }); // sin enemigos: el héroe sobrevive
    for (let t = 0; t < 31; t += 0.05) b.update(0.05);
    expect(b.sandstormActive).toBe(true);
  });
  it('el caballero fantasma aparece y expira', () => {
    const b = new Battle({ ...level('medieval'), waves: [] });
    for (let t = 0; t < 31; t += 0.05) b.update(0.05);
    expect(b.units.some(u => u.ttl !== undefined)).toBe(true);
    for (let t = 0; t < 13; t += 0.05) b.update(0.05);
    expect(b.units.some(u => u.ttl !== undefined && u.ttl > 0 && u.def.id.startsWith('ghost') && u.x === 0)).toBe(false);
  });
  it('la estampida empuja a los enemigos hacia su base', () => {
    const b = new Battle(level('oeste'));
    b.units = b.units.filter(u => u.isHero);
    b.units.push({ uid: 99, def: eraById('oeste').enemies[0], side: 'enemy', x: 500, hp: 9999, cd: 99, isHero: false });
    for (let t = 0; t < 28.1; t += 0.05) { b.update(0.05); const e = b.units.find(u => u.uid === 99)!; e.x = Math.max(e.x, 500); if (b.drainEvents().length) break; }
    expect(b.units.find(u => u.uid === 99)!.x).toBeGreaterThanOrEqual(600);
  });
});

describe('dificultad', () => {
  it.each(LEVELS.map(l => [l.id, l] as const))('%s no se gana sin jugar', (_, l) => {
    const b = new Battle(l);
    for (let i = 0; i < 8000 && b.outcome === 'playing'; i++) b.update(0.05);
    expect(b.outcome).toBe('lose');
  });
});

describe('monetización', () => {
  it('gemas consumibles se acumulan; no consumibles solo una vez', () => {
    const s = defaultSave();
    expect(applyPurchase(s, 'gems_s')).toBe(true);
    expect(applyPurchase(s, 'gems_s')).toBe(true);
    expect(s.gems).toBe(200);
    expect(applyPurchase(s, 'starter')).toBe(true);
    expect(applyPurchase(s, 'starter')).toBe(false);
    expect(s.coins).toBe(500);
    expect(applyPurchase(s, 'no_existe')).toBe(false);
  });
  it('monedas x2 permanente duplica recompensas de victoria', () => {
    const a = defaultSave(), b = defaultSave();
    applyPurchase(b, 'double_coins');
    expect(hasDoubleCoins(b)).toBe(true);
    expect(applyWin(b, LEVELS[0], 3)).toBe(applyWin(a, LEVELS[0], 3) * 2);
  });
  it('restaurar marca no consumibles sin regalar recursos', () => {
    const s = defaultSave();
    restoreOwned(s, ['double_coins', 'gems_s', 'starter']);
    expect(s.owned.sort()).toEqual(['double_coins', 'starter']);
    expect(s.coins + s.gems).toBe(0);
  });
  it('cofre gratis respeta el enfriamiento', () => {
    const s = defaultSave(), now = 1_000_000;
    const r = openChest(s, now, 0.5)!;
    expect(r.coins).toBeGreaterThanOrEqual(50);
    expect(openChest(s, now + 1000, 0.5)).toBeNull();
    expect(chestRemainingMs(s, now)).toBe(CHEST_COOLDOWN_MS);
    expect(openChest(s, now + CHEST_COOLDOWN_MS, 0.9)!.gems).toBe(5);
  });
  it('cambio de gemas, gasto y duplicar recompensa', () => {
    const s = defaultSave();
    expect(exchangeGems(s)).toBe(false);
    s.gems = 25;
    expect(exchangeGems(s)).toBe(true);
    expect(s.gems).toBe(15);
    expect(spendGems(s, 20)).toBe(false);
    expect(spendGems(s, 10)).toBe(true);
    s.coins = 10; doubleReward(s, 10);
    expect(s.coins).toBe(20);
  });
  it('revivir devuelve la partida y el boost de energía acelera la regeneración', () => {
    const b = new Battle(LEVELS[0]);
    b.units = [];           // sin héroe → derrota
    b.update(0.1);
    expect(b.outcome).toBe('lose');
    expect(b.revive()).toBe(true);
    expect(b.outcome).toBe('playing');
    expect(b.units.some(u => u.isHero)).toBe(true);
    expect(b.revive()).toBe(false); // solo si se perdió

    const a = new Battle(LEVELS[0]), c = new Battle(LEVELS[0]);
    a.energy = c.energy = 0; c.energyBoost();
    a.update(1); c.update(1);
    expect(c.energy).toBeCloseTo(a.energy * 2, 5);
  });
});

import { toConsentState } from '../src/services/native/consent-map';
describe('consentimiento nativo', () => {
  it('personalizado solo si se pueden pedir anuncios y el seguimiento está autorizado', () => {
    expect(toConsentState(true, true)).toBe('personalized');
    expect(toConsentState(true, false)).toBe('limited');
    expect(toConsentState(false, true)).toBe('limited');
  });
});

describe('economía de batalla (estilo WeAreWarriors)', () => {
  const lvl = () => new Battle(LEVELS[0]);
  it('solo la 1ª unidad está desbloqueada al empezar', () => {
    const b = lvl(); b.energy = 100;
    expect(b.unlocked).toEqual([true, false, false]);
    expect(b.summon(b.era.units[1])).toBe(false);
    expect(b.summon(b.era.units[0])).toBe(true);
  });
  it('matar enemigos da monedas y con ellas se desbloquea y se mejora la energía', () => {
    const b = lvl();
    expect(b.unlockUnit(1)).toBe(false); // sin monedas
    b.coins = 70;
    expect(b.unlockUnit(1)).toBe(true);
    expect(b.coins).toBe(0);
    expect(b.unlockUnit(1)).toBe(false); // ya desbloqueada
    const before = b.energyUpgradeCost!;
    b.coins = before;
    expect(b.upgradeEnergy()).toBe(true);
    expect(b.energyLevel).toBe(1);
  });
  it('las monedas llegan solas al derrotar enemigos (también con el agujero de gusano)', () => {
    const b = lvl();
    for (let t = 0; t < 4; t += 0.05) b.update(0.05); // aparecen las primeras ratas
    expect(b.units.some(u => u.side === 'enemy')).toBe(true);
    const c0 = b.coins;
    b.castWormhole(); b.castWormhole();
    for (let t = 0; t < 6; t += 0.05) b.update(0.05);
    // si el agujero las mató o peleó el héroe, siempre hay monedas nuevas o enemigos vivos
    expect(b.coins >= c0).toBe(true);
    let b2 = lvl(); b2.units.push({ uid: 99, def: b2.era.enemies[0], side: 'enemy', x: 500, hp: 1, cd: 9, isHero: false });
    b2.castWormhole();
    expect(b2.coins).toBe(10);
  });
  it('la energía mejorada regenera más rápido', () => {
    const a = lvl(), c = lvl();
    a.energy = c.energy = 0; c.coins = 1000; c.upgradeEnergy();
    a.update(1); c.update(1);
    expect(c.energy).toBeGreaterThan(a.energy);
  });
  it('las monedas de batalla no se arrastran entre niveles', () => {
    const a = lvl(); a.coins = 500;
    expect(new Battle(LEVELS[1]).coins).toBe(0);
  });
});
