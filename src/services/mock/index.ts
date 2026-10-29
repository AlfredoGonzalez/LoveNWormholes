import { t } from '../../i18n';
import { PRODUCTS } from '../../game/economy';
import type { Ads, Analytics, Consent, ConsentState, IAP, Services } from '../types';
import { modal } from './overlay';

const AD_SECONDS = 3;

const ads: Ads = {
  async showRewarded() {
    const r = await modal(t('ad_sim_title'), t('ad_sim_wait').replace('{s}', String(AD_SECONDS)), [
      { label: t('ad_claim'), value: 'ok', enableAfterMs: AD_SECONDS * 1000, primary: true },
      { label: t('ad_skip'), value: 'skip' },
    ]);
    return r === 'ok';
  },
};

const iap: IAP = {
  async purchase(productId) {
    const p = PRODUCTS.find(x => x.id === productId);
    if (!p) return 'failed';
    const r = await modal(t('iap_sim_title'), `${t(p.titleKey)}\n${p.priceLabel}`, [
      { label: t('buy'), value: 'buy', primary: true },
      { label: t('iap_cancel'), value: 'cancel' },
    ]);
    return r === 'buy' ? 'purchased' : 'cancelled';
  },
  async restore() { return []; }, // sin tienda real no hay nada que restaurar
};

const consent: Consent = {
  async request(): Promise<ConsentState> {
    const r = await modal(t('consent_title'), t('consent_body'), [
      { label: t('consent_accept'), value: 'personalized', primary: true },
      { label: t('consent_decline'), value: 'limited' },
    ]);
    return r === 'personalized' ? 'personalized' : 'limited';
  },
};

const log: { event: string; params?: Record<string, string | number> }[] = [];
const analytics: Analytics = {
  track(event, params) { log.push({ event, params }); if (log.length > 200) log.shift(); },
};
export const analyticsLog = () => log;

export const createMockServices = (): Services => ({ ads, iap, consent, analytics });
