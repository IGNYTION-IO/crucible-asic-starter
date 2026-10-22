create_clock -name core_clk -period 20.0 [get_ports clk]
set nonclock [get_ports {rst tx_data* tx_valid rx_ready rxd prescale*}]
set_input_delay -clock core_clk -max 2.0 $nonclock
set_input_delay -clock core_clk -min 0.2 $nonclock
set_output_delay -clock core_clk -max 2.0 [all_outputs]
set_output_delay -clock core_clk -min 0.2 [all_outputs]
set_clock_uncertainty 0.1 [all_clocks]
# Bus pad inputs are asynchronous; I/O delay values are a reference budget only.
# Reset release is synchronized in uart_core; no blanket reset false path.
