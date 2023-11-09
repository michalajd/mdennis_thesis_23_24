`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2023 12:42:44 PM
// Design Name: 
// Module Name: quickTopTest
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


module quickTopTest;
    /** Setting logic inputs/outputs */
    logic [31:0] data_lt_i, data_rt_i;
    logic clk, read_i, write_i, reset_i, done;
    logic [7:0] array_size;
    logic [31:0] data_lt_o, data_rt_o;
    logic read_o, write_o, reset_o;
    
    /** Module declaration */
    quickQueueTop DUV (.data_lt_i, .data_rt_i, .clk, .read_i, .write_i, .reset_i, .done, .array_size,
                       .data_lt_o, .data_rt_o, .read_o, .write_o, .reset_o);
                       
    /** Clock declaration */
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    /** Test begin */
    initial begin
        /** Starting values */
    end

endmodule
