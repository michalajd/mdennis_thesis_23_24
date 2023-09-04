`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2022 02:58:02 PM
// Design Name: 
// Module Name: lfsr_sim
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


module lfsr_sim;
    logic clk, rst, enb;
    logic [7:0] q;
    
    lfsr DUV (.clk, .rst, .enb, .q);
    
    parameter CLK_PD = 20;
    
    always begin
      clk = 1'b0; #(CLK_PD/2);
      clk = 1'b1; #(CLK_PD/2);
    end
    
    initial begin
        rst = 1;
        enb = 0;
        repeat (10) @ (posedge clk) #1;
        rst = 0;
        enb = 1;
        repeat (260) @(posedge clk); #1;
        $stop;
        end
    
endmodule
