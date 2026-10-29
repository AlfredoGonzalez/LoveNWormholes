import Phaser from 'phaser';
import { game } from '../services/save';
import { isUnlocked } from '../game/economy';
import { LEVELS } from '../game/data';
import { t } from '../i18n';
import { W, button, coinsText, title } from '../ui';

export class EraMapScene extends Phaser.Scene {
  constructor() { super('EraMap'); }

  create() {
    this.cameras.main.setBackgroundColor(0x7fb8e6);
    title(this, t('era_prehistoria'));
    coinsText(this, `${t('coins')}: ${game.save.coins}`);

    LEVELS.forEach((lvl, i) => {
      const x = 160 + i * 320, y = 270;
      const open = isUnlocked(game.save, lvl);
      const stars = game.save.stars[lvl.id] ?? 0;
      button(this, x, y, 220, 120, open ? `${i + 1}. ${t(lvl.nameKey)}` : `🔒 ${t('locked')}`,
        () => this.scene.start('Battle', { levelId: lvl.id }), { color: open ? 0x2ea043 : 0x666666, disabled: !open, fontSize: 20 });
      for (let k = 0; k < 3; k++) {
        this.add.text(x + (k - 1) * 36, y + 85, '★', { fontSize: '32px', color: k < stars ? '#ffe066' : '#5b6b80', stroke: '#3b2a3f', strokeThickness: 4 }).setOrigin(0.5);
      }
    });

    button(this, 100, 500, 160, 44, t('back'), () => this.scene.start('Menu'), { color: 0x555577, fontSize: 18 });
    button(this, W - 120, 500, 200, 44, t('upgrades'), () => this.scene.start('Upgrades'), { fontSize: 18 });
  }
}
