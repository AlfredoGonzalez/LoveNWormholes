import Phaser from 'phaser';
import { game, persist } from '../services/save';
import { services } from '../services';
import { EXCHANGE, PRODUCTS, applyPurchase, chestRemainingMs, exchangeGems, openChest, restoreOwned } from '../game/economy';
import { t, tf } from '../i18n';
import { W, H, button, title } from '../ui';

/** Precios localizados de la tienda real (vacío en el navegador: se usan los de referencia). */
let storePrices: Record<string, string> = {};
let pricesRequested = false;

export class ShopScene extends Phaser.Scene {
  private busy = false;
  private toast?: Phaser.GameObjects.Text;
  private lastMsg?: string;
  private pending?: string;

  constructor() { super('Shop'); }

  create() {
    this.busy = false;
    this.toast = undefined;
    if (!pricesRequested && services.iap.prices) {
      pricesRequested = true;
      services.iap.prices().then(p => { storePrices = p; if (Object.keys(p).length && this.scene.isActive('Shop')) this.scene.restart(); });
    }
    this.cameras.main.setBackgroundColor(0x3a2268);
    title(this, t('shop'), 44);
    this.add.text(W - 20, 84, `🪙 ${game.save.coins}   💎 ${game.save.gems}`, { fontSize: '20px', color: '#ffe066', stroke: '#3b2a3f', strokeThickness: 4 }).setOrigin(1, 0);

    // Cofre gratis (anuncio opcional con enfriamiento)
    const left = chestRemainingMs(game.save);
    const mins = Math.ceil(left / 60000);
    button(this, W / 2, 150, 480, 56, left > 0 ? tf('chest_cooldown', { h: Math.floor(mins / 60), m: mins % 60 }) : t('free_chest'),
      () => this.guard(async () => {
        if (!(await services.ads.showRewarded('free_chest'))) return;
        const r = openChest(game.save);
        if (r) { persist(); services.analytics.track('ad_rewarded', { placement: 'free_chest' }); this.say(tf('chest_got', { c: r.coins, g: r.gems })); }
      }), { color: 0x2ea043, disabled: left > 0 });

    // Productos IAP
    PRODUCTS.forEach((p, i) => {
      const y = 240 + i * 82;
      const owned = p.nonConsumable && game.save.owned.includes(p.id);
      this.add.text(24, y, t(p.titleKey), { fontSize: '19px', color: '#fff', wordWrap: { width: 290 } }).setOrigin(0, 0.5);
      button(this, W - 100, y, 160, 48, owned ? t('owned') : (storePrices[p.id] ?? p.priceLabel), () => this.guard(async () => {
        const r = await services.iap.purchase(p.id);
        if (r === 'purchased' && applyPurchase(game.save, p.id)) {
          persist(); services.analytics.track('purchase', { product: p.id }); this.say(t('purchase_ok'));
        } else if (r === 'failed') this.say(t('purchase_failed'));
      }), { color: 0x6a2cdc, disabled: owned, fontSize: 18 });
    });

    // Cambio de gemas por monedas
    button(this, W / 2, 240 + PRODUCTS.length * 82, 480, 48, tf('exchange', { g: EXCHANGE.gems, c: EXCHANGE.coins }),
      () => { if (exchangeGems(game.save)) { persist(); this.scene.restart(); } else this.say(t('not_enough_gems')); },
      { color: 0x2a7fb8, fontSize: 18 });

    if (this.pending) this.say(this.pending);
    button(this, 90, H - 50, 150, 48, t('back'), () => this.scene.start('Menu'), { color: 0x555577, fontSize: 18 });
    button(this, W - 160, H - 50, 290, 48, t('restore'), () => this.guard(async () => {
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
    this.toast = this.add.text(W / 2, 780, msg, { fontSize: '20px', color: '#fff', backgroundColor: '#000000cc', padding: { x: 12, y: 6 }, wordWrap: { width: 500 }, align: 'center' }).setOrigin(0.5).setDepth(30);
  }

  init(data: { toast?: string }) { this.pending = data?.toast; this.lastMsg = undefined; }
}
