`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2023 03:43:20 PM
// Design Name: 
// Module Name: quickNode
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


module quickNode(input logic clk, data_lt_i, data_rt_i, read_i, write_i, reset_i, enq, deq,
                 output logic data_rt_o, data_lt_o, read_o, write_o, reset_o
                 );
                 
                 
                 
                 // WIRES
                 logic enb;
                 logic wBRAM;
                 logic rBRAM;
                 logic sel_b;
                 logic ram_in;
                 logic ram_out;
                 logic sel_o;
                 logic sel_i;
                 logic [31:0] into_reg;
                 logic [31:0] outof_reg;
                 logic router_out;
                 logic fb;
                 logic register_enable;
                 
                 assign data_lt_o = ram_out;
                 
                 controlNode CTL (.clk, .read_i, .write_i, .reset_i, .result(fb), .enq, .deq, .dout(ram_out), .sel_i, .sel_o, .sel_b, .rd_addr(rBRAM), .wr_addr(wBRAM), 
                                  .enables(enb), .read_o, .write_o, .reset_o, .regenb(register_enable), .regsel(sel_i));
                 
                 mem2p_sw_sr BRAM (.clk, .we1(enb), .addr1(wBRAM), .din1(ram_in), .addr2(rBRAM), .dout2(ram_out));
                 
                 mux2 select_in (.d0(), .d1(data_rt_i), .sel(sel_b), .y(ram_in));
                 
                 mux2 data_out (.d0(router_out), .d1(), .sel(sel_o), .y(data_rt_o));
                 
                 mux2 data_in (.d0(data_lt_i), .d1(ram_out), .sel(sel_i), .y(into_reg));
                 
                 dff register (.clk, .enb(register_enable), .d(into_reg), .q(outof_reg));
                 
                 valueRouter VR (.clk, .reg_data(outof_reg), .ram_data(ram_out), .data_out(router_out), .fb(fb));
                 
                 
endmodule
