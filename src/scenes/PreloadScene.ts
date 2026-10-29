import Phaser from 'phaser';
import { ERAS } from '../game/data';
import { W, H } from '../ui';
import { game } from '../services/save';

const base = import.meta.env.BASE_URL;

export const ANIMS = ['idle', 'walk', 'attack', 'die'] as const;
export type AnimName = (typeof ANIMS)[number];
export const FRAME = 256; // cada cuadro de una hoja mide 256×256 (ver art-prompts/README.md)

export const heroId = (eraId: string) => `gusanito_${eraId}`;
export const sheetKey = (id: string, anim: AnimName) => `char_${id}_${anim}`;
export const baseKey = (eraId: string, side: 'home' | 'enemy') => `base_${eraId}_${side}`;
export const bgKey = (eraId: string) => `bg_${eraId}`;
export const UI_ICONS = [
  'coin', 'gem', 'star_full', 'star_empty', 'logo', 'shop_gems_s', 'shop_gems_m', 'shop_gems_l', 'shop_starter', 'shop_double_coins',
  // Hito 6a: título, hub y navegación
  'title_bg', 'title_hero', 'btn_wood', 'btn_stone', 'topbar', 'pill', 'btn_round', 'icon_gear', 'navbar', 'nav_tile', 'nav_tile_active',
  'nav_map', 'nav_memories', 'nav_battle', 'nav_upgrades', 'nav_shop', 'bone_coin',
] as const;
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

    // 1) Lista de archivos que existen (la genera Vite al compilar). 2) Solo se piden esos.
    this.load.json('manifest', 'manifest.json');
    this.load.once('filecomplete-json-manifest', () => this.queueArt(new Set<string>(this.cache.json.get('manifest') ?? [])));
    this.load.on('loaderror', (f: Phaser.Loader.File) => { if (f.key === 'manifest') this.queueArt(null); }); // sin lista: se pide todo
  }

  private queued = false;
  /** `files` = rutas existentes (o null = intentar todas). */
  private queueArt(files: Set<string> | null) {
    if (this.queued) return;
    this.queued = true;
    const has = (path: string) => files === null || files.has(path);

    const ids = ['ghost', ...ERAS.flatMap(e => [heroId(e.id), ...e.units.map(u => u.id), ...e.enemies.map(u => u.id)])];
    for (const id of ids)
      for (const a of ANIMS) {
        const path = `characters/${id}_${a}.png`;
        if (has(path)) this.load.spritesheet(sheetKey(id, a), path, { frameWidth: FRAME, frameHeight: FRAME });
      }
    const image = (key: string, path: string) => { if (has(path)) this.load.image(key, path); };
    for (const e of ERAS) {
      image(bgKey(e.id), `backgrounds/bg_${e.id}.png`);
      image(baseKey(e.id, 'home'), `bases/base_${e.id}_home.png`);
      image(baseKey(e.id, 'enemy'), `bases/base_${e.id}_enemy.png`);
      image(`hub_bg_${e.id}`, `backgrounds/hub_bg_${e.id}.png`);
      image(uiKey(`map_boss_${e.id}`), `ui/map_boss_${e.id}.png`);
    }
    for (const n of UI_ICONS) image(uiKey(n), `ui/${n}.png`);
    image('intro_bg', 'story/intro_bg.png');
    for (const n of ['01', '02', '03']) image(`story_${n}`, `story/story_${n}.png`);
    if (this.load.totalToLoad > 0 && !this.load.isLoading()) this.load.start();
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
    this.scene.start(game.save.introSeen ? 'Title' : 'Intro');
  }
}
