create_clock -name core_clk -period 83.333333 [get_ports clk]
set nonclock [get_ports {rst cs usb_dm_i usb_dp_i}]
set_input_delay -clock core_clk -max 2.0 $nonclock
set_input_delay -clock core_clk -min 0.2 $nonclock
set_output_delay -clock core_clk -max 2.0 [all_outputs]
set_output_delay -clock core_clk -min 0.2 [all_outputs]
set_clock_uncertainty 0.1 [all_clocks]
# Bus pad inputs are asynchronous; I/O delay values are a reference budget only.
# Reset is synchronous to clk; system integration must supply synchronized release.
