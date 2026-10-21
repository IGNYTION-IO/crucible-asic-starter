# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/i2c/04_synthesis/synth.tcl
# Created     : 2026-10-03
# Description : Protocol reference integration and teaching build.
# Upstream copyright and licence notices below remain applicable.
# ===============================================================================
set script_dir [file dirname [file normalize [info script]]]
set project_root [file dirname $script_dir]
source [file join $project_root flow_config.tcl]
foreach rtl $rtl_files {yosys read_verilog -I[file join $project_root 01_rtl] $rtl}
yosys hierarchy -check -top $top
yosys synth -top $top -flatten
yosys dfflibmap -liberty $ihp_liberty_slow
yosys abc -liberty $ihp_liberty_slow -D 20000
yosys hilomap -hicell sg13g2_tiehi L_HI -locell sg13g2_tielo L_LO
yosys clean
yosys read_liberty -lib -ignore_miss_func $ihp_liberty_typ
yosys check -assert
yosys stat -liberty $ihp_liberty_typ
yosys write_json [file join $script_dir synth.json]
yosys write_verilog -noattr -noexpr [file join $script_dir synth_output.v]
set sdc [open [file join $script_dir constraints.sdc] w]
puts $sdc "create_clock -name core_clk -period $period \[get_ports $clock_port\]"
puts $sdc {set nonclock [get_ports {wb_rst_i arst_i wb_adr_i* wb_dat_i* wb_we_i wb_stb_i wb_cyc_i scl_pad_i sda_pad_i}]}
puts $sdc {set_input_delay -clock core_clk -max 2.0 $nonclock}
puts $sdc {set_input_delay -clock core_clk -min 0.2 $nonclock}
puts $sdc {set_output_delay -clock core_clk -max 2.0 [all_outputs]}
puts $sdc {set_output_delay -clock core_clk -min 0.2 [all_outputs]}
puts $sdc {set_clock_uncertainty 0.1 [all_clocks]}
puts $sdc {# Bus pad inputs are asynchronous; I/O delay values are a reference budget only.}
puts $sdc {# Reset release is synchronized in i2c_core; no blanket reset false path.}
close $sdc
puts "PASS SG13G2 synthesis"
