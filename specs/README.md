# Specs

Reference protocol specifications. Each PDF is the source of truth for the
corresponding block in `hw/protocols/`; read it before writing RTL or a testbench.

| File | Protocol | Priority | Implemented in |
| --- | --- | --- | --- |
| `UART_Specification.pdf` | UART | Required | `hw/protocols/uart/` |
| `SPI_specification.pdf` | SPI | Required | `hw/protocols/spi/` |
| `I2C_specification_latest.pdf` | I2C (NXP UM10204) | Required | `hw/protocols/i2c/` |
| `USB_low_speed.pdf` | USB low-speed | Stretch | `hw/protocols/stretch/usb_ls/` |
| `Ethernet_Specification.pdf` | 10BASE-T Ethernet | Stretch | `hw/protocols/stretch/ethernet/` |

## Still needed

These aren't in this folder yet and block RTL work until written:

- **Pin map** - which of the 26 Tiny Tapeout pins (`ui_in[7:0]`, `uo_out[7:0]`,
  `uio[7:0]`, `clk`, `rst_n`) each protocol uses, and how the chip is reprogrammed
  after fabrication.
- **Architecture decision** - CPU-style ISA vs. programmable state machine, and
  the resulting instruction/state-table format.
- **Sample transaction per protocol** - one waveform each testbench in
  `hw/protocols/*/03_verification/` must reproduce, so tests aren't written
  against ambiguous timing.

Freeze target for the pin map and architecture decision: 2026-10-11.

## Other sources

These PDFs are a snapshot for convenience. If a question isn't answered here, or
you want the latest revision, go to the canonical spec instead:

| Protocol | Canonical source |
| --- | --- |
| UART | No single formal standard, treat the 8N1 framing convention as the reference |
| SPI | Motorola SPI Block Guide (no single official standard either) |
| I2C | NXP UM10204, I2C-bus specification and user manual |
| USB low-speed | USB 2.0 specification (usb.org), low-speed section |
| 10BASE-T Ethernet | IEEE 802.3, 10BASE-T section |

If a team member's copy differs from what's checked in here, the newer one wins.
Replace the PDF and update the table above.
