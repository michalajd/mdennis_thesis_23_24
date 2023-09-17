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
                   input logic [1:0] mode,
                   input logic [7:0] array_size, array_cnt_in,
                   output logic [31:0] bram_insert, to_register,
                   output logic [7:0] array_cnt_out,
                   output logic result, full);
                   
    always_comb
        case (mode)
            2'b00: begin /** CASE 1: Comparator / Route data */
                        /** Compare register and BRAM data */
                        if (reg_out > bram_out || bram_out == 32'hFFFFFFFF) result = 1'b1; // register value is larger OR equal to the current BRAM value
                        else result = 1'b0;                     // register value is smaller than the current BRAM value
                        
                        /** Route data to get into the queue / BRAM */
                        /** If result == 1, the register value is greater than the BRAM, so a swap occurs! */
                        if (result == 1) begin 
                            bram_insert = reg_out;
                            to_register = bram_out;
                        end
                        else begin 
                            bram_insert = bram_out;
                            to_register = reg_out;
                        end
                   end
                   
             2'b01: begin /** CASE 2: Increase the counter for inside the array  */
                        array_cnt_out = array_cnt_in + 1;
                        if (array_cnt_out == array_size) full = 1'b1;
                    end
                    
             default: begin
                        full = 1'b0;
                        result = 0;
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
