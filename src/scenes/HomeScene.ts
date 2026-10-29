import Phaser from 'phaser';
import { game } from '../services/save';
import { ERAS, eraById } from '../game/data';
import { nextLevel } from '../game/economy';
import { t } from '../i18n';
import { CONTENT_BOTTOM, CONTENT_TOP, addShell } from '../shell';
import { W, hasTex, woodButton } from '../ui';
import { heroId, baseKey, bgKey, sheetKey } from './PreloadScene';

/** Hub (pestaña central «Batalla»): casa de piedra de la era, Gusanito y el botón JUGAR que lanza el siguiente nivel. */
export class HomeScene extends Phaser.Scene {
  constructor() { super('Home'); }

  create() {
    const lvl = nextLevel(game.save);
    const era = eraById(lvl.eraId);
    game.eraIdx = ERAS.indexOf(era);
    addShell(this, 'battle');

    const bg = `hub_bg_${era.id}`;
    if (hasTex(this, bg)) this.add.image(W / 2, (CONTENT_TOP + CONTENT_BOTTOM) / 2, bg).setDisplaySize(W, CONTENT_BOTTOM - CONTENT_TOP + 140).setDepth(-10);
    else this.cameras.main.setBackgroundColor(era.sky === 0 ? 0xf3ead2 : 0xf3ead2);

    // Casa (la misma arte que la base del jugador en batalla)
    const houseY = 470;
    if (hasTex(this, baseKey(era.id, 'home'))) this.add.image(W / 2 + 30, houseY, baseKey(era.id, 'home')).setDisplaySize(300, 375);
    else {
      this.add.ellipse(W / 2 + 30, houseY, 270, 300, 0x9a9aa3).setStrokeStyle(6, 0x2e2024);
      this.add.rectangle(W / 2 + 80, houseY + 60, 70, 100, 0x2a2430).setStrokeStyle(4, 0x2e2024);
      this.add.ellipse(W / 2 + 30, houseY - 160, 60, 30, 0x58a14a).setStrokeStyle(4, 0x2e2024).setAngle(-25);
    }

    // Gusanito (animación idle si existe el arte)
    const art = [heroId(era.id), heroId('prehistoria')].find(id => this.textures.exists(sheetKey(id, 'idle')));
    if (art) this.add.sprite(W / 2 - 80, 620, sheetKey(art, 'idle')).setDisplaySize(190, 190).setOrigin(0.5, 1).play(sheetKey(art, 'idle'));
    else {
      this.add.ellipse(W / 2 - 70, 600, 160, 60, 0x7ccf5a).setStrokeStyle(4, 0x2e2024);
      this.add.circle(W / 2 - 100, 545, 44, 0x7ccf5a).setStrokeStyle(4, 0x2e2024);
      this.add.ellipse(W / 2 - 100, 510, 90, 36, 0x1c1c22);
      this.add.circle(W / 2 - 115, 548, 7, 0xffffff); this.add.circle(W / 2 - 85, 548, 7, 0xffffff);
    }

    this.add.text(W / 2, 668, t(lvl.nameKey), { fontSize: '22px', fontStyle: 'bold', color: '#5a4630', stroke: '#f3ead2', strokeThickness: 4 }).setOrigin(0.5);
    woodButton(this, W / 2, 745, 300, 100, t('play_caps'), () => this.scene.start('Battle', { levelId: lvl.id }));
    void bgKey;
  }
}
