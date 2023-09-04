`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2022 01:07:16 PM
// Design Name: 
// Module Name: compcounter
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


module  compcounter (
    input logic clk, rst, enb, empty,
    input logic [7:0] din,
    output logic verdict, cteal_15
    );

    // WIRES
    logic [7:0] newVal, oldVal;
    logic cont; //test wire that does nothing
    
    flip_flop FF1 (.clk, .rst, .enb, .d(din), .q(newVal));
    flip_flop FF2 (.clk, .rst, .enb, .d(newVal), .q(oldVal)); 
   
    assign verdict = (oldVal > newVal);
    assign cteal_15 = (din == 8'b11111110);
    
endmodule: compcounter
