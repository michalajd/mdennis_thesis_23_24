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
   input logic rst, clk, enb,
   output logic [3:0] q
);

   always_ff @(posedge clk)
       if (rst) q <= 4'b0001;
       else if (enb) q <= { (q[1] ^ q[0]), q[3:1] };

endmodule: lfsr
