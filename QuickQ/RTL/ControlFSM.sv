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


module ControlFSM(input logic clk, rst, enq, deq, done, result,
                  output logic we, regenb, regsel, countenb, read_addr,
                  output logic [1:0] mode
                  );
            
            /* Enumerated logic (states) */
            typedef enum logic [3:0] {
                IDLE = 4'b0001,
                FILL_ENQ = 4'b0010,
                COMPARE_ENQ = 4'b0011,
                SWAP_ENQ = 4'b0100,
                CNT_INC = 4'b0101,
                ADDR_INC = 4'b0110
            } states_t;
            
            states_t state, next;
            
            /* Internal logic */
            logic swap_done;
            logic full;
            
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
                                /* Default values */
                                read_addr = 0;
                                /* State transition logic */
                                if (enq) begin
                                    read_addr = 1; // Signal BRAM to read the value at the address
                                    next = FILL_ENQ;
                                end
                                else if (deq) next = IDLE; // FIX ME when dequeue states are added
                                else next = IDLE;
                            end
                            
                        FILL_ENQ:
                            /* Temp register (at head) filled with value from input */
                            begin
                                /* State transition logic */
                                next = COMPARE_ENQ;
                            end
                            
                        COMPARE_ENQ:
                            /* Value in register compared with value that index register points to */
                            begin
                                /* State transition logic */
                                if (result && !done) next = SWAP_ENQ;
                                else if (!result && !done) next = CNT_INC;
                                else next = COMPARE_ENQ;
                            end
                        
                        SWAP_ENQ:
                            /* Value in register swapped with value in QuickQ index */
                            begin
                                /* State transition logic */
                                if (swap_done) next = CNT_INC;
                                else next = COMPARE_ENQ;
                            end
                            
                        CNT_INC:
                            /* Counter signals register to look at next index */
                            begin
                                /* State transition logic */
                                if (full) next = ADDR_INC;
                                else next = COMPARE_ENQ;
                            end
                            
                        ADDR_INC:
                            /* If the node is full, send a signal to look at next node */
                            begin
                                /* State transition logic */
                                next = IDLE;
                            end
                            
                    endcase
               end
                
    
endmodule
