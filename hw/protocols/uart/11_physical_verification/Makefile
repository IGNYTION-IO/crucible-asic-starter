# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/uart/11_physical_verification/Makefile
# Created     : 2026-10-03
# Description : WSL Igny UART reference build entrypoint.
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
PROJECT_ROOT := $(abspath ..)
.PHONY: all signoff check-controls clean
all: signoff
signoff:
	$(PYTHON) "$(PROJECT_ROOT)/run.py" ensure_stage "$(PROJECT_ROOT)" "10_gds/uart_core.gds" "." flow
	$(PYTHON) "$(PROJECT_ROOT)/run.py" ensure_stage "$(PROJECT_ROOT)" "09_place_and_route/route.odb" "." flow
	$(PYTHON) "$(PROJECT_ROOT)/run.py" physical "$(PROJECT_ROOT)"

check-controls:
	$(PYTHON) -B "$(PROJECT_ROOT)/11_physical_verification/run_checks.py" --negative-controls

RESULT_FILES := $(addprefix 11_physical_verification/results/,\
	physical_verification.json negative_controls.json klayout_version.log \
	klayout_drc.lyrdb klayout_drc.log klayout_drc.rules.log \
	openroad_reference.log reference.power.v reference.blackboxes.v \
	yosys_reference.log reference.yosys.spice reference.spice layout.spice \
	layout.lvsdb klayout_extract.log klayout_extract.rules.log \
	netgen_lvs.tcl netgen_lvs.log netgen_lvs.console.log \
	negative_drc.rb negative_drc.gds negative_fixture.log \
	negative_drc.lyrdb negative_drc.log negative_drc.rules.log \
	negative_reference.spice negative_lvs.tcl negative_lvs.log negative_lvs.console.log)

clean:
	$(PYTHON) "$(PROJECT_ROOT)/run.py" clean_files "$(PROJECT_ROOT)" $(RESULT_FILES)
