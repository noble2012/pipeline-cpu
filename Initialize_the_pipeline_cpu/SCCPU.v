`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:33:59 05/14/2019 
// Design Name: 
// Module Name:    SCCPU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module SCCPU(Clock, Resetn, if_PC, if_Inst, exe_Alu_Result
    );
	 input Clock, Resetn;
	 output [31:0] if_PC, if_Inst, exe_Alu_Result;
	 
	 wire [1:0] pcsource;
	 wire [31:0] bpc, jpc, pc4; 
	 
	 wire [31:0] wdi;
	 
	 //IF_STAGE
	 
	 wire[31:0] if_pc4;
	 IF_STAGE stage1 (Clock, Resetn, pcsource, bpc, jpc, if_pc4, if_Inst, if_PC);
	 
	 //IF-ID register
	 wire [31:0] id_pc4,id_Inst;
	 instruction_register IF_ID_register(if_pc4,if_Inst,Clock, Resetn,id_pc4,id_Inst);
	 
	 //ID_STAGE
	 wire[4:0] id_rn,wb_rn;//id_rn用于记录该条指令的写入地址,wb_rn用于记录wb阶段的寄存器写回地址，用于修改regfile。
	 wire[2:0] id_aluc;
	 wire[31:0] id_ra,id_rb,id_imm;
	 wire id_m2reg,id_wmem,id_aluimm,id_shift,id_wreg;
	 wire wb_wreg;
	 ID_STAGE stage2 (id_pc4,id_Inst, wdi, Clock, Resetn, bpc, jpc, pcsource,
				   id_wreg,id_m2reg, id_wmem, id_aluc, id_aluimm, id_ra, id_rb, id_imm, id_shift, z,id_rn,wb_rn,wb_wreg);	 
	 
	 //ID-EXE register
	 wire[4:0] exe_rn;
	 wire[2:0] exe_aluc;
	 wire[31:0] exe_ra,exe_rb,exe_imm;
	 wire exe_m2reg,exe_wmem,exe_aluimm,exe_shift,exe_wreg;
	 
	 id_exe_register  ID_EXE_register(id_m2reg,id_wmem,id_aluc,id_aluimm,id_ra,id_rb,
    id_imm,id_shift,id_wreg,id_rn,Clock, Resetn,exe_m2reg,exe_wmem,exe_aluc,
    exe_aluimm,exe_ra,exe_rb,exe_imm,exe_shift,exe_wreg,exe_rn);
	 
	 //EXE_STAGE
	 
	 EXE_STAGE stage3 (exe_aluc, exe_aluimm, exe_ra, exe_rb, exe_imm, exe_shift, exe_Alu_Result, z);
	 
	 //EXE-MEM register
	 wire [31:0] mem_Alu_Result,mem_rb;
	 wire mem_wmem,mem_m2reg,mem_wreg;
	 wire [4:0] mem_rn;
	 
	 exe_mem_register 	EXE_MEM_register(exe_Alu_Result,exe_rb,exe_wmem,exe_m2reg,exe_wreg
      ,exe_rn,Clock, Resetn,mem_Alu_Result,mem_rb,mem_wmem,mem_m2reg,mem_wreg,mem_rn);
	 
	 //MEM_STAGE
	 wire [31:0] mem_mo;
	 MEM_STAGE stage4 (mem_wmem, mem_Alu_Result[4:0], mem_rb, Clock, mem_mo);		
	 
	 //MEM-WB register
	  wire [31:0] wb_Alu_Result,wb_mo;
	  wire wb_m2reg;
	 mem_wb_register MEM_WB_register(mem_Alu_Result,mem_m2reg,mem_wreg,mem_rn,mem_mo
    ,Clock, Resetn,wb_Alu_Result,wb_m2reg,wb_wreg,wb_rn,wb_mo);
	 
	 //WB_STAGE
	 WB_STAGE stage5 (wb_Alu_Result, wb_mo, wb_m2reg, wdi);


endmodule
