#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/ip/bondpad_70x70_novias/gds/bondpad_70x70_novias.gds"
URL="https://github.com/IHP-GmbH/ihp-sg13g2-librelane-template/raw/refs/heads/main/ip/bondpad_70x70_novias/gds/bondpad_70x70_novias.gds"
if [[ -s "$OUT" ]]; then
  echo "[OK] bondpad GDS already present: $OUT"
  exit 0
fi
mkdir -p "$(dirname "$OUT")"
echo "[FETCH] Official IHP LibreLane-template bondpad GDS"
curl -L --fail --retry 3 "$URL" -o "$OUT"
echo "[OK] $(du -h "$OUT" | cut -f1) $OUT"
