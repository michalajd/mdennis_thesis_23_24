`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Module Name   : dffe
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : d flip-flop withreset and enable
//-----------------------------------------------------------------------------
// Modification history:
// 17.03.2024 : added parameter MD
//-----------------------------------------------------------------------------

module dffre #(parameter W=32) (input logic clk, rst, enb,
             input logic [W-1:0] d,
             output logic [W-1:0] q);

    always_ff @(posedge clk)
        if (rst) q <= '0;
        else if (enb) q <= d;

endmodule: dffre
