`timescale 1ns / 1ps

module CU_EX(input logic [15:0] AOut, BOut, ALURes,
             input logic [49:0] Payload,
             input logic Z, N, O,
             
             output logic [15:0] JmpAddr, ALUOp, ALUAcc,
             output logic [49:0] PayloadOut,
             output logic [3:0] ASOut, BSOut, DestR,
             output logic ALUWE, ALUOperation, JmpConfirm, HALT);
             
             logic JmpValid; 

             assign ASOut        = Payload[15:12];
             assign BSOut        = Payload[11:8];
             assign DestR        = Payload[7:4];

             assign ALUAcc       = AOut;
             assign ALUOp        = BOut;
             
             assign ALUOperation = Payload[43];
             assign ALUWE        = Payload[0];
             assign HALT         = ~|Payload[49:42] & Payload[41];
             
             assign JmpConfirm   = Payload[42] & JmpValid;
             assign PayloadOut   = ALUWE ? { 8'b00010000,            
                                            ALURes,
                                            14'h0,                  
                                            DestR,
                                            7'h0,
                                            1'b0} : Payload; //Construct register write payload or pass
             
             always_comb begin
                    case(Payload[1]) //dynamic/immediate addressing
                        1'b0: JmpAddr = Payload[41:26];
                        1'b1: JmpAddr = BOut;
                    endcase
                    case(Payload[3:2]) //Jmp Type
                        2'b00: JmpValid = 1'b1;
                        2'b01: JmpValid = Z;
                        2'b10: JmpValid = N;
                        2'b11: JmpValid = O;
                    endcase
             end
endmodule
