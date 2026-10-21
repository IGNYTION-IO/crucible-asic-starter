# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/i2c/00_lint/Makefile
# Created     : 2026-10-03
# Description : WSL Igny I2C reference build entrypoint.
# ===============================================================================

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
PROJECT_ROOT := $(abspath ..)
.PHONY: all lint
all: lint
lint:
	cd "$(PROJECT_ROOT)" && bash run_flow.sh lint
