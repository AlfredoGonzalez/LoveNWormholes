import { ENEMY_UNITS, HERO_DEF, type LevelDef, type UnitDef } from './data';

export type Side = 'player' | 'enemy';
export type Outcome = 'playing' | 'win' | 'lose';

export interface Unit {
  uid: number;
  def: UnitDef;
  side: Side;
  x: number;
  hp: number;
  cd: number;
  isHero: boolean;
}

export const MAX_ENERGY = 100;
export const ENERGY_REGEN = 10; // por segundo
export const WORMHOLE_COOLDOWN = 20;
export const WORMHOLE_DAMAGE = 60;

/** Simulación pura (sin Phaser): fácil de probar y de balancear. */
export class Battle {
  time = 0;
  energy = 30;
  wormholeCd = 0;
  units: Unit[] = [];
  playerBaseHp: number;
  enemyBaseHp: number;
  outcome: Outcome = 'playing';
  private nextUid = 1;
  private waveIdx = 0;

  constructor(readonly level: LevelDef) {
    this.playerBaseHp = level.baseHp;
    this.enemyBaseHp = level.baseHp;
    this.spawn(HERO_DEF, 'player', true);
  }

  get enemyBaseX() { return this.level.laneLength; }

  summon(def: UnitDef): boolean {
    if (this.outcome !== 'playing' || this.energy < def.cost) return false;
    this.energy -= def.cost;
    this.spawn(def, 'player');
    return true;
  }

  castWormhole(): boolean {
    if (this.outcome !== 'playing' || this.wormholeCd > 0) return false;
    this.wormholeCd = WORMHOLE_COOLDOWN;
    for (const u of this.units) if (u.side === 'enemy') u.hp -= WORMHOLE_DAMAGE;
    this.cleanup();
    return true;
  }

  private spawn(def: UnitDef, side: Side, isHero = false) {
    const x = side === 'player' ? 0 : this.level.laneLength;
    this.units.push({ uid: this.nextUid++, def, side, x, hp: def.hp, cd: 0, isHero });
  }

  private cleanup() {
    this.units = this.units.filter(u => u.hp > 0);
  }

  update(dt: number) {
    if (this.outcome !== 'playing') return;
    this.time += dt;
    this.energy = Math.min(MAX_ENERGY, this.energy + ENERGY_REGEN * dt);
    this.wormholeCd = Math.max(0, this.wormholeCd - dt);

    const waves = this.level.waves;
    while (this.waveIdx < waves.length && waves[this.waveIdx].at <= this.time) {
      const w = waves[this.waveIdx++];
      for (let i = 0; i < w.count; i++) {
        const def = ENEMY_UNITS[w.enemy];
        this.spawn(def, 'enemy');
        this.units[this.units.length - 1].x -= i * 25; // escalonar
      }
    }

    for (const u of this.units) {
      u.cd = Math.max(0, u.cd - dt);
      const dir = u.side === 'player' ? 1 : -1;
      const target = this.findTarget(u);
      if (target) {
        if (u.cd === 0) {
          u.cd = u.def.cooldown;
          if (target === 'base') {
            if (u.side === 'player') this.enemyBaseHp -= u.def.damage;
            else this.playerBaseHp -= u.def.damage;
          } else target.hp -= u.def.damage;
        }
      } else {
        u.x += dir * u.def.speed * dt;
      }
    }

    this.units = this.units.filter(u => u.hp > 0);

    if (this.enemyBaseHp <= 0) this.outcome = 'win';
    else if (this.playerBaseHp <= 0 || !this.units.some(u => u.isHero)) this.outcome = 'lose';
  }

  /** Enemigo más cercano en rango, o 'base' si la base rival está en rango. */
  private findTarget(u: Unit): Unit | 'base' | null {
    const dir = u.side === 'player' ? 1 : -1;
    let best: Unit | null = null;
    let bestDist = Infinity;
    for (const o of this.units) {
      if (o.side === u.side) continue;
      const d = (o.x - u.x) * dir;
      if (d < -5) continue; // ya lo pasamos
      if (d <= u.def.range && d < bestDist) { best = o; bestDist = d; }
    }
    if (best) return best;
    const baseX = u.side === 'player' ? this.level.laneLength : 0;
    return Math.abs(baseX - u.x) <= u.def.range ? 'base' : null;
  }
}
