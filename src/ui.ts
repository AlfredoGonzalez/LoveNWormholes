import Phaser from 'phaser';
import { game } from './services/save';

export const W = 540, H = 960; // vertical (portrait)

export interface BtnOpts { color?: number; fontSize?: number; disabled?: boolean }

/** Botón placeholder: rectángulo + texto. Devuelve el contenedor. */
export function button(scene: Phaser.Scene, x: number, y: number, w: number, h: number, label: string, onTap: () => void, o: BtnOpts = {}) {
  const bg = scene.add.rectangle(0, 0, w, h, o.color ?? 0x6a2cdc).setStrokeStyle(3, 0x3b2a3f);
  const txt = scene.add.text(0, 0, label, { fontSize: `${o.fontSize ?? 20}px`, color: '#fff', align: 'center', wordWrap: { width: w - 12 } }).setOrigin(0.5);
  const c = scene.add.container(x, y, [bg, txt]);
  c.setAlpha(o.disabled ? 0.45 : 1);
  if (!o.disabled) { bg.setInteractive({ useHandCursor: true }); bg.on('pointerdown', onTap); }
  return c;
}

export const title = (scene: Phaser.Scene, text: string, y = 40) =>
  scene.add.text(W / 2, y, text, { fontSize: '32px', color: '#fff', stroke: '#3b2a3f', strokeThickness: 6 }).setOrigin(0.5);

const iconKey = (name: string) => `ui_${name}`;
export const hasIcon = (scene: Phaser.Scene, name: string) => scene.textures.exists(iconKey(name));

/** Imagen de icono (si ya existe el arte) o texto con emoji como respaldo. */
export function iconOrText(scene: Phaser.Scene, name: string, x: number, y: number, size: number, fallback: string) {
  return hasIcon(scene, name)
    ? scene.add.image(x, y, iconKey(name)).setDisplaySize(size, size)
    : scene.add.text(x, y, fallback, { fontSize: `${Math.round(size * 0.8)}px` }).setOrigin(0.5);
}

/** Barra de monedas y gemas arriba a la derecha, con iconos si existen. */
export function coinsText(scene: Phaser.Scene, _legacy?: string, y = 84) {
  const style = { fontSize: '22px', color: '#ffe066', stroke: '#3b2a3f', strokeThickness: 4 };
  let x = W - 20;
  for (const [name, fallback, value] of [['gem', '💎', game.save.gems], ['coin', '🪙', game.save.coins]] as const) {
    const label = scene.add.text(x, y, String(value), style).setOrigin(1, 0.5);
    x -= label.width + 18;
    iconOrText(scene, name, x, y, 28, fallback);
    x -= 26;
  }
}

/** Estrellas de un nivel (0-3) centradas en x. */
export function starRow(scene: Phaser.Scene, x: number, y: number, stars: number, size = 36) {
  for (let k = 0; k < 3; k++) {
    const on = k < stars, name = on ? 'star_full' : 'star_empty';
    if (hasIcon(scene, name)) scene.add.image(x + (k - 1) * (size + 6), y, iconKey(name)).setDisplaySize(size, size);
    else scene.add.text(x + (k - 1) * (size + 6), y, '★', { fontSize: `${size}px`, color: on ? '#ffe066' : '#5b6b80', stroke: '#3b2a3f', strokeThickness: 4 }).setOrigin(0.5);
  }
}
