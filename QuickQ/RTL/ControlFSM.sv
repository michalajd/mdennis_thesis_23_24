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


module ControlFSM(input logic clk, rst, enq, deq, dout, result,
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
                                else next = IDLE;
                            end
                        
                        COMPARE:
                            begin
                                countenb = 0; // shut off count
                                we = 0; // shut off write
                                
                                
                                if (result == 1 && dout == 1) next = IDLE; //DUMMY VALUE until we set bitwidths, the dout should be FF eventually
                                else if (result == 1) next = ADV_ADDR; // register value is larger than ram value -- increment ram address
                                else if (result == 0) next = SWAP; // register value is smaller than ram value -- initiate swap
                                else next = IDLE;
                            end
                        
                        ADV_ADDR:
                            begin
                                countenb = 1; // turn on count for one clock cycle
                                next = COMPARE; 
                            end
                            
                        SWAP:
                            begin
                                regsel = 0;
                                we = 1;
                                regenb = 1;
                                countenb = 1;
                                next = COMPARE;
                            end
                    endcase
               end
                
    
endmodule
