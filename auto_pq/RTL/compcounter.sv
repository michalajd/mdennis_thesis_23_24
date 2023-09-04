`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2022 01:07:16 PM
// Design Name: 
// Module Name: compcounter
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


module  compcounter #(parameter W=4) (
    input logic clk, rst, enb,
    output logic [W-1:0] q,
    output logic cteal_15
    );

    always_ff @(posedge clk)
        if (rst)      q <= 1;
        else if (enb) q <= q + 1;
        
    assign cteal_15 = ((q  == 15) || (q == 0));

endmodule: compcounter
