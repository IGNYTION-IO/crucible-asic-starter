# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/uart/07_placement/Makefile
# Created     : 2026-10-03
# Description : WSL Igny UART reference build entrypoint.
# ===============================================================================

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
PROJECT_ROOT := $(abspath ..)
.PHONY: all place clean
all: place
place:
	cd "$(PROJECT_ROOT)" && bash run_flow.sh place

clean:
	rm -f -- placement.def placement.odb openroad_placement.log
