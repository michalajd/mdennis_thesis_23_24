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


module qq_node #(parameter W=8, D=4, localparam DW=$clog2(D)) (
    input logic clk, rst, enq_i, deq_i,
    input logic [W-1:0] data_lt_i, data_rt_i,
    output logic full, empty, enq_o, deq_o,
    output logic [W-1:0] data_lt_o, data_rt_o);
    
    // Internal parameters
    parameter MAX_KEY = '1;
    
    // Internal logic
    logic [W-1:0] mux2_reg, mux4_bram, ram_out;
    
    // Control node logic
    logic sel_t, ld_t, we, t_gt_ram_out;
    logic [1:0] sel_b;
    logic [DW-1:0] rd_addr, wr_addr;
    
    // 2-input multiplexer
    mux2 #(.W(W)) mux2DUV (.d0(data_lt_i), .d1(data_lt_o), .sel(sel_t), .y(mux2_reg));
    
    // Temp register
    dffe #(.W(W)) tempDUV (.clk, .enb(ld_t), .d(mux2_reg), .q(data_rt_o));
    
    // BRAM
    mem2p_sw_sr #(.W(W), .D(D)) bramDUV (.clk, .we1(we), .addr1(wr_addr), .din1(mux4_bram), .addr2(rd_addr), .dout2(ram_out));
    
    // Key Comparator
    cmp_mag #(.W(W)) kcmpDUV (.a(data_rt_o), .b(data_lt_o), .a_gt_b(t_gt_ram_out));
    
    // 4-input multiplexer
    mux4 #(.W(W)) mux4DUV (.d0(ram_out), .d1(data_rt_o), .d2(data_rt_i), .d3(MAX_KEY), .sel(sel_b), .y(mux4_bram));
    
    // Controller
    qq_control #(.W(W), .D(D)) controlDUV (.clk, .rst, .enq_i, .deq_i, .t_gt_ram_out, .sel_t, .ld_t, .we,
                                           .enq_o, .deq_o, .sel_b, .rd_addr, .wr_addr);
    
endmodule
