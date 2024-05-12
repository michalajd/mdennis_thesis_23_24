`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2024 10:44:40 PM
// Design Name: 
// Module Name: quickq_top
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

module quickq_top;

    logic clk;
    
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    pq_if PQ_IF(clk);
    
    quickq DUV(PQ_IF.dev);
    
    //quickq_tb TB(PQ_IF.tb);
    
endmodule
