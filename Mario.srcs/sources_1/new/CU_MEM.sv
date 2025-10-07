`timescale 1ns / 1ps

module CU_MEM(input logic [49:0] Payload,
              input logic [15:0] DOut, COut, MemDOut,
              
              output logic [49:0] PayloadOut,
              output logic [3:0] DSOut, CSOut,
              
              output logic [9:0] MemAddrIn, MemAddrOut,
              output logic [15:0] MemDIn,
              
              output logic WE, Stall);

              assign WE = Payload[49] | Payload[48];
              assign Stall = Payload[47];

              assign DSOut = Payload[15:12];
              assign CSOut = Payload[11:8];

              assign REn = Payload[1];

              always_comb begin
                    case(Payload[47]) //Load
                        1'b0: PayloadOut = Payload;
                        1'b1: PayloadOut = {8'b00010000, MemDOut, 14'h0, DSOut, 8'h0}; //Construct Register Write or pass
                    endcase
                    case(REn) //Dynamic/Immediate Addressing
                        1'b0: begin MemAddrIn = Payload[25:16];
                                    MemAddrOut = Payload[25:16]; end
                        1'b1: begin MemAddrIn = COut[9:0];
                                    MemAddrOut = COut[9:0]; end
                    endcase
                    case(Payload[48]) //Store
                        1'b0: MemDIn = Payload[41:26];
                        1'b1: MemDIn = DOut;
                    endcase
              end
endmodule
