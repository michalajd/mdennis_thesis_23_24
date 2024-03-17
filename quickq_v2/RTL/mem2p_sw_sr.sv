`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Title         : mem2p_sw_sr 2-port memory
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// File          : mem2p_sw_sr.sv
// Author        : John Nestor  <nestorj@nestorj-mbpro-15.home>
// Created       : 13.02.2020
// Last modified : 06.06.2022
//-----------------------------------------------------------------------------
// Description :
// Two-port memory with a single clock, a synchronous write port (1)
// and a synchronous read port (2).  This will infer a "Simple Dual Port"
// (SDP) Block RAM in a Xilinx FPGA
//------------------------------------------------------------------------------
// Modification history :
// 13.02.2020 : created
// 06.06.2022 : modified port names to match text
//-----------------------------------------------------------------------------

module mem2p_sw_sr
    #(parameter W=8, D=128, localparam DW=$clog2(D))
    (
    input logic clk,
    input logic we1,
    input logic [DW-1:0] addr1,
    input logic [W-1:0]  din1,
    input logic [DW-1:0] addr2,
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
