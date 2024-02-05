`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Module Name   : dffe
// Project       : Quick Priority Queue
//-----------------------------------------------------------------------------
// Author        : Samuel Ehgartner  <ehgartns@lafayette.edu>
// Created       : August 2022
//-----------------------------------------------------------------------------
// Description   : d flip-flop with enable
//-----------------------------------------------------------------------------

module count2
    (input logic clk, rst, fill_rst,
     input logic fill_cnt,
     output logic cnt_done);

    logic [1:0] q;
    always_ff @(posedge clk) begin
        if (rst || fill_rst) begin
            q <= 0;
            cnt_done = 0;
        end
        else if (fill_cnt) begin
            if (q != 2) begin 
                q <= q + 1;
                cnt_done = 0;
            end
            if (q == 2) cnt_done = 1;
        end
    end

endmodule: count2
