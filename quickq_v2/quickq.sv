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
    
    parameter STAGE = (PQ_CAPACITY > 32) ? 16 : PQ_CAPACITY/2;
    parameter NODES = (STAGE == 16) ? (PQ_CAPACITY/STAGE) : 2;
    
    //logic to route data between numerous nodes
    kv_t [0:PQ_CAPACITY+1] kv_v; // vector of stored key-value pairs
    assign kv_v[0] = {KEY0, VAL0};
    assign kv_v[PQ_CAPACITY+1].key = KEYINF;
    assign kv_v[PQ_CAPACITY+1].value = 0;
    logic[0:NODES] enq_next;
    assign enq_next[0] = enq;
    logic[0:NODES] deq_next;
    assign deq_next[0] = deq;
    logic[0:NODES] rep_next;
    assign rep_next[0] = replace;
    
    
    genvar i;
    generate for (i=1; i<=PQ_CAPACITY/2; i++) begin
    
    qq_top #(.W(8), .D(STAGE)) U_QQTOP (
        .clk, .rst, .enq(enq_next[i-1]), .deq(deq_next[i-1]), .repl(rep_next[i-1]), .lt_i(kvi), .rt_i(kv_v[i-1]), .lt_o(kvo), 
        .rt_o(kv_v[i]), .enq_o(enq_next[i]), .deq_o(deq_next[i]), .repl_o(rep_next[i]),
        .full_t(full), .empty_t(empty), .rdy_t(rdy)
    );
    end
    endgenerate
    
endmodule
