# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/spi/08_sta/openroad_sta.tcl
# Created     : 2026-10-03
# Description : Protocol reference integration and teaching build.
# Upstream copyright and licence notices below remain applicable.
# ===============================================================================
# Post-route timing report for the IHP SG13G2 SPI implementation.

set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ..]]
source [file join $project_root flow_config.tcl]
set_thread_count 4

set route_db [file join $project_root "09_place_and_route" "route.odb"]
set route_spef [file join $project_root "09_place_and_route" "route.spef"]
set sdc [file join $project_root "04_synthesis" "constraints.sdc"]

read_db $route_db
if {[info exists ::env(STA_CORNER)] && $::env(STA_CORNER) eq "slow"} {
    read_liberty $ihp_liberty_slow
} else {
    read_liberty $ihp_liberty_typ
}
read_sdc $sdc
set_propagated_clock [all_clocks]
if {[file exists $route_spef]} {
    read_spef $route_spef
}

report_checks -path_delay min_max -fields {slew cap input_pins} -digits 3
report_worst_slack -max
report_worst_slack -min
report_tns
report_check_types -max_slew -max_fanout -max_capacitance -violators -digits 3
puts "PASS openroad_sta.tcl"
exit
