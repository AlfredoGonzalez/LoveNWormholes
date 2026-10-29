import Phaser from 'phaser';
import { game } from '../services/save';
import { isUnlocked } from '../game/economy';
import { ERAS } from '../game/data';
import { t } from '../i18n';
import { W, H, button, coinsText, title } from '../ui';

export class EraMapScene extends Phaser.Scene {
  constructor() { super('EraMap'); }

  create() {
    const era = ERAS[game.eraIdx];
    const eraOpen = isUnlocked(game.save, era.levels[0]);
    this.cameras.main.setBackgroundColor(era.sky);
    title(this, t(era.nameKey), 44);
    coinsText(this, `${t('coins')}: ${game.save.coins}`);
    if (game.eraIdx > 0) button(this, 50, 150, 70, 56, '◀', () => { game.eraIdx--; this.scene.restart(); }, { fontSize: 26, color: 0x555577 });
    if (game.eraIdx < ERAS.length - 1) button(this, W - 50, 150, 70, 56, '▶', () => { game.eraIdx++; this.scene.restart(); }, { fontSize: 26, color: 0x555577 });
    if (!eraOpen) this.add.text(W / 2, 150, t('era_locked'), { fontSize: '18px', color: '#3b2a3f' }).setOrigin(0.5);

    era.levels.forEach((lvl, i) => {
      const y = 300 + i * 170;
      const open = isUnlocked(game.save, lvl);
      const stars = game.save.stars[lvl.id] ?? 0;
      button(this, W / 2, y, 360, 100, open ? `${i + 1}. ${t(lvl.nameKey)}` : `🔒 ${t('locked')}`,
        () => this.scene.start('Battle', { levelId: lvl.id }), { color: open ? 0x2ea043 : 0x666666, disabled: !open, fontSize: 22 });
      for (let k = 0; k < 3; k++) {
        this.add.text(W / 2 + (k - 1) * 40, y + 72, '★', { fontSize: '34px', color: k < stars ? '#ffe066' : '#5b6b80', stroke: '#3b2a3f', strokeThickness: 4 }).setOrigin(0.5);
      }
    });

    button(this, 90, H - 50, 150, 48, t('back'), () => this.scene.start('Menu'), { color: 0x555577, fontSize: 18 });
    button(this, W - 110, H - 50, 180, 48, t('upgrades'), () => this.scene.start('Upgrades'), { fontSize: 18 });
  }
}
