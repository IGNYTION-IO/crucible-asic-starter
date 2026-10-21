#!/usr/bin/env bash
# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/stretch/usb_ls/10_gds/streamout.sh
# Created     : 2026-10-03
# Description : Protocol reference integration and teaching build.
# Upstream copyright and licence notices below remain applicable.
# ===============================================================================
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
: "${IHP_PDK_ROOT:?Set IHP_PDK_ROOT to the SG13G2 PDK directory}"
stdcell="$IHP_PDK_ROOT/libs.ref/sg13g2_stdcell"
igny run strm2gds \
    --lefdef-lefs "$stdcell/lef/sg13g2_tech.lef,$stdcell/lef/sg13g2_stdcell.lef" \
    --lefdef-lef-layouts "$stdcell/gds/sg13g2_stdcell.gds" \
    --lefdef-macro-resolution-mode 2 \
    --lefdef-map "$IHP_PDK_ROOT/libs.tech/klayout/tech/sg13g2.map" \
    09_place_and_route/route.def 10_gds/usb_ls_core.gds
test -s 10_gds/usb_ls_core.gds
echo 'PASS routed DEF to GDS streamout'
