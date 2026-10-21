// ===============================================================================
// Ignytion IO - CRUCIBLE CORE
// Copyright (c) 2026 Ignytion IO. All rights reserved.
// Author      : IGNYTION_TECH
// File        : hw/protocols/stretch/usb_ls/01_rtl/usb_ls_core.v
// Created     : 2026-10-03
// Description : Low-speed USB reference integration; upstream notices preserved.
// ===============================================================================
`default_nettype none
module usb_ls_core #(
    parameter ROM_FILE = "01_rtl/usb_hid_host_rom.mem"
)(
    input wire clk, rst, cs,
    input wire usb_dm_i, usb_dp_i,
    output wire usb_dm_o, usb_dp_o, usb_oe,
    output wire [1:0] device_type,
    output wire report_valid, connection_error, busy,
    output wire [63:0] report_data, hid_registers
);
    wire [9:0] rom_addr;
    wire [3:0] rom_data;
    wire rom_en;
    reg [3:0] rom [0:1023];
    reg [3:0] rom_q;
    initial $readmemh(ROM_FILE, rom);
    always @(posedge clk) if (rom_en) rom_q <= rom[rom_addr];
    assign rom_data = rom_q;
    usb_hid_host #(.FULL_SPEED(0)) controller (
        .clk(clk), .reset(rst), .cs(cs),
        .usb_dm_i(usb_dm_i), .usb_dp_i(usb_dp_i),
        .usb_dm_o(usb_dm_o), .usb_dp_o(usb_dp_o), .usb_oe(usb_oe),
        .typ(device_type), .full_report(report_valid),
        .connerr(connection_error), .busy(busy),
        .dbg_hid_report(report_data), .dbg_hid_regs(hid_registers),
        .rom_addr(rom_addr), .rom_dout(rom_data), .rom_en(rom_en)
    );
endmodule
`default_nettype wire

