# homepage sample (Vite + Hono + PostgreSQL)

LabWebSystem / Lab-Core SDK 向けに調整したホームページ用サンプルです。  
フロントエンド (`web`)・API (`api`)・DB (`db`) の 3 コンテナで、タイマー付き TODO を扱います。

## LabWebSystem 互換の前提
- 配備用の `docker-compose.yml` は **ホストポートを公開しません**。
- 公開対象は `web` サービスの `4173` のみです。
- フロントエンドは `localhost` 固定ではなく same-origin の `/api/*` を使います。
- `web` コンテナ上の Vite preview が `/api` と `/health` を `api` サービスへ中継します。
- `VITE_API_BASE_URL` の既定値は `/` で、フロント内部では same-origin 用に空文字として扱います。
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

### 2. `localhost` で単体確認する場合
```bash
docker compose -f docker-compose.yml -f docker-compose.local.yml up -d --build
```

- Web: `http://localhost:5180`
- API: `http://localhost:8787`

補足:
- `docker-compose.local.yml` は localhost 用のポート公開だけを追加します。
- ブラウザからは常に `web` 側 (`http://localhost:5180`) を開いてください。API 呼び出しは `/api` 経由で中継されます。

## 永続データ
- DB データは `${APPDATA_ROOT:-./.appdata/postgres}` に保存されます。
- LabWebSystem の標準 runtime 構成では `APPDATA_ROOT=../../appdata/homepage-sample` を想定しています。

## SDK チェック
参照 SDK リポジトリを取得済みなら、次で適合性を確認できます。

```bash
node /path/to/LabWebSystem-Core/sdk/packages/sdk-cli/bin/labcore.js lint --profile dev-sim
node /path/to/LabWebSystem-Core/sdk/packages/sdk-cli/bin/labcore.js export --profile prod
```

このリポジトリ用の運用メモは `labcore/SDK使い方.md` にまとめています。

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
