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

module dffe #(parameter W=8)
    (input logic clk, 
     input logic [W-1:0] d, 
     input logic enb,
     output logic [W-1:0] q);

    always_ff @(posedge clk)
        if (enb) q <= d;

endmodule: dffe