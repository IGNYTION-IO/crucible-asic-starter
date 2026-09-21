# tapeout

Tiny Tapeout IHP (SG13G2) submission files: `info.yaml`, pinout, and the files the
Tiny Tapeout GitHub Actions expect. Copy these from the official
`ttihp-verilog-template` so the format matches their checks exactly.

The IHP SG13G2 PDK install path inside Crucible is not yet confirmed (see the
kickoff notes). Until it is, `PDK_ROOT` in each unit's `06_floorplanning` onward
Makefiles is left blank, and GDS is produced via the Tiny Tapeout GitHub Actions
flow as a fallback.
