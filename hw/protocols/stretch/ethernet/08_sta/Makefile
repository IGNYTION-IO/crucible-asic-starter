# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# File        : hw/protocols/stretch/ethernet/08_sta/Makefile
# Created     : 2026-09-21
# Description : Make entrypoint for 10BASE-T Ethernet (stretch) OpenROAD/OpenSTA timing analysis.
# ===============================================================================

PROJECT_ROOT := $(abspath ..)
SHELL := /bin/bash
.SHELLFLAGS := -o pipefail -c

PDK_ROOT ?=
export PDK_ROOT

.PHONY: all sta clean

all: sta

sta:
	cd "$(PROJECT_ROOT)" && igny run openroad -exit 08_sta/openroad_sta.tcl | tee 08_sta/timing_report.txt

clean:
	cd "$(PROJECT_ROOT)" && rm -f 08_sta/timing_report.txt
