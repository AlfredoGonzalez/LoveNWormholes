import Phaser from 'phaser';
import { game, persist } from '../services/save';
import { claimDaily } from '../game/economy';
import { getLang, setLang, t, tf } from '../i18n';
import { services } from '../services';
import { W, button, coinsText, title } from '../ui';

export class MenuScene extends Phaser.Scene {
  constructor() { super('Menu'); }

  private async askConsent() {
    game.save.consent = await services.consent.request(game.save.consent);
    persist();
  }

  create() {
    this.cameras.main.setBackgroundColor(0x3a2268);
    title(this, t('title'), 90).setFontSize(52);
    this.add.text(W / 2, 150, '🐛💜🌀💗🐛', { fontSize: '36px' }).setOrigin(0.5);
    coinsText(this, `🪙 ${game.save.coins}  💎 ${game.save.gems}`);

    button(this, W / 2, 250, 280, 60, t('play'), () => this.scene.start('EraMap'), { color: 0x2ea043, fontSize: 26 });
    button(this, W / 2, 325, 280, 50, t('upgrades'), () => this.scene.start('Upgrades'));
    button(this, W / 2, 380, 280, 50, t('shop'), () => this.scene.start('Shop'), { color: 0xd98324 });
    button(this, W / 2 - 150, 445, 140, 40, t('privacy'), () => this.askConsent(), { color: 0x555577, fontSize: 14 });
    button(this, W / 2 + 40, 445, 220, 40, t('language'), () => {
      const next = getLang() === 'es' ? 'en' : 'es';
      setLang(next); game.save.lang = next; persist();
      this.scene.restart();
    }, { color: 0x555577, fontSize: 16 });

    if (game.save.consent === 'unknown') this.askConsent();

    const gift = claimDaily(game.save);
    if (gift > 0) {
      persist();
      this.add.text(W / 2, 500, `🎁 ${tf('daily_claimed', { n: gift })}`, { fontSize: '22px', color: '#ffe066', stroke: '#3b2a3f', strokeThickness: 4 }).setOrigin(0.5);
    }
  }
}
