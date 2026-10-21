<!--
===============================================================================
Ignytion IO - CRUCIBLE CORE
Copyright (c) 2026 Ignytion IO. All rights reserved.
Author      : IGNYTION_TECH
File        : hw/protocols/i2c/README.md
Created     : 2026-10-03
Description : Protocol reference integration and teaching build.
Upstream copyright and licence notices below remain applicable.
===============================================================================
-->
# I2C reference RTL-to-GDS build

OpenCores I2C master, wrapped as `i2c_core`, implemented as an IHP SG13G2 reference block. This is not a Tiny Tapeout submission top: the full Wishbone/pad interface exceeds that pin budget. It is not a programmable combined protocol emulator.

Source: https://github.com/freecores/i2c at `3b067f00ccced753b0502024766a51f58f3e04bc`. The four `i2c_master_*.v` files are unchanged upstream RTL. Upstream test models preserve their notices; the local bench adds fatal checks, timeout, wrapper integration, separate interrupt wires and two negative controls. The wrapper adds asynchronous assertion with two-clock synchronized reset release. The idle second master is retained from upstream; arbitration is not tested.

## Run under WSL

Run `wsl.exe bash -lic` from Windows, or the following in a WSL login shell:

```bash
igny init
unset CRUCIBLE_ENV
cd /mnt/c/Users/ignyt/Desktop/crucible/Products-and-Dev/dev/Janes_street/crucible-asic-starter/hw/protocols/i2c
igny env create janestreet-i2c                 # once, if absent
igny workspace create --env janestreet-i2c    # once, if marker absent
igny tool install iverilog
igny tool install yosys
igny tool install openroad
igny tool install klayout-stream
igny workspace lock
export IHP_PDK_ROOT="$HOME/.ciel/ciel/ihp-sg13g2/versions/22f43352dd8219f9007eb659e422e0d5fe28c5fb/ihp-sg13g2"
bash run_flow.sh flow
```

The PDK must already be installed; override `IHP_PDK_ROOT` for another location. The pinned revision is external to the Igny tool lock. `igny tool install klayout` failed in this environment because its pip package has no expected executable; `klayout-stream` supplies the working stream-out converter. No Crucible internals were modified.

Stages: `sim`/`verify`, `synth`, `physical`, `gds`, `flow`. `physical` requires mapped synthesis; `gds` requires routed DEF. The complete `flow` runs these in order. `make flow` is an equivalent WSL entry point.

## Evidence and limitations

- Simulation asserts register values, A5/5A byte transfers, and NACK for an invalid slave-memory address. Repeated START and forced clock stretching have indirect completion/data coverage only. Third/fourth reads of uninitialized model memory are not data-verified. This is not exhaustive protocol verification.
- Synthesis maps to SG13G2 using the slow library. Clock target is 20 ns / 50 MHz; I/O delays are a 2 ns reference budget, not an integration contract. Bus pad inputs are asynchronous; full CDC and reset recovery/removal signoff are not established.
- OpenROAD produces placed/CTS/routed databases, DEF, SPEF and post-route timing. Final report data must be taken from the logs, not assumed from the PASS stage marker. Typical and slow timing reports are reference measurements, not multi-corner signoff.
- `10_gds/i2c_core.gds` contains routed top geometry and actual PDK standard-cell layouts. `validate_gds.py` independently parses binary records and compares cell names/counts/placement coordinates and orientations with routed DEF. It does not establish electrical equivalence or foundry-rule compliance.
- OpenROAD routing DRC is not foundry DRC. Foundry DRC, LVS, antenna, tap/endcap strategy, scan/DFT, IR drop/EM, padframe and tapeout signoff are not performed. A fanout violation, if reported, remains an explicit limitation.

Shared task log and Claude review: repository-root `.context.md`.
