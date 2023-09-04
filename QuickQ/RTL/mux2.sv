`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2023 04:01:35 PM
// Design Name: 
// Module Name: mux2
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


module mux2 #(parameter W=32)
             (input logic [W-1:0]  d0, d1,
              input logic          sel,
              output logic [W-1:0] y );

   always_comb
     if (sel) y = d1;
     else y = d0;

endmodule: mux2
