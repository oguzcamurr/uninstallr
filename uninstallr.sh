#!/usr/bin/env bash
# uninstallr.sh – AppRemove Pro

# Darwin guard (Linux vs)
if [ "$(uname -s)" != "Darwin" ]; then
  echo "Skipping: uninstallr requires macOS (Darwin)."
  exit 0
fi
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./uninstallr.sh [--dry-run] [--force] <App Name>

Options:
  --dry-run   Just simulate steps, don’t delete
  --force     Suppress confirmations
  -h, --help  Show this help
EOF
}

# --- Parse flags ---
DRY_RUN=0
FORCE=0
APP_NAME=""
while (( "$#" )); do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --force)   FORCE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) APP_NAME="$1"; shift ;;
  esac
done
: "${APP_NAME:?Missing <App Name>. Run with -h for usage.}"

echo "=== AppRemove Pro ==="
echo "Target app: $APP_NAME"
echo "Dry-run: $DRY_RUN  Force: $FORCE"

REPORT="$(pwd)/appremove-report-$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')-$(date +%Y%m%d-%H%M%S).txt"
echo "Report: $REPORT"
echo "----" >"$REPORT"

# [1/6] Remove App bundle
echo "[1/6] Removing /Applications bundle (if any)..." | tee -a "$REPORT"
APP_PATH="/Applications/$APP_NAME.app"
if [ -d "$APP_PATH" ]; then
  echo "Found bundle: $APP_PATH" | tee -a "$REPORT"
  if [ "$DRY_RUN" -eq 0 ]; then
    rm -rf "$APP_PATH" | tee -a "$REPORT"
  fi
fi

# [2/6] Remove Application Support
echo "[2/6] Removing Application Support..." | tee -a "$REPORT"
SUPPORT_DIR="$HOME/Library/Application Support/$APP_NAME"
if [ -d "$SUPPORT_DIR" ]; then
  echo "Found support dir: $SUPPORT_DIR" | tee -a "$REPORT"
  if [ "$DRY_RUN" -eq 0 ]; then
    rm -rf "$SUPPORT_DIR" | tee -a "$REPORT"
  fi
fi

# [3/6] Remove Preferences plist
echo "[3/6] Removing Preferences plist..." | tee -a "$REPORT"
APP_ID_LOWER="$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')"
PLIST_FILE="$HOME/Library/Preferences/com.${APP_ID_LOWER}.plist"
if [ -f "$PLIST_FILE" ]; then
  echo "Found plist: $PLIST_FILE" | tee -a "$REPORT"
  if [ "$DRY_RUN" -eq 0 ]; then
    rm -f "$PLIST_FILE" | tee -a "$REPORT"
  fi
fi

# [4/6] Remove Caches
echo "[4/6] Removing Caches..." | tee -a "$REPORT"
CACHE_DIR="$HOME/Library/Caches/$APP_NAME"
if [ -d "$CACHE_DIR" ]; then
  echo "Found cache dir: $CACHE_DIR" | tee -a "$REPORT"
  if [ "$DRY_RUN" -eq 0 ]; then
    rm -rf "$CACHE_DIR" | tee -a "$REPORT"
  fi
fi

# [5/6] Remove pkgutil receipts
echo "[5/6] Removing related receipts (if any)..." | tee -a "$REPORT"
if command -v pkgutil >/dev/null 2>&1; then
  app_pkg_pattern="$(echo "$APP_NAME" | tr ' ' '.')"
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    echo "Found receipt: $f" | tee -a "$REPORT"
    if [ "$DRY_RUN" -eq 0 ]; then
      sudo pkgutil --forget "$f" | tee -a "$REPORT" || true
    fi
  done < <(pkgutil --pkgs | grep -iF "$app_pkg_pattern" || true)
else
  echo "pkgutil not available, skipping receipts step." | tee -a "$REPORT"
fi

# [6/6] Remove user Library leftovers
echo "[6/6] Removing user Library leftovers..." | tee -a "$REPORT"
LOG_DIR="$HOME/Library/Logs/$APP_NAME"
if [ -d "$LOG_DIR" ]; then
  echo "Found logs: $LOG_DIR" | tee -a "$REPORT"
  if [ "$DRY_RUN" -eq 0 ]; then
    rm -rf "$LOG_DIR" | tee -a "$REPORT"
  fi
fi

# Finalize
if [ "$DRY_RUN" -eq 1 ]; then
  echo "Dry-run complete."
  exit 0
fi

echo "Uninstall complete. See report: $REPORT"

