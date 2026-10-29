import { describe, expect, it } from 'vitest';
import { Battle } from '../src/game/sim';
import { LEVEL_PREHISTORIA_1, PLAYER_UNITS } from '../src/game/data';
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
