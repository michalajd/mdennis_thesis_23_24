`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2023 03:48:05 PM
// Design Name: 
// Module Name: controlNode
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


module controlNode(input logic clk, read_i, write_i, reset_i, result, enq, deq, dout,
                   output logic sel_i, sel_o, sel_b, rd_addr, wr_addr, enables, read_o, write_o, reset_o, regenb, regsel
                   );
                   
                   // WIRES
                   logic count_increase;
                   logic rst;
                   
                   ControlFSM FSM (.clk, .rst, .enq(enq), .deq(deq), .dout, .result(result), .we(enables), .regenb(regenb), .regsel(sel_i), .countenb(count_increase));
                   
                   counter COUNT (.clk, .rst, .enb(count_increase), .q(rd_addr));
endmodule
