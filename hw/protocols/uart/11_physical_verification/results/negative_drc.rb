layout = RBA::Layout.new
layout.dbu = 0.001
cell = layout.create_cell("uart_core_drc_negative")
cell.shapes(layout.layer(10, 0)).insert(RBA::Box.new(0, 0, 10, 10))
layout.write($output)
