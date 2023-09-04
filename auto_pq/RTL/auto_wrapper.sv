`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2022 11:45:08 AM
// Design Name: 
// Module Name: auto_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

import pq_pkg::*;

module auto_wrapper(input logic clk, rst, start, [15:0] kvi_logic,
                    output logic full, busy, empty, 
                    output logic [2:0] color_r, color_g, color_b,
                    output logic dp_n, [6:0] segs_n, [7:0] an_n);
                    
                    kv_t kvi, kvo;
                    logic [15:0] kvo_logic;
                    
                    assign kvi = kv_t'(kvi_logic);
                    assign kvo_logic = kvo;
                    
                    // WIRES
                    logic startDB, startSP;
                    logic enqFSM, deqFSM;
                    logic lfsr_enb, lfsr_rst;
                    logic count_enb, count_rst;
                    logic [3:0] q;
                    logic counter_done;
                    logic [2:0] red, green, blue;
                    logic [3:0] counter2comp;
                    
                    assign q = 4'b0000;
                    
                    // START BUTTON debouncer / single pulser
                    
                    debounce startDEBOUNCE (.clk, .pb(start), .rst, .pb_debounced(startDB));
                    single_pulser startPULSE (.clk, .din(startDB), .d_pulse(startSP));
                    
                    // INTERFACE / PQ SELECTION
                    
                    pq_if U_PQ_IF (.clk);
                    
                    //heap_pq U_HEAP_PQ(U_PQ_IF.client);      // HEAP_PQ (ADD PQ FILES)
                    
                    // FINITE STATE MACHINE
    
                    fsm_pq FSM (.clk, .rst, .start(startSP), .full, .busy, .empty, .error_comp, .cteal_15(counter_done), 
                    .lfsr_rst, .lfsr_enb, .enq(enqFSM), .deq(deqFSM), .count_enb, .count_rst, .led_r(red), .led_g(green), .led_b(blue));
                    
                    // LFSR
                    
                    lfsr LFSR (.rst(lfsr_rst), .clk, .enb(lfsr_enb), .q(kvi_logic));
                    
                    // COMPARATOR
                    
                    comparator COMP (.clk, .kvo(kvo_logic), .count(counter2comp), .verdict(error_comp));
                    
                    // COMPARATOR COUNTER
                    
                    compcounter COMP_COUNT (.clk, .rst(count_rst), .enb(count_enb), .q(counter2comp), .cteal_15(counter_done));
                    
                    // RGB
                    
                    rgb_pwm RGB (.clk, .rst, .led_r(red), .led_g(green), .led_b(blue), .color_r, .color_g, .color_b);
                    
                    // is it really this easy?
                    assign U_PQ_IF.rst = rst;
                    assign U_PQ_IF.kvi = kvi;
                    assign U_PQ_IF.enq = enqFSM;
                    assign full = U_PQ_IF.full;
                    assign busy = U_PQ_IF.busy;
                    assign empty = U_PQ_IF.empty;
                    assign kvo = U_PQ_IF.kvo;
                    assign U_PQ_IF.deq = deqFSM;
                    

    // 7-segment controller

    sevenseg_ctl SEVENSEG (.clk, .rst, .d7(7'b1111111), .d6(7'b1111111), .d5(7'b1111111), .d4(7'b1111111), .d3({3'b0, kvo[15:12]}), .d2({3'b0, kvo[11:8]}), .d1({3'b0, kvo[7:4]}), .d0({3'b0, kvo[3:0]}), 
                           .segs_n, .dp_n, .an_n);
                    
endmodule
