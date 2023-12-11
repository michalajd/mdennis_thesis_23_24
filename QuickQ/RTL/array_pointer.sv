`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 06:56:44 PM
// Design Name: 
// Module Name: array_pointer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Advanced counter that conducts a variety of functions based on a specific input.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module array_pointer(input logic clk, rst, array_cnt_ld, array_cnt_clr, array_cnt_decr, array_cnt_inc,
                     input logic [31:0] array_cnt_out, last_index,
                     output logic [31:0] pointer_next);
                     
    always_ff @ (posedge clk)
        begin
            if (rst) pointer_next <= 0;
            else if (array_cnt_ld) pointer_next <= last_index;
            else if (array_cnt_clr) pointer_next <= 0;
            else if (array_cnt_decr) pointer_next <= array_cnt_out - 1;
            else if (array_cnt_inc) pointer_next <= array_cnt_out + 1;
        end
        
endmodule
