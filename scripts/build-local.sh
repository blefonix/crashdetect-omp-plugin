#!/usr/bin/env bash
set -euo pipefail

# Reproducible local build helper for crashdetect.
# Usage:
#   scripts/build-local.sh [profile]
# Profiles:
#   dev|stage|prod (label-only; affects output directory naming)

PROFILE="${1:-dev}"
case "$PROFILE" in
  dev|stage|prod) ;;
  *) echo "Invalid profile: $PROFILE (use dev|stage|prod)" >&2; exit 2 ;;
esac

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT/build-${PROFILE}"
OUT_DIR="$ROOT/out/${PROFILE}"

mkdir -p "$OUT_DIR"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

cmake -S "$ROOT" -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF
cmake --build "$BUILD_DIR" --config Release -j"$(nproc)"

cp -f "$BUILD_DIR/crashdetect.so" "$OUT_DIR/crashdetect.so"

if command -v file >/dev/null 2>&1; then
  file "$OUT_DIR/crashdetect.so" | tee "$OUT_DIR/ARCH.txt"
fi
if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$OUT_DIR/crashdetect.so" | tee "$OUT_DIR/SHA256SUMS.txt"
fi

echo "OK: $OUT_DIR/crashdetect.so"
