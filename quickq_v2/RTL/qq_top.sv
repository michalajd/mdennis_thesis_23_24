`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2024 03:28:28 PM
// Design Name: 
// Module Name: qq_top
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

module qq_top #(parameter W=32, D=4, localparam DW=$clog2(D)) (
    input logic clk, rst, enq, deq, repl,
    input kv_t lt_i, rt_i,
    output kv_t lt_o, rt_o, // are these needed?
    output logic enq_o, deq_o, repl_o, // are these needed?
    output logic full_t, empty_t, rdy_t
    );
    
    // Internal parameters
    parameter kv_t MAX_KEY = KV_EMPTY;
    
    // Internal logic
    kv_t rt_1_lt_2, lt_2_rt_1;
    logic enq_1_2, deq_1_2, repl_1_2;
    logic full1, rdy1, empty1, full2, rdy2, empty2;
    
    qq_node #(.W(W), .D(D)) NODE1 (.clk, .rst, .enq_i(enq), .deq_i(deq), .repl_i(repl), .data_lt_i(lt_i), .data_rt_i(lt_2_rt_1),
                                   .rdy(rdy1), .full(full1), .empty(empty1), .enq_o(enq_1_2), .deq_o(deq_1_2), .repl_o(repl_1_2),
                                   .data_lt_o(lt_o), .data_rt_o(rt_1_lt_2));
                                   
    qq_node #(.W(W), .D(D)) NODE2 (.clk, .rst, .enq_i(enq_1_2), .deq_i(deq_1_2), .repl_i(repl_1_2), .data_lt_i(rt_1_lt_2), .data_rt_i(MAX_KEY),
                                   .rdy(rdy2), .full(full2), .empty(empty2), .enq_o(), .deq_o(), .repl_o(),
                                   .data_lt_o(lt_2_rt_1), .data_rt_o(rt_o));
    
    assign full_t = full2;
    assign empty_t = empty1;
    assign rdy_t = rdy1;

endmodule
