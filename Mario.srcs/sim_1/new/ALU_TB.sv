`timescale 1ns / 1ps

module ALU_TB();
    logic Z, N, O;
    logic [15:0] Accumulator, Operand, Result;
    logic Operation;
    
    ALU DUT(.Z(Z), 
            .N(N), 
            .O(O),
            .Accumulator(Accumulator), 
            .Operand(Operand), 
            .Result(Result), 
            .Operation(Operation));
        
    //0 Add
    //1 Sub      
            
    initial begin 
    
        //Add
           Operation = 1'b0; 
        Accumulator = 16'b0000000000010000;
            Operand = 16'b0000000000010000;
        
        #5;
        
        assert (Result === 16'b0000000000100000) else $error("### Addition Failed ###"); #5; 
            
        Operand = 16'b1111111111111111; #5;
        
        assert (O === 1'b1) else $error("### Overflow Failed ###"); #5;
        
        
        
        
        //Sub
           Operation = 1'b1; 
        Accumulator = 16'b0000000000010000;
            Operand = 16'b0000000000001000;
        
        #5;
        
        assert (Result === 16'b0000000000001000) else $error("### Subtraction Failed ###"); #5;
        
        Operand = 16'b1111111111111111; #5;
        
        assert (N === 1'b1) else $error("### Negative failed ###"); #5;
        
        Operand = 16'b0000000000010000; #5;
        
        assert (Z === 1'b1) else $error("### Zero failed ###"); #5;        
    end            
endmodule
