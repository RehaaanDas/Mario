`timescale 1ns / 1ps

module DataMem(input logic [15:0] DIn,
               input logic [9:0] AddrIn, AddrOut,
               input logic WE, CLK,
               output logic [15:0] DOut);
        logic [15:0] mem [0:1023];
        
        assign DOut = mem[AddrOut];
        
        always_ff@(posedge CLK) begin
            if(WE) mem[AddrIn] <= DIn;
        end
        
        initial begin
            foreach (mem[i])
                mem[i] = 16'd0;
        end
        
endmodule
