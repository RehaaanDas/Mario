`timescale 1ns / 1ps

module CU_TB();
    logic CLK, Z, N, O;
    logic [15:0] AOut, BOut, COut, DOut, EOut, MemDOut, ALUResult;
    logic [31:0] IMemDOut;
          
    logic [3:0] ASOut, BSOut, CSOut, DSOut, ESOut, RFSIn;
    logic [15:0] RFDIn, MemDIn, IAddr;
    logic [9:0] MemAddrIn, MemAddrOut;
    logic MWE, RFWE, ALUOperation;

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
           .RFDIn(RFDIn),
           .MemDIn(MemDIn),
           .IAddr(IAddr),
           .MemAddrIn(MemAddrIn),
           .MemAddrOut(MemAddrOut),
           .MWE(MWE),
           .RFWE(RFWE),
           .ALUOperation(ALUOperation));

            initial begin
                CLK = 0;
                forever #5 CLK = ~CLK;
            end

            initial begin
                IMemDOut = 32'b11010000000000000000000000000000;
                #40; //flushing pipeline


                IMemDOut = 32'b11110000011111010010000110000000;
                #10;
                IMemDOut = 32'b11010000000000000000000000000000;
                #30;
                assert(RFWE && RFSIn === 4'b0011 && RFDIn === 16'b0000111110100100) else $error("### Reg Failed ###");


                IMemDOut = 32'b11010000000000000000000000000000;
                #40; //flushing pipeline


                IMemDOut = 32'b01000010001110000000000000000000;
                EOut = 16'b1100110011001100;
                #10;
                IMemDOut = 32'b11010000000000000000000000000000;
                #30;
                assert(RFWE && ESOut === 4'b0100 && RFSIn === 4'b0111 && RFDIn === 16'b1100110011001100) else $error("### Mov Failed ###");


                IMemDOut = 32'b11010000000000000000000000000000;
                #40; //flushing pipeline


                IMemDOut = 32'b00010011100000010000000000000000;
                MemDOut = 16'b1010101010101010;
                #10;
                IMemDOut = 32'b11010000000000000000000000000000;
                #20;
                assert(MemAddrOut === 10'b0000001000) else $error("### LdI Failed ###");
                #10;
                assert(RFWE && RFSIn === 4'b0111 && RFDIn === 16'b1010101010101010) else $error("### LdI Reg Failed ###");

                #10; //account for stall

                IMemDOut = 32'b11010000000000000000000000000000;
                #40; //flushing pipeline


                IMemDOut = 32'b00011011100110000000000000000000;
                COut = 16'b1111111111111111;
                MemDOut = 16'b0110110110110110;
                #10;
                IMemDOut = 32'b11010000000000000000000000000000;
                #20;
                assert(MemAddrOut === 10'b1111111111 && CSOut === 4'b0011) else $error("### LdD Failed ###");
                #10;
                assert(RFWE && RFSIn === 4'b0111 && RFDIn === 16'b0110110110110110) else $error("### LdD Reg Failed ###");

                #10; //account for stall

                IMemDOut = 32'b11010000000000000000000000000000;
                #40; //flushing pipeline


                IMemDOut = 32'b00100011000000100000000000000000;
                DOut = 16'b1010101010101010;
                #10;
                IMemDOut = 32'b11010000000000000000000000000000;
                #20;
                assert(MWE && MemAddrIn === 10'b0000010000 && MemDIn === 16'b1010101010101010) else $error("### StrI Failed ###");


                IMemDOut = 32'b11010000000000000000000000000000;
                #40; //flushing pipeline


                IMemDOut = 32'b00101100001010000000000000000000;
                DOut = 16'b1100110011001100;
                COut = 16'b0110110110110110;
                #10;
                IMemDOut = 32'b11010000000000000000000000000000;
                #20;
                assert((MemAddrIn === 10'b0110110110) && (MemDIn === 16'b1100110011001100) && MWE) else $error("### StrD Failed ###");


                IMemDOut = 32'b11010000000000000000000000000000;
                #40; //flushing pipeline


                IMemDOut = 32'b00000000010000000000000001000000;
                #10;
                IMemDOut = 32'b11010000000000000000000000000000;
                #20;
                assert(MWE && MemDIn === 16'b0000100000000000 && MemAddrIn === 10'd32) else $error("### Mem Failed ###");


                IMemDOut = 32'b11010000000000000000000000000000;
                #40; //flushing pipeline


                IMemDOut = 32'b11100000000001000000000000000000;
                #10;
                IMemDOut = 32'b11010000000000000000000000000000;
                #20;
                assert(IAddr === 16'b0000001000000000) else $error("### JmpUC Failed ###");


                IMemDOut = 32'b11010000000000000000000000000000;
                #40; //flushing pipeline


                IMemDOut = 32'b11100010000000101000000000000000;
                Z = 1;
                #10;
                IMemDOut = 32'b11010000000000000000000000000000;
                #20;
                assert(IAddr === 16'b0000000101000000) else $error("### JmpZ Failed ###");


                IMemDOut = 32'b11010000000000000000000000000000;
                #40; //flushing pipeline


                IMemDOut = 32'b11101001010000000000000000000000;
                BOut = 16'b0110110110110110;
                #10;
                IMemDOut = 32'b11010000000000000000000000000000;
                #20;
                assert(IAddr === 16'b0110110110110110) else $error("### JmpRUC Failed ###");


                IMemDOut = 32'b11010000000000000000000000000000;
                #40; //flushing pipeline

            
                IMemDOut = 32'b11101010100000000000000000000000;
                BOut = 16'b1010101010101010;
                Z = 1;
                #10;
                IMemDOut = 32'b11010000000000000000000000000000;
                #20;
                assert(IAddr === 16'b1010101010101010) else $error("### JmpRZ Failed ###");


                IMemDOut = 32'b11010000000000000000000000000000;
                #40; //flushing pipeline

                AOut = 16'd12; BOut = 16'd13; ALUResult = 16'd25;
                IMemDOut = 32'b10000100010010110000000000000000;
                #10;
                IMemDOut = 32'b11010000000000000000000000000000;
                #10;
                assert(ASOut === 4'd8 && BSOut === 4'd9) else $error("### Add Failed ###");
                #20;
                assert(RFDIn === 16'd25 && RFSIn === 4'd6)  else $error("### Add Reg Failed ###");

                IMemDOut = 32'b11010000000000000000000000000000;
                #40; //flushing pipeline

                AOut = 16'd10; BOut = 16'd4; ALUResult = 16'd6;
                IMemDOut = 32'b10001001000011100000000000000000;
                #10;
                IMemDOut = 32'b11010000000000000000000000000000;
                #10;
                assert(ASOut === 4'd2 && BSOut === 4'd1) else $error("### sub failed ###");
                #20;
                assert(RFDIn === 16'd6 && RFSIn === 4'd12) else $error("### sub reg failed ###");
                $finish();
            end

endmodule
