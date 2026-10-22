# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/stretch/usb_ls/04_synthesis/Makefile
# Created     : 2026-10-03
# Description : WSL Igny USB_LS reference build entrypoint.
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
.PHONY: all synth clean
all: synth
synth:
	cd "$(PROJECT_ROOT)" && bash run_flow.sh synth

clean:
	$(PYTHON) "$(PROJECT_ROOT)/run.py" clean_files "$(PROJECT_ROOT)" "04_synthesis/synthesis.log" "04_synthesis/synth.json" "04_synthesis/synth_output.v" "04_synthesis/constraints.sdc"
