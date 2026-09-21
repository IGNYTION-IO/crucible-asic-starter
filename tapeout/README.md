# tapeout

Tiny Tapeout IHP (SG13G2) submission files: `info.yaml`, pinout, and the files the
Tiny Tapeout GitHub Actions expect. Copy these from the official
`ttihp-verilog-template` so the format matches their checks exactly.

Crucible has produced a GDS on IHP SG13G2 end to end, so the PDK path is confirmed
working. `PDK_ROOT` in each unit's `06_floorplanning` onward Makefiles is still
left blank here pending the exact install path to standardize on; until that's
filled in, fall back to the Tiny Tapeout GitHub Actions flow for GDS if a local
run is blocked.
