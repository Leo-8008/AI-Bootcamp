#!/usr/bin/env bash
# Configures confluence-cli for confluence.zurich.com.
# Works around the Git Bash path conversion issue (//rest/api -> /rest/api).
#
# Usage:
#   bash scripts/setup-confluence.sh             # interactive
#   CONFLUENCE_API_TOKEN=xxx bash scripts/setup-confluence.sh   # non-interactive

set -euo pipefail

DOMAIN="${CONFLUENCE_DOMAIN:-confluence.zurich.com}"
API_PATH="/rest/api"
AUTH_TYPE="bearer"

# Locate confluence CLI (handle Windows npm-global-bin not in PATH).
if command -v confluence >/dev/null 2>&1; then
  CONFLUENCE_BIN="confluence"
elif [ -n "${APPDATA:-}" ] && [ -x "$APPDATA/npm/confluence.cmd" ]; then
  CONFLUENCE_BIN="$APPDATA/npm/confluence.cmd"
elif [ -x "$HOME/AppData/Roaming/npm/confluence.cmd" ]; then
  CONFLUENCE_BIN="$HOME/AppData/Roaming/npm/confluence.cmd"
else
  echo "❌ confluence-cli not found. Install with: npm install -g confluence-cli" >&2
  exit 1
fi

# Prompt for token if not in env.
if [ -z "${CONFLUENCE_API_TOKEN:-}" ]; then
  echo "Create a Personal Access Token at: https://${DOMAIN}/plugins/personalaccesstokens/usertokens.action"
  read -rsp "Confluence Personal Access Token: " CONFLUENCE_API_TOKEN
  echo
fi

if [ -z "${CONFLUENCE_API_TOKEN}" ]; then
  echo "❌ No token provided." >&2
  exit 1
fi

# Run init with the //rest/api workaround (Git Bash on Windows otherwise rewrites /rest/api into a Windows path).
"$CONFLUENCE_BIN" init \
  --domain "$DOMAIN" \
  --api-path "/${API_PATH}" \
  --auth-type "$AUTH_TYPE" \
  --token "$CONFLUENCE_API_TOKEN" >/dev/null

# Fix the saved api-path back to a single slash.
CONFIG_FILE="$HOME/.confluence-cli/config.json"
if [ -f "$CONFIG_FILE" ]; then
  # Portable in-place sed (BSD + GNU).
  if sed --version >/dev/null 2>&1; then
    sed -i 's|"apiPath": "//rest/api"|"apiPath": "/rest/api"|' "$CONFIG_FILE"
  else
    sed -i '' 's|"apiPath": "//rest/api"|"apiPath": "/rest/api"|' "$CONFIG_FILE"
  fi
fi

echo "✅ confluence-cli configured for ${DOMAIN}"
echo "   Config: ${CONFIG_FILE}"
echo
echo "Verify with:"
echo "   confluence read 78481720 --format markdown"
