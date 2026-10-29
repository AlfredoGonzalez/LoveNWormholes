import Phaser from 'phaser';
import { game, persist } from '../services/save';
import { services } from '../services';
import { t } from '../i18n';
import { H, W, hasTex, title, woodButton } from '../ui';

/** Pantalla de título: selva, logo, Gusanito y el botón JUGAR de madera. */
export class TitleScene extends Phaser.Scene {
  private busy = false;

  constructor() { super('Title'); }

  create() {
    this.busy = false;
    this.cameras.main.setBackgroundColor(0x2a1f4d);
    if (hasTex(this, 'ui_title_bg')) this.add.image(W / 2, H / 2, 'ui_title_bg').setDisplaySize(W, H);
    else {
      this.add.rectangle(W / 2, H * 0.3, W, H * 0.6, 0x4a2f7a);
      this.add.rectangle(W / 2, H * 0.8, W, H * 0.4, 0x24452d);
      this.add.ellipse(W / 2, 560, 300, 330, 0x54546a).setStrokeStyle(8, 0x2e2024);
      this.add.ellipse(W / 2, 580, 210, 260, 0x14102a);
    }

    if (hasTex(this, 'ui_logo')) this.add.image(W / 2, 170, 'ui_logo').setDisplaySize(460, 230);
    else title(this, t('title'), 150).setFontSize(44);

    if (hasTex(this, 'ui_title_hero')) this.add.image(W / 2, 560, 'ui_title_hero').setDisplaySize(340, 340);
    else {
      // Gusanito de reemplazo: cuerpo verde con su gorra negra y la «A»
      this.add.ellipse(W / 2 + 30, 640, 220, 90, 0x7ccf5a).setStrokeStyle(5, 0x2e2024);
      this.add.circle(W / 2, 560, 82, 0x7ccf5a).setStrokeStyle(5, 0x2e2024);
      this.add.ellipse(W / 2, 505, 170, 70, 0x1c1c22).setStrokeStyle(4, 0x2e2024);
      this.add.text(W / 2, 505, 'A', { fontSize: '40px', fontStyle: 'bold', color: '#fff' }).setOrigin(0.5);
      this.add.circle(W / 2 - 26, 565, 11, 0xffffff); this.add.circle(W / 2 + 26, 565, 11, 0xffffff);
      this.add.circle(W / 2 - 22, 567, 5, 0x000000); this.add.circle(W / 2 + 30, 567, 5, 0x000000);
    }

    woodButton(this, W / 2, 800, 320, 110, t('play_caps'), () => this.play());
  }

  private async play() {
    if (this.busy) return;
    this.busy = true;
    if (game.save.consent === 'unknown') {
      game.save.consent = await services.consent.request(game.save.consent);
      persist();
    }
    this.scene.start('Home');
  }
}
