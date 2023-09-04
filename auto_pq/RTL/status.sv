`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2022 03:23:17 PM
// Design Name: 
// Module Name: status
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


module status(input logic clk, error, done,
              output logic [6:0] d7, d6, d5, d4, d3, d2, d1, d0);
              
          always_comb
              if (error)
                begin
                    assign d7 = 7'b0001110;
                    assign d6 = 7'b0001000;
                    assign d5 = 7'b1111001;
                    assign d4 = 7'b1000111;
                    assign d3 = 7'b1111111;
                    assign d2 = 7'b1111111;
                    assign d1 = 7'b1111111;
                    assign d0 = 7'b1111111;
                end  
                  
              else if (done)
                begin
                    assign d7 = 7'b1000110;
                    assign d6 = 7'b1000000;
                    assign d5 = 7'b0101111;
                    assign d4 = 7'b0101111;
                    assign d3 = 7'b0000110;
                    assign d2 = 7'b1000110;
                    assign d1 = 7'b0001111;
                    assign d0 = 7'b1111111;
                end
endmodule
