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
    /** find a way to set queue capacity to 3 */
    
    $stop;
    end
    
endmodule
