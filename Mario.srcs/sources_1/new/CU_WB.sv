`timescale 1ns / 1ps

module CU_WB(input logic [49:0] Payload,
             input logic [15:0] EOut, 
             input logic CLK,

             output logic [15:0] DIn,
             output logic [3:0]  SIn, ESOut,
             output logic WE);

             assign ESOut = Payload[15:12]; //OpA used for move source
             assign WE = Payload[45] | Payload[46];
             
             always_comb begin
                 case(Payload[46])
                        2'b0:begin
                            DIn = EOut;
                            SIn = Payload[11:8]; //OpB used for dest. reg select
                        end
                        2'b1:begin
                            DIn = Payload[41:26];
                            SIn = Payload[11:8];
                        end
                 endcase
             end
             
                      
endmodule
