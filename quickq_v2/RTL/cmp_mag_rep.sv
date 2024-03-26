`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2024 04:22:37 PM
// Design Name: 
// Module Name: cmp_mag_rep
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


module cmp_mag_rep #(parameter W=8)
  (input logic [W-1:0] a, b,
   output logic a_gt_b);

  assign a_gt_b = (a > b) || (b == '1);

endmodule: cmp_mag_rep
