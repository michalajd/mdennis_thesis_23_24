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


module qq_top #(parameter W=32, D=4, localparam DW=$clog2(D)) (
    input logic clk, rst, enq, deq,
    input logic [W-1:0] lt_i, rt_i,
    output logic [W-1:0] lt_o, rt_o, // are these needed?
    output logic enq_o, deq_o, // are these needed?
    output logic full_t, empty_t, rdy_t
    );
    
    // Internal logic
    logic [W-1:0] rt_1_lt_2, lt_2_rt_1;
    logic enq_1_2, deq_1_2;
    logic full1, rdy1, empty1, full2, rdy2, empty2;
    
    qq_node #(.W(W), .D(D)) NODE1 (.clk, .rst, .enq_i(enq), .deq_i(deq), .data_lt_i(lt_i), .data_rt_i(lt_2_rt_1),
                                   .rdy(rdy1), .full(full1), .empty(empty1), .enq_o(enq_1_2), .deq_o(deq_1_2),
                                   .data_lt_o(lt_o), .data_rt_o(rt_1_lt_2));
                                   
    qq_node #(.W(W), .D(D)) NODE2 (.clk, .rst, .enq_i(enq_1_2), .deq_i(deq_1_2), .data_lt_i(rt_1_lt_2), .data_rt_i(rt_i),
                                   .rdy(rdy2), .full(full2), .empty(empty2), .enq_o(), .deq_o(),
                                   .data_lt_o(lt_2_rt_1), .data_rt_o(rt_o));
    
    assign full_t = (full1 && full2);
    assign empty_t = (empty1 && empty2);
    assign rdy_t = (rdy1 && rdy2);

endmodule
