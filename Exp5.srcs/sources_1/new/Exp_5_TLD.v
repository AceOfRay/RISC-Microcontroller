`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Ray Valenzuela
// 
// Create Date: 10/31/2023 09:40:03 AM
// Design Name: Working Risc-V Microprocessor
// Module Name: ExpFiveTLD
// Project Name: Experiment 5
// Target Devices: Basys 3 Board
// Tool Versions: 
// Description: Implemented 6 hardware instructions LUI, LW, SW, ADD, ADDI, JAL
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ExpFiveTLD(
    input clk,
    input wire RST,
    input wire intr,
    input wire [31:0] iobus_in,
    output wire [31:0] iobus_out,
    output wire [31:0] iobus_addr,
    output wire iobus_wr
        );
        

    // data routing wires
    wire [31:0] s_type;
    wire [31:0] u_type;      
    wire [31:0] mux_2_PC;
    wire [31:0] PC_2_Mux;
    wire [31:0] J_Immed_2_Branch;
    wire [31:0] B_Immed_2_Branch;
    wire [31:0] I_Immed_2_Branch;
    wire [31:0] jalrWire;
    wire [31:0] jalWire;
    wire [31:0] branchWire;
    wire [31:0] irWire;
    wire [31:0] rs1Wire;
    wire [31:0] rs2Wire;
    wire [31:0] ALU_srcA_Wire;
    wire [31:0] ALU_srcB_Wire;
    wire [31:0] ALU_Out_Wire;
    wire [31:0] Mem_2_RegMux;
    wire [31:0] RegMux_2_RegFile;
    
    
    //pc control wires
    wire pcWrite;
    wire pc_reset;  
    wire [1:0] pcSource; 
    //alu control wires
    wire [1:0] alu_srcB;
    wire alu_srcA;
    wire [3:0] alu_fun;
    //reg file control wires
    wire [1:0] rf_wr_sel;
    wire regWrite;
    
    // memory control wires
    wire memRDEN1;
    wire memRDEN2;
    wire memWE2;
    wire iobus_db_wire;
    
    
    
    
    assign iobus_wr = iobus_db_wire;
    assign iobus_out = rs2Wire;
    assign iobus_addr = ALU_Out_Wire;
    
    
    reg_nb_sclr #(.n(32)) PC (
     .data_in  (mux_2_PC), 
     .ld       (pcWrite), 
     .clk      (clk), 
     .clr      (pc_reset), 
     .data_out (PC_2_Mux)
        );  
          
    mux_4t1_nb  #(.n(32)) mux  (
     .SEL   (pcSource), 
     .D0    (PC_2_Mux + 4), 
     .D1    (jalrWire), 
     .D2    (branchWire), 
     .D3    (jalWire),
     .D_OUT (mux_2_PC) 
        );
    
    Memory OTTER_MEMORY (
    .MEM_CLK   (clk),
    .MEM_RDEN1 (memRDEN1), 
    .MEM_RDEN2 (memRDEN2), 
    .MEM_WE2   (memWE2),
    .MEM_ADDR1 (PC_2_Mux[15:2]),
    .MEM_ADDR2 (ALU_Out_Wire),
    .MEM_DIN2  (rs2Wire),  
    .MEM_SIZE  (irWire[13:12]),
    .MEM_SIGN  (irWire[14]),
    .IO_IN     (iobus_in),
    .IO_WR     (iobus_db_wire),
    .MEM_DOUT1 (irWire),
    .MEM_DOUT2 (Mem_2_RegMux)  
        ); 
        
    Immed_Gen Immed (
    .ir({irWire[31:7], 7'b0000000}),
    .u_type(u_type),
    .s_type(s_type),
    .j_type(J_Immed_2_Branch),
    .b_type(B_Immed_2_Branch),
    .i_type(I_Immed_2_Branch)
         );
         
    Branch_Address_Gen BAG (
    .rs(rs1Wire),
    .pc(PC_2_Mux),
    .i_type(I_Immed_2_Branch),
    .j_type(J_Immed_2_Branch),
    .b_type(B_Immed_2_Branch),
    .jal(jalWire),
    .jalr(jalrWire),
    .branch(branchWire)
    );
    
    RegFile RegFile (
    .wd   (RegMux_2_RegFile),
    .clk  (clk), 
    .en   (regWrite),
    .adr1 (irWire[19:15]),
    .adr2 (irWire[24:20]),
    .wa   (irWire[11:7]),
    .rs1  (rs1Wire), 
    .rs2  (rs2Wire)  );
    
    CU_FSM my_fsm(
     .intr     (intr),
     .clk      (clk),
     .RST      (RST),
     .opcode   (irWire[6:0]),   // ir[6:0]
     .pcWrite  (pcWrite),
     .regWrite (regWrite),
     .memWE2   (memWE2),
     .memRDEN1 (memRDEN1),
     .memRDEN2 (memRDEN2),
     .reset    (pc_reset)  
     );
        
    CU_DCDR my_cu_dcdr(
     .br_eq     (), 
     .br_lt     (), 
     .br_ltu    (),
     .opcode    (irWire[6:0]),    //-  ir[6:0]
     .func7     (irWire[3]),    //-  ir[30]
     .func3     (irWire[14:12]),    //-  ir[14:12] 
     .alu_fun   (alu_fun),
     .pcSource  (pcSource),
     .alu_srcA  (alu_srcA),
     .alu_srcB  (alu_srcB), 
     .rf_wr_sel (rf_wr_sel)   );
     
    ALU alu (
    .srcA       (ALU_srcA_Wire),
    .srcB       (ALU_srcB_Wire),
    .alu_fun    (alu_fun),
    .result     (ALU_Out_Wire)
    );
    
    mux_4t1_nb  #(.n(32)) srcB_ALU_Mux  (
     .SEL   (alu_srcB), 
     .D0    (rs2Wire), 
     .D1    (I_Immed_2_Branch), 
     .D2    (s_type), 
     .D3    (PC_2_Mux),
     .D_OUT (ALU_srcB_Wire) 
        );
        
    mux_4t1_nb  #(.n(32)) RegFile_Mux  (
     .SEL   (rf_wr_sel), 
     .D0    (PC_2_Mux + 4), 
     .D1    (), //csrReg?
     .D2    (Mem_2_RegMux), 
     .D3    (ALU_Out_Wire),
     .D_OUT (RegMux_2_RegFile) 
        );
        
    mux_2t1_nb  #(.n(32)) srcA_ALU_Mux  (
       .SEL   (alu_srcA), 
       .D0    (rs1Wire), 
       .D1    (u_type), 
       .D_OUT (ALU_srcA_Wire) );
    
endmodule
   
