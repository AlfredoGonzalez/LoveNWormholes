import Phaser from 'phaser';
import { game } from './services/save';
import { UPGRADES, chestRemainingMs, formatAmount, levelLabel, nextLevel, upgradeCost } from './game/economy';
import { eraById } from './game/data';
import { t, type Key } from './i18n';
import { H, W, button, hasTex } from './ui';

/** Estructura común de las pantallas del hub: barra superior (saldos + título del nivel) y barra inferior de 5 pestañas. */
export type Tab = 'map' | 'memories' | 'battle' | 'upgrades' | 'shop';

export const TOP_H = 84;
export const NAV_H = 120;
export const CONTENT_TOP = 160;
export const CONTENT_BOTTOM = H - NAV_H - 10;

const TABS: { id: Tab; scene: string; label: Key; icon: string; emoji: string }[] = [
  { id: 'map', scene: 'EraMap', label: 'nav_map', icon: 'nav_map', emoji: '🗺️' },
  { id: 'memories', scene: 'Memories', label: 'nav_memories', icon: 'nav_memories', emoji: '💞' },
  { id: 'battle', scene: 'Home', label: 'nav_battle', icon: 'nav_battle', emoji: '⚔️' },
  { id: 'upgrades', scene: 'Upgrades', label: 'nav_upgrades', icon: 'nav_upgrades', emoji: '🃏' },
  { id: 'shop', scene: 'Shop', label: 'nav_shop', icon: 'nav_shop', emoji: '🛒' },
];

/** ¿Hay algo nuevo en la pestaña? (punto rojo) */
export function tabHasAlert(tab: Tab): boolean {
  if (tab === 'shop') return chestRemainingMs(game.save) === 0;
  if (tab === 'upgrades') return UPGRADES.some(u => (game.save.upgrades[u.id] ?? 0) < u.max && game.save.coins >= upgradeCost(u, game.save.upgrades[u.id] ?? 0));
  return false;
}

function pill(scene: Phaser.Scene, x: number, y: number, w: number, iconKey: string, fallback: string, value: number) {
  if (hasTex(scene, 'ui_pill')) scene.add.image(x, y, 'ui_pill').setDisplaySize(w, 40).setDepth(51);
  else scene.add.rectangle(x, y, w, 40, 0x5a5a66).setStrokeStyle(3, 0x2e2024).setDepth(51);
  const ix = x - w / 2 + 22;
  if (hasTex(scene, iconKey)) scene.add.image(ix, y, iconKey).setDisplaySize(32, 32).setDepth(52);
  else scene.add.text(ix, y, fallback, { fontSize: '24px' }).setOrigin(0.5).setDepth(52);
  scene.add.text(x + 14, y, formatAmount(value), { fontSize: '20px', fontStyle: 'bold', color: '#fff', stroke: '#2e2024', strokeThickness: 4 }).setOrigin(0.5).setDepth(52);
}

export function addShell(scene: Phaser.Scene, active: Tab) {
  scene.cameras.main.setBackgroundColor(0xf3ead2); // papel crema (si falta el fondo de la era)

  // ---- barra superior ----
  if (hasTex(scene, 'ui_topbar')) scene.add.image(W / 2, TOP_H / 2, 'ui_topbar').setDisplaySize(W, TOP_H).setDepth(50);
  else scene.add.rectangle(W / 2, TOP_H / 2, W, TOP_H, 0x3b3b44).setDepth(50);
  const lvl = nextLevel(game.save);
  scene.add.text(W / 2, TOP_H / 2, `${t(eraById(lvl.eraId).nameKey).toUpperCase()} ${levelLabel(lvl)}`, {
    fontSize: '18px', fontStyle: 'bold', color: '#fff3d6', stroke: '#2e2024', strokeThickness: 5, align: 'center', wordWrap: { width: 180 },
  }).setOrigin(0.5).setDepth(52);
  pill(scene, 90, TOP_H / 2, 150, 'ui_gem', '💎', game.save.gems);
  pill(scene, W - 90, TOP_H / 2, 150, 'ui_coin', '🪙', game.save.coins);

  // ---- ajustes (engrane) ----
  const gear = button(scene, 44, TOP_H + 38, 56, 56, hasTex(scene, 'ui_icon_gear') ? '' : '⚙', () => scene.scene.start('Settings'), { color: 0x6b6b74, fontSize: 28 });
  if (hasTex(scene, 'ui_icon_gear')) gear.add(scene.add.image(0, 0, 'ui_icon_gear').setDisplaySize(40, 40));
  gear.setDepth(40);

  // ---- barra inferior ----
  const y0 = H - NAV_H;
  if (hasTex(scene, 'ui_navbar')) scene.add.image(W / 2, y0 + NAV_H / 2, 'ui_navbar').setDisplaySize(W, NAV_H).setDepth(50);
  else scene.add.rectangle(W / 2, y0 + NAV_H / 2, W, NAV_H, 0x8a8a93).setStrokeStyle(4, 0x2e2024).setDepth(50);

  TABS.forEach((tab, i) => {
    const x = 54 + i * 108;
    const center = tab.id === 'battle';
    const size = center ? 104 : 88;
    const y = y0 + NAV_H / 2 + (center ? -12 : 0);
    const isActive = tab.id === active;
    const tileKey = center ? 'ui_nav_tile_active' : 'ui_nav_tile';
    let tile: Phaser.GameObjects.Image | Phaser.GameObjects.Rectangle;
    if (hasTex(scene, tileKey)) tile = scene.add.image(x, y, tileKey).setDisplaySize(size, size);
    else tile = scene.add.rectangle(x, y, size, size, center ? 0xa86a2b : 0x9c9ca6).setStrokeStyle(4, isActive ? 0xffd23f : 0x2e2024);
    tile.setDepth(51).setAlpha(isActive || center ? 1 : 0.85).setInteractive({ useHandCursor: true });
    tile.on('pointerdown', () => { if (!isActive) scene.scene.start(tab.scene); });
    if (hasTex(scene, `ui_${tab.icon}`)) scene.add.image(x, y - 6, `ui_${tab.icon}`).setDisplaySize(size * 0.62, size * 0.62).setDepth(52);
    else scene.add.text(x, y - 8, tab.emoji, { fontSize: `${Math.round(size * 0.42)}px` }).setOrigin(0.5).setDepth(52);
    scene.add.text(x, y + size / 2 - 14, t(tab.label), { fontSize: '13px', fontStyle: 'bold', color: '#fff', stroke: '#2e2024', strokeThickness: 4 }).setOrigin(0.5).setDepth(53);
    if (tabHasAlert(tab.id) && !isActive) scene.add.circle(x + size / 2 - 8, y - size / 2 + 8, 9, 0xe53935).setStrokeStyle(2, 0xffffff).setDepth(54);
  });
}
