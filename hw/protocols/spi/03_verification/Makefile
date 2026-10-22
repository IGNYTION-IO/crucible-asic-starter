# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/spi/03_verification/Makefile
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
.PHONY: all sim clean
all: sim
sim:
	cd "$(PROJECT_ROOT)" && bash run_flow.sh sim

clean:
	$(MAKE) -C "$(PROJECT_ROOT)/02_sim" clean
