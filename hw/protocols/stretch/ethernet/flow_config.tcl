# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/stretch/ethernet/flow_config.tcl
# Created     : 2026-10-03
# Description : Protocol reference integration and teaching build.
# Upstream copyright and licence notices below remain applicable.
# ===============================================================================
# IHP SG13G2 block implementation, 2.5 MHz MII target, TT timing reports.
set top ethernet_core
set clock_port mii_tx_clk
set period 400.0
set rtl_files [glob [file join $project_root 01_rtl *.v]]
if {![info exists ::env(IHP_PDK_ROOT)]} {
    set ::env(IHP_PDK_ROOT) [file normalize ~/.ciel/ciel/ihp-sg13g2/versions/22f43352dd8219f9007eb659e422e0d5fe28c5fb/ihp-sg13g2]
}
set ihp_pdk_root $::env(IHP_PDK_ROOT)
set ihp_stdcell_root [file join $ihp_pdk_root libs.ref sg13g2_stdcell]
set ihp_tech_lef [file join $ihp_stdcell_root lef sg13g2_tech.lef]
set ihp_cell_lef [file join $ihp_stdcell_root lef sg13g2_stdcell.lef]
set ihp_cell_gds [file join $ihp_stdcell_root gds sg13g2_stdcell.gds]
set ihp_liberty_typ [file join $ihp_stdcell_root lib sg13g2_stdcell_typ_1p20V_25C.lib]
set ihp_liberty_slow [file join $ihp_stdcell_root lib sg13g2_stdcell_slow_1p08V_125C.lib]
set ihp_rcx_rules [file join $ihp_pdk_root libs.tech librelane openrcx IHP_rcx_patterns.rules]
set ihp_layer_map [file join $ihp_pdk_root libs.tech klayout tech sg13g2.map]
foreach required [list $ihp_tech_lef $ihp_cell_lef $ihp_cell_gds $ihp_liberty_typ $ihp_liberty_slow $ihp_rcx_rules $ihp_layer_map] {
    if {![file exists $required]} {error "Missing PDK input: $required"}
}
