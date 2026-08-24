SHELL := /usr/bin/env bash
CONFIG := librelane/config.yaml
PDK := ihp-sg13g2
TAG ?= fullchip

.PHONY: prepare check synth floorplan pdn place cts route full openroad klayout report clean
prepare:
	./scripts/fetch_bondpad.sh

check: prepare
	./scripts/check_project.sh

synth: check
	librelane --pdk $(PDK) --run-tag $(TAG) --to Yosys.Synthesis $(CONFIG)

floorplan: check
	librelane --pdk $(PDK) --run-tag $(TAG) --to OpenROAD.Floorplan $(CONFIG)

# For debug bring-up: these targets continue the same run using its latest state.
pdn:
	librelane --pdk $(PDK) --run-tag $(TAG) --to OpenROAD.GeneratePDN $(CONFIG)

place:
	librelane --pdk $(PDK) --run-tag $(TAG) --to OpenROAD.GlobalPlacement $(CONFIG)

cts:
	librelane --pdk $(PDK) --run-tag $(TAG) --to OpenROAD.CTS $(CONFIG)

route:
	librelane --pdk $(PDK) --run-tag $(TAG) --to OpenROAD.DetailedRouting $(CONFIG)

full: check
	librelane --pdk $(PDK) --run-tag $(TAG) $(CONFIG)

openroad:
	librelane --pdk $(PDK) --run-tag $(TAG) --flow OpenInOpenROAD $(CONFIG)

klayout:
	librelane --pdk $(PDK) --run-tag $(TAG) --flow OpenInKLayout $(CONFIG)

report:
	./scripts/report_fullchip.sh runs/$(TAG)

clean:
	rm -rf runs/$(TAG)
