import Phaser from 'phaser';
import { BattleScene } from './scenes/BattleScene';
import { PreloadScene } from './scenes/PreloadScene';
import { IntroScene } from './scenes/IntroScene';
import { TitleScene } from './scenes/TitleScene';
import { HomeScene } from './scenes/HomeScene';
import { MemoriesScene } from './scenes/MemoriesScene';
import { SettingsScene } from './scenes/SettingsScene';
import { EraMapScene } from './scenes/EraMapScene';
import { UpgradesScene } from './scenes/UpgradesScene';
import { ShopScene } from './scenes/ShopScene';
import { initGame } from './services/save';
import { getLang } from './i18n';

initGame(getLang());

import { Capacitor } from '@capacitor/core';
import { setServices } from './services';

async function boot() {
  // En Android/iOS se usan los servicios reales (AdMob / RevenueCat); en el navegador, los simulados.
  if (Capacitor.isNativePlatform()) {
    try {
      const { createNativeServices } = await import('./services/native');
      setServices(await createNativeServices());
    } catch (e) { console.warn('[boot] servicios nativos no disponibles, uso simulados', e); }
  }
  new Phaser.Game({
    type: Phaser.AUTO,
    parent: 'game',
    backgroundColor: '#1b1230',
    scale: { mode: Phaser.Scale.FIT, autoCenter: Phaser.Scale.CENTER_BOTH, width: 540, height: 960 },
    scene: [PreloadScene, IntroScene, TitleScene, HomeScene, EraMapScene, MemoriesScene, UpgradesScene, ShopScene, SettingsScene, BattleScene],
  });
}

void boot();
