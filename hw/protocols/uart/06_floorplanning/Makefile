# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/uart/06_floorplanning/Makefile
# Created     : 2026-10-03
# Description : WSL Igny UART reference build entrypoint.
# ===============================================================================

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
PROJECT_ROOT := $(abspath ..)
.PHONY: all floorplan clean
all: floorplan
floorplan:
	cd "$(PROJECT_ROOT)" && bash run_flow.sh floorplan

clean:
	rm -f -- floorplan.def floorplan.odb openroad_floorplan.log
