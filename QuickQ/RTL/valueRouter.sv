`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2023 02:09:01 PM
// Design Name: 
// Module Name: valueRouter
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
module valueRouter(input logic [31:0] bram_out, reg_out,
                   input logic [2:0] mode,
                   input logic enq, deq,
                   input logic [31:0] array_size, array_cnt_in,
                   output logic [31:0] bram_insert, to_register, last_addr,
                   output logic [31:0] data_lt_o, array_cnt_out,
                   output logic result, full, empty, done);
       
    /** Internal logic */
   logic [31:0] size_before_deq; /** Size before dequeue logic is finished */
                
    always_comb
        casez (mode)
            2'b000: begin /** CASE 1: Comparator / Route data */
                        if (array_cnt_in == 0) begin
                            last_addr = 0;
                            empty = 1'b0;
                        end
                        done = 1'b0;
                        /** Compare register and BRAM data */
                        if (reg_out > bram_out || last_addr == 0) result = 1'b1; // register value is larger OR equal to the current BRAM value
                        else result = 1'b0;                     // register value is smaller than the current BRAM value
                        
                        /** Route data to get into the queue / BRAM */
                        /** If result == 1, the register value is greater than the BRAM, so a swap occurs! */
                        if (result == 1) begin 
                         /** Handle done case first */
                           /* if (bram_out == 32'hXXXXXXXX) begin
                                done = 1'b1;   
                                last_addr = array_cnt_in + 1;
                            end */
                            bram_insert = reg_out;
                            to_register = bram_out;
                            if (empty == 1) empty = 0;
                        end
                        else begin 
                            bram_insert = bram_out;
                            to_register = reg_out;
                        end
                   end
                   
             3'b001: begin /** CASE 2: Increase the counter for inside the array  */
                        result = 0;
                        done = 0;
                        array_cnt_out = array_cnt_in + 1;
                        //last_addr = array_cnt_out;
                        if (array_cnt_out == array_size) full = 1'b1;
                    end
                    
             3'b010: begin /** CASE 3: Find last element of queue */
                        done = 0;
                        array_cnt_out = last_addr;
                        size_before_deq = last_addr;
                        
                     end
                     
             3'b011: begin /** CASE 4: Decrease position of all elements until final element is removed*/
                        full = 1'b0;
                        bram_insert = bram_out;
                        if (!empty) to_register = reg_out;
                        else begin
                        data_lt_o = reg_out;
                        done = 1;
                        end
                     end
                    
             3'b100: begin /** CASE 5: Decrease the counter for inside the array */
                        if (array_cnt_in != 0) array_cnt_out = array_cnt_in - 1;
                        if (last_addr != 0) last_addr = size_before_deq - 1;
                        if (array_cnt_out == 0) begin
                            if (last_addr == 0) empty = 1'b1;
                            else empty = 1'b0;
                        end  
             end    
             default: begin
                        full = 0;
                        result = 0;
                        empty = 1;
                        array_cnt_out = 0;
                        last_addr = 0;
                        bram_insert = 32'b0;
                        data_lt_o = 32'bZ;
                        to_register = 32'bZ;
                        done = 0;
                      end
                      
        endcase

endmodule

/**module valueRouter(input logic clk, 
                   input logic [31:0] reg_data, ram_data,
                   output logic [31:0] data_out, 
                   output logic result,
                   output logic done);
                   
                   always_comb
                    if (reg_data > ram_data) result = 1'b0; // register value is larger OR equal to the current BRAM value / result = 1
                    else result = 1'b1;                     // register value is smaller than the current BRAM value / result = 0

                    mux2 MUX (.d0(reg_data), .d1(ram_data), .sel(result), .y(data_out));
                    
                    assign done = (reg_data == 32'hFFFF) ? 1'b1 : 1'b0;

endmodule */
