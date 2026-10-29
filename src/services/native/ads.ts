import { Capacitor } from '@capacitor/core';
import { AdMob, AdmobConsentStatus, RewardAdPluginEvents, type AdmobConsentInfo } from '@capacitor-community/admob';
import type { Ads, Consent, ConsentState } from '../types';
import { ADMOB_REWARDED_ID, ADS_TESTING } from './config';
import { toConsentState } from './consent-map';

const platform = () => (Capacitor.getPlatform() === 'ios' ? 'ios' : 'android');

let canRequestAds = false;
let personalized = false;
let initialized = false;

/** Actualiza el consentimiento (UMP) y, en iOS, pide ATT. Debe ocurrir ANTES de inicializar AdMob. */
async function refreshConsent(showForms: boolean): Promise<{ info: AdmobConsentInfo; state: ConsentState }> {
  let info = await AdMob.requestConsentInfo({ tagForUnderAgeOfConsent: false });
  if (showForms && info.status === AdmobConsentStatus.REQUIRED && info.isConsentFormAvailable) info = await AdMob.showConsentForm();

  let trackingOk = true;
  if (platform() === 'ios') {
    let st = (await AdMob.trackingAuthorizationStatus()).status;
    if (showForms && st === 'notDetermined') { await AdMob.requestTrackingAuthorization(); st = (await AdMob.trackingAuthorizationStatus()).status; }
    trackingOk = st === 'authorized';
  }
  canRequestAds = info.canRequestAds;
  const state = toConsentState(info.canRequestAds, trackingOk);
  personalized = state === 'personalized';
  return { info, state };
}

async function ensureInit() {
  if (initialized) return;
  await refreshConsent(false);
  if (canRequestAds) await AdMob.initialize({ initializeForTesting: ADS_TESTING });
  initialized = canRequestAds;
}

export const nativeConsent: Consent = {
  async request(current) {
    let { info, state } = await refreshConsent(true);
    // Si el usuario ya decidió y la región exige poder cambiarlo, mostramos el formulario de opciones de privacidad.
    if (current !== 'unknown' && String(info.privacyOptionsRequirementStatus) === 'REQUIRED') {
      await AdMob.showPrivacyOptionsForm();
      ({ info, state } = await refreshConsent(false));
    }
    initialized = false; await ensureInit();
    return state;
  },
};

export const nativeAds: Ads = {
  async showRewarded() {
    try {
      await ensureInit();
      if (!canRequestAds) return false;
      const adId = ADMOB_REWARDED_ID[platform()];
      let rewarded = false;
      const handle = await AdMob.addListener(RewardAdPluginEvents.Rewarded, () => { rewarded = true; });
      try {
        await AdMob.prepareRewardVideoAd({ adId, isTesting: ADS_TESTING, npa: !personalized });
        const item = await AdMob.showRewardVideoAd();
        return rewarded || !!item;
      } finally { await handle.remove(); }
    } catch (e) {
      console.warn('[ads] no se pudo mostrar el anuncio', e);
      return false;
    }
  },
};
