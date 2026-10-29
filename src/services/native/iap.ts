import { PRODUCT_CATEGORY, Purchases } from '@revenuecat/purchases-capacitor';
import { PRODUCTS } from '../../game/economy';
import type { IAP } from '../types';

const ids = PRODUCTS.map(p => p.id);

/** Compras reales vía RevenueCat. `apiKey` = clave pública del SDK (appl_… / goog_…). */
export async function createNativeIap(apiKey: string): Promise<IAP & { prices(): Promise<Record<string, string>> }> {
  await Purchases.configure({ apiKey });

  return {
    async purchase(productId) {
      try {
        const { products } = await Purchases.getProducts({ productIdentifiers: [productId], type: PRODUCT_CATEGORY.NON_SUBSCRIPTION });
        if (!products.length) return 'failed';
        await Purchases.purchaseStoreProduct({ product: products[0] });
        return 'purchased';
      } catch (e) {
        return (e as { userCancelled?: boolean | null })?.userCancelled ? 'cancelled' : 'failed';
      }
    },
    async restore() {
      try {
        const { customerInfo } = await Purchases.restorePurchases();
        return customerInfo.allPurchasedProductIdentifiers;
      } catch { return []; }
    },
    /** Precios localizados de la tienda (para mostrarlos en la tienda del juego). */
    async prices() {
      try {
        const { products } = await Purchases.getProducts({ productIdentifiers: ids, type: PRODUCT_CATEGORY.NON_SUBSCRIPTION });
        return Object.fromEntries(products.map(p => [p.identifier, p.priceString]));
      } catch { return {}; }
    },
  };
}
