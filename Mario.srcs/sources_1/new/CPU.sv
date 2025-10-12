`timescale 1ns / 1ps

module CPU(input logic CLK,
           input logic [3:0] TBRS,
           input logic [31:0] IMemDOut,

           output logic [15:0] TBROut, IAddr);

        logic   Z, N, O, 
                MWE, RFWE, Stall, HALT,
                ALUOperation;

        logic [3:0] ASOut, 
                BSOut, 
                CSOut, 
                DSOut, 
                ESOut, 
                ALUDestR,
                RFSIn;

        logic [15:0] AOut, 
                BOut, 
                COut, 
                DOut, 
                EOut, 
                RFDIn,
                MemAddrIn,
                MemAddrOut,
                MemDOut,
                MemDIn,
                ALUResult,
                ALUAcc,
                ALUOp;

        

    CU CU(.Z(Z), .N(N), .O(O), 
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

    ALU ALU(.Z(Z),   
            .N(N),   
            .O(O),  
            .Accumulator(ALUAcc),   
            .Operand(ALUOp),   
            .Result(ALUResult),   
            .Operation(ALUOperation));  

    RegisterFile RF(.ASOut(ASOut),  
                     .BSOut(BSOut),  
                     .CSOut(CSOut),  
                     .DSOut(DSOut),  
                     .ESOut(ESOut),  
                     .AOut(AOut),  
                     .BOut(BOut),  
                     .COut(COut),  
                     .DOut(DOut),  
                     .EOut(EOut),  
                     .DIn(RFDIn),  
                     .SIn(RFSIn),  
                     .WE(RFWE),  
                     .CLK(CLK),
                     
                     .TBSOut(TBRS),
                     .TBOut(TBROut));  
    
    DataMem DM(.DIn(MemDIn),  
                .AddrIn(MemAddrIn),  
                .AddrOut(MemAddrOut),  
                .WE(MWE),   
                .CLK(CLK),  
                .DOut(MemDOut));  

endmodule
