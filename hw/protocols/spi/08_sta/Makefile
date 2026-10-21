# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/spi/08_sta/Makefile
# Created     : 2026-10-03
# Description : WSL Igny SPI reference build entrypoint.
# ===============================================================================

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
PROJECT_ROOT := $(abspath ..)
.PHONY: all sta
all: sta
sta:
	cd "$(PROJECT_ROOT)" && bash run_flow.sh sta
