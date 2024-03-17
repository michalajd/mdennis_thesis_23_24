`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Module Name   : adr_cnt
// Project       : QuickQ (version 2)
//-----------------------------------------------------------------------------
// Author        : Michala Dennis  <dennismj@lafayette.edu>
// Created       : Mar 2024
//-----------------------------------------------------------------------------
// Description   : Sequential logic to control write address in QuickQ
//-----------------------------------------------------------------------------
// Modification history:
//-----------------------------------------------------------------------------


module adr_cnt #(parameter D=4, localparam DW=$clog2(D)) 
    (input logic clk, rst, clr_wraddr, inc_wraddr, 
     output logic [DW-1:0] wr_addr);
     
     always_ff @ (posedge clk)
        begin
            if (rst || clr_wraddr) wr_addr <= '0;
            else if (inc_wraddr) wr_addr = wr_addr + 1;
        end
endmodule