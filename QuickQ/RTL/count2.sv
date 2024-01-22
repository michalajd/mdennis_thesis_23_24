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
    (input logic clk, rst,
     input logic fill_cnt,
     output logic cnt_done);

    logic [1:0] q;
    always_ff @(posedge clk) begin
        if (rst) q <= 0;
        else if (fill_cnt) begin
            if (q != 2) q <= q + 1;
            if (q == 2) cnt_done = 1;
        end
    end

endmodule: count2
