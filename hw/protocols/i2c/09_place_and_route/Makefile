# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/i2c/09_place_and_route/Makefile
# Created     : 2026-10-03
# Description : WSL Igny I2C reference build entrypoint.
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
.PHONY: all cts route clean
all: cts route
cts route:
	cd "$(PROJECT_ROOT)" && bash run_flow.sh $@

clean:
	$(PYTHON) "$(PROJECT_ROOT)/run.py" clean_files "$(PROJECT_ROOT)" "09_place_and_route/cts.def" "09_place_and_route/cts.odb" "09_place_and_route/openroad_cts.log" "09_place_and_route/route.def" "09_place_and_route/route.odb" "09_place_and_route/route.spef" "09_place_and_route/route_output.v" "09_place_and_route/route.guide" "09_place_and_route/route_drc.rpt" "09_place_and_route/route_maze.log" "09_place_and_route/openroad_route.log"
