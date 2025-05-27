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
module SCCPU(Clock, Resetn, if_PC, if_Inst, exe_Alu_Result,stall
    );
	 //wb阶段的输出数据wdi,控制信号wb_m2reg,输出地址wb_rn
	 input Clock, Resetn;
	 wire [1:0] pcsource;//pcsource-下一条指令地址的选择信号
	 wire [31:0] bpc, jpc, pc4; 
	 wire [31:0] wdi;
	 
	 //数据冒险控制信号
	 output stall;
	 wire [1:0] adep,bdep;
	 
	 //IF_STAGE_SIGNAL
	 output [31:0] if_PC, if_Inst, exe_Alu_Result;
	 wire [31:0] if_pc4;
	 
	 //ID_STAGE_SIGNAL
	 wire [31:0] id_pc4,id_Inst;
	 wire[4:0] id_rn;//id_rn用于记录该条指令的写入地址。
	 wire[2:0] id_aluc;
	 wire[31:0] id_ra,id_rb,id_imm;
	 wire id_m2reg,id_wmem,id_aluimm,id_shift,id_wreg;
	 
	 //EXE_STAGE_SIGNAL
	 wire[4:0] exe_rn;
	 wire[2:0] exe_aluc;
	 wire[31:0] exe_ra,exe_rb,exe_imm;
	 wire exe_m2reg,exe_wmem,exe_aluimm,exe_shift,exe_wreg,z;//z-id阶段输出的零信号
	 
	 //MEM_STAGE_SIGNAL
	 wire [31:0] mem_Alu_Result,mem_rb;
	 wire mem_wmem,mem_m2reg,mem_wreg;
	 wire [4:0] mem_rn;
	 wire [31:0] mem_mo;
	 
	 //WB_STAGE_SIGNAL,WB阶段的输出数据wdi,控制信号wb_m2reg,输出地址wb_rn
	  wire [31:0] wb_Alu_Result,wb_mo;
	  wire wb_m2reg,wb_wreg;
	  wire [4:0] wb_rn;//wb_rn用于记录wb阶段的寄存器写回地址，用于修改regfile。
	 
	 //IF_STAGE
	 IF_STAGE stage1 (Clock, Resetn, pcsource, bpc, jpc, if_pc4, if_Inst, if_PC,stall);
	 
	 //添加IF和ID流水段间的寄存器r1,传递pc4,inst信号
	 instruction_register IF_ID_register(if_pc4,if_Inst,Clock, Resetn,id_pc4,id_Inst,stall);
	 
	 //ID_STAGE
	 ID_STAGE stage2 (id_pc4,id_Inst, wdi, ~Clock, Resetn, bpc, jpc, pcsource,
				   id_wreg,id_m2reg, id_wmem, id_aluc, id_aluimm, id_ra, id_rb, id_imm, id_shift, 
					id_rn,wb_rn,wb_wreg,exe_Alu_Result,mem_Alu_Result,mem_mo,exe_wreg,exe_rn,exe_m2reg,
					 mem_wreg,mem_rn,mem_m2reg,stall,adep,bdep );	 
	 
	 //添加ID和EXE流水段间的寄存器r2,传递m2reg,wmem,aluc,aluimm,ra,rb,imm,shift,wreg,rn信号
	 id_exe_register  ID_EXE_register(id_m2reg,id_wmem,id_aluc,id_aluimm,id_ra,id_rb,
    id_imm,id_shift,id_wreg,id_rn,Clock, Resetn,exe_m2reg,exe_wmem,exe_aluc,
    exe_aluimm,exe_ra,exe_rb,exe_imm,exe_shift,exe_wreg,exe_rn);
	 
	 //EXE_STAGE
	 EXE_STAGE stage3 (exe_aluc, exe_aluimm, exe_ra, exe_rb, exe_imm, exe_shift, exe_Alu_Result, z);
	 
	//添加EXE和MEM流水段间的寄存器r3,传递result,rb,wmem,m2reg,wreg,rn信号
	 exe_mem_register 	EXE_MEM_register(exe_Alu_Result,exe_rb,exe_wmem,exe_m2reg,exe_wreg
      ,exe_rn,Clock, Resetn,mem_Alu_Result,mem_rb,mem_wmem,mem_m2reg,mem_wreg,mem_rn);
	 
	 //MEM_STAGE
	 MEM_STAGE stage4 (mem_wmem, mem_Alu_Result[4:0], mem_rb, Clock, mem_mo);		
	 
	 //添加MEM和WB流水段间的寄存器r4,传递result,mo,m2reg,wreg,rn信号
	 mem_wb_register MEM_WB_register(mem_Alu_Result,mem_m2reg,mem_wreg,mem_rn,mem_mo
    ,Clock, Resetn,wb_Alu_Result,wb_m2reg,wb_wreg,wb_rn,wb_mo);
	 
	 //WB_STAGE
	 WB_STAGE stage5 (wb_Alu_Result, wb_mo, wb_m2reg, wdi);


endmodule
