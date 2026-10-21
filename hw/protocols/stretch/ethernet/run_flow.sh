#!/usr/bin/env bash
# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/stretch/ethernet/run_flow.sh
# Created     : 2026-10-03
# Description : Stage-aware WSL Igny reference RTL-to-GDS execution.
# ===============================================================================
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
export CRUCIBLE_ENV=janestreet-ethernet
export IHP_PDK_ROOT="${IHP_PDK_ROOT:-${HOME}/.ciel/ciel/ihp-sg13g2/versions/22f43352dd8219f9007eb659e422e0d5fe28c5fb/ihp-sg13g2}"
run_crc() {
    igny run iverilog -g2012 -s crc_equivalence -o 03_verification/crc_equivalence.out 01_rtl/ethernet_crc32.v 03_verification/upstream_lfsr.v 03_verification/crc_equivalence.v
    igny run vvp 03_verification/crc_equivalence.out | tee 03_verification/crc_equivalence.log
    grep -q '^PASS CRC equivalence:' 03_verification/crc_equivalence.log
    if igny run vvp 03_verification/crc_equivalence.out +inject_failure >03_verification/crc_negative_control.log 2>&1; then
        echo 'Injected CRC mismatch incorrectly passed' >&2; return 1
    fi
    grep -q 'CRC state equivalence mismatch' 03_verification/crc_negative_control.log
    echo 'PASS CRC equivalence negative control'
}
run_sim() {
    igny run iverilog -g2012 -s tst_bench_top -o 02_sim/ethernet_core_sim.out 01_rtl/*.v 02_sim/test.v
    igny run vvp 02_sim/ethernet_core_sim.out | tee 02_sim/simulation.log
    grep -q '^PASS ETHERNET regression:' 02_sim/simulation.log
    if igny run vvp 02_sim/ethernet_core_sim.out +inject_failure >02_sim/negative_control.log 2>&1; then
        echo 'Injected failure incorrectly passed' >&2; return 1
    fi
    grep -q 'Ethernet RX mismatch' 02_sim/negative_control.log
    echo 'PASS ETHERNET negative control'
    run_crc
}
run_lint() {
    igny run verilator --lint-only -Wall -Wno-fatal -I01_rtl --top-module ethernet_core 01_rtl/*.v |& tee 00_lint/lint_report.txt
    echo 'PASS ETHERNET lint execution (warnings retained for review)'
}
run_stage() { igny run openroad -exit "$1" | tee "${1%.tcl}.log"; }
run_sta() {
    igny run openroad -exit 08_sta/openroad_sta.tcl | tee 08_sta/timing_report.txt
    STA_CORNER=slow igny run openroad -exit 08_sta/openroad_sta.tcl | tee 08_sta/timing_slow.txt
}
run_synth() { igny run yosys -c 04_synthesis/synth.tcl | tee 04_synthesis/synthesis.log; }
run_physical() {
    for entry in 06_floorplanning/openroad_floorplan.tcl 07_placement/openroad_placement.tcl 09_place_and_route/openroad_cts.tcl 09_place_and_route/openroad_route.tcl; do
        igny run openroad -exit "$entry" | tee "${entry%.tcl}.log"
    done
    run_sta
}
run_gds() {
    igny run script 10_gds/streamout.sh
    igny run script 10_gds/validate_gds.py
if PYTHONOPTIMIZE=1 igny run script 10_gds/validate_gds.py -- --inject_failure >10_gds/negative_control.log 2>&1; then
        echo 'Injected GDS mismatch incorrectly passed' >&2; return 1
    fi
    grep -q 'DEF/GDS placement mismatch' 10_gds/negative_control.log
    echo 'PASS GDS mismatch negative control with Python optimization'
}
case "${1:-flow}" in
    lint) run_lint ;;
    floorplan) run_stage 06_floorplanning/openroad_floorplan.tcl ;;
    place) run_stage 07_placement/openroad_placement.tcl ;;
    cts) run_stage 09_place_and_route/openroad_cts.tcl ;;
    route) run_stage 09_place_and_route/openroad_route.tcl ;;
    sta) run_sta ;;
    sim|verify) run_sim ;;
    crc) run_crc ;;
    synth) run_synth ;;
    physical) run_physical ;;
    gds) run_gds ;;
    flow) run_sim; run_synth; run_physical; run_gds ;;
    *) echo 'Unknown stage' >&2; exit 2 ;;
esac
