#!/usr/bin/env bash
# uninstallr — Remove apps like they never existed (macOS only)

# Require macOS (Darwin)
if [ "$(uname -s)" != "Darwin" ]; then
  echo "Skipping: uninstallr requires macOS (Darwin)."
  exit 0
fi

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  uninstallr [--dry-run] [--force|-y] <App Name>

Options:
  --dry-run     Only simulate steps, don’t delete
  --force, -y   Skip confirmation prompts
  -h, --help    Show this help

Examples:
  uninstallr --dry-run "Spotify"
  uninstallr -y "Spotify"
EOF
}

# Default flags
DRY_RUN=0
FORCE=0
APP_NAME=""

# Parse flags
while (( "$#" )); do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --force|-y|--yes) FORCE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) APP_NAME="$1"; shift ;;
  esac
done

if [ -z "$APP_NAME" ]; then
  usage
  exit 1
fi

# Report file
REPORT="./appremove-report-$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')-$(date +%Y%m%d-%H%M%S).txt"

# Print summary
echo "=== AppRemove Pro ==="
echo "Target app: $APP_NAME"
echo "Dry-run: $DRY_RUN  Force: $FORCE"
echo "Report: $REPORT"

# Pre-flight confirmation
if [ "$DRY_RUN" -eq 1 ]; then
  echo "Dry-run mode: no changes will be made."
elif [ "$FORCE" -eq 1 ]; then
  echo "Force mode: proceeding without confirmation."
else
  # Only ask if running in interactive terminal
  if [ -t 0 ]; then
    read -r -p "Proceed to remove \"$APP_NAME\"? [y/N] " REPLY </dev/tty
    case "$REPLY" in
      [yY][eE][sS]|[yY]) ;;
      *) echo "Aborted."; exit 0 ;;
    esac
  else
    echo "Non-interactive shell: add --force to proceed without prompt."
    exit 1
  fi
fi

echo "[1/6] Removing /Applications bundle (if any)..." | tee "$REPORT"
if [ "$DRY_RUN" -eq 0 ]; then
  rm -rf "/Applications/$APP_NAME.app" 2>/dev/null || true
fi

echo "[2/6] Removing Application Support..." | tee -a "$REPORT"
if [ "$DRY_RUN" -eq 0 ]; then
  rm -rf "$HOME/Library/Application Support/$APP_NAME" 2>/dev/null || true
fi

echo "[3/6] Removing Preferences..." | tee -a "$REPORT"
if [ "$DRY_RUN" -eq 0 ]; then
  rm -f "$HOME/Library/Preferences/com.$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]').plist" 2>/dev/null || true
fi

echo "[4/6] Removing Caches..." | tee -a "$REPORT"
if [ "$DRY_RUN" -eq 0 ]; then
  rm -rf "$HOME/Library/Caches/$APP_NAME" 2>/dev/null || true
fi

echo "[5/6] Removing related receipts (if any)..." | tee -a "$REPORT"
if command -v pkgutil >/dev/null 2>&1; then
  app_pkg_pattern="$(echo "$APP_NAME" | tr ' ' '.')"
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    echo "Found receipt: $f" | tee -a "$REPORT"
    if [ "$DRY_RUN" -eq 0 ]; then
      sudo pkgutil --forget "$f" | tee -a "$REPORT" || true
    fi
  done < <(pkgutil --pkgs | grep -i "$app_pkg_pattern" || true)
else
  echo "pkgutil not available, skipping receipts step." | tee -a "$REPORT"
fi

echo "[6/6] Removing leftover logs..." | tee -a "$REPORT"
if [ "$DRY_RUN" -eq 0 ]; then
  rm -rf "$HOME/Library/Logs/$APP_NAME" 2>/dev/null || true
fi

# Dry-run exit
if [ "$DRY_RUN" -eq 1 ]; then
  echo "Dry-run complete."
  exit 0
fi

echo "✅ Uninstall complete for $APP_NAME"

