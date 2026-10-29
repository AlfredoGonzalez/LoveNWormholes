import { defineConfig, type Plugin } from 'vite';
import { existsSync, readdirSync, statSync } from 'node:fs';
import path from 'node:path';

/** Lista (assets/manifest.json) de los archivos de arte que existen, para que el juego solo pida esos. */
function assetManifest(): Plugin {
  const root = path.resolve(import.meta.dirname, 'public/assets');
  const walk = (dir: string): string[] =>
    !existsSync(dir) ? [] : readdirSync(dir).flatMap(f => {
      const p = path.join(dir, f);
      return statSync(p).isDirectory() ? walk(p) : [path.relative(root, p).split(path.sep).join('/')];
    });
  const list = () => JSON.stringify(walk(root).filter(f => f !== 'manifest.json'));
  return {
    name: 'asset-manifest',
    configureServer(server) {
      server.middlewares.use('/assets/manifest.json', (_req, res) => { res.setHeader('content-type', 'application/json'); res.end(list()); });
    },
    generateBundle() { this.emitFile({ type: 'asset', fileName: 'assets/manifest.json', source: list() }); },
  };
}

// Rutas relativas: sirven igual en GitHub Pages (/<repo>/), en local y dentro de la app nativa (Capacitor).
export default defineConfig({ base: './', plugins: [assetManifest()] });
