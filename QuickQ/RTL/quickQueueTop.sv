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
    logic enq, deq, done, result, full, swap_done, empty, we, regenb, regsel, countenb, read_addr;
    logic [1:0]  mode, mux1_sel;
    
    /** Value Router Logic */
    logic [31:0] bram_out, reg_out, bram_insert, vr_to_reg;
    logic [7:0] array_cnt_in, array_cnt_out;
    
    /** Internal wires */
    logic [31:0] toRegister;
    
    /** Assigning constants for input multiplexer */
    logic [31:0] empty_val = 32'hFFFFFFFF;
    logic [31:0] error_val = 32'b0;
    
    ControlFSM controlDUV(.clk, .rst(reset_i), .enq, .deq, .done, .result, .full, .swap_done, .empty,
                          .we, .regenb, .regsel, .countenb, .read_addr, .mode, .mux1_sel);
    
    // Input multiplexer for left-hand data
    mux4 #(.W(32)) mux1DUV(.d0(data_lt_i), .d1(vr_to_reg), .d2(empty_val), .d3(error_val), .sel(mux1_sel), .y(toRegister));
    
    // Register
    dff regDUV (.clk, .d(toRegister), .q(reg_out));
    
    // Value router declaration
    valueRouter vrDUV(.bram_out, .reg_out, .mode, .array_size, .array_cnt_in, 
                      .bram_insert, .to_register(vr_to_reg), .array_cnt_out, .result, .full, .empty);
                      
    // BRAM declaration
    
endmodule
