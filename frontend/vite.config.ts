import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";

const apiProxyTarget = process.env.VITE_PROXY_TARGET ?? "http://localhost:8787";

export default defineConfig({
  plugins: [react()],
  preview: {
    allowedHosts: true,
    proxy: {
      "/api": {
        target: apiProxyTarget,
        changeOrigin: true
      },
      "/health": {
        target: apiProxyTarget,
        changeOrigin: true
      }
    }
  },
  server: {
    allowedHosts: true,
    proxy: {
      "/api": {
        target: apiProxyTarget,
        changeOrigin: true
      },
      "/health": {
        target: apiProxyTarget,
        changeOrigin: true
      }
    }
  }
});
