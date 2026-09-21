# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# File        : hw/core/02_sim/Makefile
# Created     : 2026-09-21
# Description : Make entrypoint for Core (full chip) Icarus simulation.
# ===============================================================================

PROJECT_ROOT := $(abspath ..)
SIM_OUT := 02_sim/protocol_emulator_top_sim.out
WAVE_OUT := 02_sim/protocol_emulator_top.vcd

.PHONY: all sim compile run clean

all: sim

sim: compile run

compile:
	cd "$(PROJECT_ROOT)" && igny run iverilog -o "$(SIM_OUT)" -s test -I 01_rtl 01_rtl/protocol_emulator_top.v 02_sim/test.v

run:
	cd "$(PROJECT_ROOT)" && igny run vvp "$(SIM_OUT)"
	cd "$(PROJECT_ROOT)" && if [ -f waveform.vcd ]; then mv -f waveform.vcd "$(WAVE_OUT)"; fi

clean:
	cd "$(PROJECT_ROOT)" && rm -f "$(SIM_OUT)" "$(WAVE_OUT)"
