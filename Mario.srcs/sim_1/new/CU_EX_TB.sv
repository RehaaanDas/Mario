`timescale 1ns / 1ps

module CU_EX_TB();
    logic [15:0] AOut, BOut, ALURes;
    logic [49:0] Payload, PayloadOut;
    logic Z, N, O;
             
    logic [15:0] JmpAddr, ALUOp, ALUAcc;
    logic [3:0] ASOut, BSOut, DestR;
    logic ALUWE, ALUOperation, JmpConfirm;
    
    CU_EX DUT( .AOut(AOut),
               .BOut(BOut), 
               .ALURes(ALURes),
               .Payload(Payload), 
               .PayloadOut(PayloadOut),
               .Z(Z), 
               .N(N), 
               .O(O), 
               .JmpAddr(JmpAddr), 
               .ASOut(ASOut),
               .BSOut(BSOut),
               .DestR(DestR),
               .ALUWE(ALUWE),
               .ALUOperation(ALUOperation),
               .JmpConfirm(JmpConfirm));

    initial begin 
        Payload[49:42] = 8'b00000001; Payload[3:1] = 3'b000;
        Payload[41:26] = 16'hFADE;
        #10;
        assert (JmpAddr === 16'hFADE && JmpConfirm) else $error("### Jmp Failed ###");


        Payload[49:42] = 8'b00000001; Payload[3:1] = 3'b011; Payload[11:8] = 4'hE;
        BOut    = 16'b1110111011101110;
        Z       = 1'b1;
        #10;
        assert (JmpAddr === 16'b1110111011101110 && JmpConfirm) else $error("### JmpR Failed ###");

        Payload[49:42] = 8'b00000100; Payload[0] = 1'b1; Payload[15:12] = 4'h4; Payload[11:8] = 4'hE; Payload[7:4] = 4'hC; ALURes = 16'h0008;
        #10;
        assert((ALUOperation === 1'b0) && (ASOut === 4'h4) && (BSOut === 4'hE) && (DestR === 4'hC) && (PayloadOut === {8'b00010000, 16'h0008, 14'h0, 4'hC, 8'h0}) && ALUWE) else $error("### Add Failed ###");
        $finish;
    end
endmodule
