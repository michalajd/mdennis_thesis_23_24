`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2024 01:33:05 PM
// Design Name: 
// Module Name: kv_dffre
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
import pq_pkg::*;

module kv_dffre (input logic clk, rst, enb,
             input kv_t d,
             output kv_t q);

    always_ff @(posedge clk)
        if (rst) q <= KV_EMPTY;
        else if (enb) q <= d;

endmodule
