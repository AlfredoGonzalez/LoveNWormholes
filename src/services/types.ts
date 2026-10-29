/**
 * Contratos de los servicios de plataforma. El juego solo depende de estas interfaces;
 * hoy hay implementaciones simuladas (src/services/mock) y en el Hito 5 se añaden las
 * reales (AdMob / RevenueCat vía Capacitor). Ver docs/MONETIZATION.md.
 */
export type Placement = 'double_reward' | 'revive' | 'energy_boost' | 'free_chest';
export type ConsentState = 'unknown' | 'personalized' | 'limited';
export type PurchaseResult = 'purchased' | 'cancelled' | 'failed';

export interface Ads {
  /** Anuncio recompensado, SIEMPRE iniciado por el jugador. true = ver completo → dar recompensa. */
  showRewarded(placement: Placement): Promise<boolean>;
}

export interface IAP {
  purchase(productId: string): Promise<PurchaseResult>;
  /** Ids de productos no consumibles que el usuario ya posee en la tienda. */
  restore(): Promise<string[]>;
  /** Precios localizados de la tienda por id de producto (opcional; la tienda del juego usa los de referencia si falta). */
  prices?(): Promise<Record<string, string>>;
}

export interface Consent {
  request(current: ConsentState): Promise<ConsentState>;
}

export interface Analytics {
  track(event: string, params?: Record<string, string | number>): void;
}

export interface Services { ads: Ads; iap: IAP; consent: Consent; analytics: Analytics }
