`timescale 1ns / 1ps

module CU(input logic CLK, Z, N, O,
          input logic [15:0] AOut, BOut, COut, DOut, EOut, MemDOut, ALUResult,
          input logic [31:0] IMemDOut,
          
          output logic [3:0] ASOut, BSOut, CSOut, DSOut, ESOut, ALUDestR, RFSIn, 
          output logic [15:0] RFDIn, MemDIn, IAddr, ALUAcc, ALUOp,
          output logic [9:0] MemAddrIn, MemAddrOut,
          output logic MWE, RFWE, Stall, HALT,
          output logic ALUOperation);

        logic [49:0] D, DX, X, XM, M, MB;
        logic [31:0] FD;
        
        logic [15:0] JmpAddr;
        logic JmpConfirm;

        PC PC(  .JmpAddr(JmpAddr), 
                .CLK(CLK),
                .Jmp(JmpConfirm), 
                .STALL(Stall),
                .IAddr(IAddr));
                
        always_ff @(posedge CLK) begin
            if(Stall !== 1'b1) begin
                if(JmpConfirm === 1'b1)begin
                    FD <= 32'hd0000000; //Prevent stages from sampling stray values during jumps
                    DX <= 50'h0;
                end else begin
                    if(HALT !== 1'b1) begin //Prevent ID from progressing to keep HALT flag up
                        DX <= D;
                    end             
                    FD <= IMemDOut;
                end
          
                XM <= X;
            end;
            if(Stall === 1'b1) begin 
                XM <= 50'h0;
            end;
            
            MB <= M;
        end
                    
        CU_ID ID(.Instruction(FD), 
                 .PayloadOut(D));

        CU_EX EX(   .HALT(HALT),
                    .AOut(XAOut),
                    .BOut(XBOut), 
                    .Payload(DX), 
                    .Z(Z), 
                    .N(N), 
                    .O(O), 
                    .JmpAddr(JmpAddr), 
                    .ASOut(ASOut),
                    .BSOut(BSOut),
                    .DestR(ALUDestR),
                    .ALURes(ALUResult),
                    .ALUAcc(ALUAcc),
                    .ALUOp(ALUOp),
                    .ALUWE(ALUWE),
                    .ALUOperation(ALUOperation),
                    .JmpConfirm(JmpConfirm),
                    .PayloadOut(X));
                    
                    logic [15:0] XBOut, XAOut;
                    
                    logic ALUWE;

        BypassOverlay OXB(  .noWriters(XnoWriters), //Overlay BOut
                           .ReaderS(BSOut), 
                           .BypassS(EXOverlayS),

                           .BypassD(EXOverlayD),
                           .RFD(BOut),
                           
                           .ReaderD(XBOut));

        BypassOverlay OXA(  .noWriters(XnoWriters), //Overlay AOut
                           .ReaderS(ASOut), 
                           .BypassS(EXOverlayS),

                           .BypassD(EXOverlayD),
                           .RFD(AOut),
                           
                           .ReaderD(XAOut));

                    logic [15:0] EXOverlayD;
                    logic [3:0] EXOverlayS;
                    
                    logic XnoWriters;

                always_comb begin //Priority overlay later stages
                    XnoWriters = 1'b0;
                    if(XM[46]|XM[45]) begin
                        EXOverlayD = XM[45] ? DOut : XM[41:26];
                        EXOverlayS = XM[11:8];
                    end else if (RFWE) begin
                        EXOverlayD = RFDIn;
                        EXOverlayS = RFSIn;
                    end else XnoWriters = 1'b1;
                end

        CU_MEM MEM( .Payload(XM),
                    .PayloadOut(M), 
                    .Stall(Stall),
                    .DOut(MDOut), 
                    .COut(MCOut), 
                    .MemDOut(MemDOut), 
                    .DSOut(DSOut), 
                    .CSOut(CSOut),
                    .MemAddrIn(MemAddrIn),
                    .MemAddrOut(MemAddrOut),
                    .MemDIn(MemDIn),
                    .WE(MWE));
                    
                    logic [15:0] MDOut, MCOut;
        
        BypassOverlay ODD(  .noWriters(!RFWE), //Overlay DOut
                           .ReaderS(DSOut), 
                           .BypassS(RFSIn),

                           .BypassD(RFDIn),
                           .RFD(DOut),
                           
                           .ReaderD(MDOut));

        BypassOverlay ODC(  .noWriters(!RFWE), //Overlay COut
                           .ReaderS(CSOut), 
                           .BypassS(RFSIn),

                           .BypassD(RFDIn),
                           .RFD(COut),
                           
                           .ReaderD(MCOut));
                    
        CU_WB WB(   .Payload(MB), 
                    .DIn(RFDIn), 
                    .SIn(RFSIn), 
                    .WE(RFWE), 
                    .EOut(EOut), 
                    .ESOut(ESOut),
                    .CLK(CLK));
                    
                    
endmodule
