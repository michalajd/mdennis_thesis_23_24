`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2024 01:36:48 PM
// Design Name: 
// Module Name: kv_cmp_mag
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

module kv_cmp_mag(
    input kv_t a, b,
    output logic a_gt_b
    );

    assign a_gt_b = (a.key > b.key);

endmodule
