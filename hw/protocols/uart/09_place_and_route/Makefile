# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/uart/09_place_and_route/Makefile
# Created     : 2026-10-03
# Description : WSL Igny UART reference build entrypoint.
# ===============================================================================

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
PROJECT_ROOT := $(abspath ..)
.PHONY: all cts route clean
all: cts route
cts route:
	cd "$(PROJECT_ROOT)" && bash run_flow.sh $@

clean:
	rm -f -- cts.def cts.odb openroad_cts.log \
		route.def route.odb route.spef route_output.v route.guide \
		route_drc.rpt route_maze.log openroad_route.log
