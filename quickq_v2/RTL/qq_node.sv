`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2024 04:57:45 PM
// Design Name: 
// Module Name: qq_node
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

module qq_node #(parameter W=32, D=4, localparam DW=$clog2(D)) (
    input logic clk, rst, enq_i, deq_i, repl_i,
    input kv_t data_lt_i, data_rt_i,
    output logic rdy, full, empty, enq_o, deq_o, repl_o,
    output kv_t data_lt_o, data_rt_o);
    
    // Internal parameters
    parameter logic [W-1:0] MAX_KEY = '1;
    
    // Internal logic
    kv_t mux2_reg, mux4_bram, ram_out;
    
    // Control node logic
    logic sel_t, ld_t, we, t_gt_ram_out, t_gt_data_rt_i;
    logic [1:0] sel_b;
    logic [$clog2(PQ_CAPACITY)-1:0] rd_addr, wr_addr;

    assign data_lt_o = ram_out;
    
    // 2-input multiplexer
    //mux2 #(.W(W)) TMUX (.d0(data_lt_i), .d1(ram_out), .sel(sel_t), .y(mux2_reg));
    pq_mux2 TMUX (.a(data_lt_i), .b(ram_out), .s(sel_t), .y(mux2_reg));
    
    // Temp register
    //dffre #(.W(W)) TEMP (.clk, .rst, .enb(ld_t), .d(mux2_reg), .q(data_rt_o));
    kv_dffre TEMP (.clk, .rst, .enb(ld_t), .d(mux2_reg), .q(data_rt_o));
    
    // BRAM
    mem2p_sw_sr #(.W(KEY_WIDTH+VAL_WIDTH), .D(D)) BRAM 
        (.clk, .we1(we), .addr1(wr_addr), .din1(mux4_bram), .addr2(rd_addr), .dout2(ram_out));
    
    // Key Comparator
    //cmp_mag #(.W(W)) KCMP (.a(data_rt_o), .b(ram_out), .a_gt_b(t_gt_ram_out));
    kv_cmp_mag KCMP (.a(data_rt_o), .b(ram_out), .a_gt_b(t_gt_ram_out));
    
    // Comparator for replace
    //cmp_mag_rep #(.W(W)) KCMP2 (.a(data_rt_o), .b(data_rt_i), .a_gt_b(t_gt_data_rt_i));
    kv_cmp_mag KCMP2 (.a(data_rt_o), .b(data_rt_i), .a_gt_b(t_gt_data_rt_i));
    
    // 4-input multiplexer
    //mux4 #(.W(W)) RMUX (.d0(ram_out), .d1(data_rt_o), .d2(data_rt_i), .d3(MAX_KEY), .sel(sel_b), .y(mux4_bram));
    kv_mux4 RMUX (.a(ram_out), .b(data_rt_o), .c(data_rt_i), .d({KEYMAX, VAL0}), .s(sel_b), .y(mux4_bram));
    
    // Controller
    qq_control #(.W(W), .D(D)) CTL (.clk, .rst, .enq_i, .deq_i, .repl_i, .t_gt_ram_out, .t_gt_data_rt_i, .ram_out, 
                                    .sel_t, .ld_t, .we, .enq_o, .deq_o, .repl_o, .rdy, .full, .empty, 
                                    .sel_b, .rd_addr, .wr_addr);

endmodule
