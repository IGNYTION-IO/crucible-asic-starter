# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# File        : hw/protocols/spi/11_physical_verification/Makefile
# Created     : 2026-09-21
# Description : Make entrypoint for SPI DRC and LVS physical verification.
# ===============================================================================

PROJECT_ROOT := $(abspath ..)

.PHONY: all physical clean

all: physical

physical:
	cd "$(PROJECT_ROOT)" && if [ ! -f 10_gds/SpiCore.gds ]; then $(MAKE) -C 10_gds; fi
	cd "$(PROJECT_ROOT)" && bash 11_physical_verification/run_physical_verification.sh

clean:
	cd "$(PROJECT_ROOT)" && rm -f 11_physical_verification/results/*.ext 11_physical_verification/results/*.log \
		11_physical_verification/results/*.spice 11_physical_verification/results/physical_verification_status.txt
