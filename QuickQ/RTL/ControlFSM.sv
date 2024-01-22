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


module ControlFSM(input logic clk, rst, enq, deq, swap, full, empty, done, cnt_done,
                  input logic [31:0] last_addr,
                  output logic we, regenb, next_node, prev_node, array_cnt_ld, array_cnt_clr, array_cnt_decr, array_cnt_inc, bram_sel, fill_cnt,
                  output logic [2:0] mode, 
                  output logic [1:0] mux1_sel
                  );
            
            /* Enumerated logic (states) */
            typedef enum logic [3:0] {
                IDLE = 4'b0001,
                FILL_ENQ = 4'b0010,
                EMPTY_ENQ = 4'b0011,
                COMPARE_ENQ = 4'b0100,
                SWAP_ENQ = 4'b0101,
                CNT_INC = 4'b0110,
                ADDR_INC = 4'b0111,
                DEQ_LOCATE = 4'b1000,
                FILL_DEQ = 4'b1001,
                DEQ_SWAP = 4'b1010,
                CNT_DEC = 4'b1011,
                ADDR_DEC = 4'b1100
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
                              mode = 3'b000;
                              if (enq) next = FILL_ENQ;
                              else if (deq) next = DEQ_LOCATE;
                              else next = IDLE;
                            end
                            
                        FILL_ENQ:
                            /* Temp register (at head) filled with value from input */
                            begin
                               fill_cnt = 1;
                               mux1_sel = 2'b00;
                               regenb = 1;
                               array_cnt_clr = 1;
                               
                               if (cnt_done) begin
                                    if (empty) next = EMPTY_ENQ;
                                    else next = COMPARE_ENQ;
                               end
                               else next = FILL_ENQ;
                            end
                            
                        EMPTY_ENQ:
                            /* Special case for when we add a value to an empty queue */
                            begin
                                regenb = 1;
                                mode = 3'b100;
                                we = 1;
                                bram_sel = 0;
                                next = CNT_INC;
                            end
                            
                        COMPARE_ENQ:
                            /* Value in register compared with value that index register points to */
                            begin
                                mode = 3'b001;
                                
                                if (swap && !done) next = SWAP_ENQ;
                                else if (done) begin
                                    mode = 3'b011;
                                    next = IDLE;
                                end
                                else if (!swap) next = CNT_INC;
                                else next = COMPARE_ENQ; // should not happen
                            end
                        
                        SWAP_ENQ:
                            /* Value in register swapped with value in QuickQ index */
                            begin
                                we = 1;
                                next = CNT_INC;
                            end
                            
                        CNT_INC:
                            /* Counter signals register to look at next index */
                            begin
                                array_cnt_inc = 1;
                                if (done) mode = 3'b011;
                                if (full) next = ADDR_INC;
                                else next = COMPARE_ENQ;
                            end
                            
                        ADDR_INC:
                            /* If the node is full, send a signal to look at next node */
                            begin
                                next_node = 0;
                                array_cnt_clr = 1;
                                next = IDLE;
                            end
                            
                        DEQ_LOCATE:
                            /* Find ending position of the queue */
                            begin
                                array_cnt_ld = 1;
                                next =  FILL_DEQ;
                            end    
                            
                        FILL_DEQ:
                            /* Fill register with FFFFFFFF to empty the spot*/
                            begin
                                mux1_sel = 2'b10;
                                regenb = 1;
                                next = DEQ_SWAP;
                            end
                        
                        DEQ_SWAP:
                            /* Swap register value with that from BRAM */
                            begin
                                mode = 2'b010;
                                we = 1;
                                prev_node = 0;
                                next = CNT_DEC;
                            end
                            
                        CNT_DEC:
                            /* Decrease count size to look at preceding node */
                            begin
                                array_cnt_decr = 1;
                                mux1_sel = 2'b01;
                                regenb = 1;
                                
                                if (!empty && !done) next = DEQ_SWAP;
                                else if (empty) next = ADDR_DEC;
                                else if (done) next = IDLE;
                                else next = CNT_DEC; //should not happen
                            end
                            
                        ADDR_DEC:
                            /* When empty, signal to look at the next node */
                            begin
                                array_cnt_clr = 1;
                                next = IDLE;
                            end
                            
                        default:
                            begin
                                mode = 3'b000;
                                we = 0;
                                bram_sel = 0;
                                prev_node = 1;
                                next_node = 1;
                            end
                    endcase
               end
                
    
endmodule
