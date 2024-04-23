`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2024 10:38:06 PM
// Design Name: 
// Module Name: qqtop_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
import pq_pkg::*;

module qqtop_tb;
// Declare internal logic 
logic clk, rst, enq, deq, repl;
kv_t lt_i, rt_i, lt_o, rt_o; 
logic enq_o, deq_o, repl_o, full_t, empty_t, rdy_t;

qq_top #(.W(8)) DUV (.clk, .rst, .enq, .deq, .repl, .lt_i, .rt_i, .lt_o, .rt_o, .enq_o, .deq_o, .repl_o, .full_t, .empty_t, .rdy_t);

  /** Generate clock */
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    /** Testbench start */
    initial begin
    /** Setup: reset */
    lt_i.key = 0;
    lt_i.value = 0;
    enq = 0;
    deq = 0;
    repl = 0;
    rst = 1;
    @(posedge clk) #1;
    rst = 0;
    repeat (10) @(posedge clk);
    lt_i.key = 5;
    lt_i.value = 3;
    enq = 1;
    @(posedge clk) #1;
    enq = 0;
    repeat (5) @(posedge clk) #1;
    lt_i.key = 10;
    lt_i.value = 1;
    enq = 1;
    @(posedge clk) #1;
    enq = 0;
    repeat (5) @(posedge clk) #1;
    lt_i.key = 3;
    lt_i.value = 4;
    enq = 1;
    @(posedge clk) #1;
    enq = 0;
    repeat (5) @(posedge clk) #1;
    lt_i.key = 20;
    lt_i.value = 10;
    enq = 1;
    @(posedge clk) #1;
    enq = 0;
    repeat (5) @(posedge clk) #1;
    lt_i.key = 2;
    lt_i.value = 6;
    enq = 1;
    @(posedge clk) #1;
    enq = 0;
    repeat (7) @(posedge clk) #1;
    lt_i.key = 12;
    lt_i.value = 7;
    enq = 1;
    @(posedge clk) #1;
    enq = 0;
    repeat (10) @(posedge clk) #1;
    lt_i.key = 27;
    lt_i.value = 24;
    enq = 1;
    @(posedge clk) #1;
    enq = 0;
    repeat (5) @(posedge clk) #1;
    lt_i.key = 8;
    lt_i.value = 17;
    enq = 1;
    @(posedge clk) #1;
    enq = 0;
    repeat (10) @(posedge clk) #1; // to see FULL go high we need more time (change: rdy = 1 to allow new operation?)
    
    // Replace tests 
    lt_i.key = 9;
    lt_i.value = 9;
    repl = 1;
    @(posedge clk) #1;
    repl = 0;
    repeat (6) @(posedge clk) #1;
    lt_i.key = 4;
    lt_i.value = 1;
    repl = 1;
    @(posedge clk) #1;
    repl = 0;
    repeat (6) @(posedge clk) #1;
    lt_i.key = 15;
    lt_i.value = 16;
    repl = 1;
    @(posedge clk) #1;
    repl = 0;
    repeat (8) @(posedge clk) #1;
    lt_i.key = 30;
    lt_i.value = 0;
    repl = 1;
    @(posedge clk) #1;
    repl = 0;
    repeat (10) @(posedge clk) #1;
    
    deq = 1;
    @(posedge clk) #1;
    deq = 0;
    repeat (9) @(posedge clk) #1;
    deq = 1;
    @(posedge clk) #1;
    deq = 0;
    repeat (8) @(posedge clk) #1;
    deq = 1;
    @(posedge clk) #1;
    deq = 0;
    repeat (7) @(posedge clk) #1;
    deq = 1;
    @(posedge clk) #1;
    deq = 0;
    repeat (6) @(posedge clk) #1;
    deq = 1;
    @(posedge clk) #1;
    deq = 0;
    repeat (5) @(posedge clk) #1;
    deq = 1;
    @(posedge clk) #1;
    deq = 0;
    repeat (4) @(posedge clk) #1;
    deq = 1;
    @(posedge clk) #1;
    deq = 0;
    repeat (3) @(posedge clk) #1;
    deq = 1;
    @(posedge clk) #1;
    deq = 0;
    repeat (2) @(posedge clk) #1;

    $stop;
    end
endmodule
