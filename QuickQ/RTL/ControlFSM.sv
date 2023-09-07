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
                  output logic we, regenb, regsel, countenb
                  );

            typedef enum logic [3:0] {
                IDLE = 4'b0001,
                COMPARE = 4'b0010,
                ADV_ADDR = 4'b0100,
                SWAP = 4'b1000 
            } states_t;
            
            states_t state, next;
            
            always_ff @ (posedge clk)
                if (rst) state <= IDLE; //reset statement?
                else state <= next;
                
                always_comb
                    begin
                    
                    case (state)
                        IDLE:
                            begin
                                regenb = 0;
                                regsel = 0;
                                we = 0;
                                countenb = 0;
                                
                                if (!enq && !deq) next = IDLE;
                                else if (enq && !deq) next = COMPARE;
                                else next = IDLE;// REMOVE ME
                                /* The structure here should be the following:
                                    if (enq && !deq) next = COMPARE;
                                    else if (!enq && deq) next = REMOVE;
                                    else next = IDLE;
                                    
                                    This structure works the same way logically and handles the erroneous case that both inputs are true */
                            end
                        
                        COMPARE:
                            begin
                                countenb = 0; // shut off count
                                we = 0; // shut off write
                                
                                // 
                                
                                if (done) next = IDLE; // Go back to "IDLE" state when the next value in the temp register is FFFF
                                else if (!done && result) next = SWAP; // register value is smaller than ram value -- initiate swap
                                else if (!done && !result) next = ADV_ADDR; // register value is larger than ram value -- increment ram address
                                else next = IDLE;
                            end
                        
                            
                        SWAP:
                            begin
                                regsel = 0;
                                we = 1;
                                regenb = 1;
                                countenb = 1;
                                next = COMPARE;
                            end
                            
                        ADV_ADDR:
                            begin
                                countenb = 1; // turn on count for one clock cycle
                                next = COMPARE; 
                            end
                    endcase
               end
                
    
endmodule
