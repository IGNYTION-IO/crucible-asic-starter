# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/stretch/ethernet/Makefile
# Created     : 2026-10-03
# Description : WSL Igny ETHERNET reference build entrypoint.
# ===============================================================================

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.PHONY: all flow lint rtl sim verify synth floorplan place cts route sta physical gds evidence dft signoff
all: flow
flow:
	bash run_flow.sh lint
	bash run_flow.sh flow
lint:
	bash run_flow.sh lint
sim:
	bash run_flow.sh sim
verify:
	bash run_flow.sh verify
synth:
	bash run_flow.sh synth
floorplan:
	bash run_flow.sh floorplan
place:
	bash run_flow.sh place
cts:
	bash run_flow.sh cts
route:
	bash run_flow.sh route
sta:
	bash run_flow.sh sta
physical:
	bash run_flow.sh physical
gds:
	bash run_flow.sh gds
rtl: lint
evidence:
	node verify_build.mjs all
dft:
	$(MAKE) -C 05_dft
signoff:
	$(MAKE) -C 11_physical_verification
