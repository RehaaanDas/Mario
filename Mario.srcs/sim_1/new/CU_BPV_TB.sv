`timescale 1ns / 1ps

module CU_BPV_TB();
    logic CLK, Z, N, O;
    logic [15:0] AOut, BOut, COut, DOut, EOut, MemDOut, ALUResult;
    logic [31:0] IMemDOut;
          
    logic [3:0] ASOut, BSOut, CSOut, DSOut, ESOut, ALUDestR, RFSIn;
    logic [15:0] RFDIn, MemDIn, IAddr, ALUAcc, ALUOp;
    logic [9:0] MemAddrIn, MemAddrOut;
    logic MWE, RFWE, Stall, HALT, ALUOperation;

    CU DUT(.Z(Z), .N(N), .O(O),
           .CLK(CLK),
           .AOut(AOut),
           .BOut(BOut),
           .COut(COut),
           .DOut(DOut),
           .EOut(EOut),
           .MemDOut(MemDOut),
           .ALUResult(ALUResult),
           .IMemDOut(IMemDOut),

           .ASOut(ASOut),
           .BSOut(BSOut),
           .CSOut(CSOut),
           .DSOut(DSOut),
           .ESOut(ESOut),
           .RFSIn(RFSIn),
           .ALUDestR(ALUDestR),
           .RFDIn(RFDIn),
           .MemDIn(MemDIn),
           .IAddr(IAddr),
           .ALUAcc(ALUAcc),
           .ALUOp(ALUOp),
           .MemAddrIn(MemAddrIn),
           .MemAddrOut(MemAddrOut),
           .MWE(MWE),
           .RFWE(RFWE),
           .Stall(Stall),
           .HALT(HALT),
           .ALUOperation(ALUOperation));

            initial begin
                CLK = 0;
                forever #5 CLK = ~CLK;
            end

            initial begin
                IMemDOut = 32'b11010000000000000000000000000000;
                #40; //flushing pipeline
                             //Store CACA at R2
                IMemDOut = 32'b11110110010101100101000100000000;
                #10;         //Store BEEF at R2
                IMemDOut = 32'b11110101111101110111100100000000;
                #10;         //Dynamic Jump to address stored at R2
                IMemDOut = 32'b11101000010000000000000000000000;
                #30;

                assert(IAddr === 16'hBEEF) else $error("### MW_X Failed ###");

                IMemDOut = 32'b11010000000000000000000000000000;
                #40; //flushing pipeline
                             //Store BAFF at R2
                IMemDOut = 32'b11110101110101111111100100000000;
                #10;         //Dynamic Jump to address stored at R2
                IMemDOut = 32'b11101000010000000000000000000000;
                #30;

                assert(IAddr === 16'hBAFF) else $error("### M_X Failed ###");

                IMemDOut = 32'b11010000000000000000000000000000;
                #40; //flushing pipeline
                             //Store FAB5 at R2
                IMemDOut = 32'b11110111110101011010100100000000;
                #10;         //NOP
                IMemDOut = 32'b11010000000000000000000000000000;
                #10;         //Dynamic Jump to address stored at R2
                IMemDOut = 32'b11101000010000000000000000000000;
                #30;

                assert(IAddr === 16'hFAB5) else $error("### W_X Failed ###");

                IMemDOut = 32'b11010000000000000000000000000000;
                #40; //flushing pipeline
                             //Store BA5E at R2
                IMemDOut = 32'b11110101110100101111000100000000;
                #10;         //Store data from R2 at memory address 1010110101
                IMemDOut = 32'b00100001010101101010000000000000;
                #10;         //NOP
                IMemDOut = 32'b11010000000000000000000000000000;
                #20;

                assert(MemDIn === 16'hBA5E) else $error("### W_M Failed ###");

            end
endmodule
