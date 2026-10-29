import Phaser from 'phaser';
import { game, persist } from '../services/save';
import { UPGRADES, buyUpgrade, upgradeCost } from '../game/economy';
import { t } from '../i18n';
import { W, H, button, coinsText, title } from '../ui';

export class UpgradesScene extends Phaser.Scene {
  constructor() { super('Upgrades'); }

  create() {
    this.cameras.main.setBackgroundColor(0x3a2268);
    title(this, t('upgrades'), 44);
    coinsText(this, `${t('coins')}: ${game.save.coins}`);

    UPGRADES.forEach((u, i) => {
      const y = 200 + i * 150;
      const lvl = game.save.upgrades[u.id] ?? 0;
      const maxed = lvl >= u.max;
      const cost = upgradeCost(u, lvl);
      this.add.text(40, y, `${t(u.nameKey)}  Lv ${lvl}/${u.max}`, { fontSize: '26px', color: '#fff' }).setOrigin(0, 0.5);
      button(this, W / 2, y + 55, 440, 54, maxed ? t('maxed') : `🪙 ${cost}`, () => {
        if (buyUpgrade(game.save, u.id)) { persist(); this.scene.restart(); }
      }, { color: 0x2ea043, disabled: maxed || game.save.coins < cost });
    });

    button(this, 90, H - 50, 150, 48, t('back'), () => this.scene.start('Menu'), { color: 0x555577, fontSize: 18 });
  }
}
