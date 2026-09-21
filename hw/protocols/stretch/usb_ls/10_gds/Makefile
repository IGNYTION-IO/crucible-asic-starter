# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# File        : hw/protocols/stretch/usb_ls/10_gds/Makefile
# Created     : 2026-09-21
# Description : Make entrypoint for USB low-speed (stretch) GDS streamout.
# ===============================================================================

PROJECT_ROOT := $(abspath ..)

PDK_ROOT ?=
export PDK_ROOT

.PHONY: all gds clean

all: gds

gds:
	cd "$(PROJECT_ROOT)" && if [ ! -f 09_place_and_route/route.def ]; then $(MAKE) -C 09_place_and_route route; fi
	cd "$(PROJECT_ROOT)" && bash 10_gds/run_gds_streamout.sh

clean:
	cd "$(PROJECT_ROOT)" && rm -f 10_gds/UsbLsCore.gds
