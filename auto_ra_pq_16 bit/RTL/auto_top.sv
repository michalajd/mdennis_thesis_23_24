`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2022 02:34:58 PM
// Design Name: 
// Module Name: auto_top
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

module auto_top(pq_rd_if.client ti,
                input logic start, 
                output logic [2:0] color_r, color_g, color_b,
                output logic [7:0] data1, data2,
                output logic sigIDLE, sigSTART, sigADD, sigREMOVE, sigDISPLAY, sigFULL, sigEMPTY, toDisplay);
                
                logic [15:0] kvo_logic;
                logic [7:0] kvi_logic;
                
                //INTERFACE DECLARATIONS
                logic clk;
                kv_t kvi, kvo;
                
                assign clk = ti.clk;
                
                //assign toDisplay = (kvo_logic == 8'b11111110);
                
                // WIRES
                logic full, empty, busy, replace, deq;
                logic lfsr_rst, lfsr_enb;
                logic cteal_15;
                logic count_rst, count_enb;
                logic [3:0] counter2comp;
                logic error_comp;
                logic rst;
                logic [7:0] INVkvi;
                
                assign data1 = kvo_logic[15:8];
                assign data2 = kvo_logic[7:0];
                
                assign full = ti.full;
                assign busy = ti.busy;
                assign sigFULL = ti.full;
                assign empty = ti.empty;
                assign sigEMPTY = ti.empty;
                assign rst = ti.rst;

                assign ti.replace = replace && !full;
                assign ti.deq = deq && !empty;
                
                
                fsm_pq FSM (.clk, .rst, .start, .full, .busy, .empty, .error_comp, .cteal_15, .toDisplay,
                            .lfsr_rst, .lfsr_enb, .enq(replace), .deq, .count_enb, .count_rst, .led_r(color_r), .led_g(color_g), .led_b(color_b),
                            .sigIDLE, .sigSTART, .sigADD, .sigREMOVE, .sigDISPLAY);
                            
                lfsr LFSR (.rst(lfsr_rst), .clk, .enb(lfsr_enb), .q(INVkvi)); 
                
                assign kvi_logic = ~INVkvi;

                assign kvi = kv_t' {kvi_logic, kvi_logic};
                assign ti.kvi = kvi;
                assign kvo = ti.kvo;
                assign kvo_logic = kvo;
                
                compcounter COMPCOUNT (.clk, .rst(count_rst), .enb(count_enb), .empty, .din(kvo_logic[15:8]), .verdict(error_comp), .cteal_15(cteal_15));
                
                //comparator COMP (.kvo(kvo_logic[7:4]), .count(counter2comp), .verdict(error_comp));
                
                
endmodule
