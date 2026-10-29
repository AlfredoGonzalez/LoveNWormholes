import Phaser from 'phaser';
import { game, persist } from '../services/save';
import { UPGRADES, buyUpgrade, upgradeCost } from '../game/economy';
import { t } from '../i18n';
import { W, button, coinsText, title } from '../ui';

export class UpgradesScene extends Phaser.Scene {
  constructor() { super('Upgrades'); }

  create() {
    this.cameras.main.setBackgroundColor(0x3a2268);
    title(this, t('upgrades'));
    coinsText(this, `${t('coins')}: ${game.save.coins}`);

    UPGRADES.forEach((u, i) => {
      const y = 140 + i * 90;
      const lvl = game.save.upgrades[u.id] ?? 0;
      const maxed = lvl >= u.max;
      const cost = upgradeCost(u, lvl);
      this.add.text(120, y, `${t(u.nameKey)}  Lv ${lvl}/${u.max}`, { fontSize: '24px', color: '#fff' }).setOrigin(0, 0.5);
      button(this, W - 180, y, 200, 54, maxed ? t('maxed') : `🪙 ${cost}`, () => {
        if (buyUpgrade(game.save, u.id)) { persist(); this.scene.restart(); }
      }, { color: 0x2ea043, disabled: maxed || game.save.coins < cost });
    });

    button(this, 100, 500, 160, 44, t('back'), () => this.scene.start('Menu'), { color: 0x555577, fontSize: 18 });
  }
}
