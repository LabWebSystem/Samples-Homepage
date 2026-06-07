import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  // プレビューサーバーの設定
  preview: {
    // 全てのホストを許可（原因切り分けのため）
    allowedHosts: true,
  },
  // 開発（dev）サーバーの設定
  server: {
    // 全てのホストを許可（原因切り分けのため）
    allowedHosts: true,
  },
});