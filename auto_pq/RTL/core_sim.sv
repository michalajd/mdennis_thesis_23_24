`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2022 12:12:37 PM
// Design Name: 
// Module Name: core_sim
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


module core_sim;

    logic clk, rst, start;
    logic [3:0] data1, data2;
    logic [2:0] red, green, blue;
    logic sigIDLE, sigSTART, sigADD, sigREMOVE, sigDISPLAY, sigFULL, sigEMPTY;
    
    high_level DUV (.clk, .rst, .start, .data1, .data2, .red, .green, .blue,
                    .sigIDLE, .sigSTART, .sigADD, .sigREMOVE, .sigDISPLAY, .sigFULL, .sigEMPTY);
    
    parameter CLK_PD = 20;
    
    always begin
      clk = 1'b0; #(CLK_PD/2);
      clk = 1'b1; #(CLK_PD/2);
    end
    
    initial begin
    start = 0;
    rst = 1;
    @ (posedge clk) #1;
    rst = 0;
    start = 1;
    repeat (300) @(posedge clk); #1;
    start = 0;
    rst = 1;
    repeat (10) @ (posedge clk); #1;
    rst = 0;
    start = 1;
    repeat (300) @ (posedge clk); #1;
    $stop;
    end
    
endmodule
