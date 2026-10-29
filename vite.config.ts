import { defineConfig } from 'vite';

// Rutas relativas: sirven igual en GitHub Pages (/<repo>/), en local y dentro de la app nativa (Capacitor).
export default defineConfig({ base: './' });
