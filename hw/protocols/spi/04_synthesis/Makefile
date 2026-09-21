# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# File        : hw/protocols/spi/04_synthesis/Makefile
# Created     : 2026-09-21
# Description : Make entrypoint for SPI Yosys synthesis and SDC generation.
# ===============================================================================

PROJECT_ROOT := $(abspath ..)

.PHONY: all synth sdc clean

all: synth sdc

synth:
	cd "$(PROJECT_ROOT)" && igny run yosys -s 04_synthesis/synth.tcl

sdc:
	cd "$(PROJECT_ROOT)" && igny run yosys -c 04_synthesis/gen_sdc.tcl

clean:
	cd "$(PROJECT_ROOT)" && rm -f 04_synthesis/synth_output.v 04_synthesis/constraints.sdc
