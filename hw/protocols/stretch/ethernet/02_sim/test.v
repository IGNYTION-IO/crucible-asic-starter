// ===============================================================================
// Ignytion IO - CRUCIBLE CORE
// Copyright (c) 2026 Ignytion IO. All rights reserved.
// Author      : IGNYTION_TECH
// File        : hw/protocols/stretch/ethernet/02_sim/test.v
// Created     : 2026-10-03
// Description : Independent 10 Mbit MII frame/CRC checks and negative control.
// ===============================================================================
`timescale 1ns/1ps
module tst_bench_top;
 reg tx_clk=0,rx_clk=0,rst=1;
 always #200 tx_clk=~tx_clk;
 initial begin #73;forever #200 rx_clk=~rx_clk;end
 reg [7:0] tx_data=0;
 reg tx_valid=0,tx_last=0,tx_user=0;
 wire tx_ready;
 reg [3:0] mii_rxd=0;
 reg mii_rx_dv=0,mii_rx_er=0;
 wire [3:0] mii_txd;
 wire mii_tx_en,mii_tx_er;
 wire [7:0] rx_data;
 wire rx_valid,rx_last,rx_user,tx_underflow,rx_bad_frame,rx_bad_fcs;
 ethernet_core dut(.rst(rst),.mii_tx_clk(tx_clk),.mii_rx_clk(rx_clk),
  .tx_data(tx_data),.tx_valid(tx_valid),.tx_last(tx_last),.tx_user(tx_user),
  .tx_ready(tx_ready),.rx_data(rx_data),.rx_valid(rx_valid),
  .rx_last(rx_last),.rx_user(rx_user),.mii_rxd(mii_rxd),
  .mii_rx_dv(mii_rx_dv),.mii_rx_er(mii_rx_er),
  .mii_txd(mii_txd),.mii_tx_en(mii_tx_en),.mii_tx_er(mii_tx_er),
  .tx_underflow(tx_underflow),.rx_bad_frame(rx_bad_frame),.rx_bad_fcs(rx_bad_fcs));
 function automatic [7:0] pattern(input integer index,input integer seed);
  pattern=(index*37+seed)&255;
 endfunction
 function automatic [31:0] crc_byte(input [31:0] crc,input [7:0] data);
  integer b;reg [31:0] c;
  begin
   c=crc;
   for(b=0;b<8;b=b+1)begin
    if(c[0]^data[b])c=(c>>1)^32'hedb88320;else c=c>>1;
   end
   crc_byte=c;
  end
 endfunction
 reg [7:0] captured[0:1599];
 integer capture_count=0,frame_count=0,tx_errors=0,underflows=0;
 reg low_half=1,was_en=0;reg [3:0] low_nibble;
 always @(posedge tx_clk)begin
  #1;
  if(tx_underflow)underflows=underflows+1;
  if(mii_tx_er)tx_errors=tx_errors+1;
  if(mii_tx_en)begin
   if(!was_en)begin capture_count=0;low_half=1;end
   if(low_half)low_nibble=mii_txd;
   else begin
    if(capture_count>=1600)$fatal(1,"Oversize TX frame");
    captured[capture_count]={mii_txd,low_nibble};
    capture_count=capture_count+1;
   end
   low_half=~low_half;
  end else if(was_en)begin
   if(!low_half)$fatal(1,"Odd TX nibble count");
   frame_count=frame_count+1;
  end
  was_en=mii_tx_en;
 end
 integer rx_index=0,rx_seed=0,rx_length=0,rx_frames=0,bad_fcs_count=0,bad_frame_count=0;
 reg expect_bad=0;
 reg [7:0] expected_byte;
 always @(posedge rx_clk)begin
  #1;
  if(rx_bad_fcs)bad_fcs_count=bad_fcs_count+1;
  if(rx_bad_frame)bad_frame_count=bad_frame_count+1;
  if(rx_valid)begin
   expected_byte=pattern(rx_index,rx_seed);
   if($test$plusargs("inject_failure") && rx_index==3)expected_byte=expected_byte^1;
   if(rx_data!==expected_byte)$fatal(1,"Ethernet RX mismatch index=%0d got=%02x",rx_index,rx_data);
   if(rx_index>=rx_length)$fatal(1,"Extra RX payload");
   if(rx_user && !rx_last)$fatal(1,"RX error outside last byte");
   rx_index=rx_index+1;
   if(rx_last)begin
    if(rx_index!=rx_length || rx_user!==expect_bad)$fatal(1,"RX frame length/error mismatch");
    rx_frames=rx_frames+1;
   end
  end
 end
 task tx_frame(input integer length,input integer seed);
  integer i,old_frames,padded;
  reg [7:0] data;
  reg [31:0] crc;
  begin
   old_frames=frame_count;
   @(negedge tx_clk);
   for(i=0;i<length;i=i+1)begin
    tx_valid=1;tx_data=pattern(i,seed);tx_last=(i==length-1);
    @(posedge tx_clk);
    while(!tx_ready)@(posedge tx_clk);
    @(negedge tx_clk);
   end
   tx_valid=0;tx_last=0;
   wait(frame_count==old_frames+1);
   padded=(length<60)?60:length;
   if(capture_count!=padded+12)$fatal(1,"TX wire length %0d expected %0d",capture_count,padded+12);
   for(i=0;i<7;i=i+1)if(captured[i]!==8'h55)$fatal(1,"Bad preamble");
   if(captured[7]!==8'hd5)$fatal(1,"Bad SFD");
   crc=32'hffffffff;
   for(i=0;i<padded;i=i+1)begin
    data=(i<length)?pattern(i,seed):0;
    if(captured[8+i]!==data)$fatal(1,"TX payload/padding mismatch %0d",i);
    crc=crc_byte(crc,data);
   end
   crc=~crc;
   for(i=0;i<4;i=i+1)if(captured[8+padded+i]!==((crc>>(i*8))&255))$fatal(1,"TX independent FCS mismatch");
   repeat(30)@(negedge tx_clk);
  end
 endtask
 task rx_wire_byte(input [7:0] b);
  begin
   mii_rxd=b[3:0];@(negedge rx_clk);
   mii_rxd=b[7:4];@(negedge rx_clk);
  end
 endtask
 task rx_frame(input integer length,input integer seed,input bit corrupt);
  integer i,old_frames;
  reg [31:0] crc;
  reg [7:0] data;
  begin
   old_frames=rx_frames;rx_index=0;rx_length=length;rx_seed=seed;expect_bad=corrupt;
   @(negedge rx_clk);mii_rx_dv=1;crc=32'hffffffff;
   for(i=0;i<7;i=i+1)rx_wire_byte(8'h55);
   rx_wire_byte(8'hd5);
   for(i=0;i<length;i=i+1)begin
    data=pattern(i,seed);rx_wire_byte(data);crc=crc_byte(crc,data);
   end
   crc=~crc;if(corrupt)crc=crc^1;
   for(i=0;i<4;i=i+1)rx_wire_byte((crc>>(8*i))&255);
   mii_rx_dv=0;mii_rxd=0;
   repeat(20)@(negedge rx_clk);
   if(rx_frames!=old_frames+1)$fatal(1,"RX frame did not complete");
  end
 endtask
 initial begin
  repeat(10)@(negedge tx_clk);rst=0;
  tx_frame(14,8'h23);tx_frame(60,8'h79);tx_frame(256,8'hb1);
  if(tx_errors!=0 || underflows!=0)$fatal(1,"TX unexpected error");
  rx_frame(60,8'h14,0);rx_frame(256,8'hd4,0);
  if(bad_fcs_count!=0 || bad_frame_count!=0)$fatal(1,"Valid RX error");
  rx_frame(60,8'h53,1);
  if(bad_fcs_count!=1 || bad_frame_count!=1)$fatal(1,"Corrupt FCS not rejected");
  rst=1;repeat(10)@(negedge tx_clk);
  if(mii_tx_en!==0 || rx_valid!==0)$fatal(1,"Reset did not quiesce");
  $display("PASS ETHERNET regression: independent 10M MII clocks, preamble/SFD, padding, payload, CRC32 TX/RX, corrupt FCS and reset");
  $finish;
 end
 initial begin #5000000;$fatal(1,"Ethernet test timeout");end
endmodule

