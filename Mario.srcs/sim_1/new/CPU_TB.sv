`timescale 1ns / 1ps

module CPU_TB();
    logic                       CLK;
    logic [3:0]                 TBRS;
    logic [15:0]                TBROut;
    logic [31:0]                IMemDOut;

    logic [15:0]                IAddr;


    CPU DUT(.TBRS(TBRS),
            .TBROut(TBROut),
            .IMemDOut(IMemDOut),        
            .CLK(CLK),
            .IAddr(IAddr));

    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    initial begin 
        IMemDOut = 32'b11010000000000000000000000000000;
        #40; //flush pipeline

        TBRS = 0001;
        //             Store 0001 at R1
        IMemDOut = 32'b11110000000000000000100010000000;
        #10;
        for(int i = 0; i < 7; i++) begin    
            //             Add R1 and R2 and store at R1
            IMemDOut = 32'b10000000100100001000000000000000;
            #10;//         Sub R2 from R1 and store at R2
            IMemDOut = 32'b10001000100100010000000000000000;
            #10;//         Jump to Add Instruction [2nd instruction]
            IMemDOut = 32'b11100000000000000000001000000000;
            #10;
            IMemDOut = 32'b11010000000000000000000000000000;
            #20;
        end

        IMemDOut = 32'b11010000000000000000000000000000;
        #40;
 
        assert(TBROut === 16'd21) else $error("### FIBONACCI FAILED ###");

        IMemDOut = 32'b11010000000000000000000000000000;
        #40; //flush pipeline

        TBRS = 1001;
        //Store 0003 at Address 1 in mem
        IMemDOut = 32'b00000000000000000001100000000010;
        #10;// Store 0008 at Address 3 in mem
        IMemDOut = 32'b00000000000000000100000000000110;
        #10;// Store ACED at Address 8 in mem
        IMemDOut = 32'b00000101011001110110100000010000;
        #10;// Load from Address 1 in memory into R2
        IMemDOut = 32'b00010001000000000010000000000000;
        #10;// Load from Address given in R2 into R3
        IMemDOut = 32'b00011001100100000000000000000000;
        #10;// Load from Address given in R3 into R9
        IMemDOut = 32'b00011100100110000000000000000000;
        #10;//
        IMemDOut = 32'b11010000000000000000000000000000;
        #80;

        TBRS = 1001;
        assert(TBROut === 16'hACED) else $error("### LOADCHAIN FAILED ###");

        IMemDOut = 32'b11010000000000000000000000000000;
        #40; //flush pipeline

        TBRS = 1001;
        //             Store 0005 at R2
        IMemDOut = 32'b11110000000000000010100100000000;
        #10;//         Store 0009 at R5
        IMemDOut = 32'b11110000000000000100101010000000;
        #10;//         Compare Sub R5 from R2
        IMemDOut = 32'b01111001001010000000000000000000;
        #10;//         Jump if Z to instruction 6 [Reg Write R9 0001]
        IMemDOut = 32'b11100010000000000000110000000000;
        #30;
        if(IAddr === 16'd6)begin
            //             Store 0001 at R9
            IMemDOut = 32'b11110000000000000000110010000000;
            #10;//         Jump to instruction 5 [Halt]
            IMemDOut = 32'b11100000000000000000101000000000;
            #10;  
        end else begin
            //             Store 0000 at R9
            IMemDOut = 32'b11110000000000000000010010000000;
            #10;
        end
        //             HALT
        IMemDOut = 32'b11010000000000000000000000000000;
        #40;

        assert (TBROut === 16'h0000) 
        else   $error("### EQUALCHECK 1 FAILED ###");

        IMemDOut = 32'b11010000000000000000000000000000;
        #40; //flush pipeline

        TBRS = 1001;
        //             Store 0005 at R2
        IMemDOut = 32'b11110000000000000010100100000000;
        #10;//         Store 0005 at R5
        IMemDOut = 32'b11110000000000000010101010000000;
        #10;//         Compare Sub R5 from R2
        IMemDOut = 32'b01111001001010000000000000000000;
        #10;//         Jump if Z to instruction 6 [Reg Write R9 0001]
        IMemDOut = 32'b11100010000000000000110000000000;
        #30;
        if(IAddr === 16'd6)begin
            //             Store 0001 at R9
            IMemDOut = 32'b11110000000000000000110010000000;
            #10;//         Jump to instruction 5 [Halt]
            IMemDOut = 32'b11100000000000000000101000000000;
            #10;  
        end else begin
            //             Store 0000 at R9
            IMemDOut = 32'b11110000000000000000010010000000;
            #10;
        end
        //             HALT
        IMemDOut = 32'b11010000000000000000000000000000;
        #40;

        assert (TBROut === 16'h0001) 
        else   $error("### EQUALCHECK 2 FAILED ###");
        
        
    end
endmodule
