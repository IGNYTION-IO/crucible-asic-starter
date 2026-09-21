# Core (full chip)

The integrated protocol emulator: CPU/state machine, program memory, and all protocol
blocks from `hw/protocols/`, wrapped in the Tiny Tapeout top-level (`protocol_emulator_top`).
This is what gets submitted.

`01_rtl/` holds the top module and core logic only; protocol RTL is referenced from
`hw/protocols/*/01_rtl/`, never copied. Stages `00_lint` through `11_physical_verification`
run the same 12-stage flow described in `hw/README.md`, but over the full integrated design.

```sh
make -C hw/core flow     # run every stage, RTL to GDS
make -C hw/core gds      # run just up to GDS streamout
```
