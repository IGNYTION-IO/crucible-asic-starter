// ===============================================================================
// Ignytion IO - CRUCIBLE CORE
// Copyright (c) 2026 Ignytion IO. All rights reserved.
// Author      : IGNYTION_TECH
// File        : hw/protocols/i2c/01_rtl/i2c_core.v
// Created     : 2026-10-03
// Description : Protocol reference integration and teaching build.
// Upstream copyright and licence notices below remain applicable.
// ===============================================================================
// Ignytion integration wrapper around OpenCores I2C, pinned in README.md.
// Upstream modules retain their original copyright and disclaimer.
module i2c_core #(parameter ARST_LVL = 1'b0) (
    input wire wb_clk_i, wb_rst_i, arst_i,
    input wire [2:0] wb_adr_i,
    input wire [7:0] wb_dat_i,
    output wire [7:0] wb_dat_o,
    input wire wb_we_i, wb_stb_i, wb_cyc_i,
    output wire wb_ack_o, wb_inta_o,
    input wire scl_pad_i, sda_pad_i,
    output wire scl_pad_o, scl_padoen_o, sda_pad_o, sda_padoen_o
);
    // Asynchronous assertion, clock-synchronous release into the controller.
    wire reset_n = arst_i ^ ARST_LVL;
    (* async_reg = "true" *) reg [1:0] reset_release;
    always @(posedge wb_clk_i or negedge reset_n)
        if (!reset_n) reset_release <= 2'b00;
        else reset_release <= {reset_release[0], 1'b1};
    i2c_master_top #(.ARST_LVL(1'b0)) controller (
        .wb_clk_i(wb_clk_i), .wb_rst_i(wb_rst_i), .arst_i(reset_release[1]),
        .wb_adr_i(wb_adr_i), .wb_dat_i(wb_dat_i), .wb_dat_o(wb_dat_o),
        .wb_we_i(wb_we_i), .wb_stb_i(wb_stb_i), .wb_cyc_i(wb_cyc_i),
        .wb_ack_o(wb_ack_o), .wb_inta_o(wb_inta_o),
        .scl_pad_i(scl_pad_i), .scl_pad_o(scl_pad_o), .scl_padoen_o(scl_padoen_o),
        .sda_pad_i(sda_pad_i), .sda_pad_o(sda_pad_o), .sda_padoen_o(sda_padoen_o)
    );
endmodule
