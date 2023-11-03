`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Ray Valenzuela
// 
// Create Date: 10/24/2023 06:51:02 PM
// Design Name: immediate Generator
// Module Name: Immed_Gen
// Project Name: Experiment 4
// Target Devices: Basys 3 Board
// Tool Versions: 
// Description: Creating the immediate generator
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Immed_Gen(
    // immediate Generator inputs
    input wire [31:0] ir,
    
    //imed gen outputs
    output wire [31:0] u_type,
    output wire [31:0] s_type,
    output wire [31:0] i_type,
    output wire [31:0] j_type,
    output wire [31:0] b_type
    );
    // what determines the type of output the generator generates?
    
    // i_type instructions
    assign i_type = {{21{ir[31]}}, ir[30:20]};

    // s_type instructions
    assign s_type = {{21{ir[31]}}, ir[30:25], ir[11:7]};

    // b_type instructions
    assign b_type = {{20{ir[31]}},  ir[7], ir[30:25], ir[11:8], 1'b0};

    // u_type instructions
    assign u_type = {ir[31:12], 12'b0};

    // j_type instructions
    assign j_type = {{12{ir[31]}}, ir[19:12], ir[20], ir[30:21], 1'b0};

    
endmodule
