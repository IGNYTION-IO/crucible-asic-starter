// ===============================================================================
// Ignytion IO - CRUCIBLE CORE
// Copyright (c) 2026 Ignytion IO. All rights reserved.
// Author      : IGNYTION_TECH
// File        : hw/protocols/stretch/ethernet/01_rtl/ethernet_crc32.v
// Created     : 2026-10-03
// Description : Fixed reflected Ethernet CRC32 combinational byte transform.
// ===============================================================================
`default_nettype none
module ethernet_crc32 (
 input wire [7:0] data_in,
 input wire [31:0] state_in,
 output wire [31:0] state_out,
 output wire [7:0] data_out
);
 // Polynomial x^32+x^26+x^23+x^22+x^16+x^12+x^11+x^10+x^8+x^7+x^5+x^4+x^2+x+1.
 wire [31:0] stage [0:8];
 assign stage[0]=state_in^{24'b0,data_in};
 genvar b;
 generate for(b=0;b<8;b=b+1)begin: crc_bit
  assign stage[b+1]=(stage[b]>>1)^(stage[b][0]?32'hedb88320:32'b0);
 end endgenerate
 assign state_out=stage[8];
 // Neither MAC engine consumes data_out.
 assign data_out=8'b0;
endmodule
`default_nettype wire
