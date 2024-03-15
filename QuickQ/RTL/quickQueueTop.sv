`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 12:14:37 PM
// Design Name: 
// Module Name: quickQueueTop
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


module quickQueueTop (
                     input logic [31:0] data_lt_i, data_rt_i,
                     input logic clk, rst, enq, deq,
                     input logic [31:0] array_size,
                     output logic [31:0] data_lt_o, data_rt_o

    );
    
    import quickQ_pkg::*;
    
    /** Assigning constants */
    logic empty_val = '1;
    logic error_val = '0;
    parameter W = 32;
    parameter D = 4;
    parameter DW = $clog2(D);
    
    /** Internal logic */
    logic [W-1:0] toRegister, data_lt;
    
    /** FSM logic */
    logic we, regenb, next_node, prev_node, array_cnt_ld, array_cnt_clr, array_cnt_deq, array_cnt_inc, bram_sel, fill_rst;
    logic fill_cnt, cnt_done, cnt_rst, op_enb;
    vrMode_t mode;
    logic [1:0] mux1_sel;
    
    /** Value Router logic */
    logic [W-1:0] to_register, last_addr, bram_insert, array_cnt_out, data_rt;
    logic [DW-1:0] pointer_prev;
    logic swap, full, empty, done, last_done;
    
    /** SRFF logic */
    logic set_full, clr_full, set_empty, clr_empty, set_done, clr_done, set_swap, clr_swap;
    
    /** Register logic */
    logic [W-1:0] new_last, array_cnt_in, pointer_next, reg_out;
    
    /** BRAM logic */
    logic [W-1:0] bram_out, mux3_BRAM;
    
    /** Last Operation Encoder logic */
    logic [1:0] lastop;
    
    /** FSM declaration */
    ControlFSM #(.W(32), .D(4)) fsmDUV (.clk, .rst, .enq, .deq, .swap, .full, .empty, .done, .cnt_done, .last_addr, .array_cnt_out, .we, .regenb, .next_node, .prev_node, 
                       .array_cnt_ld, .array_cnt_clr, .array_cnt_deq, .array_cnt_inc, .bram_sel, .fill_cnt, .fill_rst, .cnt_rst, 
                       .mode, .mux1_sel, .op_enb);
                       
    /** Input multiplexer for left-hand data */
    mux4 #(.W(32)) mux1DUV(.d0(data_lt_i), .d1(to_register), .d2(empty_val), .d3(error_val), .sel(mux1_sel), .y(toRegister));
    
    /** Register to load input data */
    dffe #(.W(32)) regDUV (.clk, .d(toRegister), .enb(regenb), .q(reg_out));
    
    /** Counter for the pointer */
    array_pointer #(.D(4)) pointDUV (.clk, .rst, .cnt_rst, .array_cnt_ld, .array_cnt_clr, .array_cnt_deq, .array_cnt_inc, .array_cnt_out,
                            .last_index(last_addr), .pointer_next, .pointer_prev);
                     
    /** BRAM declaration */
    mem2p_sw_sr #(.W(32), .D(4)) bramDUV (.clk, .we1(we), .addr1(array_cnt_out), .din1(mux3_BRAM), .addr2(pointer_next), .dout2(bram_out));

    /** Value Router instantiation */
    valueRouter #(.W(32), .D(4)) vrDUV (.bram_out(bram_out), .reg_out, .new_last, .mode, .enq, .deq, .swap, .array_size, .array_cnt_in(pointer_next),
                       .pointer_prev, .lastop, .bram_insert, .to_register, .data_lt_o, .data_rt_o(data_rt), .last_addr, .array_cnt_out,
                       .set_swap, .clr_swap, .set_full, .clr_full, .set_empty, .clr_empty, .set_done, .clr_done, .last_done);
              
    /** Last value register instantiation */                   
    last_cnt #(.W(32), .D(4)) lastDUV ( .clk, .rst, .last_addr, .lastop, .last_done, .new_last);
    
    /** 2-port multiplexer instantiations */
    mux2 #(.W(32)) mux2DUV(.d0(data_rt), .d1(32'bZ), .sel(next_node), .y(data_rt_o));
    mux2 #(.W(32)) mux3DUV(.d0(bram_insert), .d1(data_rt_i), .sel(bram_sel), .y(mux3_BRAM));
    mux2 #(.W(32)) mux4DUV(.d0(data_lt), .d1(32'bZ), .sel(prev_node), .y(data_lt_o));
    
    /** Counter for the "full" case */
    count2 fullDUV(.clk, .rst, .fill_rst, .fill_cnt, .cnt_done);
    
    /** Last Operation Encoder instantiation */
    lastop_enc lastopDUV (.clk, .rst, .enb(op_enb), .enq, .deq, .lastop);
    
    /** SRFFs for remembering full/empty values instantiation */
    reg_sr fullregDUV (.clk, .rst, .s(set_full), .r(clr_full), .q(full));
    reg_sr_empty emptyregDUV (.clk, .rst, .s(set_empty), .r(clr_empty), .q(empty));
    reg_sr doneregDUV (.clk, .rst, .s(set_done), .r(clr_done), .q(done));
    reg_sr swapregDUV (.clk, .rst, .s(set_swap), .r(clr_swap), .q(swap));
    
endmodule
