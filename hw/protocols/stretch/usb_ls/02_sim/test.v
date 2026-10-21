// ===============================================================================
// Ignytion IO - CRUCIBLE CORE
// Copyright (c) 2026 Ignytion IO. All rights reserved.
// Author      : IGNYTION_TECH
// File        : hw/protocols/stretch/usb_ls/02_sim/test.v
// Created     : 2026-10-03
// Description : Low-speed USB reference integration; upstream notices preserved.
// ===============================================================================
`timescale 1ns/1ps
module tst_bench_top;
 reg clk=0,rst=1,cs=1,dp_i=0,dm_i=1;
 always #41.666667 clk=~clk;
 wire dp_o,dm_o,oe;
 wire [63:0] report_data,regs;
 wire [1:0] typ;
 wire valid,err,busy;
 usb_ls_core #(.ROM_FILE("02_sim/diagnostic_rom.mem")) dut(
  .clk(clk),.rst(rst),.cs(cs),.usb_dp_i(dp_i),.usb_dm_i(dm_i),
  .usb_dp_o(dp_o),.usb_dm_o(dm_o),.usb_oe(oe),
  .device_type(typ),.report_valid(valid),.connection_error(err),.busy(busy),
  .report_data(report_data),.hid_registers(regs));
 integer count=0, bits=0, ones=0, tx_count=0, rx_count=0, k, j;
 reg previous=0, decoded;
 reg [7:0] acc=0;
 reg [7:0] expected_tx[0:6];
 reg [7:0] expected_rx[0:7];
 reg [7:0] rx_seen[0:7];
 always @(posedge clk) begin
  #1;
  if (dut.controller.ukpstb) begin
   if (rx_count>=8) $fatal(1,"Unexpected extra payload byte");
   rx_seen[rx_count]=dut.controller.ukpdat;
   rx_count=rx_count+1;
  end
 end
 task cycles(input integer n);
  repeat(n) @(negedge clk);
 endtask
 task sendbit(input bit b);
  begin
   if(!b) begin dp_i=~dp_i;dm_i=~dm_i;end
   cycles(8);
  end
 endtask
 integer txones=0;
 task sendbyte(input reg [7:0] b);
  integer m;
  begin
   for(m=0;m<8;m=m+1) begin
    sendbit(b[m]);
    if(b[m]) txones=txones+1;else txones=0;
    if(txones==6)begin sendbit(0);txones=0;end
   end
  end
 endtask
 initial begin
  // Expected stream is independent of the DUT's microcode implementation.
  expected_tx[0]=8'h80;expected_tx[1]=8'hc3;expected_tx[2]=8'hff;
  expected_tx[3]=8'h00;expected_tx[4]=8'ha5;
  expected_tx[5]=8'haa;expected_tx[6]=8'hbb;
  for(k=0;k<8;k=k+1)expected_rx[k]=(k==0)?8'hff:(k*37)^8'ha5;
  cycles(12);rst=0;
  // First K transition begins SYNC. Sample at the middle of each 8-clock bit.
  wait(oe && dp_o==1 && dm_o==0);
  cycles(4);
  previous=0;ones=0;bits=0;acc=0;tx_count=0;
  while(dp_o!=dm_o)begin
   decoded=(dp_o==previous);
   previous=dp_o;
   if(ones==6)begin
    if(decoded!==0)$fatal(1,"TX missing stuffed zero");
    ones=0;
   end else begin
    acc[bits]=decoded;
    bits=bits+1;
    if(decoded)ones=ones+1;else ones=0;
    if(bits==8)begin
     if(tx_count>=7 || acc!==expected_tx[tx_count])$fatal(1,"TX byte mismatch index=%0d got=%02x",tx_count,acc);
     tx_count=tx_count+1;bits=0;acc=0;
    end
   end
   cycles(8);
  end
  if(tx_count!=7 || bits!=0)$fatal(1,"TX packet length mismatch");
  // EOP must contain two SE0 bit intervals; line then returns to J.
  if(dp_o!==0 || dm_o!==0)$fatal(1,"TX illegal EOP");
  cycles(8);
  if(dp_o!==0 || dm_o!==0)$fatal(1,"TX short EOP");
  cycles(8);
  if(dp_o!==0 || dm_o!==1)$fatal(1,"TX missing EOP J");
  wait(!oe);cycles(20);
  // Independent device drives valid low-speed polarity/NRZI/stuffing.
  dp_i=0;dm_i=1;txones=0;
  sendbyte(8'h80);sendbyte(8'hc3);
  for(j=0;j<8;j=j+1)sendbyte(expected_rx[j]);
  sendbyte(8'h00);sendbyte(8'h00); // CRC ignored by imported engine; not CRC compliance evidence
  dp_i=0;dm_i=0;cycles(16);dp_i=0;dm_i=1;cycles(100);
  if(rx_count!=8)$fatal(1,"RX payload count %0d",rx_count);
  if($test$plusargs("inject_failure"))expected_rx[3]=expected_rx[3]^1;
  for(j=0;j<8;j=j+1)if(rx_seen[j]!==expected_rx[j])
   $fatal(1,"USB RX mismatch index=%0d got=%02x expected=%02x",j,rx_seen[j],expected_rx[j]);
  rst=1;cycles(8);
  if(oe!==0 || typ!==0)$fatal(1,"Reset did not release line/device state");
  $display("PASS USB LS regression: 12MHz/8-clocks-per-bit, NRZI TX/RX, bit stuffing, EOP, payload and reset");
  $finish;
 end
 initial begin #2000000;$fatal(1,"USB test timeout");end
endmodule

