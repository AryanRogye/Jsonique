#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-run}"
APP_NAME="Jsonique"
BUNDLE_ID="com.aryanrogye.Jsonique"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DERIVED_DATA="$ROOT_DIR/.build/xcode"
PROJECT="$ROOT_DIR/Jsonique.xcodeproj"
APP_BUNDLE="$DERIVED_DATA/Build/Products/Debug/$APP_NAME.app"
APP_BINARY="$APP_BUNDLE/Contents/MacOS/$APP_NAME"

build_app() {
  xcodebuild \
    -project "$PROJECT" \
    -scheme "$APP_NAME" \
    -configuration Debug \
    -destination "platform=macOS" \
    -derivedDataPath "$DERIVED_DATA" \
    build
}

kill_app() {
  pkill -x "$APP_NAME" >/dev/null 2>&1 || true
}

run_in_terminal() {
  "$APP_BINARY"
}

open_app() {
  /usr/bin/open -n "$APP_BUNDLE"
}

kill_app
build_app

case "$MODE" in
  run)
    run_in_terminal
    ;;
  --open|open)
    open_app
    ;;
  --debug|debug)
    lldb -- "$APP_BINARY"
    ;;
  --logs|logs)
    run_in_terminal &
    /usr/bin/log stream --info --style compact --predicate "process == \"$APP_NAME\""
    ;;
  --telemetry|telemetry)
    open_app
    /usr/bin/log stream --info --style compact --predicate "subsystem == \"$BUNDLE_ID\""
    ;;
  --verify|verify)
    open_app
    sleep 1
    pgrep -x "$APP_NAME" >/dev/null
    ;;
  *)
    echo "usage: $0 [run|--open|--debug|--logs|--telemetry|--verify]" >&2
    exit 2
    ;;
esac
