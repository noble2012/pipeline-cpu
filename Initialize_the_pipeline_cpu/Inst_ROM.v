`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:09:27 05/15/2019 
// Design Name: 
// Module Name:    Inst_ROM 
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
module Inst_ROM(a,inst
    );
	 input [5:0] a;
	 output [31:0] inst;
	 wire [31:0] rom [0:63];
	 
	 assign rom[6'h00]=32'h00000000;		//0地址为空，从1地址开始执行；
	 assign rom[6'h01]=32'h38000866;		//store r6,0x0002(r3)  m5=0x00000006
	 assign rom[6'h02]=32'h34000481;		//load r1,0x0001(r4)   r1=0x00000006
	 assign rom[6'h03]=32'h00100421;    //add r1,r1,r1         r1=0x0000000c
	 assign rom[6'h04]=32'h08308401;    //sl1 r1,r1,5'h01      r1=0x00000018
	 assign rom[6'h05]=32'h08218401;    //sr1 r1,r1,5'h03      r1=0x00000003
	 assign rom[6'h06]=32'h14000429;		//addi r9,r1,0x0001    r9=0x00000004
	 assign rom[6'h07]=32'h3c000c81;		//beq r4,r1,6'h0b      offset=0x0003  相等转移到0bh处  
	 assign rom[6'h08]=32'h04200823;    //or r2,r1,r3          r2=0x00000003
	 assign rom[6'h09]=32'h044020e5;    //xor r8,r7,r5         r8=0x00000002  
	 assign rom[6'h0A]=32'h04100841;    //and r2,r2,r1         r2=0x00000003
	 assign rom[6'h0B]=32'h28000461;    //ori r1,r3,0x0001     r1=0x00000003
	 assign rom[6'h0C]=32'h14000901;    //addi r1,r8,0x02      r1=0x00000004  
	 assign rom[6'h0D]=32'h24000421;    //andi r1,r1,0x0001    r1=0x00000000  
	 assign rom[6'h0E]=32'h43ffec21;    //bne r1,r1,6'h08      流水线缓冲便于观察寄存器写入 
	 assign rom[6'h0F]=32'h3003fd27;    //xori r7,r9,0x00ff    r7=0x000000fb
	 assign rom[6'h10]=32'h28000461;    //ori r1,r3,0x0001     r1=0x00000003   
	 assign rom[6'h11]=32'h3c000c81;		//beq r4,r1,6'h0b      offset=0x0003  相等转移到0bh处
	 assign rom[6'h12]=32'h48000001;    //jump 0x0000001       无条件转移到01h处
	 assign rom[6'h13]=32'h00000000;     
	 assign rom[6'h14]=32'h00000000;          
	 assign rom[6'h15]=32'h00000000;          
	 assign rom[6'h16]=32'h00000000;        
	 assign rom[6'h17]=32'h00000000;
	 assign rom[6'h18]=32'h00000000;
	 assign rom[6'h19]=32'h00000000;
	 assign rom[6'h1A]=32'h00000000;
	 assign rom[6'h1B]=32'h00000000;
	 assign rom[6'h1C]=32'h00000000;
	 assign rom[6'h1D]=32'h00000000;
	 assign rom[6'h1E]=32'h00000000;
	 assign rom[6'h1F]=32'h00000000;
	 assign rom[6'h20]=32'h00000000;
	 assign rom[6'h21]=32'h00000000;
	 assign rom[6'h22]=32'h00000000;	 
	 assign rom[6'h23]=32'h00000000;
	 assign rom[6'h24]=32'h00000000;
	 assign rom[6'h25]=32'h00000000;
	 assign rom[6'h26]=32'h00000000;
	 assign rom[6'h27]=32'h00000000;
	 assign rom[6'h28]=32'h00000000;
	 assign rom[6'h29]=32'h00000000;
	 assign rom[6'h2A]=32'h00000000;
	 assign rom[6'h2B]=32'h00000000;
	 assign rom[6'h2C]=32'h00000000;
	 assign rom[6'h2D]=32'h00000000;
	 assign rom[6'h2E]=32'h00000000;
	 assign rom[6'h2F]=32'h00000000;
	 assign rom[6'h30]=32'h00000000;
	 assign rom[6'h31]=32'h00000000;
	 assign rom[6'h32]=32'h00000000;
	 assign rom[6'h33]=32'h00000000;
	 assign rom[6'h34]=32'h00000000;
	 assign rom[6'h35]=32'h00000000;
	 assign rom[6'h36]=32'h00000000;
	 assign rom[6'h37]=32'h00000000;
	 assign rom[6'h38]=32'h00000000;
	 assign rom[6'h39]=32'h00000000;
	 assign rom[6'h3A]=32'h00000000;
	 assign rom[6'h3B]=32'h00000000;
	 assign rom[6'h3C]=32'h00000000;
	 assign rom[6'h3D]=32'h00000000;
	 assign rom[6'h3E]=32'h00000000;
	 assign rom[6'h3F]=32'h00000000;
	 
	 assign inst=rom[a];
endmodule
