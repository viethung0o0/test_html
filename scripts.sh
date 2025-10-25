#!/bin/bash
set -euo pipefail

TARGET_DIR="/var/www/maintenance"
REPO_RAW_BASE="https://raw.githubusercontent.com/viethung0o0/test_html/main"

echo "[INFO] Starting maintenance HTML update at $(date)"

# Kiểm tra curl
if ! command -v curl >/dev/null 2>&1; then
    echo "[ERROR] curl not found, installing..."
    apt-get update -y && apt-get install -y curl
fi

# Tạo thư mục nếu chưa có
mkdir -p "$TARGET_DIR"

# Xóa file cũ (nếu cần)
find "$TARGET_DIR" -type f -name "*.html" -delete || true

# Kéo các file HTML chính về
echo "[INFO] Downloading index.html ..."
curl -fsSL "$REPO_RAW_BASE/index.html" -o "$TARGET_DIR/index.html"

# Nếu repo có nhiều file CSS/JS hoặc hình ảnh, bạn có thể kéo thêm:
# curl -fsSL "$REPO_RAW_BASE/style.css" -o "$TARGET_DIR/style.css"
# curl -fsSL "$REPO_RAW_BASE/script.js" -o "$TARGET_DIR/script.js"
# curl -fsSL "$REPO_RAW_BASE/logo.png" -o "$TARGET_DIR/logo.png"

# Kiểm tra file
if [ ! -f "$TARGET_DIR/index.html" ]; then
    echo "[ERROR] Download failed — index.html not found!"
    exit 1
else
    echo "[INFO] index.html updated successfully."
fi

# Restart Nginx
if command -v systemctl >/dev/null 2>&1; then
    echo "[INFO] Restarting nginx..."
    systemctl restart nginx
else
    echo "[INFO] Restarting nginx (fallback)..."
    service nginx restart || nginx -s reload
fi

echo "[SUCCESS] Maintenance page updated and nginx restarted at $(date)"
exit 0
