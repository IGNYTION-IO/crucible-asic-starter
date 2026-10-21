# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/stretch/usb_ls/03_verification/Makefile
# Created     : 2026-10-03
# Description : WSL Igny USB_LS reference build entrypoint.
# ===============================================================================

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
PROJECT_ROOT := $(abspath ..)
.PHONY: all sim
all: sim
sim:
	cd "$(PROJECT_ROOT)" && bash run_flow.sh sim
