import Phaser from 'phaser';
import { ERAS } from '../game/data';
import { W, H } from '../ui';

const base = import.meta.env.BASE_URL;

export const ANIMS = ['idle', 'walk', 'attack', 'die'] as const;
export type AnimName = (typeof ANIMS)[number];
export const FRAME = 256; // cada cuadro de una hoja mide 256×256 (ver art-prompts/README.md)

export const heroId = (eraId: string) => `gusanito_${eraId}`;
export const sheetKey = (id: string, anim: AnimName) => `char_${id}_${anim}`;
export const baseKey = (eraId: string, side: 'home' | 'enemy') => `base_${eraId}_${side}`;
export const bgKey = (eraId: string) => `bg_${eraId}`;
export const UI_ICONS = ['coin', 'gem', 'star_full', 'star_empty', 'logo', 'shop_gems_s', 'shop_gems_m', 'shop_gems_l', 'shop_starter', 'shop_double_coins'] as const;
export const uiKey = (name: string) => `ui_${name}`;

const FRAME_RATE: Record<AnimName, number> = { idle: 5, walk: 8, attack: 10, die: 8 };

/**
 * Carga TODO el arte posible. Si un archivo no existe se ignora y el juego dibuja el placeholder
 * (ver `hasTex`). Los archivos los produce `npm run art` a partir de art-inbox/.
 */
export class PreloadScene extends Phaser.Scene {
  constructor() { super('Preload'); }

  preload() {
    this.add.text(W / 2, H / 2, 'Loading…', { fontSize: '20px', color: '#fff' }).setOrigin(0.5);
    this.load.on('loaderror', () => { /* arte faltante: se usa placeholder */ });
    this.load.setPath(`${base}assets/`);

    const ids = ['ghost', ...ERAS.flatMap(e => [heroId(e.id), ...e.units.map(u => u.id), ...e.enemies.map(u => u.id)])];
    for (const id of ids)
      for (const a of ANIMS) this.load.spritesheet(sheetKey(id, a), `characters/${id}_${a}.png`, { frameWidth: FRAME, frameHeight: FRAME });
    for (const e of ERAS) {
      this.load.image(bgKey(e.id), `backgrounds/bg_${e.id}.png`);
      this.load.image(baseKey(e.id, 'home'), `bases/base_${e.id}_home.png`);
      this.load.image(baseKey(e.id, 'enemy'), `bases/base_${e.id}_enemy.png`);
    }
    for (const n of UI_ICONS) this.load.image(uiKey(n), `ui/${n}.png`);
  }

  create() {
    // Una animación por cada hoja que sí existe.
    for (const key of this.textures.getTextureKeys()) {
      const m = /^char_.+_(idle|walk|attack|die)$/.exec(key);
      if (!m || this.anims.exists(key)) continue;
      const anim = m[1] as AnimName;
      this.anims.create({
        key, frames: this.anims.generateFrameNumbers(key), frameRate: FRAME_RATE[anim],
        repeat: anim === 'idle' || anim === 'walk' ? -1 : 0,
      });
    }
    this.scene.start('Menu');
  }
}
