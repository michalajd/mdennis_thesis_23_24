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


module last_cnt(input logic clk, rst,
                input logic [31:0] last_addr,
                input logic enq, deq, done,
                output logic [31:0] new_last);
                
    always_ff @ (posedge clk)
        begin
            if (rst) new_last <= 0;
            else begin
                if (done) begin
                    if (enq) new_last = last_addr + 1;
                    else if (deq) new_last = last_addr - 1;
                    else new_last = last_addr;
                end
            end
        end
endmodule
