`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2023 12:58:43 PM
// Design Name: 
// Module Name: quickQCore
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Modu;e that combines the QuickQ control logic (FSM), value router, and BRAM. This will work
// as a condensed way to make sure that the three modules can work together for simulation.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module quickQCore(
    input logic clk, rst, enq, deq,
    input logic [31:0] reg_out,
    output logic [31:0] data_lt_o,
    output logic [1:0] mux1_sel,
    output logic regenb, next_node, bram_sel
    );
    
    /** NOTE: "size_const" is a constant that is a power of 2 that is used for the size of the BRAM array. */
    const int size_const = 32;
    
    /** Internal wires */
    // MEMORY
    logic we;
    logic [31:0] read_addr, write_addr, bram_insert, bram_out, array_size;
    
    // Instantiations
    mem2p_sw_sr #(.D(size_const)) BRAMDUV (.clk, .we1(we), .addr1(rd_addr), .din1(bram_insert), .addr2(write_addr), .dout2(bram_out), .array_size);
    
endmodule
