`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2022 03:55:03 PM
// Design Name: 
// Module Name: mem2p_sw_sr
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


module mem2p_sw_sr
    #(parameter W=8, D=128, localparam DW=$clog2(D))
    (
    input logic clk,
    input logic we1,
    input logic [DW-1:0] addr1, // WRITE
    input logic [W-1:0]  din1,
    input logic [DW-1:0] addr2, // READ
    output logic [W-1:0] dout2
    );

    logic [W-1:0] ram_array [D-1:0];
    logic [DW-1:0] addr2_r;

    // port 1 write
    always_ff @(posedge clk) begin
        if (we1) ram_array[addr1] <= din1;
    end

    // port 2 read
    always_ff @(posedge clk) begin
        addr2_r <= addr2;
    end

    assign dout2 = ram_array[addr2_r];

endmodule
