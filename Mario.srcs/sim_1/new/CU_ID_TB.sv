`timescale 1ns / 1ps
module CU_ID_TB();
    logic [31:0] Instruction;
    logic [49:0] PayloadOut;
    logic HALT;

    CU_ID dut(.Instruction(Instruction), .PayloadOut(PayloadOut), .HALT(HALT));

    initial begin
        Instruction = 32'b00000111111111111111110101010100; #5;
        assert(PayloadOut === 50'b10000000111111111111111110101010100000101000000000) else $error("### Mem Failed ###");
        #5;

        Instruction = 32'b11110110011001100110011110000000; #5;
        assert(PayloadOut === 50'b00010000110011001100110000000000000000111100000000) else $error("### Reg Failed ###");
        #5;

        Instruction = 32'b00010110101101101100000000000000; #5;
        assert(PayloadOut === 50'b00100000000000000000000001101101101101011000000000) else $error("### Ld Failed ###");
        #5;

        Instruction = 32'b00100111110101010100000000000000; #5;
        assert(PayloadOut === 50'b01000000000000000000000010101010101111101000000000) else $error("### Str Failed ###");
        #5;

        Instruction = 32'b01000001000110000000000000000000; #5;
        assert(PayloadOut === 50'b00001000000000000000000000000000000010001100000000) else $error("### Mov Failed ###");
        #5;

        Instruction = 32'b10001010001010110000000000000000; #5;
        assert(PayloadOut === 50'b00000010000000000000000000000000000100010101100001) else $error("### ALU Failed ###");
        #5;

        Instruction = 32'b11100001100110011001100000000000; #5;
        assert(PayloadOut === 50'b00000001110011001100110000000000000000110000000000) else $error("### Jmp Failed ###");
        #5;

        Instruction = 32'b01111100010010000000000000000000; #5;
        assert(PayloadOut === 50'b00000010000000000000000000000000001000100100000000) else $error("### Cmp Failed ###");
        #5;

        Instruction = 32'b10110000000000000000000000000000; #5;
        assert(PayloadOut === 50'b00000000100000000000000000000000000000000000000000) else $error("### Halt Failed ###");
        #5;
              
        $finish;
    end;
endmodule