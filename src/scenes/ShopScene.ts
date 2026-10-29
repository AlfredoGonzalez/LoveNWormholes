import Phaser from 'phaser';
import { game, persist } from '../services/save';
import { services } from '../services';
import { EXCHANGE, PRODUCTS, applyPurchase, chestRemainingMs, exchangeGems, openChest, restoreOwned } from '../game/economy';
import { t, tf } from '../i18n';
import { W, button, title } from '../ui';

export class ShopScene extends Phaser.Scene {
  private busy = false;
  private toast?: Phaser.GameObjects.Text;
  private lastMsg?: string;
  private pending?: string;

  constructor() { super('Shop'); }

  create() {
    this.busy = false;
    this.toast = undefined;
    this.cameras.main.setBackgroundColor(0x3a2268);
    title(this, t('shop'), 36);
    this.add.text(W - 20, 16, `🪙 ${game.save.coins}   💎 ${game.save.gems}`, { fontSize: '20px', color: '#ffe066', stroke: '#3b2a3f', strokeThickness: 4 }).setOrigin(1, 0);

    // Cofre gratis (anuncio opcional con enfriamiento)
    const left = chestRemainingMs(game.save);
    const mins = Math.ceil(left / 60000);
    button(this, 230, 110, 400, 52, left > 0 ? tf('chest_cooldown', { h: Math.floor(mins / 60), m: mins % 60 }) : t('free_chest'),
      () => this.guard(async () => {
        if (!(await services.ads.showRewarded('free_chest'))) return;
        const r = openChest(game.save);
        if (r) { persist(); services.analytics.track('ad_rewarded', { placement: 'free_chest' }); this.say(tf('chest_got', { c: r.coins, g: r.gems })); }
      }), { color: 0x2ea043, disabled: left > 0 });

    // Productos IAP
    PRODUCTS.forEach((p, i) => {
      const y = 180 + i * 56;
      const owned = p.nonConsumable && game.save.owned.includes(p.id);
      this.add.text(40, y, t(p.titleKey), { fontSize: '20px', color: '#fff' }).setOrigin(0, 0.5);
      button(this, W - 130, y, 180, 44, owned ? t('owned') : p.priceLabel, () => this.guard(async () => {
        const r = await services.iap.purchase(p.id);
        if (r === 'purchased' && applyPurchase(game.save, p.id)) {
          persist(); services.analytics.track('purchase', { product: p.id }); this.say(t('purchase_ok'));
        } else if (r === 'failed') this.say(t('purchase_failed'));
      }), { color: 0x6a2cdc, disabled: owned, fontSize: 18 });
    });

    // Cambio de gemas por monedas
    button(this, 230, 180 + PRODUCTS.length * 56 + 6, 400, 44, tf('exchange', { g: EXCHANGE.gems, c: EXCHANGE.coins }),
      () => { if (exchangeGems(game.save)) { persist(); this.scene.restart(); } else this.say(t('not_enough_gems')); },
      { color: 0x2a7fb8, fontSize: 18 });

    if (this.pending) this.say(this.pending);
    button(this, 100, 505, 160, 40, t('back'), () => this.scene.start('Menu'), { color: 0x555577, fontSize: 18 });
    button(this, W - 150, 505, 260, 40, t('restore'), () => this.guard(async () => {
      restoreOwned(game.save, await services.iap.restore()); persist(); this.say(t('restored'));
    }), { color: 0x555577, fontSize: 16 });
  }

  private async guard(fn: () => Promise<void>) {
    if (this.busy) return;
    this.busy = true;
    try { await fn(); } finally { this.busy = false; }
    if (this.scene.isActive('Shop')) this.scene.restart({ toast: this.lastMsg });
  }

  private say(msg: string) {
    this.lastMsg = msg;
    this.toast?.destroy();
    this.toast = this.add.text(W / 2, 470, msg, { fontSize: '20px', color: '#fff', backgroundColor: '#000000cc', padding: { x: 12, y: 6 } }).setOrigin(0.5).setDepth(30);
  }

  init(data: { toast?: string }) { this.pending = data?.toast; this.lastMsg = undefined; }
}
