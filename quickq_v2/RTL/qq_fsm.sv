`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Module Name   : qq_fsm
// Project       : QuickQ (version 2)
//-----------------------------------------------------------------------------
// Author        : Michala Dennis  <dennismj@lafayette.edu>
// Created       : Mar 2024
//-----------------------------------------------------------------------------
// Description   : fsm for QuickQ
//-----------------------------------------------------------------------------
// Modification history:
//-----------------------------------------------------------------------------


module qq_fsm #(parameter W=32, D=4, localparam DW=$clog2(D)) 
              (input logic clk, rst, enq_i, deq_i, t_gt_ram_out,
               input logic [DW-1:0] wr_addr,
               input logic [W-1:0] ram_out,
               output logic sel_t, ld_t, clr_wraddr, incr_wraddr, we, enq_o, deq_o,
               output logic full, empty,
               output logic [1:0] incr_ctl, sel_b);
     
    /** Parameter declaration */
    parameter MAX_KEY = '1;
               
    /** Enumerated logic (states) */
    typedef enum logic [2:0] {
        INIT1 = 3'b001,
        INIT2 = 3'b010,
        IDLE = 3'b011,
        ENQ1 = 3'b100,
        ENQRT = 3'b101,
        DEQ1 = 3'b110,
        DEQRT = 3'b111
    } states_t;
    
    states_t state, next;
    
    /** Clock */
    always_ff @ (posedge clk)
        if (rst) state <= INIT1; // reset statement
        else state <= next;
        
        always_comb begin
            case (state)
                INIT1:
                    /** Set the write address to 0 */
                    begin
                        clr_wraddr = 1;
                        empty = 1;
                        
                        // State transition logic
                        next = INIT2;
                    end
                    
                INIT2:
                    /** Set array to fill with the max value (FF) */
                    begin
                        clr_wraddr = 0;
                        incr_wraddr = 1;
                        sel_b = 2'b11; // ram_in = MAX_KEY
                        we = 1;
                        // State transition logic
                        if (wr_addr == D-1) next = IDLE;
                        else next = INIT2;
                    end
                    
                IDLE:
                    /** The idle state */
                    begin
                        // State transition logic
                        if (enq_i) begin
                            sel_t = 0; // t <= data_lt_i
                            clr_wraddr = 1;
                            incr_ctl = 2'b00; // rd_addr = wr_addr = 0;
                            ld_t = 1;
                            next = ENQ1;
                        end
                        else if (deq_i) begin
                            clr_wraddr = 1;
                            incr_ctl = 2'b01; //rd_addr = wr_addr+1 = 1;
                            next = DEQ1;
                        end
                        else next = IDLE;
                    end
                
                ENQ1:
                    /** ENQ primary state */
                    begin
                        clr_wraddr = 0;
                        incr_ctl = 2'b01; // rd_addr = wr_addr + 1;
                        incr_wraddr = 1;
                        
                        if (!t_gt_ram_out) begin
                            sel_t = 1; // temp <= ram_out;
                            sel_b = 2'b01; // ram_in = temp;
                            we = 1;
                        end
                        
                        // State transition logic
                        if (ram_out == MAX_KEY) begin
                            empty = 0;
                            if (wr_addr == D-1) full = 1; // should this go to ENQRT?
                            next = IDLE;
                        end 
                        else if (wr_addr == D-1) next = ENQRT;
                        else next = ENQ1;   
                    end
                
                ENQRT:
                    /** Signal to next node */
                    begin
                        ld_t = 1; // data_rt_o = temp
                        enq_o = 1;
                        next = IDLE;
                    end
                
                DEQ1:
                    /** DEQ primary state */
                    begin
                        incr_ctl = 2'b10; // rd_addr = wr_addr + 2;
                        incr_wraddr = 1;
                        sel_b = 2'b00; // ram_in = ram_out;
                        we = 1;
                        
                        // State transition logic
                        if (ram_out == MAX_KEY) begin
                            full = 0;
                            if (wr_addr == 0) empty = 1; // should this go to DEQRT?
                            next = IDLE;
                        end
                        else if (wr_addr == D-2) next = DEQRT;
                        else next = DEQ1;
                    end
                    
                DEQRT:
                    /** Signal to previous node */
                    begin
                        sel_b = 2'b10; // ram_in = data_rt_i;
                        we = 1;
                        deq_o = 1;
                    end
                    
                default:
                    begin
                        sel_t = 0;
                        ld_t = 0;
                        clr_wraddr = 0;
                        incr_wraddr = 0;
                        we = 0;
                        enq_o = 0;
                        deq_o = 0;
                        full = 0;
                        empty = 0;
                        incr_ctl = 2'b00; // rd_addr = wr_addr;
                        sel_b = 2'b00; // ram_out = ram_in;
                    end
                
                endcase
        end
               
endmodule