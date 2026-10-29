import type { ConsentState } from '../types';

/** Traduce el resultado de UMP (+ ATT en iOS) al estado de consentimiento del juego. */
export function toConsentState(canRequestAds: boolean, trackingAuthorized: boolean): ConsentState {
  return canRequestAds && trackingAuthorized ? 'personalized' : 'limited';
}
