`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Module Name   : pri_enc_4_2
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : 4-2 Priority Encoder
//-----------------------------------------------------------------------------

module lastop_enc import quickQ_pkg::*; 
                 (input logic clk, rst, enb, enq, deq,
                  output logic [1:0] lastop);

    always_ff @ (posedge clk) begin
        if (enb) begin
            if (!deq && !enq) lastop <= LO_NOP;
            else if (deq && !enq) lastop <= LO_DEQ;
            else if (!deq && enq) lastop <= LO_ENQ;
            else lastop <= LO_ERR;
        end
    end

endmodule
