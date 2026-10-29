import { createMockServices } from './mock';
import type { Services } from './types';

/** Servicios activos. Hoy: simulados. En el Hito 5 se reemplazan en plataformas nativas con setServices(). */
export let services: Services = createMockServices();
export const setServices = (s: Services) => { services = s; };
