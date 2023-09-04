//-----------------------------------------------------------------------------
// Package Name   : sr_pq_wrapper - interface wrapper for top-level sr_pq
// Project       : HWPQ: Hardware Priority Queue Study
//-----------------------------------------------------------------------------
// Author        : John Nestor
// Created       : July 13, 2021
//-----------------------------------------------------------------------------
// Description   : Instantiates sr_pq with inteface and connects to external
//                 pins for synthesis
//-----------------------------------------------------------------------------

import pq_pkg::*;

module ra_pq_wrapper(
    input logic clk, rst,
    input logic [15:0] kvi_logic,
    input logic enq,
    output logic full,
    output logic busy,
    output logic empty,
    input logic deq,
    input logic enq_deq,
    output logic [6:0] segs_n,
    output logic dp_n,
    output logic [7:0] an_n
    );

    kv_t kvi, kvo;
    logic [15:0] kvo_logic;
    
    assign kvi = kv_t'(kvi_logic);
    assign kvo_logic = kvo;
    
    // WIRES
    
    logic enqDB, deqDB, repDB, enqSP, deqSP, repSP;                
    logic enq_signal, deq_signal;
    
    // debouncer / single pulser
    
    debounce enqDEBOUNCE (.clk, .pb(enq), .rst, .pb_debounced(enqDB));
    single_pulser enqPULSE (.clk, .din(enqDB), .d_pulse(enqSP));
    
    debounce deqDEBOUNCE (.clk, .pb(deq), .rst, .pb_debounced(deqDB));
    single_pulser deqPULSE (.clk, .din(deqDB), .d_pulse(deqSP));
    
    debounce repDEBOUNCE (.clk, .pb(enq_deq), .rst, .pb_debounced(repDB));
    single_pulser repPULSE (.clk, .din(repDB), .d_pulse(repSP));
    
    assign enq_signal = (enqSP || repSP);
    assign deq_signal = (deqSP || repSP);

    pq_if U_PQ_IF (.clk);

    ra_pq U_RA_PQ(U_PQ_IF.dev);

   // is it really this easy?
    assign U_PQ_IF.rst = rst;
    assign U_PQ_IF.kvi = kvi;
    assign U_PQ_IF.enq = enq_signal;
    assign full = U_PQ_IF.full;
    assign busy = U_PQ_IF.busy;
    assign empty = U_PQ_IF.empty;
    assign kvo = U_PQ_IF.kvo;
    assign U_PQ_IF.deq = deq_signal;
    
    // 7-segment controller

    sevenseg_ctl SEVENSEG (.clk, .rst, .d7(7'b1111111), .d6(7'b1111111), .d5(7'b1111111), .d4(7'b1111111), .d3({3'b0, kvo[15:12]}), .d2({3'b0, kvo[11:8]}), .d1({3'b0, kvo[7:4]}), .d0({3'b0, kvo[3:0]}), 
                           .segs_n, .dp_n, .an_n);

endmodule
