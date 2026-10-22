<!--
===============================================================================
Ignytion IO - CRUCIBLE CORE
Copyright (c) 2026 Ignytion IO. All rights reserved.
Author      : IGNYTION_TECH
File        : hw/protocols/uart/11_physical_verification/README.md
Created     : 2026-10-03
Description : UART foundry verification status reference-stage guide.
===============================================================================
-->
# UART physical verification

`make signoff` runs the installed IHP SG13G2 KLayout **main DRC deck**, extracts
the layout with the IHP LVS deck in hierarchical mode, and compares it against
the powered routed netlist with Netgen and the IHP setup file. A unique match
and equivalent top-level pin lists are required. VDD/VSS and MOS body
connections are retained; no power-pin stripping, implicit supply merging or
top-port mismatch exclusion is used.

Run from the UART root in an initialized WSL Igny shell:

```bash
igny run make signoff
igny run make -C 11_physical_verification check-controls
node verify_build.mjs signoff
```

The controls add an undersized Metal2 shape and disconnect one reference
instance's VDD. Both must be rejected. Missing tools, failed processes, missing
reports and changed inputs return nonzero. Reports and input/rule hashes are
written under `results/`; `make clean` removes the known generated files.
If the routed database or GDS is missing after cleaning, `make signoff` first
runs the existing `make flow` target to rebuild the prerequisites. Existing
inputs that fail verification are retained and cause a nonzero result.

The UART environment needs `make`, `openroad`, `yosys` and `netgen`. A full
KLayout application is also required; the stream-only package does not include
the DRC engine. The existing extracted application is resolved at
`~/Crucible/tools/klayout-gui/root`; `KLAYOUT_GUI_ROOT` can select a compatible
package root. The receipt records the application version used. The default
PDK is `~/.ciel/ciel/ihp-sg13g2/versions/22f43352dd8219f9007eb659e422e0d5fe28c5fb/ihp-sg13g2`;
`IHP_PDK_ROOT` overrides it.

The physical database must contain VDD/VSS boundary pins on the existing power
grid and supply connections for every inserted cell. `power_ports.tcl` in the
routing stage establishes these after hold repair and filler insertion.

This is **block physical verification**, not a foundry release approval. The
separate density and antenna decks, ERC, IR/EM, DFT, padframe and full-chip
integration are not performed by this target. No manufacturability claim is
supported.

See [the unit README](../README.md) for source provenance, prerequisites, interfaces, tested cases, reproduction and physical-evidence limitations. Keep the upstream licence notices. Tool-generated artifacts use their required formats; provenance is recorded in the source headers, unit README, tool lock and validation receipt rather than corrupting binary/standard-format payloads.
