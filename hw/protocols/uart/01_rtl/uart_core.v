// ===============================================================================
// Ignytion IO - CRUCIBLE CORE
// Copyright (c) 2026 Ignytion IO. All rights reserved.
// Author      : IGNYTION_TECH
// File        : hw/protocols/uart/01_rtl/uart_core.v
// Created     : 2026-10-03
// Description : Protocol reference integration and teaching build.
// Upstream copyright and licence notices: see LICENSE.forencich.
// ===============================================================================
// Alex Forencich UART integration; original MIT notices: see LICENSE.forencich.
module uart_core (
    input wire clk, rst,
    input wire [7:0] tx_data,
    input wire tx_valid,
    output wire tx_ready,
    output wire [7:0] rx_data,
    output wire rx_valid,
    input wire rx_ready,
    input wire rxd,
    output wire txd, tx_busy, rx_busy, rx_overrun_error, rx_frame_error,
    input wire [15:0] prescale
);
    // External RX is asynchronous. Reset is active-high and synchronous.
    (* async_reg = "true" *) reg [1:0] rx_sync;
    always @(posedge clk)
        if (rst) rx_sync <= 2'b11;
        else rx_sync <= {rx_sync[0],rxd};
    uart controller (
        .clk(clk), .rst(rst), .s_axis_tdata(tx_data), .s_axis_tvalid(tx_valid),
        .s_axis_tready(tx_ready), .m_axis_tdata(rx_data), .m_axis_tvalid(rx_valid),
        .m_axis_tready(rx_ready), .rxd(rx_sync[1]), .txd(txd),
        .tx_busy(tx_busy), .rx_busy(rx_busy), .rx_overrun_error(rx_overrun_error),
        .rx_frame_error(rx_frame_error), .prescale(prescale)
    );
endmodule
