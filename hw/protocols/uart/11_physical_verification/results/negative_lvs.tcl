lvs {{/mnt/c/Users/ignyt/Desktop/crucible/Products-and-Dev/dev/Janes_street/crucible-asic-starter/hw/protocols/uart/11_physical_verification/results/layout.spice} uart_core} {{/mnt/c/Users/ignyt/Desktop/crucible/Products-and-Dev/dev/Janes_street/crucible-asic-starter/hw/protocols/uart/11_physical_verification/results/negative_reference.spice} uart_core} {/home/hasan/.ciel/ciel/ihp-sg13g2/versions/22f43352dd8219f9007eb659e422e0d5fe28c5fb/ihp-sg13g2/libs.tech/netgen/ihp-sg13g2_setup.tcl} {/mnt/c/Users/ignyt/Desktop/crucible/Products-and-Dev/dev/Janes_street/crucible-asic-starter/hw/protocols/uart/11_physical_verification/results/negative_lvs.log}
set matched [verify unique]
puts "NETGEN_UNIQUE=$matched"
if {$matched != 1} {exit 3}
quit
