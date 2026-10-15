# crucible-asic-starter

A reproducible starter for open-source ASIC design, powered by Crucible.

Fork it, and go from RTL to GDS without fighting your environment - toolchain, PDK, and verification stack resolved and pinned for you.

Built as a community starter for the **Jane Street protocol-emulator ASIC competition**. Targets the Tiny Tapeout IHP 130nm (CMOS5L) flow.

## Quickstart

```sh
igny env create janestreet
igny workspace create --path . --env janestreet
igny tool install iverilog
igny tool install verilator
igny tool install yosys
igny tool install cocotb
igny tool install gtkwave
igny workspace lock

make -C hw/protocols/uart lint sim
```

No Conda fights, no PDK hunt, no version drift. The one-command `igny init` /
`igny build` flow is the target shape for this repo, not yet the current one -
see [Status](#status).

## Repository layout

```
crucible-asic-starter/
├── Specs/                   reference protocol specifications (PDF)
├── docs/                    prerequisites.md: what a team needs to know before starting
├── hw/
│   ├── protocols/           each protocol built and verified on its own
│   │   ├── uart/
│   │   ├── spi/
│   │   ├── i2c/
│   │   └── stretch/         usb_ls/, ethernet/
│   └── core/                full chip: all protocols integrated (what we tape out)
└── tapeout/                 Tiny Tapeout IHP submission files
```

Every unit in `hw/` (each protocol, and `core/`) is a self-contained flow with the same
12 numbered stages and a `Makefile` orchestrating them (`make -C hw/<unit> flow`):

```
00_lint → 01_rtl → 02_sim → 03_verification → 04_synthesis → 05_dft →
06_floorplanning → 07_placement → 08_sta → 09_place_and_route → 10_gds → 11_physical_verification
```

See `hw/README.md` for what each stage takes in and the artifact it produces.

## Status

Work in progress - first public release coming soon.

- [x] Protocol reference specs (`Specs/`)
- [x] 12-stage RTL-to-GDS flow scaffolded per protocol and for the integrated core (`hw/`)
- [ ] Pin map and architecture (ISA vs. state machine) frozen - see `Specs/README.md`
- [ ] RTL for any protocol
- [ ] IHP SG13G2 PDK wired into Crucible (`PDK_ROOT`) - see `tapeout/README.md`
- [ ] Tiny Tapeout submission files (`tapeout/info.yaml`, pinout)
- [ ] `igny init` / `igny build` one-command flow

---

_Not affiliated with or endorsed by Jane Street. "Jane Street" is a trademark of Jane Street Group, LLC._
