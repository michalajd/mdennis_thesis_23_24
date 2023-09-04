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

module dffe (input logic clk, d, enb,
             output logic q);

    always_ff @(posedge clk)
        if (enb) q <= d;

endmodule: dffe