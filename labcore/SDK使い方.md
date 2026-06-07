# Samples-Homepage 向け SDK 使い方

このリポジトリは `LabWebSystem-Core` の SDK 仕様に合わせて調整されています。

## 1. この repo からそのまま SDK を実行
初回は SDK 本体を `.labcore/sdk/LabWebSystem-Core` へ自動取得してから実行します。  
固定している参照先は `dev/2026-06-07` / commit `fd46d475041e5c452b161260c385adff94d5aade` です。

```bash
yarn labcore:lint
yarn labcore:preflight
yarn labcore:guard
yarn labcore:export
```

## 2. 手動で SDK を参照したい場合
```bash
git clone --depth 1 --branch dev/2026-06-07 https://github.com/LabWebSystem/LabWebSystem-Core.git
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
- localhost の LabWebSystem-Core では `LAB_CORE_ROOT_DOMAIN=lab.localhost` を前提にしています。
- 研究室ドメインや独自ドメインへ配備する場合は、登録時またはアプリ詳細画面で `hostname` を変更してください。
- 例:
  - `homepage.lab.localhost`
  - `homepage.fukaya-sus.lab`
  - `homepage.example.com`

## 6. localhost と配備 compose の違い
- `docker-compose.yml`
  - LabWebSystem 配備向け
  - `ports:` を持たず、`web:4173` と `api:8787` を内部公開します
  - `APPDATA_ROOT=../../appdata/homepage-sample` を前提にします
  - `prod` profile では `LABCORE_DEVICE_MODE=real` を明示し、`guard prod` を通します
- `docker-compose.dev.yml`
  - 単体開発向け
  - `localhost:5180` と `localhost:8787` を追加公開します
  - `dev-sim` / `dev-real-device` profile では `APPDATA_ROOT=./.appdata/homepage-sample` を使います
  - `dev-sim` は `LABCORE_DEVICE_MODE=mock`、`dev-real-device` は `LABCORE_DEVICE_MODE=real` を使います
