`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2022 01:38:02 PM
// Design Name: 
// Module Name: counter_size
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


module counter_size #(parameter W=4) (input logic clk, rst, sel, count_size_enb,
                    output logic [W-1:0] size);
                    
                    always_ff @ (posedge clk)
                        if (rst) size <= 0;
                        else if (count_size_enb) 
                            begin
                                if (sel) size <= size + 1;
                                else size <= size - 1;
                            end  

endmodule
