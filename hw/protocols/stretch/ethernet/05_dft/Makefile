# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/stretch/ethernet/05_dft/Makefile
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
.PHONY: all clean
all:
	@echo 'This reference flow has no implemented scan/DFT stage. Do not claim signoff.' >&2
	@exit 2

# This placeholder stage produces no files.
clean:
	$(PYTHON) "$(PROJECT_ROOT)/run.py" clean_files "$(PROJECT_ROOT)"
