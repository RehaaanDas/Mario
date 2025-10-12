`timescale 1ns / 1ps

module BypassOverlay(input logic noWriters,
                     input logic [3:0] ReaderS, BypassS,
                     input logic [15:0] BypassD, RFD,
                     
                     output logic [15:0] ReaderD);

                    always_comb begin
                            if (!noWriters && (ReaderS == BypassS)) begin
                                ReaderD = BypassD;
                            end else begin
                                ReaderD = RFD;
                            end
                    end
endmodule
