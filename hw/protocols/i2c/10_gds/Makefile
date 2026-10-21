# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/i2c/10_gds/Makefile
# Created     : 2026-10-03
# Description : WSL Igny I2C reference build entrypoint.
# ===============================================================================

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
PROJECT_ROOT := $(abspath ..)
.PHONY: all gds
all: gds
gds:
	cd "$(PROJECT_ROOT)" && bash run_flow.sh gds
