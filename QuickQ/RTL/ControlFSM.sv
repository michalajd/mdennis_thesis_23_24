`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2023 12:50:46 PM
// Design Name: 
// Module Name: ControlFSM
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


module ControlFSM(input logic clk, rst, enq, deq, done, result, full, swap_done, empty,
                  output logic we, regenb, regsel, countenb, re, next_node, bram_sel,
                  output logic [31:0] rd_addr, wr_addr,
                  output logic [2:0] mode, 
                  output logic [1:0] mux1_sel
                  );
            
            /* Enumerated logic (states) */
            typedef enum logic [3:0] {
                IDLE = 4'b0001,
                FILL_ENQ = 4'b0010,
                COMPARE_ENQ = 4'b0011,
                SWAP_ENQ = 4'b0100,
                CNT_INC = 4'b0101,
                ADDR_INC = 4'b0110,
                DEQ_LOCATE = 4'b0111,
                FILL_DEQ = 4'b1000,
                DEQ_SWAP = 4'b1001,
                CNT_DEC = 4'b1010,
                ADDR_DEC = 4'b1011
            } states_t;
            
            states_t state, next;
            
            /* Clock */
            always_ff @ (posedge clk)
                if (rst) state <= IDLE; // Reset statement
                else state <= next;
                
                always_comb
                    begin
                    
                    case (state)
                        IDLE:
                            /* Default state for when no action is specified in the queue */
                            begin
                                mode = 3'b100;
                                /* Default values */
                                re = 0;
                                /* State transition logic */
                                if (enq) begin
                                    re = 1; // Signal BRAM to read the value at the address
                                    next = FILL_ENQ;
                                end
                                else if (deq) begin
                                    next = DEQ_LOCATE;
                                end
                                else next = IDLE;
                            end
                            
                        FILL_ENQ:
                            /* Temp register (at head) filled with value from input */
                            begin
                                /* State transition logic */
                                mux1_sel = 2'b00; 
                                mode = 3'b000;
                                next = COMPARE_ENQ;
                            end
                            
                        COMPARE_ENQ:
                            /* Value in register compared with value that index register points to */
                            begin
                                /* State transition logic */
                                if (result /*&& !done)*/) begin 
                                    next = SWAP_ENQ;
                                    wr_addr = rd_addr;
                                end
                                else /** if (!result && !done) */ next = CNT_INC;
                                //else next = COMPARE_ENQ;
                            end
                        
                        SWAP_ENQ:
                            /* Value in register swapped with value in QuickQ index */
                            begin
                                we = 1; /** Write new value to the BRAM */
                                /* State transition logic */
                                if (swap_done) begin
                                    we = 0;
                                    mode = 2'b001;
                                    next = CNT_INC;
                                end
                                else next = SWAP_ENQ;
                            end
                            
                        CNT_INC:
                            /* Counter signals register to look at next index */
                            begin
                                /* State transition logic */
                                if (full) next = ADDR_INC;
                                else begin 
                                    mux1_sel = 2'b01; // Input mux chooses value router data
                                    rd_addr++;
                                    next = COMPARE_ENQ;
                                end
                            end
                            
                        ADDR_INC:
                            /* If the node is full, send a signal to look at next node */
                            begin
                                /* State transition logic */
                                next = IDLE;
                            end
                            
                        DEQ_LOCATE:
                            /* Find ending position of the queue */
                            begin
                                /** PSEUDO CODE IDEAS:
                                    boolean value comes from VR pointing to address
                                    if (hasElement) begin
                                        next = DEQ_LOCATE;
                                        vr_addr_inc;
                                    else next = FILL_DEQ;
                                */
                            end    
                            
                        FILL_DEQ:
                            /* Fill register with FFFFFFFF to empty the spot*/
                            begin
                                mux1_sel = 2'b10; // Input mux sends in FFFF
                                mode = 3'b010;
                                next = DEQ_SWAP;
                            end
                        
                        DEQ_SWAP:
                            /* Swap register value with that from BRAM */
                            begin
                                we = 1; /** Write new value to the BRAM */
                                /* State transition logic */
                                if (swap_done) begin
                                    we = 0;
                                    mode = 3'b011;
                                    next = CNT_DEC;
                                end
                                else next = SWAP_ENQ;
                            end
                            
                        CNT_DEC:
                            /* Decrease count size to look at preceding node */
                            begin
                                /* State transition logic */
                                if (empty) next = ADDR_DEC;
                                else begin 
                                    mux1_sel = 2'b01; // Input mux chooses value router data
                                    rd_addr--;
                                next = DEQ_SWAP;
                            end
                        end
                            
                        ADDR_DEC:
                            /* When empty, signal to look at the next node */
                            begin
                                next = IDLE;
                            end
                    endcase
               end
                
    
endmodule
