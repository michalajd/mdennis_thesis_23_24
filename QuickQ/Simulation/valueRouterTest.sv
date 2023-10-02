`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2023 04:10:48 PM
// Design Name: 
// Module Name: valueRouterTest
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


module valueRouterTest;
    /** Input logic */
    logic [31:0] bram_out, reg_out;
    logic [2:0] mode;
    logic [7:0] array_size, array_cnt_in;
    
    /** Output logic */
    logic [31:0] bram_insert, to_register, data_lt_o;
    logic [7:0] array_cnt_out;
    logic result, full, empty;
    
    /** Instantiate ValueRouter module */
    valueRouter DUV (.bram_out, .reg_out, .mode, .array_size, .array_cnt_in,
                     .bram_insert, .to_register, .data_lt_o, .array_cnt_out, .result, .full, .empty);
                     
    /** Running the Test */
    initial begin
        /** Set initial logic values */
        array_size = 3'd5;
        array_cnt_in = 8'b0;
        
        /** Add a value with an empty queue */
        bram_out = 32'hFFFFFFFF;
        reg_out = 32'd2;
        mode = 3'b000;
        #10;
        
        /** Test queue size increase */
        mode = 3'b001;
        #10;
        array_cnt_in = array_cnt_out;
        
        /** Add a value that would NOT be swapped */
        bram_out = 32'd2;
        reg_out = 32'd1;
        mode = 3'b000;
        #10;
        
        mode = 3'b001;
        #10;
        array_cnt_in = array_cnt_out;
        
        /** Test case for value router being full */
        array_cnt_in = 8'd4;
        bram_out = 32'hf657c062;
        reg_out = 32'hf680d628;
        mode = 3'b000;
        #10;
        
        mode = 2'b001;
        #10;
        array_cnt_in = array_cnt_out;
        
        /** Removing a value */
        array_cnt_in = 8'd2;
        bram_out = 32'h39b034ac;
        reg_out = 32'h39b034ab;
        mode = 3'b010;
        #10;
        
        mode = 3'b011;
        #10;
        array_cnt_in = array_cnt_out;
        
        /** Check empty conditional */
        
        $stop;
    end

endmodule
