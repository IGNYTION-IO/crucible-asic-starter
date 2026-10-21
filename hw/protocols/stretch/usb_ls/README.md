<!--
===============================================================================
 Ignytion IO - CRUCIBLE CORE
 Copyright (c) 2026 Ignytion IO. All rights reserved.
 Author      : IGNYTION_TECH
 File        : hw/protocols/stretch/usb_ls/README.md
 Created     : 2026-10-03
 Description : Low-speed USB reference integration; upstream notices preserved.
 ===============================================================================
-->
# Low-speed USB student reference

Imported m1nl/usb_hid_host at e49217661b275554807760d4e12097b0f189316a,
https://github.com/m1nl/usb_hid_host . Apache-2.0 notices and original authors remain.

The core is a restricted HID host, FULL_SPEED=0, with a 12 MHz clock and
1.5 Mbit/s low-speed D+/D- signalling. Separate input/output/output-enable pins
require suitable external electrical pads/transceiver, host pull-downs, protected
5 V VBUS supply and connector circuitry. This RTL does not implement analog USB
pad circuitry or certify USB electrical compliance.

The wrapper embeds the pinned synchronous 1024 x 4-bit microcode ROM and exposes
HID report/debug bytes. Interface rst is synchronous active high; cs must remain
high for normal execution. Inputs use the upstream sampled filter, not a
signoff-certified CDC implementation.

## Verification boundary

The independent directed diagnostic-ROM simulation has passed. The imported upstream cocotb test is not
accepted: it has no decisive assertions, uses full-speed clocking, ignores
requested low-speed bit durations and does not add bit stuffing. Our independent
Icarus bench exercises low-speed NRZI encoding/decoding and stuffing using
a directed diagnostic ROM through the same real top-level core.

The production HID enumeration ROM is retained, but full enumeration across
real devices is not yet verified. Source review found no receive CRC validation:
the upstream engine discards CRC bytes and identifies PIDs from only the low
nibble. This is a restricted educational reference, not a USB-compliant
general-purpose emulator or a Tiny Tapeout submission. These limitations must
not be disguised by passing line-code tests.

## Reproduce the reference build

In WSL login Bash: igny init; unset CRUCIBLE_ENV; cd to this unit, then
make lint sim, make flow, and node verify_build.mjs all.
The unit binds and locks Icarus, Verilator, Yosys, OpenROAD and klayout-stream.
Supply IHP_PDK_ROOT for the pinned SG13G2 PDK when reproducing elsewhere.

The directed diagnostic-ROM test passed independent NRZI TX/RX, stuffing,
two-bit SE0 EOP, eight payload bytes and reset, and its injected byte mismatch
failed. This is not a production enumeration-ROM regression.

SG13G2 synthesis maps 2608 functional cells. The reference die is 500 x 500 um.
Routed TT setup/hold is +76.96/+0.16 ns and slow +73.83/+0.21 ns at 83.333333 ns.
The router DRC report is empty. Independently decoded GDS contains 4,371,854
bytes, 49 structures and 49,699 placed standard-cell instances including fillers.
Coordinates/orientations agree with DEF, and a deliberate mismatch fails even
under Python optimization. The raw SHA256 receipt is run-specific.

This is not a Tiny Tapeout submission.
Foundry DRC/LVS, DFT, antenna and full-chip signoff are not performed.
See GATES.md and repository .context.md for live progress.

