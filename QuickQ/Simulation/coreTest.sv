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
    logic clk, rst, enq, deq, regenb, next_node;
    logic [1:0] mux1_sel;
    logic [31:0] reg_out, data_lt_o, to_register;
    
    /** Module instantiation */
    quickQCore DUV (.clk, .rst, .enq, .deq, .reg_out, .data_lt_o, .to_register, .mux1_sel,  .regenb, .next_node);
    
    /** Generate clock */
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    /** Testbench start */
    initial begin
    /** Setup: reset */
    reg_out = 32'b0;
    rst = 1;
    @(posedge clk) #1;
    rst = 0;
    
    /** Test 1: Dequeue while empty */
    deq = 1;
    @(posedge clk) #1;
    deq = 0;
    repeat(5) @(posedge clk) #1;
    
    /** Test 2: Enqueue while empty */
    enq = 1;
    reg_out = 32'd5;
    @(posedge clk) #1;
    enq = 0;
    repeat(5) @(posedge clk) #1;
    
    $stop;
    end
    
endmodule
