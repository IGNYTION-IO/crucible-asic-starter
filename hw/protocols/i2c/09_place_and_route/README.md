<!--
===============================================================================
Ignytion IO - CRUCIBLE CORE
Copyright (c) 2026 Ignytion IO. All rights reserved.
Author      : IGNYTION_TECH
File        : hw/protocols/i2c/09_place_and_route/README.md
Created     : 2026-10-03
Description : I2C clock tree and routing reference-stage guide.
===============================================================================
-->
# I2C Clock tree and routing

CTS buffers the clock and repairs hold/design rules. Detailed routing creates route.def, route.odb, route.spef and the router DRC report. These are router-rule checks, not foundry signoff.

Run from this existing stage directory in an initialized WSL Igny shell:\n\n```bash\nmake\n```\n\nThe Make recipe returns to the protocol root and invokes the actual stage-aware run_flow.sh.

See [the unit README](../README.md) for source provenance, prerequisites, interfaces, tested cases, reproduction and physical-evidence limitations. Keep the upstream licence notices. Tool-generated artifacts use their required formats; provenance is recorded in the source headers, unit README, tool lock and validation receipt rather than corrupting binary/standard-format payloads.
