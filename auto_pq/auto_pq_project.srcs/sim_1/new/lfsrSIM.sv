`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2022 03:57:42 PM
// Design Name: 
// Module Name: lfsrSIM
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


module lfsrSIM;

    logic rst, clk, enb;
    logic [3:0] q;

    lfsr DUV(.rst, .clk, .enb, .q);

    parameter CLK_PD = 20;

    always begin
        clk = 1'b0; #(CLK_PD/2);
        clk = 1'b1; #(CLK_PD/2);
    end

    initial begin
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
        enb = 1;
        repeat (10) @(posedge clk); #1;
        enb = 0;
        repeat (4) @(posedge clk); #1;
        enb = 1;
        repeat (8) @(posedge clk); #1;
        $stop;
    end
endmodule
