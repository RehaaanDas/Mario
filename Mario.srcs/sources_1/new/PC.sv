`timescale 1ns / 1ps

module PC(input logic [15:0] JmpAddr,
          input logic CLK, Jmp, STALL,
          
          output logic [15:0] IAddr);
          
          always_ff@(posedge CLK) begin
                if(STALL === 1'b1) IAddr <= IAddr;
                else if(Jmp === 1'b1) IAddr <= JmpAddr;
                else IAddr <= IAddr + 16'd1;
          end
          
          initial begin
                IAddr = 16'h0;
          end
endmodule