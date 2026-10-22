yosys read_verilog -lib [file join $env(UART_CHECK_RESULTS) reference.blackboxes.v]
yosys read_verilog [file join $env(UART_CHECK_RESULTS) reference.power.v]
yosys hierarchy -check -top uart_core
yosys setattr -mod -unset top
yosys write_spice [file join $env(UART_CHECK_RESULTS) reference.yosys.spice]
