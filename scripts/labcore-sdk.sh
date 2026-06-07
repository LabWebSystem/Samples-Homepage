#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SDK_REPO_URL="${LABCORE_SDK_REPO_URL:-https://github.com/LabWebSystem/LabWebSystem-Core.git}"
SDK_BRANCH="${LABCORE_SDK_BRANCH:-dev/2026-06-07}"
SDK_COMMIT="${LABCORE_SDK_COMMIT:-fd46d475041e5c452b161260c385adff94d5aade}"
SDK_DIR="${LABCORE_SDK_DIR:-$ROOT_DIR/.labcore/sdk/LabWebSystem-Core}"
SDK_READY_MARKER="$SDK_DIR/.sdk-ready-commit"

clone_sdk() {
  mkdir -p "$(dirname "$SDK_DIR")"
  git clone --filter=blob:none --branch "$SDK_BRANCH" "$SDK_REPO_URL" "$SDK_DIR"
}

sync_sdk() {
  if [ ! -d "$SDK_DIR/.git" ]; then
    clone_sdk
  fi

  local current_remote
  current_remote="$(git -C "$SDK_DIR" remote get-url origin 2>/dev/null || true)"
  if [ "$current_remote" != "$SDK_REPO_URL" ]; then
    git -C "$SDK_DIR" remote set-url origin "$SDK_REPO_URL"
  fi

  if ! git -C "$SDK_DIR" fetch --depth 1 origin "$SDK_COMMIT" >/dev/null 2>&1; then
    git -C "$SDK_DIR" fetch --depth 1 origin "$SDK_BRANCH" >/dev/null 2>&1
  fi

  git -C "$SDK_DIR" checkout --force "$SDK_COMMIT" >/dev/null 2>&1
}

bootstrap_sdk() {
  local installed_commit=""
  local cli_entrypoint="$SDK_DIR/sdk/packages/sdk-cli/dist/src/main.js"
  if [ -f "$SDK_READY_MARKER" ]; then
    installed_commit="$(cat "$SDK_READY_MARKER")"
  fi

  if [ "$installed_commit" != "$SDK_COMMIT" ] || [ ! -d "$SDK_DIR/node_modules" ] || [ ! -f "$cli_entrypoint" ]; then
    (
      cd "$SDK_DIR"
      corepack yarn install --immutable
    )
    (
      cd "$SDK_DIR/sdk"
      corepack yarn build
    )
    printf '%s\n' "$SDK_COMMIT" > "$SDK_READY_MARKER"
  fi
}

sync_sdk
bootstrap_sdk

exec node "$SDK_DIR/sdk/packages/sdk-cli/bin/labcore.js" "$@"
