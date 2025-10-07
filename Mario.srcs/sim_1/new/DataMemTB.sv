`timescale 1ns / 1ps

module DataMemTB();
    logic [15:0] DIn;
    logic [9:0] AddrIn, AddrOut;
    logic WE, CLK;
    logic [15:0] DOut;
    
    DataMem DUT(.DIn(DIn),
                .AddrIn(AddrIn),
                .AddrOut(AddrOut),
                .WE(WE), 
                .CLK(CLK),
                .DOut(DOut));
                
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end
    
    initial begin
        AddrIn = 10'b0000000000; WE = 1'b1; DIn = 16'b0101010101010101; #10;
        AddrOut = 10'b0000000000; #5;
        assert (DOut === 16'b0101010101010101) else $error("### FAILURE ###");
        
        #10; $finish;
    end
                
endmodule
