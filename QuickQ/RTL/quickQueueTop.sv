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


module quickQueueTop(input logic [31:0] data_lt_i, data_rt_i,
                     input logic clk, rst, enq, deq,
                     input logic [7:0] array_size,
                     output logic [31:0] data_lt_o, data_rt_o

    );
    
    /** Assigning constants */
    logic empty_val = 32'bZ;
    logic error_val = 32'b0;
    
    /** Internal logic */
    logic [31:0] toRegister, data_lt, last_index;
    
    /** FSM logic */
    logic we, regenb, next_node, prev_node, array_cnt_ld, array_cnt_clr, array_cnt_decr, array_cnt_inc, bram_sel, fill_rst;
    logic fill_cnt, cnt_done, cnt_rst;
    logic [2:0] mode;
    logic [1:0] mux1_sel;
    
    /** Value Router logic */
    logic [31:0] to_register, last_addr, bram_insert, array_cnt_out, data_rt;
    logic swap, full, empty, done, last_done;
    
    /** Register logic */
    logic [31:0] new_last, array_cnt_in, pointer_next, reg_out;
    
    /** BRAM logic */
    logic [31:0] bram_out, mux3_BRAM;
    
    /** FSM declaration */
    ControlFSM fsmDUV (.clk, .rst, .enq, .deq, .swap, .full, .empty, .done, .cnt_done, .last_addr, .we, .regenb, .next_node, .prev_node, 
                       .array_cnt_ld, .array_cnt_clr, .array_cnt_decr, .array_cnt_inc, .bram_sel, .fill_cnt, .fill_rst, .cnt_rst, .mode, .mux1_sel);
                       
    /** Input multiplexer for left-hand data */
    mux4 #(.W(8)) mux1DUV(.d0(data_lt_i), .d1(to_register), .d2(empty_val), .d3(error_val), .sel(mux1_sel), .y(toRegister));
    
    /** Register to load input data */
    dffe #(.W(8)) regDUV (.clk, .d(toRegister), .enb(regenb), .q(reg_out));
    
    /** Counter for the pointer */
    array_pointer pointDUV (.clk, .rst, .cnt_rst, .array_cnt_ld, .array_cnt_clr, .array_cnt_decr, .array_cnt_inc, .array_cnt_out,
                            .last_index, .pointer_next);
                     
    /** BRAM declaration */
    mem2p_sw_sr #(.W(8), .D(4)) bramDUV (.clk, .we1(we), .addr1(array_cnt_out), .din1(mux3_BRAM), .addr2(pointer_next), .dout2(bram_out),
                 .array_size);

    /** Value Router instantiation */
    valueRouter vrDUV (.bram_out(bram_out), .reg_out, .new_last, .mode, .enq, .deq, .array_size, .array_cnt_in(pointer_next), 
                       .bram_insert, .to_register, .last_addr, .data_lt_o, .array_cnt_out, .data_rt_o(data_rt), 
                       .swap, .full, .empty, .done, .last_done);
              
    /** Last value register instantiation */                   
    last_cnt lastDUV ( .clk, .rst, .last_addr, .enq, .deq, .last_done, .new_last);
    
    /** 2-port multiplexer instantiations */
    mux2 #(.W(8)) mux2DUV(.d0(data_rt), .d1(32'bZ), .sel(next_node), .y(data_rt_o));
    mux2 #(.W(8)) mux3DUV(.d0(bram_insert), .d1(data_rt_i), .sel(bram_sel), .y(mux3_BRAM));
    mux2 #(.W(8)) mux4DUV(.d0(data_lt), .d1(32'bZ), .sel(prev_node), .y(data_lt_o));
    
    /** Counter for the "full" case */
    count2 fullDUV(.clk, .rst, .fill_rst, .fill_cnt, .cnt_done);
    
//    /** FSM Logic */
//    logic enq, deq, done, result, full, swap_done, empty, we, regenb, regsel, countenb, rd_addr, bram_sel, re, next_node;
//    logic [1:0]  mode, mux1_sel;
//    logic [31:0] rd_addr, wr_addr;
    
//    /** Value Router Logic */
//    logic [31:0] bram_out, reg_out, bram_insert, vr_to_reg, donereg_to_vr;
//    logic [7:0] array_cnt_in, array_cnt_out;
    
//    /** Internal wires */
//    logic [31:0] toRegister;
    
//    /** Assigning constants for input multiplexer */
//    logic [31:0] empty_val = 32'hFFFFFFFF;
//    logic [31:0] error_val = 32'b0;
    
//    /** Control logic initialization */
//    ControlFSM controlDUV(.clk, .rst(reset_i), .enq, .deq, .done, .result, .full, .swap_done, .empty,
//                          .we, .regenb, .regsel, .countenb, .next_node, .bram_sel, .rd_addr, .wr_addr, .mode, .mux1_sel);
    
//    /** Input multiplexer for left-hand data */
//    mux4 #(.W(32)) mux1DUV(.d0(data_lt_i), .d1(vr_to_reg), .d2(empty_val), .d3(error_val), .sel(mux1_sel), .y(toRegister));
    
//    /** Temp register declaration */
//    dffe regDUV (.clk, .d(toRegister), .enb(regenb), .q(reg_out));
    
//    /** Register for last value declaration */
//    dffe lastDUV (.clk, .d(toRegister), .enb(done), .q(donereg_to_vr));
    
//    /** Value router declaration */
//    valueRouter vrDUV(.bram_out, .reg_out, .mode, .array_size, .array_cnt_in, 
//                      .bram_insert, .to_register(vr_to_reg), .array_cnt_out, .result, .full, .empty, .done);
                      
//    /** BRAM declaration */
//    mem2p_sw_sr BRAMDUV (.clk, .we1(we), .addr1(write_addr), .din1(bram_insert), .addr2(rd_addr), .dout2(bram_out));
    
//    /** Output multiplexer for right-hand data */
//    mux2 #(.W(32)) mux2DUV(.d0(reg_out), .d1(32'bZ), .sel(next_node), .y(data_rt_o));
    
//    /** Multiplexer for controlling BRAM inputs */
//    mux2 #(.W(32)) mux3DUV(.d0(bram_insert), .d1(data_rt_i), .sel(bram_sel), .y(bram_insert));
    
endmodule
