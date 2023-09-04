`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2022 12:50:59 PM
// Design Name: 
// Module Name: compcount_sim
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


module compcount_sim;
        logic clk, rst, enb;
        logic [7:0] din;
        logic verdict, cteal_15;
        
        compcounter DUV (.clk, .rst, .enb, .din, .verdict, .cteal_15);
        
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
        din = 8'b00000001;
        @(posedge clk); #1;
        din = 8'b00000101;
        repeat (10) @(posedge clk); #1;
        din = 8'b00001000;
        @(posedge clk); #1;
        din = 8'b00000010;
        @(posedge clk); #1;
        din = 8'b11111110;
        repeat (10) @(posedge clk); #1;
        $stop;
        end
endmodule
