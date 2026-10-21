<!--
===============================================================================
Ignytion IO - CRUCIBLE CORE
Copyright (c) 2026 Ignytion IO. All rights reserved.
Author      : IGNYTION_TECH
File        : hw/protocols/uart/10_gds/README.md
Created     : 2026-10-03
Description : UART routed gds export reference-stage guide.
===============================================================================
-->
# UART Routed GDS export

klayout-stream combines routed DEF and actual PDK cell GDS. The independent binary decoder compares cell identities, placements and orientations. validation.json describes the live export. A raw hash is run-specific, not timestamp-independent reproducibility.

Run from this existing stage directory in an initialized WSL Igny shell:\n\n```bash\nmake\n```\n\nThe Make recipe returns to the protocol root and invokes the actual stage-aware run_flow.sh.

See [the unit README](../README.md) for source provenance, prerequisites, interfaces, tested cases, reproduction and physical-evidence limitations. Keep the upstream licence notices. Tool-generated artifacts use their required formats; provenance is recorded in the source headers, unit README, tool lock and validation receipt rather than corrupting binary/standard-format payloads.
