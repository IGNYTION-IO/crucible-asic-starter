# Preserve the routed geometry and make the physical supply interface explicit.
proc connect_uart_supplies {} {
    add_global_connection -net VDD -pin_pattern {^VDD$} -power
    add_global_connection -net VSS -pin_pattern {^VSS$} -ground
    global_connect
    set block [ord::get_db_block]
    foreach {name type} {VDD POWER VSS GROUND} {
        set net [$block findNet $name]
        if {$net == "NULL"} {error "Missing supply net $name"}
        set terminal [$block findBTerm $name]
        if {$terminal == "NULL"} {
            set terminal [odb::dbBTerm_create $net $name]
        }
        $terminal setSigType $type
        $terminal setIoType INOUT
        if {[llength [$terminal getBPins]] > 0} {continue}
        set found 0
        foreach wire [$net getSWires] {
            foreach box [$wire getWires] {
                if {[$box isVia]} {continue}
                set layer [$box getTechLayer]
                if {[$layer getName] != "TopMetal2"} {continue}
                set pin [odb::dbBPin_create $terminal]
                $pin setPlacementStatus FIRM
                odb::dbBox_create $pin $layer [$box xMin] [$box yMin] [$box xMax] [$box yMax]
                set found 1
                break
            }
            if {$found} {break}
        }
        if {!$found} {error "No existing TopMetal2 supply geometry for $name"}
    }
}
