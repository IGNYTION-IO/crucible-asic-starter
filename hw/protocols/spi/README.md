<!--
===============================================================================
Ignytion IO - CRUCIBLE CORE
Copyright (c) 2026 Ignytion IO. All rights reserved.
Author      : IGNYTION_TECH
File        : hw/protocols/spi/README.md
Created     : 2026-10-03
Description : Protocol reference integration and teaching build.
Upstream copyright and licence notices below remain applicable.
===============================================================================
-->
# SPI reference RTL-to-GDS build

Upstream https://github.com/nandland/spi-master at `1ab581969f8ea2f794072a144b55cd74e5a54f34`, MIT licence retained in `01_rtl/LICENSE.nandland`. `SPI_Master.v` retains upstream logic. Local `spi_core` supplies synchronized reset release and a chip-select envelope.

The hardened block is compile-time SPI mode 0, divider 2 (12.5 MHz SPI clock from 50 MHz core clock). Other modes/dividers are elaboration parameters. Simulation covers all four modes, all 256 byte values, complementary independent MISO data, MOSI order, 16 edges per transfer, idle polarity, CS release, and reset abort. A deliberately wrong receive expectation must fail. Assert `tx_valid` for one clock only when `tx_ready` is high. External slaves must meet the sampled MISO timing budget.

## WSL Igny execution

After `igny init`, `unset CRUCIBLE_ENV` and enter this existing SPI directory. Once only: `igny env create janestreet-spi`, `igny workspace create --env janestreet-spi`, and `igny tool bind iverilog`, `yosys`, `openroad`, `klayout-stream` individually (or install if not acquired). Run `igny workspace lock`. Set `IHP_PDK_ROOT` to the installed SG13G2 PDK revision `22f43352dd8219f9007eb659e422e0d5fe28c5fb`. Then `bash run_flow.sh flow` or `make flow`.

The stage commands are `sim`, `synth`, `physical`, `gds`. They execute simulation/negative control, SG13G2 mapping, floorplan/placement/CTS/route/extraction/TT-and-slow STA, and routed DEF stream-out with independently decoded binary GDS. The top is `spi_core`; output is `10_gds/spi_core.gds`. Raw GDS hashes are run-specific because of timestamps.

## Limits

This is not a Tiny Tapeout submission top and is not the required programmable emulator. The SG13G2 flow is a teaching reference; Jane Street requires the CMOS5L template. Timing and I/O constraints are reference budgets. The independent export checker verifies standard-cell names, counts, coordinates and orientations, plus resolved PDK via references. It does not establish electrical equivalence. OpenROAD routing DRC is only router-rule evidence. Foundry DRC, LVS, antenna, scan/DFT, CDC signoff, IR/EM and full-chip signoff are not performed. See live timing reports for violations; stage completion alone is not timing closure.
