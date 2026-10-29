import Phaser from 'phaser';
import { ERAS } from '../game/data';
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
    const ids = ['hero', ...ERAS.flatMap(e => [`hero_${e.id}`, e.ghost.id, ...e.units.map(u => u.id), ...e.enemies.map(u => u.id)])];
    for (const id of ids) this.load.image(charKey(id), `characters/${id}/idle_01.png`);
    for (const e of ERAS) for (const l of ['far', 'mid', 'near']) this.load.image(`bg_${e.id}_${l}`, `backgrounds/${e.id}/${l}.png`);
  }

  create() { this.scene.start('Menu'); }
}
