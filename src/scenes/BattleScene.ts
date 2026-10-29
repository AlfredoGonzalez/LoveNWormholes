import Phaser from 'phaser';
import { Battle, MAX_ENERGY, WORMHOLE_COOLDOWN } from '../game/sim';
import { LEVEL_PREHISTORIA_1, PLAYER_UNITS } from '../game/data';
import { t } from '../i18n';

const W = 960, H = 540, GROUND = 400, LANE_X0 = 90, LANE_X1 = 870;

/** Escena de render: toda la lógica vive en Battle (sim.ts). Arte = formas placeholder. */
export class BattleScene extends Phaser.Scene {
  private battle!: Battle;
  private gfx!: Phaser.GameObjects.Graphics;
  private energyText!: Phaser.GameObjects.Text;
  private wormholeBtn!: Phaser.GameObjects.Text;
  private banner?: Phaser.GameObjects.Text;
  private unitButtons: { bg: Phaser.GameObjects.Rectangle; cost: number }[] = [];

  constructor() { super('Battle'); }

  create() {
    this.battle = new Battle(LEVEL_PREHISTORIA_1);
    this.unitButtons = [];
    this.banner = undefined;
    this.cameras.main.setBackgroundColor(0x7fb8e6);
    this.add.rectangle(W / 2, GROUND + 80, W, 160, 0x6b8e4e);
    this.add.text(W / 2, 20, `${t('era_prehistoria')} — ${t('story_intro')}`, {
      fontSize: '14px', color: '#1b1230', wordWrap: { width: W - 40 }, align: 'center',
    }).setOrigin(0.5, 0);
    this.gfx = this.add.graphics();
    this.energyText = this.add.text(20, H - 130, '', { fontSize: '18px', color: '#fff' });

    PLAYER_UNITS.forEach((def, i) => {
      const x = 80 + i * 150, y = H - 50;
      const bg = this.add.rectangle(x, y, 140, 70, def.color).setInteractive({ useHandCursor: true });
      this.add.text(x, y - 15, t(def.nameKey), { fontSize: '13px', color: '#1b1230', align: 'center', wordWrap: { width: 130 } }).setOrigin(0.5);
      this.add.text(x, y + 20, `⚡${def.cost}`, { fontSize: '16px', color: '#1b1230' }).setOrigin(0.5);
      bg.on('pointerdown', () => this.battle.summon(def));
      this.unitButtons.push({ bg, cost: def.cost });
    });

    this.wormholeBtn = this.add.text(W - 120, H - 50, '', {
      fontSize: '16px', color: '#fff', backgroundColor: '#6a2cdc', padding: { x: 12, y: 18 }, align: 'center',
    }).setOrigin(0.5).setInteractive({ useHandCursor: true });
    this.wormholeBtn.on('pointerdown', () => this.battle.castWormhole());
  }

  update(_: number, deltaMs: number) {
    const b = this.battle;
    b.update(Math.min(deltaMs, 100) / 1000);
    const px = (x: number) => LANE_X0 + (x / b.level.laneLength) * (LANE_X1 - LANE_X0);

    const g = this.gfx;
    g.clear();
    // bases
    g.fillStyle(0xff9ec4).fillRect(LANE_X0 - 60, GROUND - 80, 50, 80);
    g.fillStyle(0x4a3a5a).fillRect(LANE_X1 + 10, GROUND - 100, 60, 100);
    this.bar(g, LANE_X0 - 60, GROUND - 95, 50, b.playerBaseHp / b.level.baseHp, 0x4ade80);
    this.bar(g, LANE_X1 + 10, GROUND - 115, 60, b.enemyBaseHp / b.level.baseHp, 0xef4444);

    for (const u of b.units) {
      const y = GROUND - u.def.size / 2 - (u.isHero ? 0 : (u.uid % 3) * 6);
      g.fillStyle(u.def.color).fillCircle(px(u.x), y, u.def.size / 2);
      g.fillStyle(0x000000).fillCircle(px(u.x) + (u.side === 'player' ? 4 : -4), y - 3, 2);
      if (u.isHero) { g.lineStyle(3, 0xffffff).strokeCircle(px(u.x), y, u.def.size / 2 + 2); }
      this.bar(g, px(u.x) - 12, y - u.def.size / 2 - 8, 24, u.hp / u.def.hp, u.side === 'player' ? 0x4ade80 : 0xef4444);
    }

    this.energyText.setText(`${t('energy')}: ${Math.floor(b.energy)}/${MAX_ENERGY}`);
    for (const ub of this.unitButtons) ub.bg.setAlpha(b.energy >= ub.cost ? 1 : 0.4);
    const cd = Math.ceil(b.wormholeCd);
    this.wormholeBtn.setText(cd > 0 ? `${t('wormhole')}\n${cd}s` : `${t('wormhole')}\n🌀`);
    this.wormholeBtn.setAlpha(b.wormholeCd > 0 ? 0.5 : 1);
    void WORMHOLE_COOLDOWN;

    if (b.outcome !== 'playing' && !this.banner) {
      this.banner = this.add.text(W / 2, H / 2 - 40, `${t(b.outcome === 'win' ? 'win' : 'lose')}\n\n[ ${t('retry')} ]`, {
        fontSize: '28px', color: '#fff', backgroundColor: '#000000cc', padding: { x: 24, y: 20 }, align: 'center',
      }).setOrigin(0.5).setInteractive({ useHandCursor: true });
      this.banner.on('pointerdown', () => this.scene.restart());
    }
  }

  private bar(g: Phaser.GameObjects.Graphics, x: number, y: number, w: number, pct: number, color: number) {
    g.fillStyle(0x000000, 0.6).fillRect(x, y, w, 5);
    g.fillStyle(color).fillRect(x, y, w * Math.max(0, pct), 5);
  }
}
