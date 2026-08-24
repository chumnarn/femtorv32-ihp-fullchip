#!/usr/bin/env bash
set -euo pipefail
RUN=${1:-}
if [[ -z "$RUN" ]]; then
  RUN=$(find runs -mindepth 1 -maxdepth 1 -type d -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -1 | cut -d' ' -f2- || true)
fi
[[ -n "$RUN" ]] || { echo "No run directory found"; exit 1; }
echo "Run: $RUN"
echo "--- SRAM references ---"
grep -R "RM_IHPSG13_1P_1024x32_c2_bm_bist" "$RUN" 2>/dev/null | head -20 || true
echo "--- key metrics ---"
grep -RhiE 'utilization|die area|core area|wns|tns|unrouted|drc|lvs|antenna' "$RUN" 2>/dev/null | tail -80 || true
