// ===============================================================================
// Ignytion IO - CRUCIBLE CORE
// Copyright (c) 2026 Ignytion IO. All rights reserved.
// Author      : IGNYTION_TECH
// File        : hw/protocols/stretch/ethernet/01_rtl/ethernet_core.v
// Created     : 2026-10-03
// Description : 10 Mbit MII MAC reference integration; original notices preserved.
// ===============================================================================

`default_nettype none
module ethernet_core (
 input wire rst, mii_tx_clk, mii_rx_clk,
 input wire [7:0] tx_data,
 input wire tx_valid, tx_last, tx_user,
 output wire tx_ready,
 output wire [7:0] rx_data,
 output wire rx_valid, rx_last, rx_user,
 input wire [3:0] mii_rxd,
 input wire mii_rx_dv, mii_rx_er,
 output wire [3:0] mii_txd,
 output wire mii_tx_en, mii_tx_er,
 output wire tx_underflow, rx_bad_frame, rx_bad_fcs
);
 wire [7:0] tx_gmii;
 assign mii_txd=tx_gmii[3:0];
 // Fixed MII mode: each clock transfers four bits. At 2.5 MHz this is 10 Mbit/s.
 axis_gmii_tx #(.ENABLE_PADDING(1),.MIN_FRAME_LENGTH(64)) tx(
  .clk(mii_tx_clk),.rst(rst),.s_axis_tdata(tx_data),
  .s_axis_tvalid(tx_valid),.s_axis_tready(tx_ready),
  .s_axis_tlast(tx_last),.s_axis_tuser(tx_user),
  .gmii_txd(tx_gmii),.gmii_tx_en(mii_tx_en),.gmii_tx_er(mii_tx_er),
  .ptp_ts(96'b0),.clk_enable(1'b1),.mii_select(1'b1),
  .cfg_ifg(8'd12),.cfg_tx_enable(1'b1),.error_underflow(tx_underflow)
 );
 axis_gmii_rx rx(
  .clk(mii_rx_clk),.rst(rst),.gmii_rxd({4'b0,mii_rxd}),
  .gmii_rx_dv(mii_rx_dv),.gmii_rx_er(mii_rx_er),
  .m_axis_tdata(rx_data),.m_axis_tvalid(rx_valid),
  .m_axis_tlast(rx_last),.m_axis_tuser(rx_user),
  .ptp_ts(96'b0),.clk_enable(1'b1),.mii_select(1'b1),
  .cfg_rx_enable(1'b1),.error_bad_frame(rx_bad_frame),
  .error_bad_fcs(rx_bad_fcs)
 );
endmodule
`default_nettype wire

