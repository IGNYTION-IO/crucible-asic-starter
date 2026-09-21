# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# File        : hw/protocols/spi/07_placement/Makefile
# Created     : 2026-09-21
# Description : Make entrypoint for SPI OpenROAD placement.
# ===============================================================================

PROJECT_ROOT := $(abspath ..)

PDK_ROOT ?=
export PDK_ROOT

.PHONY: all place clean

all: place

place:
	cd "$(PROJECT_ROOT)" && if [ ! -f 06_floorplanning/floorplan.odb ]; then $(MAKE) -C 06_floorplanning; fi
	cd "$(PROJECT_ROOT)" && igny run openroad -exit 07_placement/openroad_placement.tcl

clean:
	cd "$(PROJECT_ROOT)" && rm -f 07_placement/placement.def 07_placement/placement.odb
