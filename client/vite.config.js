import { defineConfig } from 'vite';
import importMetaUrlPlugin from '@codingame/esbuild-import-meta-url-plugin';

export default defineConfig({
  worker: {
    format: 'es'
  },
  build: {
    outDir: '../monaco',
    emptyOutDir: true,
    rollupOptions: {
      input: 'src/index.html'
    }
  },
  optimizeDeps: {
    esbuildOptions: {
      plugins: [importMetaUrlPlugin]
    }
  },
  plugins: [
    {
      // strip CSP meta tags from generated HTML
      name: 'strip-csp',
      transformIndexHtml(html) {
        return html.replace(/<meta http-equiv="Content-Security-Policy"[^>]*>/gi, '');
      }
    }
  ]
});