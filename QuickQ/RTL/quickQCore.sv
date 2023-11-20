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
    output logic [31:0] data_lt_o, to_register,
    output logic [1:0] mux1_sel,
    output logic regenb, next_node
    );
    
    /** Internal wires */
    // MEMORY
    logic we;
    logic [31:0] rd_addr, write_addr, array_size;
    logic [31:0] bram_out, bram_insert; 
    
    // VALUE ROUTER
    logic result, full, empty, done;
    logic [2:0] mode;
    logic [31:0] array_cnt_in, last_addr, data_lt_o, array_cnt_out;
    
    // FSM LOGIC
    logic [1:0] mux1_sel;

    // Instantiations
    // BRAM
    mem2p_sw_sr #(.W(32), .D(3)) BRAMDUV (.clk, .we1(we), .addr1(rd_addr), .din1(bram_insert), .addr2(write_addr), .dout2(bram_out), .array_size);
    
    // VALUE ROUTER
    valueRouter VRDUV (.bram_out, .reg_out, .mode, .array_size, .array_cnt_in, .bram_insert, .to_register, .last_addr,
                       .data_lt_o, .array_cnt_out, .result, .full, .empty, .done);
    
    // FSM LOGIC
    ControlFSM FSMDUV (.clk(clk), .rst(rst), .enq(enq), .deq(deq), .result(result), .full(full), .swap_done(done), .empty(empty),
                       .last_addr(last_addr), .we(we), .regenb(regenb), .next_node(next_node), .rd_addr(rd_addr), 
                       .wr_addr(write_addr), .mode(mode), .mux1_sel(mux1_sel));
    
    always_ff @ (posedge clk) begin
        array_cnt_in = array_cnt_out;
    end
    
endmodule
