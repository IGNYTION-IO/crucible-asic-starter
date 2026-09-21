# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# File        : hw/protocols/spi/06_floorplanning/Makefile
# Created     : 2026-09-21
# Description : Make entrypoint for SPI OpenROAD floorplanning.
# ===============================================================================

PROJECT_ROOT := $(abspath ..)

# TODO: point PDK_ROOT at the Crucible-installed IHP SG13G2 PDK once the
# install path is confirmed (see tapeout/README.md).
PDK_ROOT ?=
export PDK_ROOT

.PHONY: all floorplan clean

all: floorplan

floorplan:
	cd "$(PROJECT_ROOT)" && igny run openroad -exit 06_floorplanning/openroad_floorplan.tcl

clean:
	cd "$(PROJECT_ROOT)" && rm -f 06_floorplanning/floorplan.def 06_floorplanning/floorplan.odb
