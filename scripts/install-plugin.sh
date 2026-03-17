#!/usr/bin/env bash
set -euo pipefail

# Install built crashdetect.so to a target plugins directory.
# Usage:
#   scripts/install-plugin.sh [profile] [plugins_dir]
# Example:
#   scripts/install-plugin.sh stage /path/to/server/plugins

PROFILE="${1:-stage}"
PLUGINS_DIR="${2:-./plugins}"

case "$PROFILE" in
  dev|stage|prod) ;;
  *) echo "Invalid profile: $PROFILE (use dev|stage|prod)" >&2; exit 2 ;;
esac

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/out/$PROFILE/crashdetect.so"
DST="$PLUGINS_DIR/crashdetect.so"

[ -f "$SRC" ] || { echo "Missing build artifact: $SRC" >&2; exit 1; }
mkdir -p "$PLUGINS_DIR"

if [ -f "$DST" ]; then
  cp -f "$DST" "$DST.bak"
fi

install -m 755 "$SRC" "$DST"

echo "Installed: $DST"
if [ -f "$DST.bak" ]; then
  echo "Backup: $DST.bak"
fi
