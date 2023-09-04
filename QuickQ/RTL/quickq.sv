`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2022 02:16:54 PM
// Design Name: 
// Module Name: quickq
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

module quickq(
pq_if.dev di
    );

    logic clk, rst;
    kv_t kvi, kvo;
    logic idle;

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
    assign di.busy = !idle;  // always done in one cycle

    //localparam  LEVELS = $clog2(PQ_CAPACITY+1);

   
   
    //assign empty = (heap_size == 0);

    //assign full = (heap_size == PQ_CAPACITY);

    kv_t i_kv, i_kv_next, j_kv, j_kv_next, min_kv, min_kv_next;

    // memory signals
    logic [KEY_WIDTH+VAL_WIDTH-1:0] din, dout;
    logic we;

    kv_t din_kv, dout_kv;

    assign din = din_kv;
    assign dout_kv = kv_t'(dout);
    
    // INSTANTIATION WIRES
    
    logic [7:0] BRAM_out, BRAM_in, BRAM_reg, temp_reg, location1, location2;
    logic FSM2addr, FSM2size, sel, write, deq_shift;

    // memory (BRAM) for PQ storage
    mem2p_sw_sr #(.W(KEY_WIDTH+VAL_WIDTH), .D(PQ_CAPACITY+1)) U_BRAM (
        .clk, .we, .addr1(location1), .din1(BRAM_in), .addr2(location2), .dout2(BRAM_out));
        
    dffe BRAM_REGISTER (.clk, .d(BRAM_out), .enb, .q(BRAM_reg));

    dffe TEMP_REGISTER (.clk, .d(kvi_logic), .enb, .q(temp_reg)); // look into kvi_logic
    
    //quickFSM FSM (.clk, .rst, .busy, .full, .empty, .enq, .deq, .key_addr(BRAM_reg), .key_reg(temp_reg), .count_incr(FSM2addr), .current_size_enb(FSM2size), .select(sel), .we1(write), .deq_shift,
                  //.key2temp, .key2BRAM(BRAM_in));
                  
    counter_size COUNT_SIZE (.clk, .rst, .sel, .count_size_enb(FSM2addr), .size);
    
    counter_addr COUNT_ADDR (.clk, .rst, .enb(FSM2size), .q(location1));
    
    count_increase COUNT_INCR (.clk, .rst, .enb(deq_shift), .in(location1), .out(location2)); 
    
endmodule
