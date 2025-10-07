`timescale 1ns / 1ps

module RegisterFileTB();
    logic [15:0] DIn;
    logic [3:0] ASOut, BSOut, CSOut, DSOut, ESOut, SIn, TBSOut;
    logic WE, CLK;
    logic [15:0] AOut, BOut, COut, DOut, EOut, TBOut;
    
    RegisterFile DUT(.ASOut(ASOut),
                     .BSOut(BSOut),
                     .CSOut(CSOut),
                     .DSOut(DSOut),
                     .ESOut(ESOut),
                     .TBSOut(TBSOut),
                     .AOut(AOut),
                     .BOut(BOut),
                     .COut(COut),
                     .DOut(DOut),
                     .EOut(EOut),
                     .TBOut(TBOut),
                     .DIn(DIn),
                     .SIn(SIn),
                     .WE(WE),
                     .CLK(CLK) );
    
    initial begin 
        CLK = 0;
        forever #5 CLK = ~CLK;
    end
    
    initial begin
        DIn = 16'hAAAA; SIn = 4'hA; WE = 1'b1;
        #15;
        DIn = 16'hBBBB; SIn = 4'hB; WE = 1'b1;
        #15;
        DIn = 16'hCCCC; SIn = 4'hC; WE = 1'b1;
        #15;
        DIn = 16'hDDDD; SIn = 4'hD; WE = 1'b1;
        #15;
        DIn = 16'hEEEE; SIn = 4'hE; WE = 1'b1;
        #15;
        DIn = 16'hFFFF; SIn = 4'hF; WE = 1'b1;
        #15;
        
        ASOut = 4'hA; BSOut = 4'hB; CSOut = 4'hC; DSOut = 4'hD; ESOut = 4'hE; TBSOut = 4'hF; #1;
        assert(AOut === 16'hAAAA) else $error("### A Failed ###");
        assert(BOut === 16'hBBBB) else $error("### B Failed ###");
        assert(COut === 16'hCCCC) else $error("### C Failed ###");
        assert(DOut === 16'hDDDD) else $error("### D Failed ###");
        assert(EOut === 16'hEEEE) else $error("### E Failed ###");
        assert(TBOut === 16'hFFFF) else $error("### TB Failed ###");
    end
endmodule
