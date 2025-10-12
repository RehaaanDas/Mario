`timescale 1ns / 1ps

module CU_WB_TB();
    logic [49:0] Payload;
    logic [15:0] EOut;
    logic CLK;

    logic [15:0] DIn;
    logic [3:0]  SIn, ESOut;
    logic WE;
    
    CU_WB DUT(.Payload(Payload), 
    .DIn(DIn), 
    .SIn(SIn), 
    .WE(WE), 
    .EOut(EOut), 
    .ESOut(ESOut),
    .CLK(CLK));

    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end
    
    initial begin
        Payload[49:42] = 8'b00010000; 
        Payload[41:26] = 16'hF00D; 
        Payload[11:8] = 4'hC;

        #10; //5
        assert(DIn === 16'hF00D 
            && SIn === 4'hC 
            && WE === 1'b1)
        else $error("### FAILED REG ###");
        


        Payload[49:42] = 8'b00001000; 
        Payload[15:12] = 4'h5; 
        Payload[11:8] = 4'hE;
        EOut = 16'hC0BB;

        #10;
        assert(DIn === 16'hC0BB 
            && SIn === 4'hE 
            && WE === 1'b1) 
        else $error("### FAILED MOV ###");
        $finish;
    end
endmodule
