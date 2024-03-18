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


module qq_control #(
    parameter W = 8,
    D = 4,
    localparam DW = $clog2(D)
) (
    input logic clk,
    rst,
    enq_i,
    deq_i,
    t_gt_ram_out,
    input logic [W-1:0] ram_out,
    output logic sel_t,
    ld_t,
    we,
    enq_o,
    deq_o,
    rdy,
    full,
    empty,
    output logic [1:0] sel_b,
    output logic [DW-1:0] rd_addr,
    wr_addr
);

    // Internal logic
    logic clr_wraddr, incr_wraddr;
    logic clr_empty, set_empty, clr_full, set_full;
    logic [1:0] incr_ctl;

    qq_fsm #(
        .W(W),
        .D(D)
    ) FSM (
        .clk,
        .rst,
        .enq_i,
        .deq_i,
        .t_gt_ram_out,
        .full,
        .wr_addr,
        .rd_addr,
        .ram_out,
        .sel_t,
        .ld_t,
        .clr_wraddr,
        .incr_wraddr,
        .we,
        .enq_o,
        .deq_o,
        .rdy,
        .set_full,
        .clr_full,
        .set_empty,
        .clr_empty,
        .incr_ctl,
        .sel_b
    );

    adr_cnt #(
        .D(D)
    ) ADRCNT (
        .clk,
        .rst,
        .clr_wraddr,
        .incr_wraddr,
        .wr_addr
    );

    adr_inc #(
        .D(D)
    ) ADRINC (
        .incr_ctl,
        .wr_addr,
        .rd_addr
    );

    reg_sr_empty EMPTYFF (
        .clk,
        .rst,
        .r(clr_empty),
        .s(set_empty),
        .q(empty)
    );

    reg_sr FULLFF (
        .clk,
        .rst,
        .r(clr_full),
        .s(set_full),
        .q(full)
    );

endmodule
