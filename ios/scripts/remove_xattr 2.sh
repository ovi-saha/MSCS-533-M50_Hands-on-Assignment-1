#!/bin/bash
# Strips extended attributes that break codesign ("resource fork / Finder info not allowed")
set -euo pipefail

echo "[xattr-fix] Stripping extended attributes..."

# Only run for iOS device/simulator builds
case "${PLATFORM_NAME:-}" in
  iphoneos|iphonesimulator) ;;
  *) echo "[xattr-fix] Non-iOS platform (${PLATFORM_NAME:-}), skipping."; exit 0 ;;
esac

# Be defensive: these env vars are provided by Xcode during build
if [[ -n "${TARGET_BUILD_DIR:-}" && -d "${TARGET_BUILD_DIR:-}" ]]; then
  echo "[xattr-fix] Cleaning TARGET_BUILD_DIR: $TARGET_BUILD_DIR"
  xattr -rc "$TARGET_BUILD_DIR" || true
fi

if [[ -n "${BUILT_PRODUCTS_DIR:-}" && -d "${BUILT_PRODUCTS_DIR:-}" ]]; then
  echo "[xattr-fix] Cleaning BUILT_PRODUCTS_DIR: $BUILT_PRODUCTS_DIR"
  xattr -rc "$BUILT_PRODUCTS_DIR" || true
fi

# Also clean the project ios folder to avoid reintroducing attrs on next copy
if [[ -n "${SRCROOT:-}" && -d "${SRCROOT:-}" ]]; then
  echo "[xattr-fix] Cleaning SRCROOT (ios dir): $SRCROOT"
  xattr -rc "$SRCROOT" || true
fi

# Extra: if Flutter engine frameworks carry quarantine attrs in the SDK cache,
# strip them once to avoid re-copying quarantined files every build.
# (This path exists on modern Flutter versions.)
ENGINE_DIR="$HOME/development/flutter/bin/cache/artifacts/engine"
if [[ -d "$ENGINE_DIR" ]]; then
  echo "[xattr-fix] Cleaning Flutter engine cache: $ENGINE_DIR"
  xattr -rc "$ENGINE_DIR" || true
fi

echo "[xattr-fix] Done."
