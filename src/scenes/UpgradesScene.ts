import Phaser from 'phaser';
import { game, persist } from '../services/save';
import { UPGRADES, buyUpgrade, upgradeCost } from '../game/economy';
import { t } from '../i18n';
import { CONTENT_TOP, addShell } from '../shell';
import { W, button } from '../ui';

export class UpgradesScene extends Phaser.Scene {
  constructor() { super('Upgrades'); }

  create() {
    addShell(this, 'upgrades');
    this.add.text(W / 2, CONTENT_TOP + 24, t('upgrades').toUpperCase(), { fontSize: '30px', fontStyle: 'bold', color: '#5a4630' }).setOrigin(0.5);

    UPGRADES.forEach((u, i) => {
      const y = CONTENT_TOP + 110 + i * 150;
      const lvl = game.save.upgrades[u.id] ?? 0;
      const maxed = lvl >= u.max;
      const cost = upgradeCost(u, lvl);
      this.add.text(40, y, `${t(u.nameKey)}  Lv ${lvl}/${u.max}`, { fontSize: '26px', color: '#5a4630', fontStyle: 'bold' }).setOrigin(0, 0.5);
      button(this, W / 2, y + 55, 440, 54, maxed ? t('maxed') : `🪙 ${cost}`, () => {
        if (buyUpgrade(game.save, u.id)) { persist(); this.scene.restart(); }
      }, { color: 0x2ea043, disabled: maxed || game.save.coins < cost });
    });

  }
}
