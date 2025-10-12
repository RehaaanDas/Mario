`timescale 1ns / 1ps

module ALU(input logic Operation,
           input logic [15:0] Accumulator, Operand,
           output logic [15:0] Result,
           output logic Z, N, O);
           
           always_comb begin
                case(Operation)
                    1'b0:      {O, Result} = Accumulator + Operand;
                    1'b1: begin 
                                Result = Accumulator - Operand;
                                N = (Operand > Accumulator);
                                Z = ~(|Result);
                           end
                endcase                 
           end
endmodule
