`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:34:26 05/14/2019 
// Design Name: 
// Module Name:    IF_STAGE 
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
module IF_STAGE(clk,clrn,pcsource,bpc,jpc,pc4,inst, PC,stall
    );
	 input clk, clrn;
	 input [31:0] bpc,jpc;
	 input [1:0] pcsource;
	 input stall;
	 
	 output [31:0] pc4,inst;
	 output [31:0] PC;
	 
	 wire [31:0] pc;		
	 wire [31:0] npc;		//下一条指令地址
	 //wire [31:0] inst_org; //PC对应的指令内容
	 
 	 dff32 program_counter(npc,clk,clrn,pc,stall);   //利用32位的D触发器实现PC
	 add32 pc_plus4(pc,32'h4,pc4);//32位加法器，用来计算PC+4
	 mux32_4_1 next_pc(pc4,bpc,jpc,32'b0,pcsource,npc);//根据pcsource信号选择下一条指令的地址
	 Inst_ROM inst_mem(pc[7:2],inst); //指令存储器
	 
	 assign PC=pc;
	 //assign inst = (pcsource ==2'b01 || pcsource ==2'b10) ? 32'h0 : inst_org;
	 //若PCsource不为0，则废掉当前指令，即把指令内容置零
	 
endmodule
