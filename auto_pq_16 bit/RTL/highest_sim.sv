`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2022 11:24:04 AM
// Design Name: 
// Module Name: highest_sim
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


module highest_sim;
    
    logic clk, rst, start;
    logic red, blue, green;
    logic [6:0] segs_n;
    logic [7:0] an_n;
    logic dp_n;
    logic sigIDLE, sigSTART, sigADD, sigREMOVE, sigDISPLAY, sigFULL, sigEMPTY;
    
    highest_level DUV (.clk, .rst, .start, .red, .blue, .green, .segs_n, .an_n, .dp_n, .sigIDLE, .sigSTART, .sigREMOVE, .sigDISPLAY, .sigFULL, .sigEMPTY);
    
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
    repeat (10750) @(posedge clk); #1;
    $stop;
    end
      

    
endmodule
