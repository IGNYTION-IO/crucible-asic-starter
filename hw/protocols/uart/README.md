<!--
===============================================================================
Ignytion IO - CRUCIBLE CORE
Copyright (c) 2026 Ignytion IO. All rights reserved.
Author      : IGNYTION_TECH
File        : hw/protocols/uart/README.md
Created     : 2026-10-03
Description : UART reference integration, reproduction and evidence boundaries.
===============================================================================
-->
# UART reference RTL-to-GDS build

Upstream https://github.com/alexforencich/verilog-uart pinned at `1b867e53af738e4a8bc7c839ca2f1c07f40382dc`. Original MIT notices are retained in `01_rtl/LICENSE.forencich`. Ignytion headers describe this integration and do not replace upstream ownership.

`uart_core` implements full-duplex 8N1 UART with independent transmit/receive ready-valid byte interfaces. TX and RX send the least significant bit first. `rst` is synchronous and active high. A two-flop input synchronizer samples external `rxd`. RX errors are pulse outputs, not software counters. The bench counts those pulses.

## Interface and rate

`clk`, `rst`, `tx_data[7:0]`, `tx_valid`, `tx_ready`, `rx_data[7:0]`, `rx_valid`, `rx_ready`, `rxd`, `txd`, `tx_busy`, `rx_busy`, `rx_overrun_error`, `rx_frame_error`, `prescale[15:0]`.

Hold TX valid/data until ready accepts the byte. RX valid/data remain available until the receiver accepts them. Keep prescale stable while either direction is busy. Bit period is `8 * prescale` clock cycles, so nominal baud is `f_clk / (8 * prescale)`. The validated divisors are 2 through 7. Other divisors, tolerance to arbitrary baud mismatch, parity and alternate frame formats are outside this regression. At 50 MHz, prescale 54 gives approximately 115740.74 baud, an illustrative calculation rather than a tested operating point.

## Verification and known limitations

Independent serial TX and RX models check all 256 byte values in full duplex at prescale 4. The separate prescale 2..7 sweep uses fixed TX 0x96 and RX 0x69; this is not all bytes at all divisors. Receive backpressure, malformed STOP/framing error, receive-buffer overrun, reset abort and a subsequent transfer are checked. A deliberately wrong RX expectation must fail. The malformed-STOP source can remain low long enough to resemble a new START and produce a later recovery word. The bench explicitly drains that recovery word before isolating the overrun case. Do not claim break detection or recovery certification. This is no CDC/metastability signoff.

## WSL Igny reproduction

Run `igny init`, `unset CRUCIBLE_ENV`, and enter this existing UART directory. The workspace selects `janestreet-uart`. Create that environment/workspace only if absent. Bind or install `iverilog`, `verilator`, `yosys`, `openroad` and `klayout-stream`, then run `igny workspace lock`. Set `IHP_PDK_ROOT` to the installed IHP SG13G2 revision `22f43352dd8219f9007eb659e422e0d5fe28c5fb`, or use the script's user-relative default.

Run `make flow` from WSL, or `bash run_flow.sh lint` followed by `bash run_flow.sh flow`. Individual stages: `sim`, `synth`, `floorplan`, `place`, `cts`, `route`, `sta`, `physical`, `gds`. `physical` runs floorplan through routed extraction and TT/slow STA. `gds` exports `10_gds/uart_core.gds` with `klayout-stream` and independently decodes it against DEF placements, cell identities and orientations. Run `make signoff` for block DRC/LVS before inspecting all evidence with `node verify_build.mjs all`; missing routed/GDS prerequisites are built automatically.

## Physical evidence boundary

Target core clock: 50 MHz, period 20 ns. Die: 300 x 300 micrometres. Read live `08_sta/timing_report.txt`, `08_sta/timing_slow.txt` and `10_gds/validation.json` for final measured values. Raw GDS SHA256 is a run-specific byte fingerprint because stream-out embeds timestamps. Router-rule DRC and structural GDS export do not establish foundry manufacturability or electrical equivalence.

`make signoff` runs the IHP KLayout main DRC deck and strict power-aware Netgen LVS. The physical database includes VDD/VSS boundary pins and reconnects supply pins on cells inserted by CTS/hold repair and filler placement. Reports, input hashes and the compared scope are recorded in `11_physical_verification/results/physical_verification.json`. `make -C 11_physical_verification check-controls` also exercises deliberate DRC and supply-connectivity failures. See [physical verification](11_physical_verification/README.md) for runtime requirements and report details.

This is not a Tiny Tapeout submission top and is not the required general-purpose programmable emulator. Jane Street requires its CMOS5L template, while this SG13G2 flow is a student reference. The separate density and antenna decks, scan/DFT, padframe, CDC signoff, IR/EM, ERC and foundry/full-chip release signoff are not performed. `make dft` deliberately fails because scan/DFT is unimplemented.

Lint warnings from upstream sizing/initializers remain visible in `00_lint/lint_report.txt`. Successful elaboration does not mean warning-free RTL.
