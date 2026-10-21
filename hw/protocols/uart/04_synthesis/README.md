<!--
===============================================================================
Ignytion IO - CRUCIBLE CORE
Copyright (c) 2026 Ignytion IO. All rights reserved.
Author      : IGNYTION_TECH
File        : hw/protocols/uart/04_synthesis/README.md
Created     : 2026-10-03
Description : UART mapped synthesis reference-stage guide.
===============================================================================
-->
# UART Mapped synthesis

Yosys maps the selected top to SG13G2 cells, inserts tie cells and writes synth.json, synth_output.v and constraints.sdc. Unresolved cells and latch cells are rejected by the evidence checker.

Run from this existing stage directory in an initialized WSL Igny shell:\n\n```bash\nmake\n```\n\nThe Make recipe returns to the protocol root and invokes the actual stage-aware run_flow.sh.

See [the unit README](../README.md) for source provenance, prerequisites, interfaces, tested cases, reproduction and physical-evidence limitations. Keep the upstream licence notices. Tool-generated artifacts use their required formats; provenance is recorded in the source headers, unit README, tool lock and validation receipt rather than corrupting binary/standard-format payloads.
