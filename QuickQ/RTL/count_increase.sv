`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/10/2022 03:57:17 PM
// Design Name: 
// Module Name: count_increase
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


module count_increase(input logic clk, rst, enb,
                      input logic [7:0] in,
                      output logic [7:0] out);

                      always_ff @ (posedge clk)
                        if (rst) out <= 0;
                        else if (enb) out <= in + 1;
                        else out <= in;
                      
endmodule
