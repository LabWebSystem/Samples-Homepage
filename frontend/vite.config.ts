import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  // プレビューサーバーの設定
  preview: {
    allowedHosts: ["homepage.samples.fukaya-sus.lab"],
  },
  // 開発（dev）サーバーでも同様のエラーが出る場合は、以下のコメントアウトを解除して設定してください
  // server: {
  //   allowedHosts: ["homepage.samples.fukaya-sus.lab"],
  // },
});