`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2022 01:46:25 PM
// Design Name: 
// Module Name: quickFSM
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


module quickFSM(input logic clk, rst, busy, full, empty, enq, deq,
                input logic [7:0] key_addr, key_reg,
                output logic count_incr, current_size_enb, select, we1, deq_shift,
                output logic [7:0] key2temp, key2BRAM
                  );
                  
                typedef enum logic [3:0] {
                    IDLE = 4'b0001,
                    ENQ_ADD = 4'b0010,
                    ENQ_COMPARE = 4'b0011,
                    ENQ_SWAP = 4'b0100,
                    ENQ_SHIFT = 4'b0101,
                    ENQ_FINISH = 4'b0110,
                    DEQ_REMOVE = 4'b0111,
                    DEQ_SHIFT = 4'b1000,
                    DEQ_WRITE = 4'b1001,
                    DEQ_FINISH = 4'b1010
                } states_t;
                
                states_t state, next;
                
                always_ff @ (posedge clk)
                    if (rst) state <= IDLE;
                    else state <= next;
                    
                always_comb
                    begin
                        
                    next = IDLE;
                    
                    case(state)
                        IDLE:
                            begin
                                
                                current_size_enb = 0;
                                count_incr = 0;
                            
                                if (enq) next = ENQ_ADD;
                                else if (deq) next = DEQ_REMOVE;
                                else next = IDLE;
                            end
                            
                        ENQ_ADD:
                            begin
                            // CODE TO FILL TEMP REGISTER HERE
                            
                            next = ENQ_COMPARE;
                            end
                            
                        ENQ_COMPARE:
                            begin
                                if (key_addr == 8'b11111111) next = ENQ_SWAP;
                                else if (key_addr < key_reg) begin
                                    count_incr = 1;
                                    next = ENQ_COMPARE;
                                    end
                                else next = ENQ_SWAP;
                            end
                        
                        ENQ_SWAP:
                            begin
                            key2temp = key_addr;
                            key2BRAM = key_reg;
                            we1 = 1;
                            if (key_addr == 8'b11111111 || full) next = ENQ_FINISH;
                            else next = ENQ_SHIFT;
                            
                            
                            end
                        
                        ENQ_SHIFT:
                            begin
                            count_incr = 1;
                            we1 = 0;
                            next = ENQ_COMPARE;
                            
                            end
                            
                        ENQ_FINISH:
                            begin
                            current_size_enb = 1;
                            select = 1;
                            next = IDLE;
                            end
                            
                        DEQ_REMOVE:
                            begin
                            // CODE FOR REMOVING FROM QUEUE POSITION 1
                            
                            next = DEQ_SHIFT;
                            end
                            
                        DEQ_SHIFT:
                            begin
                            we1 = 0;
                            if (key_addr == 8'b11111111) next = DEQ_FINISH; 
                            else next = DEQ_WRITE;
                            end
                            
                        DEQ_WRITE:
                            begin
                            // WRITING INTO ADDRESS
                            we1 = 1;
                            next = DEQ_SHIFT;
                            end
                            
                        DEQ_FINISH:
                            begin
                            current_size_enb = 1;
                            select = 0;
                            
                            end 
                            
                    endcase
              end
                    
endmodule
