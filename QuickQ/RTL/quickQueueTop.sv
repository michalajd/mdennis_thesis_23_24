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
                     input logic clk, read_i, write_i, reset_i,
                     input logic [7:0] array_size,
                     output logic [31:0] data_lt_o, data_rt_o,
                     output logic read_o, write_o, reset_o

    );
    
    /** FSM Logic */
    logic enq, deq, done, result, full, swap_done, empty, we, regenb, regsel, countenb, read_addr, bram_sel, next_node;
    logic [1:0]  mode, mux1_sel;
    logic [31:0] rd_addr, wr_addr;
    
    /** Value Router Logic */
    logic [31:0] bram_out, reg_out, bram_insert, vr_to_reg;
    logic [7:0] array_cnt_in, array_cnt_out;
    
    /** Internal wires */
    logic [31:0] toRegister;
    
    /** Assigning constants for input multiplexer */
    logic [31:0] empty_val = 32'hFFFFFFFF;
    logic [31:0] error_val = 32'b0;
    
    /** Control logic initialization */
    ControlFSM controlDUV(.clk, .rst(reset_i), .enq, .deq, .done, .result, .full, .swap_done, .empty,
                          .we, .regenb, .regsel, .countenb, .re, .next_node, .bram_sel, .rd_addr, .wr_addr, .mode, .mux1_sel);
    
    /** Input multiplexer for left-hand data */
    mux4 #(.W(32)) mux1DUV(.d0(data_lt_i), .d1(vr_to_reg), .d2(empty_val), .d3(error_val), .sel(mux1_sel), .y(toRegister));
    
    /** Temp register declaration */
    dff regDUV (.clk, .d(toRegister), .q(reg_out));
    
    /** Value router declaration */
    valueRouter vrDUV(.bram_out, .reg_out, .mode, .array_size, .array_cnt_in, 
                      .bram_insert, .to_register(vr_to_reg), .array_cnt_out, .result, .full, .empty);
                      
    /** BRAM declaration */
    mem2p_sw_sr BRAMDUV (.clk, .we1(we), .addr1(write_addr), .din1(bram_insert), .addr2(read_addr), .dout2(bram_out));
    
    /** Output multiplexer for right-hand data */
    mux2 #(.W(32)) mux2DUV(.d0(reg_out), .d1(32'bZ), .sel(next_node), .y(data_rt_o));
    
    /** Multiplexer for controlling BRAM inputs */
    mux2 #(.W(32)) mux3DUV(.d0(bram_insert), .d1(data_rt_i), .sel(bram_sel), .y(bram_insert));
    
endmodule
