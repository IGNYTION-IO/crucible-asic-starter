# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/stretch/ethernet/02_sim/Makefile
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
PROJECT_ROOT := $(abspath ..)
.PHONY: all sim clean
all: sim
sim:
	cd "$(PROJECT_ROOT)" && bash run_flow.sh sim

clean:
	$(PYTHON) "$(PROJECT_ROOT)/run.py" clean_files "$(PROJECT_ROOT)" "02_sim/ethernet_core_sim.out" "02_sim/simulation.log" "02_sim/negative_control.log"
