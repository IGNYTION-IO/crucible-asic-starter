# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/stretch/ethernet/04_synthesis/synth.tcl
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
yosys abc -liberty $ihp_liberty_slow -D 400000
yosys hilomap -hicell sg13g2_tiehi L_HI -locell sg13g2_tielo L_LO
yosys clean
yosys read_liberty -lib -ignore_miss_func $ihp_liberty_typ
yosys check -assert
yosys stat -liberty $ihp_liberty_typ
yosys write_json [file join $script_dir synth.json]
yosys write_verilog -noattr -noexpr [file join $script_dir synth_output.v]
set sdc [open [file join $script_dir constraints.sdc] w]
puts $sdc {# Ignytion IO - CRUCIBLE CORE; IGNYTION_TECH; 2026-10-03; generated reference constraints.}
puts $sdc {create_clock -name tx_clk -period 400.0 [get_ports mii_tx_clk]}
puts $sdc {create_clock -name rx_clk -period 400.0 [get_ports mii_rx_clk]}
puts $sdc {set_input_delay -clock tx_clk -max 2.0 [get_ports {rst tx_data* tx_valid tx_last tx_user}]}
puts $sdc {set_input_delay -clock tx_clk -min 0.2 [get_ports {rst tx_data* tx_valid tx_last tx_user}]}
puts $sdc {set_input_delay -clock rx_clk -max 2.0 -add_delay [get_ports rst]}
puts $sdc {set_input_delay -clock rx_clk -min 0.2 -add_delay [get_ports rst]}
puts $sdc {set_input_delay -clock rx_clk -max 2.0 [get_ports {mii_rxd* mii_rx_dv mii_rx_er}]}
puts $sdc {set_input_delay -clock rx_clk -min 0.2 [get_ports {mii_rxd* mii_rx_dv mii_rx_er}]}
puts $sdc {set_output_delay -clock tx_clk -max 2.0 [get_ports {mii_txd* mii_tx_en mii_tx_er tx_ready tx_underflow}]}
puts $sdc {set_output_delay -clock tx_clk -min 0.2 [get_ports {mii_txd* mii_tx_en mii_tx_er tx_ready tx_underflow}]}
puts $sdc {set_output_delay -clock rx_clk -max 2.0 [get_ports {rx_data* rx_valid rx_last rx_user rx_bad_frame rx_bad_fcs}]}
puts $sdc {set_output_delay -clock rx_clk -min 0.2 [get_ports {rx_data* rx_valid rx_last rx_user rx_bad_frame rx_bad_fcs}]}
puts $sdc {set_clock_uncertainty 0.1 [all_clocks]}
puts $sdc {# Reference I/O budgets; actual PHY timing and system CDC remain integration work.}
close $sdc
puts "PASS SG13G2 synthesis"
