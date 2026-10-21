// ===============================================================================
// Ignytion IO - CRUCIBLE CORE
// Copyright (c) 2026 Ignytion IO. All rights reserved.
// Author      : IGNYTION_TECH
// File        : hw/protocols/spi/01_rtl/spi_core.v
// Created     : 2026-10-03
// Description : Protocol reference integration and teaching build.
// Upstream copyright and licence notices below remain applicable.
// ===============================================================================
// Nandland SPI master integration. See README.md and LICENSE.nandland.
// SPI mode and divider are elaboration-time parameters, not runtime registers.
module spi_core #(parameter SPI_MODE=0, parameter CLKS_PER_HALF_BIT=2) (
    input wire clk, rst_n,
    input wire [7:0] tx_byte,
    input wire tx_valid,
    output wire tx_ready,
    output wire [7:0] rx_byte,
    output wire rx_valid,
    output wire sclk, mosi, cs_n,
    input wire miso
);
    (* async_reg = "true" *) reg [1:0] reset_release;
    always @(posedge clk or negedge rst_n)
        if (!rst_n) reset_release <= 2'b00;
        else reset_release <= {reset_release[0], 1'b1};
    SPI_Master #(.SPI_MODE(SPI_MODE), .CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT)) master (
        .i_Rst_L(reset_release[1]), .i_Clk(clk),
        .i_TX_Byte(tx_byte), .i_TX_DV(tx_valid), .o_TX_Ready(tx_ready),
        .o_RX_DV(rx_valid), .o_RX_Byte(rx_byte),
        .o_SPI_Clk(sclk), .i_SPI_MISO(miso), .o_SPI_MOSI(mosi)
    );
    assign cs_n = !reset_release[1] || (tx_ready && !tx_valid);
endmodule
