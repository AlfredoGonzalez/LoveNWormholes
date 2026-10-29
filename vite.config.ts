import { defineConfig } from 'vite';

// En GitHub Pages el sitio vive en /<repo>/; en local, en /.
export default defineConfig({
  base: process.env.GITHUB_ACTIONS ? '/LoveNWormholes/' : '/',
});
