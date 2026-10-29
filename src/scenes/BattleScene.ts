import Phaser from 'phaser';
import { Battle, MAX_ENERGY } from '../game/sim';
import { LEVELS, eraById, levelById, type EraDef, type LevelDef } from '../game/data';
import { REVIVE_GEMS, applyWin, doubleReward, modsFrom, spendGems, starsFor } from '../game/economy';
import { services } from '../services';
import { game, persist } from '../services/save';
import { t, tf } from '../i18n';
import { W, H, button } from '../ui';
import { charKey } from './PreloadScene';

const GROUND = 400, LANE_X0 = 90, LANE_X1 = 870;

/** Escena de render: toda la lógica vive en Battle (sim.ts). Usa arte si existe, si no formas placeholder. */
export class BattleScene extends Phaser.Scene {
  private battle!: Battle;
  private level!: LevelDef;
  private era!: EraDef;
  private sand?: Phaser.GameObjects.Rectangle;
  private alertText?: Phaser.GameObjects.Text;
  private msgs: string[] = [];
  private resultObjs: Phaser.GameObjects.GameObject[] = [];
  private reviveUsed = false;
  private boostUsed = false;
  private busy = false;
  private boostBtn?: Phaser.GameObjects.Container;
  private gfx!: Phaser.GameObjects.Graphics;
  private energyText!: Phaser.GameObjects.Text;
  private wormholeBtn!: Phaser.GameObjects.Text;
  private unitButtons: { bg: Phaser.GameObjects.Rectangle; cost: number }[] = [];
  private sprites = new Map<number, Phaser.GameObjects.Image>();
  private ended = false;
  private tutorialStep = 0;
  private tutorialBox?: Phaser.GameObjects.Text;

  constructor() { super('Battle'); }

  init(data: { levelId?: string }) { this.level = levelById(data.levelId ?? LEVELS[0].id); this.era = eraById(this.level.eraId); }

  create() {
    this.battle = new Battle(this.level, modsFrom(game.save.upgrades));
    this.unitButtons = [];
    this.sprites.clear();
    this.ended = false;
    this.reviveUsed = false;
    this.boostUsed = false;
    this.busy = false;
    this.resultObjs = [];
    this.cameras.main.setBackgroundColor(this.era.sky);
    const bgKey = `bg_${this.era.id}_far`;
    if (this.textures.exists(bgKey)) this.add.image(W / 2, 200, bgKey).setDisplaySize(W, 400);
    this.add.rectangle(W / 2, GROUND + 80, W, 160, this.era.ground);
    this.sand = this.add.rectangle(W / 2, H / 2, W, H, 0xd9b36a, 0.35).setDepth(5).setVisible(false);
    this.alertText = undefined;
    this.add.text(W / 2, 14, `${t(this.level.nameKey)} — ${t(this.era.nameKey)}`, { fontSize: '16px', color: '#1b1230' }).setOrigin(0.5, 0);
    this.gfx = this.add.graphics();
    this.energyText = this.add.text(20, H - 130, '', { fontSize: '18px', color: '#fff', stroke: '#3b2a3f', strokeThickness: 3 });

    this.era.units.forEach((def, i) => {
      const x = 80 + i * 150, y = H - 50;
      const bg = this.add.rectangle(x, y, 140, 70, def.color).setStrokeStyle(3, 0x3b2a3f).setInteractive({ useHandCursor: true });
      this.add.text(x, y - 15, t(def.nameKey), { fontSize: '13px', color: '#1b1230', align: 'center', wordWrap: { width: 130 } }).setOrigin(0.5);
      this.add.text(x, y + 20, `⚡${def.cost}`, { fontSize: '16px', color: '#1b1230' }).setOrigin(0.5);
      bg.on('pointerdown', () => { if (!this.tutorialBox) this.battle.summon(def); });
      this.unitButtons.push({ bg, cost: def.cost });
    });

    this.wormholeBtn = this.add.text(W - 120, H - 50, '', {
      fontSize: '16px', color: '#fff', backgroundColor: '#6a2cdc', padding: { x: 12, y: 18 }, align: 'center',
    }).setOrigin(0.5).setInteractive({ useHandCursor: true });
    this.wormholeBtn.on('pointerdown', () => { if (!this.tutorialBox) this.battle.castWormhole(); });

    this.boostBtn = button(this, W - 120, H - 125, 170, 34, t('boost_energy'), () => this.watchBoost(), { color: 0xd98324, fontSize: 15 });
    services.analytics.track('level_start', { level: this.level.id });

    this.tutorialStep = 0;
    this.tutorialBox = undefined;
    this.msgs = [];
    const first = LEVELS[0].id === this.level.id;
    if (first && !game.save.tutorialDone) this.msgs.push(t('tut1'), t('tut2'), t('tut3'));
    if (this.era.levels[0].id === this.level.id && !game.save.stars[this.level.id]) this.msgs.unshift(t(this.era.introKey));
    this.showMessages();
  }

  private showMessages() {
    if (this.tutorialStep >= this.msgs.length) {
      this.tutorialBox?.destroy(); this.tutorialBox = undefined;
      if (!game.save.tutorialDone && this.msgs.length) { game.save.tutorialDone = true; persist(); }
      return;
    }
    this.tutorialBox?.destroy();
    this.tutorialBox = this.add.text(W / 2, 200, `${this.msgs[this.tutorialStep]}\n\n${t('tap_continue')}`, {
      fontSize: '24px', color: '#fff', backgroundColor: '#000000dd', padding: { x: 24, y: 20 }, align: 'center', wordWrap: { width: 640 },
    }).setOrigin(0.5).setDepth(10).setInteractive();
    this.tutorialBox.once('pointerdown', () => { this.tutorialStep++; this.showMessages(); });
  }

  private onAnomaly(kind: string, x: number | undefined, px: (x: number) => number) {
    const txt = tf('anomaly_alert', { name: t(this.era.anomaly.nameKey) });
    this.alertText?.destroy();
    this.alertText = this.add.text(W / 2, 60, `🌀 ${txt}`, { fontSize: '24px', color: '#fff', backgroundColor: '#6a2cdcdd', padding: { x: 14, y: 8 } }).setOrigin(0.5).setDepth(12);
    this.time.delayedCall(2000, () => { this.alertText?.destroy(); this.alertText = undefined; });
    if (kind === 'meteor' && x !== undefined) {
      const m = this.add.circle(px(x), GROUND - 10, 50, 0xff7b00, 0.7).setDepth(6);
      this.tweens.add({ targets: m, alpha: 0, scale: 1.6, duration: 600, onComplete: () => m.destroy() });
      this.cameras.main.shake(250, 0.01);
    } else if (kind === 'stampede') this.cameras.main.shake(400, 0.008);
    else if (kind === 'ghost') this.cameras.main.flash(300, 207, 216, 255);
  }

  update(_: number, deltaMs: number) {
    const b = this.battle;
    if (!this.tutorialBox) b.update(Math.min(deltaMs, 100) / 1000);
    const px = (x: number) => LANE_X0 + (x / b.level.laneLength) * (LANE_X1 - LANE_X0);

    for (const e of b.drainEvents()) this.onAnomaly(e.kind, e.x, px);
    this.sand?.setVisible(b.sandstormActive);

    const g = this.gfx;
    g.clear();
    g.fillStyle(0xff9ec4).fillRect(LANE_X0 - 60, GROUND - 80, 50, 80);
    g.fillStyle(0x4a3a5a).fillRect(LANE_X1 + 10, GROUND - 100, 60, 100);
    this.bar(g, LANE_X0 - 60, GROUND - 95, 50, b.playerBaseHp / b.playerBaseMax, 0x4ade80);
    this.bar(g, LANE_X1 + 10, GROUND - 115, 60, b.enemyBaseHp / b.level.enemyBaseHp, 0xef4444);

    const alive = new Set<number>();
    for (const u of b.units) {
      alive.add(u.uid);
      const heroKey = this.textures.exists(charKey(`hero_${this.era.id}`)) ? `hero_${this.era.id}` : 'hero';
      const key = charKey(u.isHero ? heroKey : u.def.id);
      const y = GROUND - (u.isHero ? 0 : (u.uid % 3) * 6);
      const x = px(u.x);
      if (this.textures.exists(key)) {
        let s = this.sprites.get(u.uid);
        if (!s) { s = this.add.image(x, y, key).setOrigin(0.5, 1).setFlipX(u.side === 'enemy'); this.sprites.set(u.uid, s); }
        const h = u.def.size * 2.4;
        s.setDisplaySize(h * (s.width / s.height), h).setPosition(x, y).setAlpha(u.ttl !== undefined ? 0.6 : 1);
        this.bar(g, x - 12, y - h - 6, 24, u.hp / u.def.hp, u.side === 'player' ? 0x4ade80 : 0xef4444);
      } else {
        const cy = y - u.def.size / 2;
        g.fillStyle(u.def.color, u.ttl !== undefined ? 0.55 : 1).fillCircle(x, cy, u.def.size / 2);
        g.fillStyle(0x000000).fillCircle(x + (u.side === 'player' ? 4 : -4), cy - 3, 2);
        if (u.isHero) g.lineStyle(3, 0xffffff).strokeCircle(x, cy, u.def.size / 2 + 2);
        this.bar(g, x - 12, cy - u.def.size / 2 - 8, 24, u.hp / u.def.hp, u.side === 'player' ? 0x4ade80 : 0xef4444);
      }
    }
    for (const [uid, s] of this.sprites) if (!alive.has(uid)) { s.destroy(); this.sprites.delete(uid); }

    this.energyText.setText(`${t('energy')}: ${Math.floor(b.energy)}/${MAX_ENERGY}${b.boostActive ? '  ' + t('energy_boost_on') : ''}`);
    for (const ub of this.unitButtons) ub.bg.setAlpha(b.energy >= ub.cost ? 1 : 0.4);
    const cd = Math.ceil(b.wormholeCd);
    this.wormholeBtn.setText(cd > 0 ? `${t('wormhole')}\n${cd}s` : `${t('wormhole')}\n🌀`);
    this.wormholeBtn.setAlpha(b.wormholeCd > 0 ? 0.5 : 1);

    if (b.outcome !== 'playing' && !this.ended) { this.ended = true; this.showResult(); }
  }

  private async watchBoost() {
    if (this.boostUsed || this.busy || this.tutorialBox || this.battle.outcome !== 'playing') return;
    this.busy = true;
    try {
      if (await services.ads.showRewarded('energy_boost')) {
        this.battle.energyBoost(); this.boostUsed = true; this.boostBtn?.setVisible(false);
        services.analytics.track('ad_rewarded', { placement: 'energy_boost' });
      }
    } finally { this.busy = false; }
  }

  private addResult<T extends Phaser.GameObjects.GameObject>(o: T): T { this.resultObjs.push(o); return o; }

  private clearResult() { this.resultObjs.forEach(o => o.destroy()); this.resultObjs = []; }

  private showResult() {
    const b = this.battle;
    const win = b.outcome === 'win';
    let msg = t(win ? 'win' : 'lose');
    let coins = 0;
    if (win) {
      const stars = starsFor(b.playerBaseHp / b.playerBaseMax);
      coins = applyWin(game.save, this.level, stars);
      persist();
      msg += `\n${'★'.repeat(stars)}${'·'.repeat(3 - stars)}\n${t('reward')}: 🪙 ${coins}`;
    }
    services.analytics.track('level_end', { level: this.level.id, win: win ? 1 : 0, revived: this.reviveUsed ? 1 : 0 });
    this.addResult(this.add.rectangle(W / 2, H / 2, W, H, 0x000000, 0.65).setDepth(20));
    this.addResult(this.add.text(W / 2, 140, msg, { fontSize: '30px', color: '#fff', align: 'center', lineSpacing: 10 }).setOrigin(0.5).setDepth(21));

    // Extras OPCIONALES: nunca se muestra un anuncio sin que el jugador toque el botón.
    if (win && coins > 0) {
      const dbl = this.addResult(button(this, W / 2, 255, 320, 50, tf('double_reward', { n: coins }), async () => {
        if (this.busy) return; this.busy = true;
        try {
          if (await services.ads.showRewarded('double_reward')) {
            doubleReward(game.save, coins); persist(); dbl.destroy();
            services.analytics.track('ad_rewarded', { placement: 'double_reward' });
            this.addResult(this.add.text(W / 2, 255, `🪙 +${coins}`, { fontSize: '26px', color: '#ffe066' }).setOrigin(0.5).setDepth(21));
          }
        } finally { this.busy = false; }
      }, { color: 0xd98324, fontSize: 18 }).setDepth(21));
    }
    if (!win && !this.reviveUsed) {
      this.addResult(button(this, W / 2 - 170, 255, 300, 50, t('revive'), async () => {
        if (this.busy) return; this.busy = true;
        try {
          if (await services.ads.showRewarded('revive')) {
            services.analytics.track('ad_rewarded', { placement: 'revive' }); this.doRevive();
          }
        } finally { this.busy = false; }
      }, { color: 0xd98324, fontSize: 18 }).setDepth(21));
      this.addResult(button(this, W / 2 + 170, 255, 300, 50, tf('revive_gems', { n: REVIVE_GEMS }), () => {
        if (spendGems(game.save, REVIVE_GEMS)) { persist(); this.doRevive(); }
      }, { color: 0x2a7fb8, fontSize: 18, disabled: game.save.gems < REVIVE_GEMS }).setDepth(21));
    }

    const idx = LEVELS.indexOf(this.level), next = LEVELS[idx + 1];
    const btns: [string, () => void][] = [[t('retry'), () => this.scene.restart({ levelId: this.level.id })], [t('map'), () => this.scene.start('EraMap')]];
    if (win && next) btns.splice(1, 0, [t('next'), () => this.scene.start('Battle', { levelId: next.id })]);
    btns.forEach(([label, cb], i) => this.addResult(button(this, W / 2 + (i - (btns.length - 1) / 2) * 180, 360, 160, 56, label, cb).setDepth(21)));
  }

  private doRevive() {
    if (!this.battle.revive()) return;
    this.reviveUsed = true; this.ended = false; this.clearResult();
  }

  private bar(g: Phaser.GameObjects.Graphics, x: number, y: number, w: number, pct: number, color: number) {
    g.fillStyle(0x000000, 0.6).fillRect(x, y, w, 5);
    g.fillStyle(color).fillRect(x, y, w * Math.max(0, pct), 5);
  }
}
