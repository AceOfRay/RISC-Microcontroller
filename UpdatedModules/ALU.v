`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2023 12:16:56 PM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input wire [31:0] srcA,
    input wire [31:0] srcB,
    input wire [3:0] alu_fun,
    output reg [31:0] result
    );
    
    parameter ADD = 4'b0000;
    parameter SUB = 4'b1000;
    parameter OR  = 4'b0110;
    parameter AND = 4'b0111;   
    parameter XOR = 4'b0010;
    parameter SRL = 4'b0101;
    parameter SLL = 4'b0001;
    parameter SRA = 4'b1101;
    parameter SLT = 4'b0010;
    parameter SLTU = 4'b0011;
    parameter LUI = 4'b1001;
    

    
    always @(*) begin
    
        case (alu_fun)
            ADD: result = srcA + srcB;
            SUB: result = srcA - srcB;
            OR: result = srcA | srcB;
            AND: result = srcA & srcB;
            XOR: result = srcA ^ srcB; 
            SRL: result = srcA >> srcB[4:0];  //check
            SLL: result = $signed(srcA) << srcB; //incorrect but corrected
            SRA: result = srcA >>> srcB[4:0]; // removed $
            SLT: begin // check
                result = $signed(srcA) < srcB;
            end       //result = (srcA < srcB); // ask about SLT and SLTU
            
            SLTU: begin // check
                result = srcA < srcB;
            end     //result = ($signed(srcA) < $signed(srcB)); 
            
            LUI: result = srcA; //just passed through apparently
            default: result = srcA;
                        
        endcase
    end
endmodule