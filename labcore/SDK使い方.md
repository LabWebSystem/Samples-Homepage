# Samples-Homepage 向け SDK 使い方

このリポジトリは `LabWebSystem-Core` の SDK 仕様に合わせて調整されています。

## 1. 参照 SDK を取得
```bash
git clone --depth 1 --branch dev/2026-06-07 https://github.com/LabWebSystem/LabWebSystem-Core.git
```

## 2. SDK 依存をセットアップ
```bash
cd LabWebSystem-Core
corepack yarn install
```

## 3. このリポジトリを lint
```bash
node /path/to/LabWebSystem-Core/sdk/packages/sdk-cli/bin/labcore.js lint --profile dev-sim
```

## 4. export payload を確認
```bash
node /path/to/LabWebSystem-Core/sdk/packages/sdk-cli/bin/labcore.js export --profile prod
```

## 5. hostname の扱い
- `labcore.app.yaml` の既定値は `homepage.lab.localhost` です。
- 研究室ドメインや独自ドメインへ配備する場合は、登録時またはアプリ詳細画面で `hostname` を変更してください。
- 例:
  - `homepage.fukaya-sus.lab`
  - `homepage.example.com`

## 6. localhost と配備 compose の違い
- `docker-compose.yml`
  - LabWebSystem 配備向け
  - `ports:` を持たず、`web:4173` と `api:8787` を内部公開します
- `docker-compose.local.yml`
  - 単体開発向け
  - `localhost:5180` と `localhost:8787` を追加公開します
