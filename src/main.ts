import Phaser from 'phaser';
import { BattleScene } from './scenes/BattleScene';
import { PreloadScene } from './scenes/PreloadScene';
import { MenuScene } from './scenes/MenuScene';
import { EraMapScene } from './scenes/EraMapScene';
import { UpgradesScene } from './scenes/UpgradesScene';
import { initGame } from './services/save';
import { getLang } from './i18n';

initGame(getLang());

new Phaser.Game({
  type: Phaser.AUTO,
  parent: 'game',
  backgroundColor: '#1b1230',
  scale: { mode: Phaser.Scale.FIT, autoCenter: Phaser.Scale.CENTER_BOTH, width: 960, height: 540 },
  scene: [PreloadScene, MenuScene, EraMapScene, UpgradesScene, BattleScene],
});
