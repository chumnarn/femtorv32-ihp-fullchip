# FemtoRV32 + IHP SG13G2 SRAM — LibreLane 3.0.9 Full Chip

Full-chip baseline using the IHP SG13G2 `Chip` flow:

- FemtoRV32 Quark RV32I CPU
- 64 KiB SRAM = 16 × `RM_IHPSG13_1P_1024x32_c2_bm_bist`
- UART TX/RX
- 4 LED outputs
- IHP 3.3 V I/O pads + 1.2 V core supply pads
- deterministic 16-SRAM placement
- custom SRAM-aware PDN
- 3.2 mm × 3.2 mm die

## Quick start

```bash
cd femtorv32-ihp-fullchip
nix-shell                 # or use the existing LibreLane 3.0.9 shell
make check
make floorplan TAG=fp01
make openroad TAG=fp01
make full TAG=chip01


make floorplan TAG=fp01
make openroad TAG=fp01

make place TAG=fp01
make openroad TAG=fp01

make cts TAG=fp01
make openroad TAG=fp01

make route  TAG=fp01
make openroad TAG=fp01

make full TAG=chip01
make openroad TAG=fp01
make klayout TAG=fp01
```

The first `make check` downloads the 149-KiB bondpad GDS from the official
IHP LibreLane template because that bondpad is not yet part of the PDK.

For staged debugging, use `make synth`, `make floorplan`, `make pdn`, `make place`,
`make cts`, and `make route` with the same `TAG`.


## ดูเพิ่ม

- FemtoRV32 SoC on IHP SG13G2: https://github.com/chumnarn/femtorv32-ihp
- ต้นฉบับ ITA-CORES: https://github.com/FelipeFFerreira/ITA-CORES
- FemtoRV32: https://github.com/BrunoLevy/learn-fpga
- LibreLane: https://librelane.readthedocs.io/
- IHP Open PDK: https://github.com/IHP-GmbH/IHP-Open-PDK
