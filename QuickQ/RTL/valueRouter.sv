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
module valueRouter import quickQ_pkg::*; 
       #(parameter W=8, D=128, localparam DW=$clog2(D)) (
                   input logic [W-1:0] bram_out, reg_out, new_last,
                   input vrMode_t mode,
                   input logic enq, deq, swap,
                   input logic [DW-1:0] array_size, array_cnt_in, pointer_prev,
                   input logic [1:0] lastop,
                   output logic [W-1:0] bram_insert, to_register, data_lt_o, data_rt_o,
                   output logic [DW-1:0]last_addr, array_cnt_out,
                   output logic set_swap, clr_swap, set_full, clr_full, set_empty, clr_empty, set_done, clr_done, last_done);
       
    /** Internal logic */
   logic [31:0] size_before_deq; /** Size before dequeue logic is finished */
   logic [31:0] next_bram; /** SHOULD BE A REG SIGNAL: Value in the "i+1" of the BRAM */
           
    always_comb
        begin
            bram_insert = '0;
            to_register = '0;
            data_lt_o = '0;
            data_rt_o = '0;
            set_swap = 0;
            clr_swap = 0;
            set_full = 0;
            clr_full = 0;
            set_empty = 0;
            clr_empty = 0;
            set_done = 0;
            clr_done = 0;
            last_done = 0;
        case (mode)
            VR_DEF: begin /** CASE 1: Default */
                        last_addr = new_last;
                        last_done = 0;
                        clr_full = 1;
                        clr_swap = 1;
                        if (new_last == 0) begin
                            set_empty = 1;
                            last_addr = 0;
                        end
                        else if (new_last == array_size + 1) set_full = 1;
                        else begin
                            //clr_empty = 1;
                            //clr_full = 1;
                        end
                        array_cnt_out = 0;
                        bram_insert = '0;
                        to_register = '0;
                        clr_done = 1;
                        array_cnt_out = array_cnt_in;
                   end
                   
             VR_ENQ_COMPARE: begin /** CASE 2: Compare values (enq)  */
                        /** Compare register and BRAM data */
                        last_done = 0;
                        array_cnt_out = array_cnt_in;
                        clr_done = 1;
                        if (reg_out === 'x) begin 
                            set_done = 1;
                            clr_done = 0;
                        end
                        if (reg_out < bram_out || last_addr == 0 || bram_out === 'x) set_swap = 1; // register value is smaller OR equal to the current BRAM value
                        //else clr_swap = 1;                     // register value is smaller than the current BRAM value
                        
                        /** Route data to get into the queue / BRAM */
                        /** If result == 1, the register value is greater than the BRAM, so a swap occurs! */
//                        if (swap) begin 
//                            bram_insert = reg_out;
//                            /*if (!done)*/ to_register = bram_out;
//                            /*else to_register = 'x;*/
//                            //if (empty == 1) empty = 0;
//                        end 
//                        else begin 
//                            bram_insert = bram_out;
//                            to_register = reg_out;
//                        end  
                    end
                    
             VR_DEQ_SWAP: begin /** CASE 3: Swap out values in deq */
                        array_cnt_out = pointer_prev;
                        clr_full = 1;
                        if (array_cnt_in == '0) data_lt_o = bram_out;
                        bram_insert = bram_out;
                     end
                     
             VR_LAST: begin /** CASE 4: Change the "last" index of the array */
                        if (new_last == 0 && lastop == LO_DEQ) begin
                            set_empty = 1;
                            data_lt_o = reg_out;
                        end
                        else if (new_last > array_size) begin
                            data_rt_o = reg_out;
                        end
                        else if (lastop == LO_ENQ) begin
                            last_done = 1;
                            if (new_last == array_size) set_full = 1;
                            else clr_full = 1;
                        end
                        else last_done = 0;
                    last_addr = new_last;
                    //last_done = 0;
                    end
                    
            VR_EMPTY: begin  /** Empty case */
                        bram_insert = reg_out;
                        set_done = 1;
                        clr_empty = 1;
                        //last_done = 1;
                    end
                    
            VR_CNT: begin
                        clr_swap = 1;
                        if (swap) begin 
                            bram_insert = reg_out;
                            to_register = bram_out;
                        end 
                        else begin 
                            bram_insert = bram_out;
                            to_register = reg_out;
                        end  
                       array_cnt_out = array_cnt_in;
                       //bram_insert = bram_out;
                       //to_register = reg_out; 
                 end
                 
            VR_DEQ_RD: begin
                        array_cnt_out = array_cnt_in;
                        //next_bram = bram_out; // SHOULD BE A REG SIGNAL
            
                         end
                         
            default: begin /** CASE 1: Default */
                        set_full = 0;
                        clr_full = 0;
                        set_swap = 0;
                        clr_swap = 0;
                        set_empty = 1;
                        clr_empty = 0;
                        array_cnt_out = 0;
                        last_addr = 0;
                        bram_insert = '0;
                        data_lt_o = '0;
                        data_rt_o = '0;
                        to_register = '0;
                        set_done = 0;
                        clr_done = 0;
                        last_done = 0;
                   end
                      
        endcase
        end
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
