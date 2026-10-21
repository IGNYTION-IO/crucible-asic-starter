// ===============================================================================
// Ignytion IO - CRUCIBLE CORE
// Copyright (c) 2026 Ignytion IO. All rights reserved.
// Author      : IGNYTION_TECH
// File        : hw/protocols/stretch/ethernet/03_verification/crc_equivalence.v
// Created     : 2026-10-03
// Description : Compare consumed CRC state output with preserved upstream RTL.
// ===============================================================================
`timescale 1ns/1ps
`default_nettype none
module crc_equivalence;
 reg [31:0] state_in;
 reg [7:0] data_in;
 wire [31:0] fixed_state, upstream_state;
 reg [39:0] vector_bits;
 reg [31:0] sequence_state;
 integer i, checks;
 reg inject;
 ethernet_crc32 fixed_crc(.data_in(data_in), .state_in(state_in),
   .state_out(fixed_state), .data_out());
 lfsr #(.LFSR_WIDTH(32), .LFSR_POLY(32'h04c11db7),
   .LFSR_CONFIG("GALOIS"), .LFSR_FEED_FORWARD(0), .REVERSE(1),
   .DATA_WIDTH(8), .STYLE("REDUCTION")) upstream_crc (
   .data_in(data_in), .state_in(state_in), .state_out(upstream_state), .data_out());
 task check_vector;
  input [39:0] bits;
  reg [31:0] expected;
  begin
   {state_in, data_in}=bits;
   #1;
   expected=upstream_state;
   if(inject && checks==3) expected=expected^32'b1;
   if(fixed_state !== expected) $fatal(1,"CRC state equivalence mismatch at vector %0d",checks);
   checks=checks+1;
  end
 endtask
 initial begin
  inject=$test$plusargs("inject_failure"); checks=0;
  check_vector(40'b0);
  for(i=0;i<40;i=i+1) check_vector(40'b1<<i);
  vector_bits=40'h5729a10e6b;
  for(i=0;i<256;i=i+1)begin
   vector_bits={vector_bits[38:0],vector_bits[39]^vector_bits[35]^vector_bits[20]^vector_bits[0]};
   check_vector(vector_bits);
  end
  // Standard ASCII "123456789", reflected CRC32, initial/final XOR all ones.
  sequence_state=32'hffffffff;
  for(i=0;i<9;i=i+1)begin
   state_in=sequence_state; data_in=8'h31+i;
   #1; sequence_state=fixed_state;
  end
  if((~sequence_state)!==32'hcbf43926) $fatal(1,"CRC32 known check vector mismatch");
  $display("PASS CRC equivalence: %0d upstream vectors and CRC32 known check", checks);
  $finish;
 end
endmodule
`default_nettype wire
