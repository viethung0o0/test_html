#!/bin/bash
set -euo pipefail

TARGET_DIR="/var/www/maintenance"
REPO_RAW_BASE="https://raw.githubusercontent.com/viethung0o0/test_html/main"

echo "[INFO] Starting maintenance HTML update at $(date)"

if ! command -v curl >/dev/null 2>&1; then
    echo "[ERROR] curl not found, installing..."
    apt-get update -y && apt-get install -y curl
fi

mkdir -p "$TARGET_DIR"

find "$TARGET_DIR" -type f -name "*.html" -delete || true

echo "[INFO] Downloading index.html ..."
curl -fsSL "$REPO_RAW_BASE/index.html" -o "$TARGET_DIR/index.html"

# curl -fsSL "$REPO_RAW_BASE/style.css" -o "$TARGET_DIR/style.css"
# curl -fsSL "$REPO_RAW_BASE/script.js" -o "$TARGET_DIR/script.js"
# curl -fsSL "$REPO_RAW_BASE/logo.png" -o "$TARGET_DIR/logo.png"

if [ ! -f "$TARGET_DIR/index.html" ]; then
    echo "[ERROR] Download failed — index.html not found!"
    exit 1
else
    echo "[INFO] index.html updated successfully."
fi

if command -v systemctl >/dev/null 2>&1; then
    echo "[INFO] Restarting nginx..."
    systemctl restart nginx
else
    echo "[INFO] Restarting nginx (fallback)..."
    service nginx restart || nginx -s reload
fi

echo "[SUCCESS] Maintenance page updated and nginx restarted at $(date)"
exit 0
