# Protocol blocks

Each protocol is built and verified on its own before it is integrated in `hw/core/`.
Read the matching spec in `Specs/` before writing RTL or a testbench.

| Folder | Protocol | Priority | Spec |
| --- | --- | --- | --- |
| `uart/` | UART | Required | `Specs/UART_Specification.pdf` |
| `spi/` | SPI | Required | `Specs/SPI_specification.pdf` |
| `i2c/` | I2C | Required | `Specs/I2C_specification_latest.pdf` |
| `stretch/usb_ls/` | USB low-speed | Stretch | `Specs/USB_low_speed.pdf` |
| `stretch/ethernet/` | 10BASE-T Ethernet | Stretch | `Specs/Ethernet_Specification.pdf` |
