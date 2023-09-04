`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2022 11:46:11 AM
// Design Name: 
// Module Name: high_level
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

module high_level(input logic clk, rst, start,
                  output logic [7:0] data1, data2,
                  output logic [2:0] red, green, blue,
                  output logic sigIDLE, sigSTART, sigADD, sigREMOVE, sigDISPLAY, sigFULL, sigEMPTY);
                  
                  
                  // WIRES
                  
                  //logic enq, deq;
                  //kv_t kvi, kvo;
                  
                  logic [15:0] kvo_logic;
                  
                  logic toDisplay;
                   // INTERFACE
                  
                  //pq_if U_PQ_IF (.clk);
                  pq_rd_if U_PQ_IF_RD (.clk);
                                   
                  auto_top AUTO (.ti(U_PQ_IF_RD.client), .start, .color_r(red), .color_g(green), .color_b(blue), .data1, .data2,
                                 .sigIDLE, .sigSTART, .sigADD, .sigREMOVE, .sigDISPLAY, .sigFULL, .sigEMPTY, .toDisplay);
                      
                  // PRIORITY QUEUE AND INTERFACE CONNECTIONS
                  
                  //heap_pq U_HEAP_PQ(U_PQ_IF.dev); //IT WORKS
                  //sr_pq U_SR_PQ(U_PQ_IF.dev); //IT WORKS
                  //sr_pq_s U_SR_PQ_S(U_PQ_IF.dev); //IT WORKS
                  //pheap_pq U_PHEAP(U_PQ_IF.dev);
                  ra_pq_s U_RA_PQ_S(U_PQ_IF_RD.dev); // Needs another interface???
                  //ra_pq_r U_RA_PQ_R(U_PQ_IF.dev);
                  //ra_pq U_RA_PQ(U_PQ_IF_RD.dev);
                  
                  assign U_PQ_IF_RD.rst = rst;
                  /* is it really this easy? (is this really necessary?)
                  assign U_PQ_IF.kvi = kvi;
                  assign U_PQ_IF.enq = enq;
                  assign full = U_PQ_IF.full;
                  assign busy = U_PQ_IF.busy;
                  assign empty = U_PQ_IF.empty;
                  assign kvo = U_PQ_IF.kvo;
                  assign U_PQ_IF.deq = deq;
               */
                  

endmodule
