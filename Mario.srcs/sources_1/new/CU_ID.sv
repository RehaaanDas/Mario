`timescale 1ns / 1ps

module CU_ID(input logic [31:0] Instruction,
             output logic [49:0] PayloadOut);

            always_comb begin
                case (Instruction[31:28])
                    4'b0000: PayloadOut = { 8'b10000000,            
                                            Instruction[26:11],
                                            Instruction[10:1],      
                                            4'h0,
                                            Instruction[10:7],     
                                            6'h0,
                                            Instruction[27],        
                                            1'b0};

                    4'b1111: PayloadOut = { 8'b00010000,            
                                            Instruction[26:11],
                                            14'h0,                  
                                            Instruction[10:7],      
                                            7'h0, //Reg
                                            1'b0};            

                    4'b0001: PayloadOut = { 24'b001000000000000000000000,   
                                            Instruction[22:13],     
                                            Instruction[26:23],     
                                            Instruction[22:19],     
                                            6'h0,                  
                                            Instruction[27], //Load 
                                            1'b0};

                    4'b0010: PayloadOut = { 24'b010000000000000000000000,
                                            Instruction[22:13],      
                                            Instruction[26:23],      
                                            Instruction[22:19],      
                                            6'h0,
                                            Instruction[27], //Store  
                                            1'b0};

                    4'b0100: PayloadOut = { 34'b0000100000000000000000000000000000,
                                            Instruction[26:23],      
                                            Instruction[22:19],      
                                            7'h0, //Move
                                            1'b0}; 

                    4'b1000: PayloadOut = { {5'h0, ~Instruction[27], Instruction[27], 1'b0}, 
                                            26'h0,                     
                                            Instruction[26:23],      
                                            Instruction[22:19],      
                                            Instruction[18:15],      
                                            3'b000, //ALU
                                            1'b1}; 

                    4'b1110: PayloadOut = { 8'b00000001,
                                            Instruction[24:9],           
                                            14'h0,                   
                                            Instruction[24:21],          
                                            4'h0,
                                            Instruction[26:25],          
                                            Instruction[27],//Jmp      
                                            1'b0}; 

                    4'b0111: PayloadOut = { {5'h0, ~Instruction[27], Instruction[27], 1'b0}, 
                                            26'h0,
                                            Instruction[26:23],      
                                            Instruction[22:19],      
                                            Instruction[18:15],      
                                            4'h0}; //Cmp

                    4'b1011: PayloadOut = 50'b00000000100000000000000000000000000000000000000000; //Halt
                    default: PayloadOut = 0; //NOP
                endcase
            end
endmodule
