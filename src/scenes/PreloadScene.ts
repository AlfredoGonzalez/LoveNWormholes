import Phaser from 'phaser';
import { ENEMY_UNITS, PLAYER_UNITS } from '../game/data';
import { W, H } from '../ui';

const base = import.meta.env.BASE_URL;
/** Si un archivo no existe se ignora: el juego dibuja el placeholder (ver `hasTex`). */
export const charKey = (id: string) => `char_${id}`;

export class PreloadScene extends Phaser.Scene {
  constructor() { super('Preload'); }

  preload() {
    this.add.text(W / 2, H / 2, 'Loading…', { fontSize: '20px', color: '#fff' }).setOrigin(0.5);
    this.load.on('loaderror', () => { /* arte faltante: se usa placeholder */ });
    this.load.setPath(`${base}assets/`);
    const ids = ['hero', ...PLAYER_UNITS.map(u => u.id), ...Object.keys(ENEMY_UNITS)];
    for (const id of ids) this.load.image(charKey(id), `characters/${id}/idle_01.png`);
    for (const l of ['far', 'mid', 'near']) this.load.image(`bg_prehistoria_${l}`, `backgrounds/prehistoria/${l}.png`);
  }

  create() { this.scene.start('Menu'); }
}
