`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2023 06:59:58 PM
// Design Name: 
// Module Name: coreTest
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


module quickq_v2_tb;
    /** Declare internal logic */
    logic clk, rst, enq_i, deq_i, repl_i; 
    logic rdy, full, empty, enq_o, deq_o, repl_o;
    logic [31:0] data_lt_i, data_rt_i, data_lt_o, data_rt_o;
    
    /** Module instantiation */
    qq_node DUV (
        .clk,
        .rst,
        .enq_i,
        .deq_i,
        .repl_i,
        .rdy,
        .full,
        .empty,
        .enq_o,
        .deq_o,
        .repl_o,
        .data_lt_i, 
        .data_rt_i,
        .data_lt_o, 
        .data_rt_o
        );

        assign data_rt_i = '1;
    
    /** Generate clock */
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    /** Testbench start */
    initial begin
    /** Setup: reset */
    data_lt_i = 0;
    enq_i = 0;
    deq_i = 0;
    repl_i = 0;
    rst = 1;
    @(posedge clk) #1;
    rst = 0;
    repeat (10) @(posedge clk);
    data_lt_i = 5;
    enq_i = 1;
    @(posedge clk) #1;
    enq_i = 0;
    repeat (5) @(posedge clk) #1;
    data_lt_i = 10;
    enq_i = 1;
    @(posedge clk) #1;
    enq_i = 0;
    repeat (5) @(posedge clk) #1;
    data_lt_i = 3;
    enq_i = 1;
    @(posedge clk) #1;
    enq_i = 0;
    repeat (5) @(posedge clk) #1;
    data_lt_i = 20;
    enq_i = 1;
    @(posedge clk) #1;
    enq_i = 0;
    repeat (5) @(posedge clk) #1;
    
    // Replace tests 
    data_lt_i = 8;
    repl_i = 1;
    @(posedge clk) #1;
    repl_i = 0;
    repeat (5) @(posedge clk) #1;
    data_lt_i = 4;
    repl_i = 1;
    @(posedge clk) #1;
    repl_i = 0;
    repeat (5) @(posedge clk) #1;
    data_lt_i = 26;
    repl_i = 1;
    @(posedge clk) #1;
    repl_i = 0;
    repeat (5) @(posedge clk) #1;
    data_rt_i = 29;
    data_lt_i = 28;
    repl_i = 1;
    @(posedge clk) #1;
    repl_i = 0;
    repeat (5) @(posedge clk) #1;
    
    // Dequeue tests
    data_rt_i = '1;
    deq_i = 1;
    @(posedge clk) #1;
    deq_i = 0;
    repeat (5) @(posedge clk) #1;
    deq_i = 1;
    @(posedge clk) #1;
    deq_i = 0;
    repeat (5) @(posedge clk) #1;
    deq_i = 1;
    @(posedge clk) #1;
    deq_i = 0;
    repeat (5) @(posedge clk) #1;
    deq_i = 1;
    @(posedge clk) #1;
    deq_i = 0;
    repeat (10) @(posedge clk) #1;
    
    // Mixed behavior tests
    data_lt_i = 4;
    enq_i = 1;
    @(posedge clk) #1;
    enq_i = 0;
    repeat (5) @(posedge clk) #1;
    data_lt_i = 2;
    enq_i = 1;
    @(posedge clk) #1;
    enq_i = 0;
    repeat (5) @(posedge clk) #1;
    deq_i = 1;
    @(posedge clk) #1;
    deq_i = 0;
    repeat (5) @(posedge clk) #1;
    data_lt_i = 13;
    enq_i = 1;
    @(posedge clk) #1;
    enq_i = 0;
    repeat (5) @(posedge clk) #1;
    deq_i = 1;
    @(posedge clk) #1;
    deq_i = 0;
    repeat (5) @(posedge clk) #1;
    
    $stop;   
    end
    
endmodule
