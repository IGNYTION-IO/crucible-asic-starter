# hw

All hardware, organised by unit and then by RTL-to-GDS stage.

```
hw/
├── protocols/   one folder per protocol, each hardened on its own
└── core/        full chip: all protocols integrated, the design we tape out
```

Every unit (each protocol, and `core/`) is a self-contained RTL-to-GDS flow with the
same 12 numbered stages and the same top-level `Makefile` orchestrating them -
mirroring the reference flow in `demos/apb`:

| Stage | Contents | Output artifact |
| --- | --- | --- |
| `00_lint` | Verilator lint | `lint_report.txt` |
| `01_rtl` | Verilog source | `<module>.v` |
| `02_sim` | Directed Icarus Verilog testbench | `<module>_sim.out`, `<module>.vcd` |
| `03_verification` | cocotb / self-checking Python verification | `results/*.xml` |
| `04_synthesis` | Yosys synthesis against the IHP SG13G2 stdcells | `synth_output.v`, `constraints.sdc` |
| `05_dft` | Design-for-test (placeholder until needed) | - |
| `06_floorplanning` | OpenROAD floorplan | `floorplan.def`, `floorplan.odb` |
| `07_placement` | OpenROAD placement | `placement.def`, `placement.odb` |
| `08_sta` | OpenROAD/OpenSTA timing | `timing_report.txt` |
| `09_place_and_route` | Clock-tree synthesis + routing | `route.def`, `route_output.v`, `route.spef` |
| `10_gds` | GDS streamout | `<Module>.gds` |
| `11_physical_verification` | Magic DRC + Netgen LVS | `results/physical_verification_status.txt` |

Run a full unit's flow with `make -C hw/<unit> flow`, or a single stage with
`make -C hw/<unit>/<stage>`. Each stage's Makefile calls the tool through
`igny run` so it always resolves to the environment's locked tool versions.

The IHP SG13G2 PDK path (`PDK_ROOT`) used from `06_floorplanning` onward is not
yet wired in - see `tapeout/README.md`.
