`timescale 1ns / 1ps

module PC_TB();

    logic [15:0] JmpAddr;
    logic CLK, Jmp, STALL;
          
    logic [15:0] IAddr;
    
    PC PC(  .JmpAddr(JmpAddr), 
            .CLK(CLK), 
            .Jmp(Jmp), 
            .STALL(STALL),
            .IAddr(IAddr));
            
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end
    
    initial begin
        #70;
        assert(IAddr === 16'd7) else $error("### PC Increment failed ###");

        Jmp = 1'b1; JmpAddr = 16'hABCD;
        #10;
        assert(IAddr === 16'hABCD) else $error("### JMP FAiled ###");

        STALL = 1'b1;
        #30;
        assert(IAddr === 16'hABCD) else $error("### STALL Failed ###");
        $finish;                      
    end
endmodule
