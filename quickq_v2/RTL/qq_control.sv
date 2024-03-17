`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Module Name   : qq_control
// Project       : QuickQ (version 2)
//-----------------------------------------------------------------------------
// Author        : Michala Dennis  <dennismj@lafayette.edu>
// Created       : Mar 2024
//-----------------------------------------------------------------------------
// Description   : Control node for the QuickQ
//-----------------------------------------------------------------------------
// Modification history:
//-----------------------------------------------------------------------------


module qq_control #(parameter W=8, D=4, localparam DW=$clog2(D)) (
    input logic clk, rst, enq_i, deq_i, t_gt_ram_out,
    input logic [W-1:0] ram_out,
    output logic sel_t, ld_t, we, enq_o, deq_o, full, empty,
    output logic [1:0] sel_b,
    output logic [D-1:0] rd_addr, wr_addr);
    
    // Internal logic
    logic [DW-1:0] rd_addr, wr_addr;
    logic clr_wraddr, inc_wraddr;
    logic [1:0] incr_ctl;
    
    qq_fsm #(.W(W), .D(D)) fsmDUV (.clk, .rst, .enq_i, .deq_i, .t_gt_ram_out, .wr_addr, .ram_out,
                                   .sel_t, .ld_t, .clr_wraddr, .inc_wraddr, .we, .enq_o, .deq_o,
                                   .full, .empty, .incr_ctl, .sel_b);
                                   
    adr_cnt #(.D(D)) adrcntDUV (.clk, .rst, .clr_wraddr, .inc_wraddr, .wr_addr);
    adr_inc #(.D(D)) adrincDUV (.clk, .rst, .incr_ctl, .wr_addr, .rd_addr);
    
endmodule
