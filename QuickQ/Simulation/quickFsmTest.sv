`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 11:32:43 AM
// Design Name: 
// Module Name: quickFsmTest
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


module quickFsmTest;

/** Logic values for initialization */
    logic clk, rst, enq, deq, done, result, full, swap_done, empty; /** Inputs */
    logic we, regenb, regsel, countenb, re, next_node, bram_sel; /** One-bit outputs */
    logic [1:0] mux1_sel; /** Two-bit outputs */
    logic [2:0] mode; /** Three-bit outputs */
    logic [31:0] rd_addr, wr_addr; /** 32-bit outputs */
                  
/** Instantiate DUV */           
ControlFSM DUV (.clk, .rst, .enq, .deq, .done, .result, .full, .swap_done, .empty,
                .we, .regenb, .regsel, .countenb, .re, .next_node, .bram_sel,
                .rd_addr, .wr_addr, .mode, .mux1_sel);
                
    /** Generate clock */
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    /** Testbench start */
    initial begin
        rst = 1;
        enq = 0;
        deq = 0;
        done = 0;
        result = 0;
        full = 0;
        @(posedge clk) #1;
        rst = 0;
        
        /** Check enqueue state entry */
        repeat(4) @(posedge clk) #1;
        enq = 1;
        @(posedge clk) #1;
        
        /** Test enqueue logic when swap needs to happen */
        enq = 0;
        result = 1;
        swap_done = 0;
        repeat(3) @(posedge clk) #1;
        swap_done = 1;
        @(posedge clk) #1;
        
        /** Check logic when counter is full */
        full = 1;
        repeat (4) @(posedge clk) #1;
        
        /** Check empty logic */
        full = 0;
        empty = 1;
        @(posedge clk) #1;
        enq = 1;
        repeat (4) @(posedge clk) #1;
        
        $stop;
        end            
    endmodule
