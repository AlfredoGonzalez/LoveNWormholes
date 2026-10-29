import Phaser from 'phaser';
import { game, persist } from '../services/save';
import { t, type Key } from '../i18n';
import { H, W, hasTex } from '../ui';

const PANELS: { key: string; caption: Key; emoji: string; color: number; angle: number; y: number }[] = [
  { key: 'story_01', caption: 'intro_1', emoji: '🍎💞', color: 0xcfe8a8, angle: -2, y: 215 },
  { key: 'story_02', caption: 'intro_2', emoji: '🔮❓', color: 0xf2d9a0, angle: 2.5, y: 480 },
  { key: 'story_03', caption: 'intro_3', emoji: '🌀😱', color: 0xb9c8f2, angle: -2, y: 745 },
];

/** Cómic de introducción: tres paneles que caen uno tras otro; toca para continuar. */
export class IntroScene extends Phaser.Scene {
  private shown = 0;
  private hint!: Phaser.GameObjects.Text;

  constructor() { super('Intro'); }

  create() {
    this.shown = 0;
    this.cameras.main.setBackgroundColor(0xf3ead2);
    if (hasTex(this, 'intro_bg')) this.add.image(W / 2, H / 2, 'intro_bg').setDisplaySize(W, H);
    this.hint = this.add.text(W / 2, H - 40, t('intro_tap'), { fontSize: '20px', fontStyle: 'italic', color: '#6b5a3a' }).setOrigin(0.5).setDepth(10);
    this.tweens.add({ targets: this.hint, alpha: 0.35, duration: 700, yoyo: true, repeat: -1 });
    this.input.on('pointerdown', () => this.next());
    this.next();
  }

  private next() {
    if (this.shown >= PANELS.length) return this.finish();
    const p = PANELS[this.shown++];
    const w = 440, h = 275;
    const c = this.add.container(W / 2, -200).setAngle(p.angle * 3);
    if (hasTex(this, p.key)) c.add(this.add.image(0, 0, p.key).setDisplaySize(w, h));
    else {
      c.add([this.add.rectangle(0, 0, w, h, p.color).setStrokeStyle(6, 0x4a6b2f), this.add.text(0, 0, p.emoji, { fontSize: '80px' }).setOrigin(0.5)]);
    }
    c.add(this.add.text(0, h / 2 + 34, t(p.caption), { fontSize: '17px', color: '#3b2a1a', align: 'center', wordWrap: { width: w }, backgroundColor: '#f3ead2cc', padding: { x: 6, y: 3 } }).setOrigin(0.5, 0.5));
    this.tweens.add({ targets: c, y: p.y, angle: p.angle, duration: 650, ease: 'Bounce.easeOut' });
  }

  private finish() {
    game.save.introSeen = true;
    persist();
    this.scene.start('Title');
  }
}
