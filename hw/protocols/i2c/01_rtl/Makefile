# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/i2c/01_rtl/Makefile
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
.PHONY: all lint clean
all: lint
lint:
	cd "$(PROJECT_ROOT)" && bash run_flow.sh lint

clean:
	$(MAKE) -C "$(PROJECT_ROOT)/00_lint" clean
