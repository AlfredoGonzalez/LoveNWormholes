import Phaser from 'phaser';
import { CONTENT_TOP, addShell } from '../shell';
import { t } from '../i18n';
import { W } from '../ui';

/** Recuerdos (marcador de posición del Hito 6d): rejilla de polaroids bloqueadas y Medidor de Amor. */
export class MemoriesScene extends Phaser.Scene {
  constructor() { super('Memories'); }

  create() {
    addShell(this, 'memories');
    this.add.text(W / 2, CONTENT_TOP + 20, t('nav_memories').toUpperCase(), { fontSize: '30px', fontStyle: 'bold', color: '#5a4630' }).setOrigin(0.5);
    for (let i = 0; i < 6; i++) {
      const x = W / 2 + (i % 2 ? 95 : -95), y = CONTENT_TOP + 165 + Math.floor(i / 2) * 165;
      this.add.rectangle(x, y, 150, 160, 0xfdfaf0).setStrokeStyle(3, 0x8a7a5a).setAngle(i % 2 ? 2 : -2);
      this.add.rectangle(x, y - 10, 124, 116, 0x6b6b74).setAngle(i % 2 ? 2 : -2);
      this.add.text(x, y - 10, '🔒', { fontSize: '40px' }).setOrigin(0.5);
    }
    this.add.text(W / 2, 748, `💗 ${t('love_meter')}`, { fontSize: '20px', fontStyle: 'bold', color: '#5a4630' }).setOrigin(0.5);
    this.add.rectangle(W / 2, 778, 400, 20, 0xcdbf9a).setStrokeStyle(3, 0x5a4630);
    this.add.text(W / 2, 812, t('memories_soon'), { fontSize: '14px', color: '#6b5a3a', align: 'center', wordWrap: { width: 480 } }).setOrigin(0.5);
  }
}
