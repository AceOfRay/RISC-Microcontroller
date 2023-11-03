`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2023 07:58:55 PM
// Design Name: 
// Module Name: Branch_Address_Gen
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


module Branch_Address_Gen(
    // branch gen inputs
    input wire [31:0] rs,
    input wire [31:0] pc,
    input wire [31:0] i_type,
    input wire [31:0] j_type,
    input wire [31:0] b_type,
    // outputs of the branch addr gen
    output wire [31:0] jal,
    output wire [31:0] jalr,
    output wire [31:0] branch
    // what determines the type of output the generator generates?
    );
    
    assign jal = (pc) + j_type; // next experiment revert pc-4 to pc
    assign jalr = rs + i_type; // next eperiment turn 12 into rs
    assign branch = (pc) + b_type; // BE WEARY OF PC supposed to be pc-4
    
endmodule
