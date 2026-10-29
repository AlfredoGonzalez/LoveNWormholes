import { Capacitor } from '@capacitor/core';
import { createMockServices } from '../mock';
import type { Services } from '../types';
import { REVENUECAT_KEY } from './config';
import { nativeAds, nativeConsent } from './ads';
import { createNativeIap } from './iap';

/** Servicios reales para Android/iOS. Si falta la clave de RevenueCat, las compras siguen simuladas. */
export async function createNativeServices(): Promise<Services> {
  const mock = createMockServices();
  const key = REVENUECAT_KEY[Capacitor.getPlatform() === 'ios' ? 'ios' : 'android'];
  let iap: Services['iap'] = mock.iap;
  if (key) {
    try { iap = await createNativeIap(key); } catch (e) { console.warn('[iap] RevenueCat no disponible, uso compras simuladas', e); }
  } else {
    console.warn('[iap] sin VITE_RC_KEY_*: compras simuladas');
  }
  return { ads: nativeAds, iap, consent: nativeConsent, analytics: mock.analytics };
}
