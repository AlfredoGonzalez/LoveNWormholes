import Phaser from 'phaser';
import { Battle, MAX_ENERGY } from '../game/sim';
import { PLAYER_UNITS, LEVELS, levelById, type LevelDef } from '../game/data';
import { applyWin, modsFrom, starsFor } from '../game/economy';
import { game, persist } from '../services/save';
import { t } from '../i18n';
import { W, H, button } from '../ui';
import { charKey } from './PreloadScene';

const GROUND = 400, LANE_X0 = 90, LANE_X1 = 870;

/** Escena de render: toda la lógica vive en Battle (sim.ts). Usa arte si existe, si no formas placeholder. */
export class BattleScene extends Phaser.Scene {
  private battle!: Battle;
  private level!: LevelDef;
  private gfx!: Phaser.GameObjects.Graphics;
  private energyText!: Phaser.GameObjects.Text;
  private wormholeBtn!: Phaser.GameObjects.Text;
  private unitButtons: { bg: Phaser.GameObjects.Rectangle; cost: number }[] = [];
  private sprites = new Map<number, Phaser.GameObjects.Image>();
  private ended = false;
  private tutorialStep = 0;
  private tutorialBox?: Phaser.GameObjects.Text;

  constructor() { super('Battle'); }

  init(data: { levelId?: string }) { this.level = levelById(data.levelId ?? LEVELS[0].id); }

  create() {
    this.battle = new Battle(this.level, modsFrom(game.save.upgrades));
    this.unitButtons = [];
    this.sprites.clear();
    this.ended = false;
    this.cameras.main.setBackgroundColor(0x7fb8e6);
    if (this.textures.exists('bg_prehistoria_far')) this.add.image(W / 2, 200, 'bg_prehistoria_far').setDisplaySize(W, 400);
    this.add.rectangle(W / 2, GROUND + 80, W, 160, 0x6b8e4e);
    this.add.text(W / 2, 14, `${t(this.level.nameKey)} — ${t('era_prehistoria')}`, { fontSize: '16px', color: '#1b1230' }).setOrigin(0.5, 0);
    this.gfx = this.add.graphics();
    this.energyText = this.add.text(20, H - 130, '', { fontSize: '18px', color: '#fff', stroke: '#3b2a3f', strokeThickness: 3 });

    PLAYER_UNITS.forEach((def, i) => {
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

    this.tutorialStep = 0;
    this.tutorialBox = undefined;
    if (!game.save.tutorialDone && this.level.id === LEVELS[0].id) this.showTutorial();
  }

  private showTutorial() {
    const steps = ['tut1', 'tut2', 'tut3'] as const;
    if (this.tutorialStep >= steps.length) {
      this.tutorialBox?.destroy(); this.tutorialBox = undefined;
      game.save.tutorialDone = true; persist();
      return;
    }
    this.tutorialBox?.destroy();
    this.tutorialBox = this.add.text(W / 2, 200, `${t(steps[this.tutorialStep])}\n\n${t('tap_continue')}`, {
      fontSize: '24px', color: '#fff', backgroundColor: '#000000dd', padding: { x: 24, y: 20 }, align: 'center', wordWrap: { width: 640 },
    }).setOrigin(0.5).setDepth(10).setInteractive();
    this.tutorialBox.once('pointerdown', () => { this.tutorialStep++; this.showTutorial(); });
  }

  update(_: number, deltaMs: number) {
    const b = this.battle;
    if (!this.tutorialBox) b.update(Math.min(deltaMs, 100) / 1000);
    const px = (x: number) => LANE_X0 + (x / b.level.laneLength) * (LANE_X1 - LANE_X0);

    const g = this.gfx;
    g.clear();
    g.fillStyle(0xff9ec4).fillRect(LANE_X0 - 60, GROUND - 80, 50, 80);
    g.fillStyle(0x4a3a5a).fillRect(LANE_X1 + 10, GROUND - 100, 60, 100);
    this.bar(g, LANE_X0 - 60, GROUND - 95, 50, b.playerBaseHp / b.playerBaseMax, 0x4ade80);
    this.bar(g, LANE_X1 + 10, GROUND - 115, 60, b.enemyBaseHp / b.level.baseHp, 0xef4444);

    const alive = new Set<number>();
    for (const u of b.units) {
      alive.add(u.uid);
      const key = charKey(u.isHero ? 'hero' : u.def.id);
      const y = GROUND - (u.isHero ? 0 : (u.uid % 3) * 6);
      const x = px(u.x);
      if (this.textures.exists(key)) {
        let s = this.sprites.get(u.uid);
        if (!s) { s = this.add.image(x, y, key).setOrigin(0.5, 1).setFlipX(u.side === 'enemy'); this.sprites.set(u.uid, s); }
        const h = u.def.size * 2.4;
        s.setDisplaySize(h * (s.width / s.height), h).setPosition(x, y);
        this.bar(g, x - 12, y - h - 6, 24, u.hp / u.def.hp, u.side === 'player' ? 0x4ade80 : 0xef4444);
      } else {
        const cy = y - u.def.size / 2;
        g.fillStyle(u.def.color).fillCircle(x, cy, u.def.size / 2);
        g.fillStyle(0x000000).fillCircle(x + (u.side === 'player' ? 4 : -4), cy - 3, 2);
        if (u.isHero) g.lineStyle(3, 0xffffff).strokeCircle(x, cy, u.def.size / 2 + 2);
        this.bar(g, x - 12, cy - u.def.size / 2 - 8, 24, u.hp / u.def.hp, u.side === 'player' ? 0x4ade80 : 0xef4444);
      }
    }
    for (const [uid, s] of this.sprites) if (!alive.has(uid)) { s.destroy(); this.sprites.delete(uid); }

    this.energyText.setText(`${t('energy')}: ${Math.floor(b.energy)}/${MAX_ENERGY}`);
    for (const ub of this.unitButtons) ub.bg.setAlpha(b.energy >= ub.cost ? 1 : 0.4);
    const cd = Math.ceil(b.wormholeCd);
    this.wormholeBtn.setText(cd > 0 ? `${t('wormhole')}\n${cd}s` : `${t('wormhole')}\n🌀`);
    this.wormholeBtn.setAlpha(b.wormholeCd > 0 ? 0.5 : 1);

    if (b.outcome !== 'playing' && !this.ended) { this.ended = true; this.showResult(); }
  }

  private showResult() {
    const b = this.battle;
    const win = b.outcome === 'win';
    let msg = t(win ? 'win' : 'lose');
    if (win) {
      const stars = starsFor(b.playerBaseHp / b.playerBaseMax);
      const coins = applyWin(game.save, this.level, stars);
      persist();
      msg += `\n${'★'.repeat(stars)}${'·'.repeat(3 - stars)}\n${t('reward')}: 🪙 ${coins}`;
    }
    this.add.rectangle(W / 2, H / 2, W, H, 0x000000, 0.65).setDepth(20);
    this.add.text(W / 2, 170, msg, { fontSize: '30px', color: '#fff', align: 'center', lineSpacing: 10 }).setOrigin(0.5).setDepth(21);
    const idx = LEVELS.indexOf(this.level), next = LEVELS[idx + 1];
    const btns: [string, () => void][] = [[t('retry'), () => this.scene.restart({ levelId: this.level.id })], [t('map'), () => this.scene.start('EraMap')]];
    if (win && next) btns.splice(1, 0, [t('next'), () => this.scene.start('Battle', { levelId: next.id })]);
    btns.forEach(([label, cb], i) => button(this, W / 2 + (i - (btns.length - 1) / 2) * 180, 330, 160, 56, label, cb).setDepth(21));
  }

  private bar(g: Phaser.GameObjects.Graphics, x: number, y: number, w: number, pct: number, color: number) {
    g.fillStyle(0x000000, 0.6).fillRect(x, y, w, 5);
    g.fillStyle(color).fillRect(x, y, w * Math.max(0, pct), 5);
  }
}
