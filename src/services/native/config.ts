/**
 * IDs de anuncios y claves de compras. Por defecto: IDs de PRUEBA de Google (públicos, no generan ingresos ni sanciones).
 * Para producción define las variables en un archivo `.env.production` (ver docs/RELEASE.md); nunca subas claves secretas al repo.
 * Las claves públicas de RevenueCat (appl_… / goog_…) no son secretas, pero se mantienen fuera del código por orden.
 */
const env = import.meta.env;

export const ADS_TESTING: boolean = env.VITE_ADS_TESTING !== 'false';

export const ADMOB_REWARDED_ID = {
  android: env.VITE_ADMOB_REWARDED_ANDROID ?? 'ca-app-pub-3940256099942544/5224354917', // ID de prueba de Google
  ios: env.VITE_ADMOB_REWARDED_IOS ?? 'ca-app-pub-3940256099942544/1712485313',         // ID de prueba de Google
};

export const REVENUECAT_KEY = {
  android: (env.VITE_RC_KEY_ANDROID as string | undefined) ?? '',
  ios: (env.VITE_RC_KEY_IOS as string | undefined) ?? '',
};
