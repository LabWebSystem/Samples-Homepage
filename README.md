# homepage sample (Vite + Hono + PostgreSQL)

LabWebSystem / Lab-Core SDK 向けに調整したホームページ用サンプルです。  
フロントエンド (`web`)・API (`api`)・DB (`db`) の 3 コンテナで、タイマー付き TODO を扱います。

## LabWebSystem 互換の前提
- 配備用の `docker-compose.yml` は **ホストポートを公開しません**。
- 公開対象は `web` サービスの `4173` のみです。
- フロントエンドは `localhost` 固定ではなく same-origin の `/api/*` を使います。
- `web` コンテナ上の Vite preview が `/api` と `/health` を `api` サービスへ中継します。
- `VITE_API_BASE_URL` の既定値は `/` で、フロント内部では same-origin 用に空文字として扱います。
- `VITE_PROXY_TARGET` の既定値は `http://api:8787` で、LabWebSystem 配備時も `web` から `api` へ内部中継します。
- `labcore.app.yaml` の `hostname` はローカル開発向けに `homepage.lab.localhost` を既定値にしています。

LabWebSystem 上で独自ドメインまたは研究室ドメインを使う場合:
- 登録時またはアプリ詳細画面で `hostname` を `homepage.<LAB_CORE_ROOT_DOMAIN>` に変更してください。
- 例:
  - localhost 開発: `homepage.lab.localhost`
  - 研究室運用: `homepage.fukaya-sus.lab`
  - 独自ドメイン運用: `homepage.example.com`

## 構成
- `web`: Vite + React
- `api`: Hono + PostgreSQL
- `db`: PostgreSQL 16

## 起動方法
### 1. LabWebSystem / Lab-Core へ配備する場合
```bash
docker compose -f docker-compose.yml up -d --build
```

この compose は LabWebSystem が内部ネットワーク越しに `web:4173` へルーティングする前提です。  
`APPDATA_ROOT` を省略した場合は、LabWebSystem-Core の標準 clone 配置に合わせて `../../appdata/homepage-sample` を使います。

### 2. `localhost` で単体確認する場合
```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
```

- Web: `http://localhost:5180`
- API: `http://localhost:8787`

補足:
- `docker-compose.dev.yml` は localhost 用のポート公開だけを追加します。
- ブラウザからは常に `web` 側 (`http://localhost:5180`) を開いてください。API 呼び出しは `/api` 経由で中継されます。
- SDK の `dev-sim` / `dev-real-device` profile も `docker-compose.dev.yml` を使い、`APPDATA_ROOT=./.appdata/homepage-sample` を上書きします。

## 永続データ
- LabWebSystem / Lab-Core 配備時:
  - `APPDATA_ROOT=../../appdata/homepage-sample`
- localhost 開発時:
  - `APPDATA_ROOT=./.appdata/homepage-sample`
- PostgreSQL の実データは `APPDATA_ROOT` で指定したディレクトリに保存されます。

## SDK チェック
このリポジトリには `yarn labcore:*` スクリプトを追加してあり、初回実行時に `LabWebSystem-Core` の SDK (`dev/2026-06-07`, commit `fd46d475041e5c452b161260c385adff94d5aade`) を `.labcore/sdk/` に自動取得します。

```bash
yarn labcore:lint
yarn labcore:preflight
yarn labcore:guard
yarn labcore:export
```

このリポジトリ用の運用メモは `labcore/SDK使い方.md` にまとめています。

## LabWebSystem-Core 側で揃える値
- localhost 開発:
  - `LAB_CORE_ROOT_DOMAIN=lab.localhost`
  - `hostname=homepage.lab.localhost`
- 研究室運用:
  - `LAB_CORE_ROOT_DOMAIN=<研究室ドメイン>`
  - `hostname=homepage.<LAB_CORE_ROOT_DOMAIN>`
- 独自ドメイン運用:
  - `hostname=homepage.example.com` のように Core 側の登録値を直接変更
- Core 側の `LAB_CORE_APPS_ROOT` / `LAB_CORE_APPDATA_ROOT` を標準構成で使う場合、この repo の `prod` profile は `../../appdata/homepage-sample` を前提にしています。

## CORS 設定
- 既定値は `CORS_ORIGIN=*` です。
- このサンプルは `web` から same-origin の `/api` を叩くため、LabWebSystem 配備時は CORS に依存しません。
- 追加で外部フロントエンドから直接 API を叩く場合だけ、必要な Origin に絞って上書きしてください。

## 主な API
- `GET /api/tasks` 現在タスク
- `GET /api/tasks/history` 過去タスク
- `POST /api/tasks` タスク作成
- `PATCH /api/tasks/:id` 進捗/状態更新
- `DELETE /api/tasks/:id` タスク削除
- `POST /api/tasks/:id/timer` タイマー設定
- `POST /api/tasks/:id/timer/pause` タイマー中断
- `POST /api/tasks/:id/timer/resume` タイマー再開
- `DELETE /api/tasks/:id/timer` タイマー削除
- `POST /api/tasks/:id/evaluation` 評価投稿
