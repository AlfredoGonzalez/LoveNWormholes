import Phaser from 'phaser';
import { game } from '../services/save';
import { isUnlocked } from '../game/economy';
import { ERAS } from '../game/data';
import { t } from '../i18n';
import { CONTENT_TOP, addShell } from '../shell';
import { W, button, hasTex, starRow } from '../ui';

/** Mapa de niveles de la era: camino punteado en zigzag, nodos con estrellas y el jefe final arriba. */
export class EraMapScene extends Phaser.Scene {
  constructor() { super('EraMap'); }

  create() {
    const era = ERAS[game.eraIdx];
    addShell(this, 'map');
    this.cameras.main.setBackgroundColor(0xe9d9b4); // pergamino

    this.add.text(W / 2, CONTENT_TOP + 24, t(era.nameKey).toUpperCase(), { fontSize: '30px', fontStyle: 'bold', color: '#5a4630' }).setOrigin(0.5);
    if (game.eraIdx > 0) button(this, 60, CONTENT_TOP + 24, 60, 52, '◀', () => { game.eraIdx--; this.scene.restart(); }, { fontSize: 24, color: 0x8a7a5a });
    if (game.eraIdx < ERAS.length - 1) button(this, W - 60, CONTENT_TOP + 24, 60, 52, '▶', () => { game.eraIdx++; this.scene.restart(); }, { fontSize: 24, color: 0x8a7a5a });
    if (!isUnlocked(game.save, era.levels[0])) this.add.text(W / 2, CONTENT_TOP + 62, t('era_locked'), { fontSize: '16px', color: '#7a4630' }).setOrigin(0.5);

    // Posiciones en zigzag: nivel 1 abajo, jefe arriba.
    const pts = era.levels.map((_, i) => ({ x: i % 2 === 0 ? 150 : 390, y: 700 - i * 150 }));
    const boss = { x: W / 2, y: 700 - era.levels.length * 150 + 10 };
    const path = this.add.graphics();
    const chain = [...pts, boss];
    for (let i = 0; i < chain.length - 1; i++) this.dotted(path, chain[i], chain[i + 1]);

    // Jefe final de la era
    const bossKey = `ui_map_boss_${era.id}`;
    if (hasTex(this, bossKey)) this.add.image(boss.x, boss.y, bossKey).setDisplaySize(150, 150);
    else {
      this.add.circle(boss.x, boss.y, 52, 0x8a4a3a).setStrokeStyle(5, 0x2e2024);
      this.add.text(boss.x, boss.y, '👹', { fontSize: '52px' }).setOrigin(0.5);
    }

    era.levels.forEach((lvl, i) => {
      const { x, y } = pts[i];
      const open = isUnlocked(game.save, lvl);
      const stars = game.save.stars[lvl.id] ?? 0;
      const node = this.add.circle(x, y, 50, open ? 0x7a6a4a : 0x9a9a9a).setStrokeStyle(6, 0x2e2024);
      this.add.text(x, y - 2, open ? String(i + 1) : '🔒', { fontSize: open ? '40px' : '34px', fontStyle: 'bold', color: '#fff3d6', stroke: '#2e2024', strokeThickness: 6 }).setOrigin(0.5);
      this.add.text(x, y + 66, t(lvl.nameKey), { fontSize: '15px', fontStyle: 'bold', color: '#5a4630', align: 'center', wordWrap: { width: 170 } }).setOrigin(0.5);
      starRow(this, x, y - 70, stars, 30);
      if (open) {
        node.setInteractive({ useHandCursor: true });
        node.on('pointerdown', () => this.scene.start('Battle', { levelId: lvl.id }));
      }
    });
  }

  private dotted(g: Phaser.GameObjects.Graphics, a: { x: number; y: number }, b: { x: number; y: number }) {
    const n = Math.round(Math.hypot(b.x - a.x, b.y - a.y) / 22);
    g.fillStyle(0x7a6a4a);
    for (let k = 1; k < n; k++) g.fillCircle(a.x + ((b.x - a.x) * k) / n, a.y + ((b.y - a.y) * k) / n, 4);
  }
}
