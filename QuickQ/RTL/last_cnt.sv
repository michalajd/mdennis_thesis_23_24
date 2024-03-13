`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 07:35:40 PM
// Design Name: 
// Module Name: last_cnt
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


module last_cnt import quickQ_pkg::*; #(parameter W=8, D=128, localparam DW=$clog2(D))
               (input logic clk, rst,
                input logic [DW-1:0] last_addr,
                input logic [1:0] lastop, 
                input logic last_done,
                output logic [DW-1:0] new_last);
                
    always_ff @ (posedge clk)
        begin
            if (rst) new_last <= 0;
            else begin
                if (last_done) begin
                    if (lastop == LO_ENQ) new_last <= last_addr + 1;
                    else if (lastop == LO_DEQ) new_last <= last_addr - 1;
                    else new_last <= last_addr;
                end
                //else new_last <= last_addr;
            end
        end
endmodule
