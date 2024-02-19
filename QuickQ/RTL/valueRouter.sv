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
module valueRouter import quickQ_pkg::*; (
                   input logic [31:0] bram_out, reg_out, new_last,
                   input vrMode_t mode,
                   input logic enq, deq,
                   input logic [31:0] array_size, array_cnt_in,
                   input logic [1:0] lastop,
                   output logic [31:0] bram_insert, to_register, last_addr,
                   output logic [31:0] data_lt_o, array_cnt_out, data_rt_o,
                   output logic swap, full, empty, done, last_done);
       
    /** Internal logic */
   logic [31:0] size_before_deq; /** Size before dequeue logic is finished */
           
    always_comb
        case (mode)
            VR_DEF: begin /** CASE 1: Default */
                        last_addr = new_last;
                        last_done = 0;
                        full = 0;
                        swap = 0;
                        if (new_last == 0) begin
                            empty = 1;
                            last_addr = 0;
                        end
                        else if (new_last == array_size + 1) full = 1;
                        else begin
                            empty = 0;
                            full = 0;
                        end
                        array_cnt_out = 0;
                        bram_insert = '0;
                        to_register = '0;
                        done = 0;
                        array_cnt_out = array_cnt_in;
                   end
                   
             VR_ENQ_COMPARE: begin /** CASE 2: Compare values (enq)  */
                        /** Compare register and BRAM data */
                        last_done = 0;
                        array_cnt_out = array_cnt_in;
                        done = 0;
                        last_done = 0;
                        if (reg_out === 'x) done = 1;
                        if (reg_out < bram_out || last_addr == 0 || bram_out === 'x) swap = 1'b1; // register value is smaller OR equal to the current BRAM value
                        else swap = 1'b0;                     // register value is smaller than the current BRAM value
                        
                        /** Route data to get into the queue / BRAM */
                        /** If result == 1, the register value is greater than the BRAM, so a swap occurs! */
                        if (swap == 1) begin 
                            bram_insert = reg_out;
                            /*if (!done)*/ to_register = bram_out;
                            /*else to_register = 'x;*/
                            if (empty == 1) empty = 0;
                        end
                        else begin 
                            bram_insert = bram_out;
                            to_register = reg_out;
                        end  
                    end
                    
             VR_DEQ_SWAP: begin /** CASE 3: Swap out values in deq */
                        full = 1'b0;
                        bram_insert = bram_out;
                        if (!empty) to_register = reg_out;
                        else data_lt_o = reg_out;
                     end
                     
             VR_LAST: begin /** CASE 4: Change the "last" index of the array */
                        if (new_last == 0 && lastop == LO_DEQ) begin
                            empty = 1;
                            data_lt_o = reg_out;
                        end
                        else if (new_last > array_size) begin
                            data_rt_o = reg_out;
                        end
                        else if (lastop == LO_ENQ) begin
                            last_done = 1;
                            if (new_last == array_size) full = 1;
                            else full = 0;
                        end
                        else last_done = 0;
                    last_addr = new_last;
                    //last_done = 0;
                    end
            VR_EMPTY: begin  /** Empty case */
                        bram_insert = reg_out;
                        done = 1;
                        //last_done = 1;
                    end
            VR_CNT: begin
                       array_cnt_out = array_cnt_in;
                       //bram_insert = bram_out;
                       //to_register = reg_out; 
                 end
            default: begin /** CASE 1: Default */
                        full = 0;
                        swap = 0;
                        empty = 1;
                        array_cnt_out = 0;
                        last_addr = 0;
                        bram_insert = '0;
                        data_lt_o = '0;
                        data_rt_o = '0;
                        to_register = '0;
                        done = 0;
                        last_done = 0;
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
