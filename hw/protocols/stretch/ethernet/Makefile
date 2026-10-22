# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/stretch/ethernet/Makefile
# Created     : 2026-10-03
# Description : WSL Igny ETHERNET reference build entrypoint.
# ===============================================================================

ifeq ($(OS),Windows_NT)
SHELL := cmd.exe
.SHELLFLAGS := /c
PYTHON ?= python
else
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
PYTHON ?= python3
endif
export PYTHON
PROJECT_ROOT := $(abspath .)
.PHONY: all flow lint rtl sim verify synth floorplan place cts route sta physical gds evidence dft signoff clean
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

# Remove generated stage outputs; keep sources, scripts and workspace configuration.
clean:
	$(MAKE) -C 00_lint clean
	$(MAKE) -C 01_rtl clean
	$(MAKE) -C 02_sim clean
	$(MAKE) -C 03_verification clean
	$(MAKE) -C 04_synthesis clean
	$(MAKE) -C 05_dft clean
	$(MAKE) -C 06_floorplanning clean
	$(MAKE) -C 07_placement clean
	$(MAKE) -C 08_sta clean
	$(MAKE) -C 09_place_and_route clean
	$(MAKE) -C 10_gds clean
	$(MAKE) -C 11_physical_verification clean
