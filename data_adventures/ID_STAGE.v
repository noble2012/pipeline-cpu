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
              wdi,clk,clrn,bpc,jpc,pcsource,id_wreg,
				  m2reg,wmem,aluc,aluimm,a,b,imm,
				  shift,rsrtequ,id_rn,wb_rn,wb_wreg,
				  exe_result,mem_result,mem_mo,  //exe阶段的结果，mem阶段的ALU结果，mem阶段的访存结果（Forwarding）
				  exe_wreg,exe_rn,exe_m2reg,     //exe阶段的指令写寄存器信号，目的寄存器地址，数据选择信号(Forwarding)
				  mem_wreg,mem_rn,mem_m2reg,     //mem阶段的指令写寄存器信号，目的寄存器地址，数据选择信号(Forwarding)
				  stall,adep,bdep                //输出stall信号，告知IF阶段，adep和bdep作为数据源选择信号
    );//单周期中rn与regfile直接相连，但是在多周期中rn要向后传递，所以定义了outputrn，并且
	 input [31:0] pc4,inst,wdi;		//pc4-PC值用于计算jpc；inst-读取的指令；wdi-向寄存器写入的数据
	 input clk,clrn;		//clk-时钟信号；clrn-复位信号；
	 input rsrtequ;	 //branch控制信号
	 input [4:0] wb_rn;//记录此阶段regfile的写回寄存器号
	 input  wb_wreg;//此阶段控制寄存器写使能的控制信号
	 input [31:0] exe_result,mem_result,mem_mo;   //exe阶段的结果，mem阶段的ALU结果，mem阶段的访存结果作为选择数据源
	 input [4:0] exe_rn,mem_rn;
	 input exe_wreg,exe_m2reg,mem_wreg,mem_m2reg; //检测是否EXE阶段和MEM阶段的指令与当前指令存在数据冲突
	 
	 output [31:0] bpc,jpc,a,b,imm;		//bpc-branch_pc；jpc-jump_pc；a-寄存器操作数a；b-寄存器操作数b；imm-立即数操作数
	 output [2:0] aluc;		//ALU控制信号
	 output [1:0] pcsource;		//下一条指令地址选择
	 output m2reg,wmem,aluimm,shift,id_wreg;		
	 
	 output [4:0] id_rn;		//记录当前指令的寄存器号,用于传递到后续的阶段
	 output stall; 
	 output [1:0] adep,bdep;            //数据源选择信号
	 
	 wire wreg;
	 wire [5:0] op,func;
	 wire [4:0] rs,rt,rd,rn;
	 wire [31:0] qa,qb,br_offset;
	 wire [15:0] ext16;
	 wire regrt,sext,e,wmem_org;//regrt选择写回寄存器来自rd还是rt
	 assign func=inst[25:20];  
	 assign op=inst[31:26];
	 assign rs=inst[9:5];
	 assign rt=inst[4:0];
	 assign rd=inst[14:10];
	



    assign adep = ((exe_rn != 5'b0) & exe_wreg & (exe_rn == rs) &  ~exe_m2reg) ? 2'b01 :               ((mem_rn != 5'b0) & mem_wreg & (mem_rn == rs) & ~mem_m2reg) ? 2'b10 :                   ((mem_rn != 5'b0) & mem_wreg & (mem_rn == rs) &  mem_m2reg) ? 2'b11 : 2'b00;  
					// 2'b01 选exe_result,2'b10 选mem_result,2'b11 选mem_mo(load),2b'00 直接选regfile输出
	 assign bdep = ((exe_rn != 5'b0) & exe_wreg & (exe_rn == rt) &  ~exe_m2reg) ? 2'b01 :               ((mem_rn != 5'b0) & mem_wreg & (mem_rn == rt) & ~mem_m2reg) ? 2'b10 :                   ((mem_rn != 5'b0) & mem_wreg & (mem_rn == rt) &  mem_m2reg) ? 2'b11 : 2'b00;   
					// 2'b01 选exe_result,2'b10 选mem_result,2'b11 选mem_mo(load),2b'00 直接选regfile输出
	 
	 assign stall = (exe_rn !=0)&((rs == exe_rn) | (rt == exe_rn)& ~regrt) & (exe_wreg&exe_m2reg);
					//若EXE级指令与当前指令存在冲突，且是load指令则需要暂停流水线
					
					
					
	 mux32_4_1 fwa_mux(qa,exe_result,mem_result,mem_mo,adep,a);//确定a
	 mux32_4_1 fwb_mux(qb,exe_result,mem_result,mem_mo,bdep,b);//确定b
	 
	 Control_Unit cu(rsrtequ,func,                          //控制部件
	             op,wreg,m2reg,wmem_org,aluc,regrt,aluimm,
					 sext,pcsource,shift);
	
	 assign id_wreg = ~stall & wreg;                           //若流水线暂停则当前指令作废
	 assign wmem = ~stall & wmem_org;
	 
    Regfile rf (rs,rt,wdi,wb_rn,wb_wreg,clk,clrn,qa,qb);//寄存器堆，有32个32位的寄存器，0号寄存器恒为0
	 
	 
	 mux5_2_1 des_reg_num (rd,rt,regrt,rn); //选择目的寄存器是来自于rd,还是rt
	 assign e=sext&inst[25];//符号拓展或0拓展
	 assign ext16={16{e}};//符号拓展
	 assign imm={ext16,inst[25:10]};		//将立即数进行符号拓展

	 assign br_offset={imm[29:0],2'b00};		//计算偏移地址
	 add32 br_addr (pc4,br_offset,bpc);		//beq,bne指令的目标地址的计算
	 assign jpc={pc4[31:28],inst[25:0],2'b00};		//jump指令的目标地址的计算
	 assign id_rn = rn;
endmodule
