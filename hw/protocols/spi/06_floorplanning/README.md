<!--
===============================================================================
Ignytion IO - CRUCIBLE CORE
Copyright (c) 2026 Ignytion IO. All rights reserved.
Author      : IGNYTION_TECH
File        : hw/protocols/spi/06_floorplanning/README.md
Created     : 2026-10-03
Description : SPI floorplan reference-stage guide.
===============================================================================
-->
# SPI Floorplan

Creates the 300 by 300 micrometre reference die, rows, I/O locations and power grid from mapped synthesis. This is not a Tiny Tapeout floorplan.

Run from this existing stage directory in an initialized WSL Igny shell:\n\n```bash\nmake\n```\n\nThe Make recipe returns to the protocol root and invokes the actual stage-aware run_flow.sh.

See [the unit README](../README.md) for source provenance, prerequisites, interfaces, tested cases, reproduction and physical-evidence limitations. Keep the upstream licence notices. Tool-generated artifacts use their required formats; provenance is recorded in the source headers, unit README, tool lock and validation receipt rather than corrupting binary/standard-format payloads.
