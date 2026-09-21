# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# File        : hw/protocols/stretch/ethernet/00_lint/Makefile
# Created     : 2026-09-21
# Description : Make entrypoint for 10BASE-T Ethernet (stretch) Verilator lint. Output: lint_report.txt
# ===============================================================================

PROJECT_ROOT := $(abspath ..)

.PHONY: all lint clean

all: lint

lint:
	cd "$(PROJECT_ROOT)" && igny run verilator --lint-only -Wall -Wno-fatal -I01_rtl 01_rtl/ethernet_core.v | tee 00_lint/lint_report.txt

clean:
	cd "$(PROJECT_ROOT)" && rm -f 00_lint/lint_report.txt
