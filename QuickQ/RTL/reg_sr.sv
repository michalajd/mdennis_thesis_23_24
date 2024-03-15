`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2024 05:20:00 PM
// Design Name: 
// Module Name: reg_sr
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


module reg_sr (
    input logic clk, rst, s, r,
    output logic q);

    always_ff @(posedge clk) begin
        if (rst || r) q <= 0;
        else if (s) q <= 1;
    end
endmodule
