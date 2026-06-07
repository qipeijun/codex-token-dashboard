#!/usr/bin/env bash
set -euo pipefail

REPO="hututuo/codex-token-dashboard"
APP_NAME="Codex Token Dashboard.app"
ASSET_NAME="CodexTokenDashboard.app.zip"
DOWNLOAD_URL="https://github.com/${REPO}/releases/latest/download/${ASSET_NAME}"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Codex Token Dashboard is a macOS app. This installer only supports macOS." >&2
  exit 1
fi

TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "Downloading Codex Token Dashboard..."
curl -fL --progress-bar "$DOWNLOAD_URL" -o "$TMP_DIR/$ASSET_NAME"

echo "Unpacking..."
ditto -x -k "$TMP_DIR/$ASSET_NAME" "$TMP_DIR"

APP_PATH="$TMP_DIR/$APP_NAME"
if [[ ! -d "$APP_PATH" ]]; then
  echo "Install failed: $APP_NAME was not found in the downloaded archive." >&2
  exit 1
fi

if [[ -n "${CODEX_TOKEN_DASHBOARD_INSTALL_DIR:-}" ]]; then
  INSTALL_DIR="$CODEX_TOKEN_DASHBOARD_INSTALL_DIR"
  mkdir -p "$INSTALL_DIR"
elif [[ -d "/Applications" && -w "/Applications" ]]; then
  INSTALL_DIR="/Applications"
else
  INSTALL_DIR="$HOME/Applications"
  mkdir -p "$INSTALL_DIR"
fi

TARGET="$INSTALL_DIR/$APP_NAME"

echo "Installing to $TARGET..."
rm -rf "$TARGET"
ditto "$APP_PATH" "$TARGET"

if command -v xattr >/dev/null 2>&1; then
  xattr -dr com.apple.quarantine "$TARGET" 2>/dev/null || true
fi

echo
echo "Installed: $TARGET"
if [[ "${CODEX_TOKEN_DASHBOARD_NO_OPEN:-0}" != "1" ]]; then
  echo "Opening Codex Token Dashboard..."
  open "$TARGET"
fi
echo
echo "Note: this installer removes the common browser-download quarantine flag."
echo "It is still an unsigned app, so strict MDM, security tools, or macOS policy can still block it."
