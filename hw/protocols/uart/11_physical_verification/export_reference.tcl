read_db $env(UART_CHECK_DATABASE)
set block [ord::get_db_block]
foreach name {VDD VSS} {
    set terminal [$block findBTerm $name]
    if {$terminal == "NULL" || [llength [$terminal getBPins]] == 0} {
        error "Missing physical supply boundary pin: $name"
    }
}
foreach instance [$block getInsts] {
    foreach terminal [$instance getITerms] {
        set name [[$terminal getMTerm] getName]
        if {$name ni {VDD VSS}} {continue}
        set net [$terminal getNet]
        if {$net == "NULL" || [$net getName] != $name} {
            error "Incorrect $name connection on [$instance getName]"
        }
    }
}
write_verilog -include_pwr_gnd [file join $env(UART_CHECK_RESULTS) reference.power.v]
puts {PASS powered routed reference export}
exit
