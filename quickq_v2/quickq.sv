`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Package Name  : quickQ 
// Project       : HWPQ: Hardware Priority Queue Study
//-----------------------------------------------------------------------------
// Author        : Michala Dennis
// Created       : April 15, 2024
//-----------------------------------------------------------------------------
// Description   : Version of top module that incorporates package
//-----------------------------------------------------------------------------

import pq_pkg::*;

module quickq(
    pq_if.dev di
    );
    
    logic clk, rst;
    kv_t kvi, kvo;
    logic rdy; // rdy_t in top module

    assign kvi = di.kvi;
    assign di.kvo = kvo;
    assign clk = di.clk;
    assign rst = di.rst;

    logic full, empty, enq, deq;
    assign enq = di.enq && !full;
    assign deq = di.deq && !empty;
    assign replace = di.enq && di.deq && !empty;

    assign di.full = full;
    assign di.empty = empty;
    assign di.busy = !rdy; 
    
    // logic for outputs that go to nowhere
    logic [KEY_WIDTH+VAL_WIDTH-1:0] rt_o;
    logic enq_o, deq_o, repl_o;
    
    qq_top #(.W(KEY_WIDTH + VAL_WIDTH), .D(PQ_CAPACITY/2)) U_QQTOP (
        .clk, .rst, .enq, .deq, .repl(replace), .lt_i(kvi), .rt_i(KEYMAX), .lt_o(kvo), 
        .rt_o, .enq_o, .deq_o, .rdy_o,
        .full_t(full), .empty_t(empty), .rdy_t(rdy)
    );
    
    
endmodule
