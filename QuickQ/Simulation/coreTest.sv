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


module coreTest;
    /** Declare internal logic */
    logic clk, rst, enq, deq;
    logic [31:0] array_size;
    logic [31:0] data_lt_i, data_rt_i, data_lt_o, data_rt_o;
    
    /** Module instantiation */
    quickQueueTop DUV (.data_lt_i, .data_rt_i, .clk, .rst, .enq, .deq, .array_size,.data_lt_o, .data_rt_o);
    
    /** Generate clock */
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    /** Testbench start */
    initial begin
    /** Setup: reset */
    array_size = 31'd3;
    rst = 1;
    repeat(2) @(posedge clk) #1;
    rst = 0;
    
    /** Test 1: Dequeue while empty */
    deq = 1;
    repeat(2) @(posedge clk) #1;
    deq = 0;
    repeat(5) @(posedge clk) #1;
    
    /** Test 2: Enqueue while empty */
    deq = 0;
    enq = 1;
    data_lt_i = 8'd4;
    repeat(5) @(posedge clk) #1;
    enq = 0;
    repeat(10) @(posedge clk) #1;
    
    /** Test 3: Enqueue with a swap */
    enq = 1;
    data_lt_i = 8'd2;
    repeat(19) @(posedge clk) #1;
    enq = 0;
    repeat(5) @(posedge clk) #1;
    
    /** Test 4: Enqueue with no swap */
    enq = 1;
    data_lt_i = 8'd9;
    repeat(20) @(posedge clk) #1;
    enq = 0;
    repeat(10) @(posedge clk) #1;
    
    /** Test 4: Enq with two swaps */
    enq = 1;
    data_lt_i = 8'd3;
    repeat(10) @(posedge clk) #1;
    enq = 0;
    repeat(35) @(posedge clk) #1;
    
    /** Test 5: Enq but array is full */
    enq = 1;
    data_lt_i = 8'd7;
    repeat(10) @(posedge clk) #1;
    enq = 0;
    repeat(30) @(posedge clk) #1;
    
    /** Test 6: Deq while array is full */
    deq = 1;
    repeat(10) @(posedge clk) #1;
    deq = 0;
    repeat(30) @(posedge clk) #1;
    $stop;
    end
    
endmodule
