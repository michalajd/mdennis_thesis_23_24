`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2022 02:19:18 PM
// Design Name: 
// Module Name: lfsr
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


module lfsr(
   input logic clk, rst, enb,
   output logic [7:0] q
);

   always_ff @(posedge clk)
       if (rst) q <= 8'b00000001;
       else if (enb) q <= ({(q[7]^q[6])^(q[5]^q[0]), q[7:1]});
endmodule: lfsr
