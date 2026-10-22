# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/uart/09_place_and_route/openroad_route.tcl
# Created     : 2026-10-03
# Description : Protocol reference integration and teaching build.
# Upstream copyright and licence notices below remain applicable.
# ===============================================================================
# IHP SG13G2 global/detailed routing and filler insertion for uart_core.

set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ..]]
source [file join $project_root flow_config.tcl]
set_thread_count 4

set cts_db [file join $script_dir "cts.odb"]
set sdc [file join $project_root "04_synthesis" "constraints.sdc"]
foreach required [list $cts_db $sdc] {
    if {![file exists $required]} {
        puts stderr "Missing prerequisite: $required"
        exit 1
    }
}

read_db $cts_db
read_liberty $ihp_liberty_typ
read_sdc $sdc
set_propagated_clock [all_clocks]

set_routing_layers -signal Metal2-TopMetal2 -clock Metal3-TopMetal2
global_route -guide_file [file join $script_dir "route.guide"]
detailed_route \
    -output_drc [file join $script_dir "route_drc.rpt"] \
    -output_maze [file join $script_dir "route_maze.log"]

# Fill all legal row gaps with PDK-provided spacer cells before stream-out.
filler_placement {sg13g2_fill_1 sg13g2_fill_2}

# CTS/hold repair and filler insertion add cells after the initial PDN setup.
source [file join $script_dir power_ports.tcl]
connect_uart_supplies

if {[file exists $ihp_rcx_rules]} {
    define_process_corner -ext_model_index 0 $ihp_rcx_rules
    extract_parasitics -ext_model_file $ihp_rcx_rules
    write_spef [file join $script_dir "route.spef"]
} else {
    puts "WARNING: IHP OpenRCX rules not found; route.spef will not be generated."
}

write_def [file join $script_dir "route.def"]
write_db [file join $script_dir "route.odb"]
write_verilog [file join $script_dir "route_output.v"]
puts "IHP routing complete: [file join $script_dir route.def]"
puts "PASS openroad_route.tcl"
exit
