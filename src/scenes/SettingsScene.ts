import Phaser from 'phaser';
import { game, persist } from '../services/save';
import { services } from '../services';
import { getLang, setLang, t } from '../i18n';
import { H, W, button, title } from '../ui';

/** Ajustes: idioma, privacidad y volver a ver la historia (sonido/vibración llegan con el audio). */
export class SettingsScene extends Phaser.Scene {
  constructor() { super('Settings'); }

  create() {
    this.cameras.main.setBackgroundColor(0x3a2268);
    title(this, t('settings'), 70);
    button(this, W / 2, 230, 380, 64, t('language'), () => {
      const next = getLang() === 'es' ? 'en' : 'es';
      setLang(next); game.save.lang = next; persist();
      this.scene.restart();
    }, { color: 0x555577, fontSize: 20 });
    button(this, W / 2, 320, 380, 64, t('privacy'), async () => {
      game.save.consent = await services.consent.request(game.save.consent);
      persist();
    }, { color: 0x555577, fontSize: 20 });
    button(this, W / 2, 410, 380, 64, t('view_story'), () => this.scene.start('Intro'), { color: 0x555577, fontSize: 20 });
    button(this, W / 2, H - 70, 220, 56, t('back'), () => this.scene.start('Home'), { color: 0x2ea043, fontSize: 20 });
  }
}
