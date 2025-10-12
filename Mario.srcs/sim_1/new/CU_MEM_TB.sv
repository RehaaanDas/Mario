`timescale 1ns / 1ps

module CU_MEM_TB();
    logic [49:0] Payload;
    logic [15:0] DOut, COut, MemDOut;
              
    logic [49:0] PayloadOut;
    logic [3:0] DSOut, CSOut;
            
    logic [9:0] MemAddrIn, MemAddrOut;
    logic [15:0] MemDIn;
              
    logic WE;

    CU_MEM DUT( .Payload(Payload),
                .PayloadOut(PayloadOut), 
                .DOut(DOut), 
                .COut(COut), 
                .MemDOut(MemDOut), 
                .DSOut(DSOut), 
                .CSOut(CSOut),
                .MemAddrIn(MemAddrIn),
                .MemAddrOut(MemAddrOut),
                .MemDIn(MemDIn),
                .WE(WE));

    initial begin
        //MEM  
                Payload[49:42] = 8'b10000000; Payload[25:16] = 10'b0110001100; Payload[41:26] = 16'b0111011101110111; Payload[1] = 1'b0;
                #30; assert((MemAddrIn === 10'b0110001100) && (MemDIn === 16'b0111011101110111)) else $error("### MEM Failed - MemAddrIn = %b - MemDIn = %b ###", MemAddrIn, MemDIn);
                #5;

                COut = 16'hBEEF;
                Payload[49:42] = 8'b10000000; Payload[11:8] = 4'b1011; Payload[41:26] = 16'b1000100010001000; Payload[1] = 1'b1;
                #30; assert((MemAddrIn === 10'hBEEF) && (MemDIn === 16'b1000100010001000)) else $error("### MEMR Failed - MemAddrIn = %b - MemDIn = %b ###", MemAddrIn, MemDIn);
                #5;
        //STORE
                DOut = 16'hFECE;
                Payload[49:42] = 8'b01000000; Payload[25:16] = 10'b1001110011; Payload[15:12] = 4'b0100; Payload[1] = 1'b0;
                #30; assert((MemAddrIn === 10'b1001110011) && (MemDIn === 16'hFECE)) else $error("### ST Failed - MemAddrIn = %b - MemDIn = %b ###", MemAddrIn, MemDIn);
                #5;

                DOut = 16'hBACC; COut = 16'hCACA;
                Payload[49:42] = 8'b01000000; Payload[11:8] = 4'b0101; Payload[15:12] = 4'b1100; Payload[1] = 1'b1;
                #30; assert((MemAddrIn === 10'hCACA) && (MemDIn === 16'hBACC)) else $error("### STR Failed - MemAddrIn = %b - MemDIn = %b ###", MemAddrIn, MemDIn);
                #5;
        //LD
                MemDOut = 16'b0000111100001111;
                Payload[49:42] = 8'b00100000; Payload[25:16] = 10'b0110111011; Payload[15:12] = 4'b1001; Payload[1] = 1'b0;
                #30; assert(PayloadOut === 50'b00010000000011110000111100000000000000100100000000) else $error("### LD Failed - PayloadOut = %b ###", PayloadOut);
                #5;

                DOut = 16'hBA5E; MemDOut = 16'b0010111100101111;
                Payload[49:42] = 8'b00100000; Payload[25:16] = 10'b0110111011; Payload[15:12] = 4'b1001; Payload[11:8] = 4'b0110;  Payload[1] = 1'b1;
                #30; assert(PayloadOut === 50'b00010000001011110010111100000000000000100100000000) else $error("### LDR Failed - PayloadOut = %b ###", PayloadOut);
                #5;
                $finish;
    end
endmodule
