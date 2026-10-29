import { BATTLE_ECON, ENEMY_COIN, ENEMY_UNITS, HERO_DEF, eraById, scaleUnit, type AnomalyKind, type EraDef, type LevelDef, type UnitDef } from './data';

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
  ttl?: number; // segundos de vida restantes (aliados fantasma)
}

/** Evento visual para la escena (se consume con `drainEvents`). */
export interface BattleEvent { kind: AnomalyKind; x?: number }

/** Multiplicadores que vienen de las mejoras permanentes. */
export interface Mods { energyRegen: number; baseHp: number; heroDamage: number }
export const NO_MODS: Mods = { energyRegen: 1, baseHp: 1, heroDamage: 1 };

export const MAX_ENERGY = 100;
export const ENERGY_REGEN = 10; // por segundo
export const WORMHOLE_COOLDOWN = 20;
export const WORMHOLE_DAMAGE = 60;

export const SANDSTORM_DURATION = 8;
export const SANDSTORM_SLOW = 0.6;
export const GHOST_LIFETIME = 12;
export const METEOR_RADIUS = 90;
export const STAMPEDE_PUSH = 120;
export const BOOST_SECONDS = 30;
export const REVIVE_CLEAR_X = 300;

/** Generador pseudoaleatorio determinista (mulberry32) para poder probar las anomalías. */
function rng(seed: number) {
  let a = seed >>> 0;
  return () => {
    a = (a + 0x6d2b79f5) >>> 0;
    let t = a;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

/** Simulación pura (sin Phaser): fácil de probar y de balancear. */
export class Battle {
  time = 0;
  energy = 30;
  wormholeCd = 0;
  units: Unit[] = [];
  playerBaseHp: number;
  readonly playerBaseMax: number;
  enemyBaseHp: number;
  outcome: Outcome = 'playing';
  readonly era: EraDef;
  sandUntil = 0;
  boostUntil = 0;
  /** Monedas de batalla (se ganan matando enemigos; se reinician en cada nivel). */
  coins = 0;
  /** Qué unidades de la era ya se desbloquearon (la 1ª siempre). */
  unlocked: boolean[] = [true, false, false];
  energyLevel = 0;
  private heroDef!: UnitDef;
  private events: BattleEvent[] = [];
  private nextUid = 1;
  private waveIdx = 0;
  private anomalyTimer: number;
  private rand: () => number;

  constructor(readonly level: LevelDef, private readonly mods: Mods = NO_MODS, seed = 1234) {
    this.era = eraById(level.eraId);
    this.rand = rng(seed);
    this.anomalyTimer = this.era.anomaly.interval;
    this.playerBaseMax = Math.round(level.baseHp * mods.baseHp);
    this.playerBaseHp = this.playerBaseMax;
    this.enemyBaseHp = level.enemyBaseHp;
    const hero = scaleUnit(HERO_DEF, this.era.power);
    this.heroDef = { ...hero, damage: hero.damage * mods.heroDamage };
    this.spawn(this.heroDef, 'player', true);
  }

  get boostActive() { return this.time < this.boostUntil; }

  /** Energía x2 por unos segundos (recompensa de anuncio opcional). */
  energyBoost(seconds = BOOST_SECONDS) { this.boostUntil = this.time + seconds; }

  /** Segunda oportunidad: recupera el hogar al 50 %, devuelve al héroe y despeja enemigos cercanos. */
  revive(): boolean {
    if (this.outcome !== 'lose') return false;
    this.playerBaseHp = Math.max(this.playerBaseHp, this.playerBaseMax * 0.5);
    this.units = this.units.filter(u => u.side === 'player' || u.x > REVIVE_CLEAR_X);
    if (!this.units.some(u => u.isHero)) this.spawn(this.heroDef, 'player', true);
    this.outcome = 'playing';
    return true;
  }

  get sandstormActive() { return this.time < this.sandUntil; }

  drainEvents(): BattleEvent[] {
    const e = this.events; this.events = []; return e;
  }

  summon(def: UnitDef): boolean {
    const idx = this.era.units.indexOf(def);
    if (this.outcome !== 'playing' || this.energy < def.cost || (idx >= 0 && !this.unlocked[idx])) return false;
    this.energy -= def.cost;
    this.spawn(def, 'player');
    return true;
  }

  /** Gasta monedas de batalla para desbloquear la unidad `idx` (1 o 2). */
  unlockUnit(idx: number): boolean {
    const cost = BATTLE_ECON.unlockCost[idx];
    if (this.outcome !== 'playing' || idx < 1 || this.unlocked[idx] || cost === undefined || this.coins < cost) return false;
    this.coins -= cost; this.unlocked[idx] = true;
    return true;
  }

  /** Costo de la siguiente mejora de energía, o null si ya está al máximo. */
  get energyUpgradeCost(): number | null { return BATTLE_ECON.energyCosts[this.energyLevel] ?? null; }

  upgradeEnergy(): boolean {
    const cost = this.energyUpgradeCost;
    if (this.outcome !== 'playing' || cost === null || this.coins < cost) return false;
    this.coins -= cost; this.energyLevel++;
    return true;
  }

  castWormhole(): boolean {
    if (this.outcome !== 'playing' || this.wormholeCd > 0) return false;
    this.wormholeCd = WORMHOLE_COOLDOWN;
    for (const u of this.units) if (u.side === 'enemy') u.hp -= WORMHOLE_DAMAGE * this.era.power;
    this.reap();
    return true;
  }

  /** Retira a los muertos y paga monedas de batalla por los enemigos derrotados. */
  private reap() {
    for (const u of this.units) if (u.hp <= 0 && u.side === 'enemy') this.coins += ENEMY_COIN[u.def.id] ?? 0;
    this.units = this.units.filter(u => u.hp > 0);
  }

  private spawn(def: UnitDef, side: Side, isHero = false, ttl?: number) {
    const x = side === 'player' ? 0 : this.level.laneLength;
    this.units.push({ uid: this.nextUid++, def, side, x, hp: def.hp, cd: 0, isHero, ttl });
  }

  private triggerAnomaly() {
    const kind = this.era.anomaly.kind;
    const len = this.level.laneLength;
    switch (kind) {
      case 'meteor': {
        const x = 150 + this.rand() * (len - 300);
        for (const u of this.units) if (Math.abs(u.x - x) <= METEOR_RADIUS) u.hp -= 40 * this.era.power;
        this.events.push({ kind, x });
        break;
      }
      case 'sandstorm':
        this.sandUntil = this.time + SANDSTORM_DURATION;
        this.events.push({ kind });
        break;
      case 'ghost':
        this.spawn(this.era.ghost, 'player', false, GHOST_LIFETIME);
        this.events.push({ kind });
        break;
      case 'stampede':
        for (const u of this.units) if (u.side === 'enemy') u.x = Math.min(len, u.x + STAMPEDE_PUSH);
        this.events.push({ kind });
        break;
    }
  }

  update(dt: number) {
    if (this.outcome !== 'playing') return;
    this.time += dt;
    this.energy = Math.min(MAX_ENERGY, this.energy + ENERGY_REGEN * this.mods.energyRegen * (1 + BATTLE_ECON.energyBonusPerLevel * this.energyLevel) * (this.boostActive ? 2 : 1) * dt);
    this.wormholeCd = Math.max(0, this.wormholeCd - dt);

    this.anomalyTimer -= dt;
    if (this.anomalyTimer <= 0) { this.anomalyTimer += this.era.anomaly.interval; this.triggerAnomaly(); }

    const waves = this.level.waves;
    while (this.waveIdx < waves.length && waves[this.waveIdx].at <= this.time) {
      const w = waves[this.waveIdx++];
      for (let i = 0; i < w.count; i++) {
        this.spawn(scaleUnit(ENEMY_UNITS[w.enemy], this.level.enemyBoost), 'enemy');
        this.units[this.units.length - 1].x -= i * 25; // escalonar
      }
    }

    const speedMult = this.sandstormActive ? SANDSTORM_SLOW : 1;
    for (const u of this.units) {
      u.cd = Math.max(0, u.cd - dt);
      if (u.ttl !== undefined) { u.ttl -= dt; if (u.ttl <= 0) u.hp = 0; }
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
        u.x += dir * u.def.speed * speedMult * dt;
      }
    }

    this.reap();

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
