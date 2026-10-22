# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/spi/06_floorplanning/Makefile
# Created     : 2026-10-03
# Description : WSL Igny SPI reference build entrypoint.
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
.PHONY: all floorplan clean
all: floorplan
floorplan:
	cd "$(PROJECT_ROOT)" && bash run_flow.sh floorplan

clean:
	$(PYTHON) "$(PROJECT_ROOT)/run.py" clean_files "$(PROJECT_ROOT)" "06_floorplanning/floorplan.def" "06_floorplanning/floorplan.odb" "06_floorplanning/openroad_floorplan.log"
