`timescale 1ns / 1ps

module RegisterFile(input logic [15:0] DIn,
                    input logic [3:0] ASOut, BSOut, CSOut, DSOut, ESOut, SIn, TBSOut,
                    input logic WE, CLK,
                    output logic [15:0] AOut, BOut, COut, DOut, EOut, TBOut);
                    
                    logic [15:0] file [0:15];
                    
                    always_ff@(posedge CLK) begin
                        if(WE) file[SIn] <= DIn;
                    end
                    
                    assign AOut = file[ASOut];
                    assign BOut = file[BSOut];
                    assign COut = file[CSOut];
                    assign DOut = file[DSOut];
                    assign EOut = file[ESOut];
                    assign TBOut = file[TBSOut];

                    initial begin
                        foreach (file[i])
                            file[i] = 16'd0;
                    end
endmodule
