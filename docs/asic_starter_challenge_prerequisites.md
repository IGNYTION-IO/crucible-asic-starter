# Prerequisites

What a team should know before starting. The team as a whole should cover all three
areas, and each member should be strong in at least one.

| Role | Owns |
| --- | --- |
| RTL lead | ISA or state machine, datapath, pin map |
| Verification lead | Testbenches, reference models, formal and random testing |
| Flow / integration lead | Tiny Tapeout template, Crucible flow, timing, area, GDS |

## 1. RTL-to-GDS

**Design box:** IHP 130nm SG13G2 via Tiny Tapeout · 6 × 4 tiles (~0.7 mm²) ·
26 pins (8 in, 8 out, 8 bidirectional, `clk`, `rst_n`) · single clock, active-low reset.

- **RTL:** synthesizable Verilog, FSMs, counters, shift registers, no latches,
  reset handling, input synchronizers, bidirectional and open-drain pins
- **Verification:** self-checking testbenches that fail on mismatch, waveform debug,
  reference models, basic Python for cocotb. Good to have: constrained-random,
  coverage, formal
- **Physical design:** know what each stage in Chip       Lifecycle does and produces:
  lint, RTL, sim, verification, synthesis, DFT, floorplan, placement, STA,
  place and route, GDS, DRC/LVS. Be able to read a timing report and a DRC report

## 2. Protocols

References are in `specs/`.

| Protocol | Status | Must know | Pins |
| --- | --- | --- | --- |
| UART | Mandatory | Frame format (start, data LSB first, parity, stop; 8N1), baud divisor, 16× oversampling, framing/parity/overrun errors | 2 |
| SPI | Mandatory | SCLK/MOSI/MISO/CS, modes 0 to 3 (CPOL/CPHA), controller vs peripheral, bit order, CS timing, full duplex | 4 |
| I2C | Mandatory | Open-drain SDA/SCL, START/STOP/repeated START, ACK/NACK, 7-bit address + R/W, clock stretching, arbitration, 100 and 400 kbit/s | 2 bidir |
| Low-speed USB | Optional | 1.5 Mbit/s differential D+/D−, NRZI, bit stuffing, SE0/EOP, packets and CRC (USB 2.0 ch. 7 and 8) | 2 bidir |
| 10 Mbit Ethernet | Optional | Manchester at 10 Mbit/s (20 MHz+ clock), frame format and CRC32, external analog/PHY (IEEE 802.3) | 2 to 4 |

Take on the optional protocols only after UART, SPI and I2C pass.

## 3. Crucible knowledge

Crucible is the EDA platform by Ignytion IO. The whole flow, from RTL to GDS, runs through it,
so every team member uses the same tools and versions. Learn it from these resources:

| Resource | Link |
| --- | --- |
| Video tutorials | [youtube.com/@Ignytionio](https://www.youtube.com/@Ignytionio) |
| Digital design examples | [github.com/CRUCIBLE-WORKBENCH/digital-design](https://github.com/CRUCIBLE-WORKBENCH/digital-design) |
| Analog design examples | [github.com/CRUCIBLE-WORKBENCH/analog-design](https://github.com/CRUCIBLE-WORKBENCH/analog-design) |
| Whitepapers | [whitepaper.ignytion.io](https://whitepaper.ignytion.io/) |


Questions: info@ignytion.io
