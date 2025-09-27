#!/bin/bash
# Require macOS (Darwin)
if [ "$(uname)" != "Darwin" ]; then
  echo "Skipping: uninstallr requires macOS (Darwin)."
  exit 0
fi
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./appremove_pro.sh [--dry-run] [--force] <App Name>

Examples:
  ./appremove_pro.sh CoinPoker
  ./appremove_pro.sh --dry-run "Google Chrome"

Flags:
  --dry-run   Show what would be deleted, do not delete
  --force     Do not ask for confirmation
EOF
}

DRY_RUN=0
FORCE=0
ARGS=()

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --force)   FORCE=1 ;;
    -h|--help) usage; exit 0 ;;
    *)         ARGS+=("$arg") ;;
  esac
done

if [ ${#ARGS[@]} -eq 0 ]; then
  usage; exit 1
fi

APP_NAME="${ARGS[*]}"
APP_NAME_LOWER="$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')"
TIMESTAMP="$(date +"%Y%m%d-%H%M%S")"
REPORT="$HOME/appremove-report-$APP_NAME_LOWER-$TIMESTAMP.txt"

say_do() {
  local cmd="$1"
  echo "$cmd" | tee -a "$REPORT"
  if [ $DRY_RUN -eq 0 ]; then
    eval "$cmd"
  fi
}

echo "=== AppRemove Pro ==="            | tee "$REPORT"
echo "Target app: $APP_NAME"           | tee -a "$REPORT"
echo "Dry-run: $DRY_RUN  Force: $FORCE" | tee -a "$REPORT"
echo "Report: $REPORT"                 | tee -a "$REPORT"
echo                                   | tee -a "$REPORT"

if [ $FORCE -eq 0 ]; then
  read -r -p "Proceed to remove \"$APP_NAME\"? [y/N] " ans
  case "${ans:-N}" in
    y|Y) ;;
    *) echo "Aborted."; exit 0 ;;
  esac
fi

echo "[1/6] Stopping processes…" | tee -a "$REPORT"
say_do "pkill -f \"$APP_NAME\" || true"

echo "[2/6] Removing app bundles…" | tee -a "$REPORT"
for p in "/Applications/$APP_NAME.app" "$HOME/Applications/$APP_NAME.app"; do
  if [ -e "$p" ]; then
    say_do "sudo rm -rf \"$p\""
  fi
done

echo "[3/6] Removing user Library artifacts…" | tee -a "$REPORT"
USER_PATHS=(
  "$HOME/Library/Application Support/$APP_NAME"
  "$HOME/Library/Application Support/${APP_NAME_LOWER}"
  "$HOME/Library/Preferences/com.${APP_NAME_LOWER}.*"
  "$HOME/Library/Preferences/${APP_NAME}*"
  "$HOME/Library/Caches/com.${APP_NAME_LOWER}.*"
  "$HOME/Library/Caches/${APP_NAME}*"
  "$HOME/Library/Logs/$APP_NAME"
  "$HOME/Library/Logs/${APP_NAME}*"
  "$HOME/Library/LaunchAgents/com.${APP_NAME_LOWER}.*"
)
for pat in "${USER_PATHS[@]}"; do
  for f in $(/bin/ls -1d "$pat" 2>/dev/null || true); do
    say_do "rm -rf \"$f\""
  done
done

echo "[4/6] Removing system Library artifacts…" | tee -a "$REPORT"
SYS_PATHS=(
  "/Library/Application Support/$APP_NAME"
  "/Library/Application Support/${APP_NAME_LOWER}"
  "/Library/LaunchAgents/com.${APP_NAME_LOWER}.*"
  "/Library/LaunchDaemons/com.${APP_NAME_LOWER}.*"
  "/Library/Preferences/com.${APP_NAME_LOWER}.*"
  "/Library/Caches/com.${APP_NAME_LOWER}.*"
  "/Library/Logs/${APP_NAME}*"
)
for pat in "${SYS_PATHS[@]}"; do
  for f in $(/bin/ls -1d "$pat" 2>/dev/null || true); do
    say_do "sudo rm -rf \"$f\""
  done
done

echo "[5/6] Removing related receipts (if any)…" | tee -a "$REPORT"

if command -v pkgutil >/dev/null 2>&1; then
  app_pkg_pattern="$(echo "$APP_NAME" | tr ' ' '.')"

  # pkg listesinde uygulama adına benzeyen kayıtları gez
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    echo "Found receipt: $f" | tee -a "$REPORT"

    # Dry-run değilse forget uygula
    if [ "${DRY_RUN:-1}" -eq 0 ]; then
      sudo pkgutil --forget "$f" | tee -a "$REPORT" || true
    fi
  done < <(pkgutil --pkgs | grep -i "$app_pkg_pattern" || true)
else
  echo "pkgutil not available, skipping receipts step." | tee -a "$REPORT"
fi
if [ "${DRY_RUN:-1}" -eq 1 ]; then
  echo "Dry-run complete."
  exit 0
fi

echo "[6/6] Optional: empty Trash…" | tee -a "$REPORT"
if [ $FORCE -eq 1 ]; then
  say_do "sudo rm -rf \"$HOME/.Trash\"/* 2>/dev/null || true"
else
  read -r -p "Empty Trash now? [y/N] " ans2
  if [[ "$ans2" =~ ^[yY]$ ]]; then
    say_do "sudo rm -rf \"$HOME/.Trash\"/* 2>/dev/null || true"
  fi
fi

echo
echo "✅ Done. Removal report saved to: $REPORT" | tee -a "$REPORT"

