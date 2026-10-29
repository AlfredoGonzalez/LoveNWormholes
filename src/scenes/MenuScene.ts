import Phaser from 'phaser';
import { game, persist } from '../services/save';
import { claimDaily } from '../game/economy';
import { getLang, setLang, t, tf } from '../i18n';
import { W, button, coinsText, title } from '../ui';

export class MenuScene extends Phaser.Scene {
  constructor() { super('Menu'); }

  create() {
    this.cameras.main.setBackgroundColor(0x3a2268);
    title(this, t('title'), 90).setFontSize(52);
    this.add.text(W / 2, 150, '🐛💜🌀💗🐛', { fontSize: '36px' }).setOrigin(0.5);
    coinsText(this, `${t('coins')}: ${game.save.coins}`);

    button(this, W / 2, 250, 280, 60, t('play'), () => this.scene.start('EraMap'), { color: 0x2ea043, fontSize: 26 });
    button(this, W / 2, 325, 280, 50, t('upgrades'), () => this.scene.start('Upgrades'));
    button(this, W / 2, 390, 280, 44, t('language'), () => {
      const next = getLang() === 'es' ? 'en' : 'es';
      setLang(next); game.save.lang = next; persist();
      this.scene.restart();
    }, { color: 0x555577, fontSize: 16 });

    const gift = claimDaily(game.save);
    if (gift > 0) {
      persist();
      this.add.text(W / 2, 460, `🎁 ${tf('daily_claimed', { n: gift })}`, { fontSize: '22px', color: '#ffe066', stroke: '#3b2a3f', strokeThickness: 4 }).setOrigin(0.5);
    }
  }
}
