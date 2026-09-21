# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# File        : hw/core/03_verification/Makefile
# Created     : 2026-09-21
# Description : Make entrypoint for Core (full chip) Python/cocotb verification.
# ===============================================================================

PROJECT_ROOT := $(abspath ..)
VERIFY_ROOT := 03_verification/py_verification_protocol_emulator_top

.PHONY: all check test clean

all: check test

check:
	cd "$(PROJECT_ROOT)" && igny run script "$(VERIFY_ROOT)/check_env.py"

test:
	cd "$(PROJECT_ROOT)" && igny run script "$(VERIFY_ROOT)/run_tests.py"

clean:
	cd "$(PROJECT_ROOT)" && rm -rf "$(VERIFY_ROOT)/results" "$(VERIFY_ROOT)/sim_build"
	cd "$(PROJECT_ROOT)" && find "$(VERIFY_ROOT)" -type d -name "__pycache__" -exec rm -rf {} +
