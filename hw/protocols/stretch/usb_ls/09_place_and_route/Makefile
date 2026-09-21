# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# File        : hw/protocols/stretch/usb_ls/09_place_and_route/Makefile
# Created     : 2026-09-21
# Description : Make entrypoint for USB low-speed (stretch) OpenROAD CTS and routing.
# ===============================================================================

PROJECT_ROOT := $(abspath ..)

PDK_ROOT ?=
export PDK_ROOT

.PHONY: all cts route clean

all: route

cts:
	cd "$(PROJECT_ROOT)" && if [ ! -f 07_placement/placement.odb ]; then $(MAKE) -C 07_placement; fi
	cd "$(PROJECT_ROOT)" && igny run openroad -exit 09_place_and_route/openroad_cts.tcl

route: cts
	cd "$(PROJECT_ROOT)" && igny run openroad -exit 09_place_and_route/openroad_route.tcl

clean:
	cd "$(PROJECT_ROOT)" && rm -f 09_place_and_route/cts.def 09_place_and_route/cts.odb \
		09_place_and_route/route.def 09_place_and_route/route.odb 09_place_and_route/route.spef \
		09_place_and_route/route_output.v 09_place_and_route/route.guide 09_place_and_route/route_drc.rpt
