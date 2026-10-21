// ===============================================================================
// Ignytion IO - CRUCIBLE CORE
// Copyright (c) 2026 Ignytion IO. All rights reserved.
// Author      : IGNYTION_TECH
// File        : hw/protocols/spi/02_sim/test.v
// Created     : 2026-10-03
// Description : Protocol reference integration and teaching build.
// Upstream copyright and licence notices below remain applicable.
// ===============================================================================
`timescale 1ns/1ps
module spi_case #(parameter MODE=0, parameter HALF=2)(output reg done=0);
    localparam CPOL = MODE >= 2;
    localparam CPHA = MODE % 2;
    reg clk=0, rst_n=0, tx_valid=0, miso=0;
    reg [7:0] tx_byte=0, response_byte=0, observed_mosi=0;
    wire tx_ready, rx_valid, sclk, mosi, cs_n;
    wire [7:0] rx_byte;
    integer samples=0, edges=0, received=0, trial;
    reg active=0;
    always #5 clk=~clk;
    spi_core #(.SPI_MODE(MODE), .CLKS_PER_HALF_BIT(HALF)) dut(.*);
    // Independent peripheral model: drive the complemented byte, not loopback.
    always @(posedge sclk or negedge sclk) begin
        if (active && !cs_n) begin
            edges=edges+1;
            if ((CPHA == 0 && sclk != CPOL) || (CPHA == 1 && sclk == CPOL)) begin
                #1;
                observed_mosi={observed_mosi[6:0],mosi};
                samples=samples+1;
            end else if (samples < 8) miso=response_byte[7-samples];
        end
    end
    always @(posedge clk) begin
        #2;
        if (rx_valid && active) begin
            if ($test$plusargs("inject_failure") && MODE==0) begin
                if (rx_byte !== (response_byte ^ 8'h01)) $fatal(1,"SPI injected mismatch rejected");
            end else if (rx_byte !== response_byte) $fatal(1,"SPI mode %0d RX mismatch expected %h actual %h",MODE,response_byte,rx_byte);
            if (samples!=8 || observed_mosi!==tx_byte) $fatal(1,"SPI mode %0d MOSI mismatch",MODE);
            received=received+1;
        end
    end
    initial begin
        repeat(4) @(negedge clk); rst_n=1;
        wait(tx_ready); #2;
        if (sclk!==CPOL || cs_n!==1) $fatal(1,"SPI idle polarity/select mismatch");
        for(trial=0;trial<256;trial=trial+1) begin
            @(negedge clk);
            tx_byte=trial; response_byte=~trial; miso=response_byte[7];
            samples=0; edges=0; observed_mosi=0; active=1; tx_valid=1;
            @(negedge clk); tx_valid=0;
            wait(received==trial+1); wait(tx_ready); #2;
            if(edges!=16 || cs_n!==1 || sclk!==CPOL) $fatal(1,"SPI clock count/idle mismatch mode %0d edges %0d",MODE,edges);
            active=0;
            repeat(2) @(negedge clk);
        end
        // Abort during a transfer. Check reset assertion and synchronized release.
        @(negedge clk); tx_valid=1;
        @(negedge clk); tx_valid=0;
        repeat(5) @(negedge clk); rst_n=0;
        #2;
        if(cs_n!==1 || sclk!==CPOL || rx_valid!==0) $fatal(1,"SPI abort reset mismatch");
        repeat(3) @(negedge clk); rst_n=1;
        wait(tx_ready); #2;
        if(cs_n!==1 || sclk!==CPOL) $fatal(1,"SPI reset release mismatch");
        done=1;
    end
endmodule
module tst_bench_top;
    wire [3:0] done;
    genvar mode;
    generate for(mode=0;mode<4;mode=mode+1) begin:g
        spi_case #(.MODE(mode),.HALF(2+mode%2)) testcase(.done(done[mode]));
    end endgenerate
    initial begin
        $dumpfile("02_sim/spi_core.vcd"); $dumpvars(0,tst_bench_top);
        #3000000; $fatal(1,"SPI regression timeout");
    end
    initial begin
        wait(&done);
        $display("PASS SPI regression: all 256 bytes, all four modes, independent MOSI/MISO, divider, CS and reset abort");
        $finish;
    end
endmodule
