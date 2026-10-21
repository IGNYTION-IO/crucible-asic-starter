<!--
===============================================================================
Ignytion IO - CRUCIBLE CORE
Copyright (c) 2026 Ignytion IO. All rights reserved.
Author      : IGNYTION_TECH
File        : hw/protocols/stretch/ethernet/README.md
Created     : 2026-10-03
Description : 10 Mbit MII MAC reference and verification boundaries.
===============================================================================
-->
# 10 Mbit Ethernet student MAC reference

Imported Alex Forencich verilog-ethernet at
77320a9471d19c7dd383914bc049e02d9f4f1ffb,
https://github.com/alexforencich/verilog-ethernet . Original MIT copyright and
permission notices remain in all imported RTL and UPSTREAM_LICENSE.txt.

Integration instantiates the upstream transmit/receive engines in fixed MII mode.
PHY-supplied TX and RX clocks are independent 2.5 MHz clocks. Each transfers one
four-bit nibble, giving 10 Mbit/s. This matches Microchip's MII definition:
https://ww1.microchip.com/downloads/en/DeviceDoc/00002436B.pdf, section 3.12.

The core supplies preamble/SFD, minimum-frame zero padding, CRC32 generation and
checking and a fixed 12-byte inter-frame gap. It needs an external analog PHY,
magnetics and connector. No Manchester/analog 10BASE-T transceiver, MDIO
management, link negotiation or half-duplex collision/retry logic is supplied.
This is a full-duplex MAC reference, not a complete Ethernet network stack.

TX data/valid/last/user and ready belong to mii_tx_clk. RX data/valid/last/user
belong to mii_rx_clk. Receive output has no ready/backpressure input: downstream
must continuously accept it. rst is synchronous active high in both domains;
system reset generation/release and cross-domain consumers remain integration work.

The upstream generic LFSR elaboration remained expensive even after selecting
REDUCTION in both instances and the module default. Interrupted logs are retained.
Integration replaces it with ethernet_crc32, a fixed eight-step reflected CRC32
byte transform with the same consumed state_out update. Its unused data_out is
tied to zero, so it is not a generic drop-in replacement for other LFSR consumers.
The original LFSR is preserved under 03_verification for reference, outside the
active RTL source glob. Independent frame/FCS tests are rerun after this change.
The dedicated CRC regression compares zero, all 40 one-hot input basis vectors
and 256 deterministic mixed vectors against the preserved upstream state_out,
checks ASCII "123456789" produces CRC32 CBF43926, and rejects an injected mismatch.
The pin identifies the upstream source baseline, not byte-identical integration.

## Reproduce

In WSL login Bash: igny init; unset CRUCIBLE_ENV; cd to this unit.
Then make lint sim, make flow, and node verify_build.mjs all.
crucible.lock pins Icarus, Verilator, Yosys, OpenROAD and klayout-stream.
Use IHP_PDK_ROOT to supply the matching SG13G2 PDK on another machine.

Independent tests drive different RX and TX clocks and do not loop TX into RX.
They assert TX preamble/SFD, low-nibble-first ordering, padding, payload and
independent CRC32 for 14-, 60- and 256-byte inputs; RX is driven with independent
60- and 256-byte frames plus a corrupt-FCS frame. Corrupt FCS raises the expected
error, and deliberately changing an expected RX byte causes a fatal failure.
Reset quiescence is checked. Underflow, RXER, runt/oversize, collision and real
board/PHY operation are not claimed as covered.

## Physical status

Mapped synthesis contains 1042 functional cells, excluding scope metadata.
The reference die is 500 x 500 um. Extracted TT setup/hold is +396.77/+0.18 ns
and slow +395.00/+0.27 ns; no VIOLATED markers remain and router DRC is empty.
Independently decoded GDS has 3,219,696 bytes, 47 structures and 53,628 placed
standard-cell instances including fillers. Placements/orientations agree with
DEF and a deliberate export mismatch fails under Python optimization.
Consult GATES.md and repository .context.md for acceptance, not command exit alone.
Reference timing constraints are 400 ns per MII clock with explicit domain I/O
budgets. The current SDC does not declare these clocks asynchronous, so reported
slacks use its reference synchronous relationship, not arbitrary real PHY clock
phase/frequency. The common reset input is budgeted in both domains, but its safe
delivery/release and cross-domain paths are not certified by these reports.
They do not certify any particular PHY's setup/hold specification.
Foundry DRC/LVS, DFT, antenna and full-chip signoff are not performed.
This is not a Tiny Tapeout submission or the Jane Street programmable emulator.
