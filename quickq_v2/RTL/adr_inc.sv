`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Module Name   : adr_inc
// Project       : QuickQ (version 2)
//-----------------------------------------------------------------------------
// Author        : Michala Dennis  <dennismj@lafayette.edu>
// Created       : Mar 2024
//-----------------------------------------------------------------------------
// Description   : Sequential logic to control read address in QuickQ
//-----------------------------------------------------------------------------
// Modification history:
//-----------------------------------------------------------------------------


module adr_inc #(parameter D=4, localparam DW=$clog2(D)) 
    (input logic clk, rst, 
     input logic [1:0] incr_ctl,
     input logic [DW-1:0] wr_addr,
     output logic [DW-1:0] rd_addr);
     
     always_ff @ (posedge clk)
     begin
        if (rst) rd_addr <= '0;
        
        // can this be a case statement?
        else if (incr_ctl == 2'b00) rd_addr <= wr_addr;
        else if (incr_ctl == 2'b01) rd_addr <= wr_addr + 1;
        else if (incr_ctl == 2'b10) rd_addr <= wr_addr + 2;
     end
     
endmodule