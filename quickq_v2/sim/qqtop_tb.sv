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


module qqtop_tb;
// Declare internal logic 
logic clk, rst, enq, deq, repl;
logic [31:0] lt_i, rt_i, lt_o, rt_o; 
logic enq_o, deq_o, repl_o, full_t, empty_t, rdy_t;

qq_top DUV (.clk, .rst, .enq, .deq, .repl, .lt_i, .rt_i, .lt_o, .rt_o, .enq_o, .deq_o, .repl_o, .full_t, .empty_t, .rdy_t);

  /** Generate clock */
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    /** Testbench start */
    initial begin
    /** Setup: reset */
    lt_i = 0;
    enq = 0;
    deq = 0;
    repl = 0;
    rst = 1;
    @(posedge clk) #1;
    rst = 0;
    repeat (10) @(posedge clk);
    lt_i = 5;
    enq = 1;
    @(posedge clk) #1;
    enq = 0;
    repeat (5) @(posedge clk) #1;
    lt_i = 10;
    enq = 1;
    @(posedge clk) #1;
    enq = 0;
    repeat (5) @(posedge clk) #1;
    lt_i = 3;
    enq = 1;
    @(posedge clk) #1;
    enq = 0;
    repeat (5) @(posedge clk) #1;
    lt_i = 20;
    enq = 1;
    @(posedge clk) #1;
    enq = 0;
    repeat (5) @(posedge clk) #1;
    lt_i = 2;
    enq = 1;
    @(posedge clk) #1;
    enq = 0;
    repeat (5) @(posedge clk) #1;
    lt_i = 12;
    enq = 1;
    @(posedge clk) #1;
    enq = 0;
    repeat (5) @(posedge clk) #1;
    lt_i = 27;
    enq = 1;
    @(posedge clk) #1;
    enq = 0;
    repeat (5) @(posedge clk) #1;
    lt_i = 8;
    enq = 1;
    @(posedge clk) #1;
    enq = 0;
    repeat (10) @(posedge clk) #1; // to see FULL go high we need more time (change: rdy = 1 to allow new operation?)
    
    // Replace tests 
    lt_i = 9;
    repl = 1;
    @(posedge clk) #1;
    repl = 0;
    repeat (6) @(posedge clk) #1;
    lt_i = 4;
    repl = 1;
    @(posedge clk) #1;
    repl = 0;
    repeat (6) @(posedge clk) #1;
    /*
    deq = 1;
    @(posedge clk) #1;
    deq = 0;
    repeat (5) @(posedge clk) #1;
    deq = 1;
    @(posedge clk) #1;
    deq = 0;
    repeat (5) @(posedge clk) #1;
    deq = 1;
    @(posedge clk) #1;
    deq = 0;
    repeat (5) @(posedge clk) #1;
    deq = 1;
    @(posedge clk) #1;
    deq = 0;
    repeat (10) @(posedge clk) #1;
    deq = 1;
    @(posedge clk) #1;
    deq = 0;
    repeat (5) @(posedge clk) #1;
    deq = 1;
    @(posedge clk) #1;
    deq = 0;
    repeat (5) @(posedge clk) #1;
    deq = 1;
    @(posedge clk) #1;
    deq = 0;
    repeat (5) @(posedge clk) #1;
    deq = 1;
    @(posedge clk) #1;
    deq = 0;
    repeat (5) @(posedge clk) #1; */
    $stop;
    end
endmodule
