import Phaser from 'phaser';

export const W = 960, H = 540;

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
  scene.add.text(W / 2, y, text, { fontSize: '34px', color: '#fff', stroke: '#3b2a3f', strokeThickness: 6 }).setOrigin(0.5);

export const coinsText = (scene: Phaser.Scene, text: string) =>
  scene.add.text(W - 20, 16, text, { fontSize: '20px', color: '#ffe066', stroke: '#3b2a3f', strokeThickness: 4 }).setOrigin(1, 0);
