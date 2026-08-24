#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
: "${PDK_ROOT:?PDK_ROOT is not set. Enter the LibreLane nix-shell first.}"
PDK="$PDK_ROOT/ihp-sg13g2"
MAC=RM_IHPSG13_1P_1024x32_c2_bm_bist
files=(
 "$ROOT/src/femtorv32_quark.v"
 "$ROOT/src/ihp_sram_64k.v"
 "$ROOT/src/chip_core.sv"
 "$ROOT/src/chip_top.sv"
 "$ROOT/librelane/config.yaml"
 "$ROOT/librelane/chip_top.sdc"
 "$ROOT/librelane/pdn_cfg.tcl"
 "$ROOT/ip/bondpad_70x70_novias/lef/bondpad_70x70_novias.lef"
 "$ROOT/ip/bondpad_70x70_novias/gds/bondpad_70x70_novias.gds"
 "$PDK/libs.ref/sg13g2_sram/lef/$MAC.lef"
 "$PDK/libs.ref/sg13g2_sram/gds/$MAC.gds"
 "$PDK/libs.ref/sg13g2_sram/verilog/$MAC.v"
)
fail=0
for f in "${files[@]}"; do
  if [[ -s "$f" ]]; then echo "[OK] $f"; else echo "[MISSING] $f"; fail=1; fi
done
exit "$fail"
