`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2022 02:21:09 PM
// Design Name: 
// Module Name: fsm_pq
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


module fsm_pq( input logic clk, rst, start, full, busy, empty, error_comp, cteal_15,
               output logic lfsr_rst, lfsr_enb, enq, deq, count_enb, count_rst, 
               output logic [2:0] led_r, led_g, led_b, 
               output logic sigIDLE, sigSTART, sigADD, sigREMOVE, sigDISPLAY);
    
        typedef enum logic [4:0] {
            IDLE = 5'b00001,
            START = 5'b00010,
            ADD = 5'b00100,
            REMOVE = 5'b01000,
            DISPLAY = 5'b10000
           } states_t;
           
           states_t state, next;
           
           always_ff @ (posedge clk)
                if (rst) state <= IDLE;
                else state <= next;
                
           always_comb
               begin
               
               next = IDLE;
               sigIDLE = 1;
                sigSTART = 0;
                sigADD = 0; 
                sigREMOVE = 0;
                sigDISPLAY = 0;
                count_rst = 0;
                count_enb = 0;
                lfsr_rst = 0;
                lfsr_enb = 0;
                led_r = 3'b000;
                led_b = 3'b000;
                led_g = 3'b000;
                enq = 0;
                deq = 0;
                            
               
               case(state)
                    IDLE:
                        begin
                            sigIDLE = 1;
                            sigSTART = 0;
                            sigADD = 0; 
                            sigREMOVE = 0;
                            sigDISPLAY = 0;
                            count_rst = 1;
                            lfsr_rst = 1;
                            lfsr_enb = 0;
                            led_r = 3'b000;
                            led_b = 3'b000;
                            led_g = 3'b000;
                            
                            if (start) next = START;
                            else next = IDLE;
                       end
                    
                    START:
                        begin
                            sigIDLE = 0;
                            sigSTART = 1;
                            sigADD = 0; 
                            sigREMOVE = 0;
                            sigDISPLAY = 0;
                            lfsr_rst = 0;
                            lfsr_enb = 0;
                            
                            next = ADD;
                        end
                        
                    ADD:
                        begin
                            sigIDLE = 0;
                            sigSTART = 0;
                            sigADD = 1; 
                            sigREMOVE = 0;
                            sigDISPLAY = 0;
                            if (!busy) begin
                                enq = 1;
                                lfsr_enb = 1;
                                if (full) next = REMOVE;
                                else next = ADD;
                            end
                            else begin
                                enq = 0;
                                lfsr_enb = 0;
                                next = ADD;
                            end
                        end
                        
                    REMOVE:
                        begin
                            sigIDLE = 0;
                            sigSTART = 0;
                            sigADD = 0; 
                            sigREMOVE = 1;
                            sigDISPLAY = 0;
                            enq = 0;
                            lfsr_enb = 0;
                            count_rst = 0;
                            if (!busy) begin
                                count_enb = 1;
                                deq = 1;
                                if (error_comp || cteal_15) next = DISPLAY;
                                else next = REMOVE;
                            end
                            else begin
                                count_enb = 0;
                                deq = 0;
                                next = REMOVE;
                            end               
                        end
                      
                    DISPLAY:
                        begin
                            sigIDLE = 0;
                            sigSTART = 0;
                            sigADD = 0; 
                            sigREMOVE = 0;
                            sigDISPLAY = 1;
                            deq = 0;
                            count_enb = 0;
                            
                            if (cteal_15)
                                begin
                                    led_r = 3'b000;
                                    led_b = 3'b000;
                                    led_g = 3'b011;
                                end
                                
                            if (error_comp) 
                                begin
                                    led_r = 3'b011;
                                    led_b = 3'b000;
                                    led_g = 3'b000;
                                end
                                
                            if (rst) next = IDLE;
                            else next = DISPLAY;
                            
                        end      
                        
               endcase
           end     
               
    
    
endmodule
