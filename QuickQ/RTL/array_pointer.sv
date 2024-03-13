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


module array_pointer #(parameter D=128, localparam DW=$clog2(D))
    (input logic clk, rst, cnt_rst, array_cnt_ld, array_cnt_clr, array_cnt_deq, array_cnt_inc,
                     input logic [DW-1:0] array_cnt_out, last_index,
                     output logic [DW-1:0] pointer_next, pointer_prev);
                     
    always_ff @ (posedge clk)
        begin
            if (rst || cnt_rst || array_cnt_clr) begin 
                pointer_next <= 0;
                pointer_prev <= 0;
            end
            else if (array_cnt_ld) begin
                pointer_next <= 1; // for dequeue
                pointer_prev <= 0;
            end
            else if (array_cnt_deq) begin 
                pointer_prev <= array_cnt_out;
                pointer_next <= array_cnt_out + 1;
            end
            else if (array_cnt_inc) begin
                pointer_next <= array_cnt_out + 1;
                pointer_prev <= 0;
            end
            else begin
                pointer_next <= array_cnt_out;
                pointer_prev <= 0;
            end
        end
        
endmodule
