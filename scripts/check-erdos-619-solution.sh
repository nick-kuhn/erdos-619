#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="${1:-$ROOT/comparator/erdos_619.json}"

COMPARATOR_BIN="${COMPARATOR_BIN:-$ROOT/.tools/comparator/.lake/build/bin/comparator}"
COMPARATOR_LEAN4EXPORT="${COMPARATOR_LEAN4EXPORT:-$ROOT/.tools/comparator/.lake/packages/lean4export/.lake/build/bin/lean4export}"
COMPARATOR_DEV_FAKE_LANDRUN="${COMPARATOR_DEV_FAKE_LANDRUN:-0}"

if [[ ! -x "$COMPARATOR_BIN" ]]; then
  cat >&2 <<MSG
Comparator binary not found at:
  $COMPARATOR_BIN

Build it with:
  (cd .tools/comparator && lake build lean4export comparator)

or set COMPARATOR_BIN to an existing comparator executable.
MSG
  exit 2
fi

if [[ ! -x "$COMPARATOR_LEAN4EXPORT" ]]; then
  cat >&2 <<MSG
lean4export binary not found at:
  $COMPARATOR_LEAN4EXPORT

Set COMPARATOR_LEAN4EXPORT to a lean4export binary compatible with this project's Lean version.
MSG
  exit 2
fi

if [[ "$COMPARATOR_DEV_FAKE_LANDRUN" == "1" ]]; then
  LANDRUN_BIN="$ROOT/scripts/dev-fake-landrun.sh"
elif [[ -n "${COMPARATOR_LANDRUN:-}" ]]; then
  LANDRUN_BIN="$COMPARATOR_LANDRUN"
elif command -v landrun >/dev/null 2>&1; then
  LANDRUN_BIN="$(command -v landrun)"
else
  cat >&2 <<'MSG'
landrun was not found. Install landrun or set COMPARATOR_LANDRUN to its absolute path.
For non-adversarial wiring tests only, set COMPARATOR_DEV_FAKE_LANDRUN=1.
MSG
  exit 2
fi

if [[ ! -x "$LANDRUN_BIN" ]]; then
  echo "landrun path is not executable: $LANDRUN_BIN" >&2
  exit 2
fi

SHIM_DIR="$ROOT/.tools/bin"
mkdir -p "$SHIM_DIR"
ln -sfn "$LANDRUN_BIN" "$SHIM_DIR/landrun"
ln -sfn "$COMPARATOR_LEAN4EXPORT" "$SHIM_DIR/lean4export"

cd "$ROOT"
PATH="$SHIM_DIR:$PATH" exec lake env "$COMPARATOR_BIN" "$CONFIG"
