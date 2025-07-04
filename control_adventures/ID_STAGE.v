`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:26:48 05/15/2019 
// Design Name: 
// Module Name:    ID_STAGE 
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
module ID_STAGE(pc4,inst,
              wdi,clk,clrn,bpc,jpc,pcsource,wreg,
				  m2reg,wmem,aluc,aluimm,a,b,imm,
				  shift,rn,wb_rn,wb_wreg
    );//单周期中rn与regfile直接相连，但是在多周期中rn要向后传递，所以定义了outputrn，并且
	 input [31:0] pc4,inst,wdi;		//pc4-PC值用于计算jpc；inst-读取的指令；wdi-向寄存器写入的数据
	 input clk,clrn;		//clk-时钟信号；clrn-复位信号；
	 input [4:0] wb_rn;//记录此阶段regfile的写回寄存器号
	 input  wb_wreg;//此阶段控制寄存器写使能的控制信号
	 output [31:0] bpc,jpc,a,b,imm;		//bpc-branch_pc；jpc-jump_pc；a-寄存器操作数a；b-寄存器操作数b；imm-立即数操作数
	 output [2:0] aluc;		//ALU控制信号
	 output [1:0] pcsource;		//下一条指令地址选择
	 output m2reg,wmem,aluimm,shift,wreg;		
	 
	 output [4:0] rn;		//记录当前指令的寄存器号,用于传递到后续的阶段
	 
	 wire rsrtequ;
	 wire [5:0] op,func;
	 wire [4:0] rs,rt,rd;
	 wire [31:0] qa,qb,br_offset;
	 wire [15:0] ext16;
	 wire regrt,sext,e;

	 assign func=inst[25:20];  
	 assign op=inst[31:26];
	 assign rs=inst[9:5];
	 assign rt=inst[4:0];
	 assign rd=inst[14:10];
	 Control_Unit cu(rsrtequ,func,                          //控制部件
	             op,wreg,m2reg,wmem,aluc,regrt,aluimm,
					 sext,shift);
			 
    Regfile rf (rs,rt,wdi,wb_rn,wb_wreg,clk,clrn,qa,qb);//寄存器堆，有32个32位的寄存器，0号寄存器恒为0
	 mux5_2_1 des_reg_num (rd,rt,regrt,rn); //选择目的寄存器是来自于rd,还是rt

	 assign a=qa;
	 assign b=qb;
	 
	  //控制冒险解决方案
	 assign rsrtequ = ~|( a ^ b );
							 //判断两操作数是否相等
	 assign pcsource = (inst[31:26] == 6'b001111 && rsrtequ) || (inst[31:26] == 6'b010000 && ~rsrtequ) ? 2'b01: 
							 (inst[31:26] == 6'b010010) ? 2'b10 : 2'b00;
							 //branch指令且满足条件，则pcsource为01，jump指令则pcsource为10，顺序执行则pcsource为00

	 assign e=sext&inst[25];//符号拓展或0拓展
	 assign ext16={16{e}};//符号拓展
	 assign imm={ext16,inst[25:10]};		//将立即数进行符号拓展

	 assign br_offset={imm[29:0],2'b00};		//计算偏移地址
	 add32 br_addr (pc4,br_offset,bpc);		//beq,bne指令的目标地址的计算
	 assign jpc={pc4[31:28],inst[25:0],2'b00};		//jump指令的目标地址的计算
	 
endmodule
