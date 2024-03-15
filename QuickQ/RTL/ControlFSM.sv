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
//
// Added mode enumerated type JN 2/8/2024

module ControlFSM import quickQ_pkg::*;  #(parameter W=8, D=128, localparam DW=$clog2(D)) (
                  input logic clk, rst, enq, deq, swap, full, empty, done, cnt_done,
                  input logic [DW-1:0] last_addr, array_cnt_out,
                  output logic we, regenb, next_node, prev_node, array_cnt_ld, array_cnt_clr, array_cnt_deq, array_cnt_inc,
                  output logic bram_sel, fill_cnt, fill_rst, cnt_rst,
                  vrMode_t mode, 
                  output logic [1:0] mux1_sel,
                  output logic op_enb
                  );
            
            /* Enumerated logic (states) */
            typedef enum logic [3:0] {
                IDLE = 4'b0001,
                FILL_ENQ = 4'b0010,
                EMPTY_ENQ = 4'b0011,
                COMPARE_ENQ = 4'b0100,
                SWAP_ENQ = 4'b0101,
                CNT_INC = 4'b0110,
                ENQ_BUFFER = 4'b0111,
                ADDR_INC = 4'b1000,
                DEQ_LOCATE = 4'b1001,
                FILL_DEQ = 4'b1010,
                DEQ_SWAP = 4'b1011,
                CNT_DEC = 4'b1100,
                ADDR_DEC = 4'b1101
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
                              array_cnt_ld = 0;
                              array_cnt_clr = 0;
                              array_cnt_deq = 0;
                              array_cnt_inc = 0;
                              op_enb = 0;
                              fill_rst = 1;
                              cnt_rst = 1;
                              mode = VR_DEF; // 3'b000;
                              we = 0;
                              if (enq) next = FILL_ENQ;
                              else if (deq) begin
                                cnt_rst = 0;
                                next = DEQ_LOCATE;
                              end
                              else next = IDLE;
                            end
                            
                        FILL_ENQ:
                            /* Temp register (at head) filled with value from input */
                            begin
                               cnt_rst = 0;
                               op_enb = 1;
                               fill_rst = 0;
                               fill_cnt = 1;
                               mux1_sel = 2'b00;
                               regenb = 1;
                               array_cnt_clr = 1;
                               
                               if (cnt_done) begin
                                    if (empty) next = EMPTY_ENQ;
                                    else begin 
                                        mode = VR_ENQ_COMPARE;
                                        next = COMPARE_ENQ;
                                    end
                               end
                               else next = FILL_ENQ;
                            end
                            
                        EMPTY_ENQ:
                            /* Special case for when we add a value to an empty queue */
                            begin
                                array_cnt_clr = 0;
                                op_enb = 0;
                                fill_cnt = 0;
                                regenb = 1;
                                mode = VR_EMPTY; //3'b100;
                                we = 1;
                                bram_sel = 0;
                                next = CNT_INC;
                            end
                            
                        COMPARE_ENQ:
                            /* Value in register compared with value that index register points to */
                            begin
                                op_enb = 0;
                                array_cnt_clr = 0;
                                array_cnt_inc = 0;
                                fill_cnt = 0;
                                cnt_rst = 0;
                                //if (cnt_done) begin
                                    if (done) begin 
                                        mode = VR_DEQ_RD; // DO NOTHING
                                        next = IDLE;
                                    end
                                    //else begin
                                    //mode = VR_ENQ_COMPARE; //3'b001;
                                    
                                    else if (swap) begin
                                        //mode = VR_CNT; //3'b101;
                                        next = SWAP_ENQ;
                                    end
                                    else if (!swap) next = CNT_INC;
                                    else next = COMPARE_ENQ; // should not happen
                                    //end
                                //end
                                //else next = COMPARE_ENQ;
                            end
                        
                        SWAP_ENQ:
                            /* Value in register swapped with value in QuickQ index */
                            begin
                                mode = VR_CNT; //3'b101;
                                we = 1;
                                next = CNT_INC;
                            end
                            
                        CNT_INC:
                            /* Counter signals register to look at next index */
                            begin
                                we = 0;
                                array_cnt_inc = 1;
                                if (full && (last_addr == array_cnt_out)) next = ADDR_INC;
                                else begin 
                                    mux1_sel = 2'b01;
                                    fill_rst = 1;
                                    //mode = VR_CNT; //3'b101;
                                    next = ENQ_BUFFER;
                                end
                            end
                        
                        ENQ_BUFFER:
                            begin
                                array_cnt_inc = 0;
                                fill_rst = 0;
                                fill_cnt = 1;
                                
                                 if (cnt_done) begin
                                     if (done) begin
                                        mode = VR_LAST; //3'b011;
                                        op_enb = 0;
                                     end
                                     else mode = VR_ENQ_COMPARE; //3'b001;
                                     next = COMPARE_ENQ;
                                 end
                               else next = ENQ_BUFFER;
                            end    
                            
                        ADDR_INC:
                            /* If the node is full, send a signal to look at next node */
                            begin
                                mode = VR_LAST;
                                next_node = 0;
                                array_cnt_clr = 1;
                                next = IDLE;
                            end
                            
                        DEQ_LOCATE: 
                            begin
                                op_enb = 1;
                                array_cnt_ld = 1;
                                //array_cnt_decr = 1;
                                //mode = VR_DEQ_RD;
                                next = DEQ_SWAP;
                            end 
                               
                        FILL_DEQ: // DELETE ME???
                            /* Fill register with FFFFFFFF to empty the spot*/
                            begin
                                //op_enb = 1;
                                //array_cnt_ld = 0;
                                array_cnt_deq = 1;
                                //mode = VR_DEQ_RD;
                                next = DEQ_SWAP;
                            end
                        
                        DEQ_SWAP:
                            /* Swap register value with that from BRAM */
                            begin
                                op_enb = 0;
                                array_cnt_ld = 0;
                                array_cnt_inc = 1;
                                mode = VR_DEQ_SWAP; //2'b010;
                                we = 1;
                                prev_node = 0;
                                // transition logic
                                if (array_cnt_out >= last_addr) next = IDLE;
                                else if (empty) next = ADDR_DEC;
                                else next = DEQ_SWAP;
                            end
                            
                        CNT_DEC: // delete???
                            /* Decrease count size to look at preceding node */
                            begin
                                mode = VR_DEQ_RD;
                                array_cnt_deq = 1;
                                //mux1_sel = 2'b01;
                                //regenb = 1;
                                
                                if (!empty && !done) next = DEQ_SWAP;
                                else if (empty) next = ADDR_DEC;
                                else if (done) next = IDLE;
                                else next = CNT_DEC; //should not happen
                            end
                            
                        ADDR_DEC:
                            /* When empty, signal to look at the next node */
                            begin
                                array_cnt_inc = 0;
                                array_cnt_clr = 1;
                                next = IDLE;
                            end
                            
                        default:
                            begin
                                mode = VR_DEF; //3'b000;
                                we = 0;
                                bram_sel = 0;
                                prev_node = 1;
                                next_node = 1;
                            end
                    endcase
               end
                
    
endmodule
