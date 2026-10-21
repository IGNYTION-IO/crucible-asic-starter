# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/spi/07_placement/openroad_placement.tcl
# Created     : 2026-10-03
# Description : Protocol reference integration and teaching build.
# Upstream copyright and licence notices below remain applicable.
# ===============================================================================
# IHP SG13G2 global and detailed placement for spi_core.

set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ..]]
source [file join $project_root flow_config.tcl]
set_thread_count 4

set floorplan_db [file join $project_root "06_floorplanning" "floorplan.odb"]
set sdc [file join $project_root "04_synthesis" "constraints.sdc"]
foreach required [list $floorplan_db $sdc] {
    if {![file exists $required]} {
        puts stderr "Missing prerequisite: $required"
        exit 1
    }
}

read_db $floorplan_db
read_liberty $ihp_liberty_typ
read_sdc $sdc
set_wire_rc -signal -layer Metal2

global_placement -density 0.55
estimate_parasitics -placement
repair_design -slew_margin 10 -cap_margin 10 -max_utilization 60
detailed_placement
check_placement -verbose

write_def [file join $script_dir "placement.def"]
write_db [file join $script_dir "placement.odb"]
puts "IHP placement complete: [file join $script_dir placement.odb]"
puts "PASS openroad_placement.tcl"
exit
