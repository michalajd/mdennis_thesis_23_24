`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2022 03:34:27 PM
// Design Name: 
// Module Name: autosim
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


module autosim;

    logic clk;
    pq_if U_PQ_IF (.clk);
    
    logic rst, start, sigIDLE, sigSTART, sigADD, sigREMOVE, sigDISPLAY, sigFULL, sigEMPTY;
    logic [7:0] kvo_logic;
    logic [2:0] color_r, color_g, color_b;
    logic [1:0] data1, data2, data3, data4;
    
    auto_top DUV (.ti(U_PQ_IF.client), .rst, .start, .kvo_logic, .color_r, .color_g, .color_b, .data1, .data2,
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
    repeat (50) @(posedge clk); #1;
    end
endmodule
