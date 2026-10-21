// ===============================================================================
// Ignytion IO - CRUCIBLE CORE
// Copyright (c) 2026 Ignytion IO. All rights reserved.
// Author      : IGNYTION_TECH
// File        : hw/protocols/uart/02_sim/test.v
// Created     : 2026-10-03
// Description : Protocol reference integration and teaching build.
// Upstream copyright and licence notices below remain applicable.
// ===============================================================================
`timescale 1ns/1ps
module tst_bench_top;
    reg clk=0,rst=1,tx_valid=0,rx_ready=0,rxd=1;
    reg [7:0] tx_data=0;
    reg [15:0] prescale=4;
    wire tx_ready,rx_valid,txd,tx_busy,rx_busy,rx_overrun_error,rx_frame_error;
    wire [7:0] rx_data;
    integer frame_errors=0,overrun_errors=0,trial,divisor,baseline_overruns;
    uart_core dut(.*);
    always #10 clk=~clk;
    always @(posedge clk) begin
        #1;
        if(rx_frame_error) frame_errors=frame_errors+1;
        if(rx_overrun_error) overrun_errors=overrun_errors+1;
    end
    task ticks(input integer n);
        repeat(n) @(negedge clk);
    endtask
    task send_rx(input [7:0] value,input bit stop_ok);
        integer bit_index;
        begin
            @(negedge clk); rxd=0; ticks(8*prescale);
            for(bit_index=0;bit_index<8;bit_index=bit_index+1) begin
                rxd=value[bit_index]; ticks(8*prescale);
            end
            rxd=stop_ok; ticks(8*prescale); rxd=1; ticks(8*prescale);
        end
    endtask
    task check_rx(input [7:0] expected);
        reg [7:0] comparison;
        begin
            wait(rx_valid); #1; comparison=expected;
            if($test$plusargs("inject_failure")) comparison=expected^8'h01;
            if(rx_data!==comparison) $fatal(1,"UART RX mismatch expected %h actual %h",comparison,rx_data);
            // Receiver must preserve its output while the consumer stalls.
            ticks(4);
            if(!rx_valid || rx_data!==expected) $fatal(1,"UART RX backpressure stability failure");
            rx_ready=1; ticks(1); rx_ready=0; #1;
            if(rx_valid) $fatal(1,"UART RX handshake did not clear valid");
        end
    endtask
    task send_tx(input [7:0] value);
        begin
            wait(tx_ready); @(negedge clk); tx_data=value; tx_valid=1;
            @(negedge clk); tx_valid=0;
            wait(!tx_busy); ticks(1);
        end
    endtask
    task check_tx(input [7:0] expected);
        integer bit_index;
        reg [7:0] observed;
        begin
            @(negedge txd); ticks(4*prescale);
            if(txd!==0) $fatal(1,"UART TX start bit failure");
            for(bit_index=0;bit_index<8;bit_index=bit_index+1) begin
                ticks(8*prescale); observed[bit_index]=txd;
            end
            ticks(8*prescale);
            if(txd!==1 || observed!==expected) $fatal(1,"UART TX frame mismatch expected %h actual %h",expected,observed);
        end
    endtask
    initial begin
        $dumpfile("02_sim/uart_core.vcd"); $dumpvars(0,tst_bench_top);
        #20000000; $fatal(1,"UART regression timeout");
    end
    initial begin
        ticks(5); rst=0; ticks(5);
        if(txd!==1 || rx_valid!==0) $fatal(1,"UART reset/idle mismatch");
        // Different TX and RX patterns, independent wire-level models.
        for(trial=0;trial<256;trial=trial+1) begin
            fork
                send_tx(trial[7:0]);
                check_tx(trial[7:0]);
                send_rx(~trial[7:0],1);
                check_rx(~trial[7:0]);
            join
        end
        for(divisor=2;divisor<=7;divisor=divisor+1) begin
            prescale=divisor; ticks(8);
            fork send_tx(8'h96); check_tx(8'h96); send_rx(8'h69,1); check_rx(8'h69); join
        end
        prescale=4;
        if(frame_errors || overrun_errors) $fatal(1,"UART unexpected error during valid frames");
        send_rx(8'h55,0);
        if(frame_errors!=1 || rx_valid) $fatal(1,"UART malformed stop not rejected");
        wait(!rx_busy); ticks(8*prescale);
        // A sustained low malformed stop can look like another START to this
        // receiver. Drain any recovery word before measuring buffer overrun.
        rx_ready=1; ticks(2); rx_ready=0;
        baseline_overruns=overrun_errors;
        // Explicitly exercise the one-word receive buffer overrun contract.
        send_rx(8'h11,1);
        if(!rx_valid || rx_data!==8'h11) $fatal(1,"UART queued receive failure valid=%b data=%h errors=%0d busy=%b",rx_valid,rx_data,frame_errors,rx_busy);
        send_rx(8'h22,1);
        if(overrun_errors!=baseline_overruns+1 || !rx_valid || rx_data!==8'h22) $fatal(1,"UART overrun not signalled count=%0d valid=%b data=%h frames=%0d busy=%b",overrun_errors,rx_valid,rx_data,frame_errors,rx_busy);
        rx_ready=1; ticks(1); rx_ready=0;
        // Reset aborts a frame and returns both interfaces to idle.
        @(negedge clk); tx_valid=1; rxd=0; ticks(5); tx_valid=0; rst=1;
        ticks(2); rxd=1; #1;
        if(txd!==1 || tx_busy || rx_busy || rx_valid) $fatal(1,"UART reset abort failed");
        rst=0; ticks(8);
        fork send_tx(8'ha5); check_tx(8'ha5); send_rx(8'h5a,1); check_rx(8'h5a); join
        $display("PASS UART regression: all 256 bytes, independent full-duplex TX/RX, divisors 2..7, backpressure, framing, overrun and reset");
        $finish;
    end
endmodule
