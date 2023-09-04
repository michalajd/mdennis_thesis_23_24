`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2022 02:52:23 PM
// Design Name: 
// Module Name: ra_pq_s_sim
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


module ra_pq_s_sim;
    
    logic clk, rst;
    logic [15:0] kvi_logic;
    logic full;
    logic busy;
    logic empty;
    logic deq;
    logic enq_deq;
    logic [6:0] segs_n;
    logic dp_n;
    logic [7:0] an_n;

    ra_pq_s_wrapper DUV (.clk, .rst, .kvi_logic, .full, .busy, .empty, .deq, .enq_deq, .segs_n, .dp_n, .an_n);
    
    parameter CLK_PD = 20;
    
    always begin
      clk = 1'b0; #(CLK_PD/2);
      clk = 1'b1; #(CLK_PD/2);
    end
    
    initial begin
    rst = 1;
    repeat (10) @ (posedge clk) #1;
    rst = 0;
    enq_deq = 1;
    kvi_logic = 16'b1000111011001100;
    repeat (1) @ (posedge clk) #1;
    kvi_logic = 16'b1011101111001100;
    repeat (1) @ (posedge clk) #1;
    kvi_logic = 16'b1001100111001100;
    repeat (1) @ (posedge clk) #1;
    kvi_logic = 16'b1010101011001100;
    repeat (1) @ (posedge clk) #1;
    kvi_logic = 16'b0001000111001100;
    repeat (1) @ (posedge clk) #1;
    kvi_logic = 16'b0111011111001100;
    repeat (1) @ (posedge clk) #1;
    kvi_logic = 16'b0010001011001100;
    repeat (1) @ (posedge clk) #1;
    kvi_logic = 16'b1100110011001100;
    repeat (1) @ (posedge clk) #1;
    enq_deq = 0;
    deq = 1;
    repeat (50) @(posedge clk); #1;
    $stop;
    end
    
endmodule
