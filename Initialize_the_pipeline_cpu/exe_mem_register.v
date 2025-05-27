`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:28:15 05/15/2025 
// Design Name: 
// Module Name:    exe_mem_register 
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
module exe_mem_register(exe_Alu_Result,exe_rb,exe_wmem,exe_m2reg,exe_wreg
,exe_rn,clk,clrn,mem_Alu_Result,mem_rb,mem_wmem,mem_m2reg,mem_wreg,mem_rn
    );
input [31:0] exe_Alu_Result,exe_rb;
input [4:0] exe_rn;
input exe_wmem,exe_m2reg,exe_wreg;
input clrn,clk;
output [31:0] mem_Alu_Result,mem_rb;
output [4:0] mem_rn;
output mem_wmem,mem_m2reg,mem_wreg;
reg [31:0] mem_Alu_Result,mem_rb;
reg [4:0]mem_rn;
reg mem_wmem,mem_m2reg,mem_wreg;
always @(posedge clk or negedge clrn)
		 if(clrn == 0)
			 begin
				 mem_Alu_Result<=0;
				 mem_rb<=0;
				 mem_rn<=0;
				 mem_wmem<=0;
				 mem_m2reg<=0;
				 mem_wreg<=0;
			 end
		 else
			begin
			    mem_Alu_Result<=exe_Alu_Result;
				 mem_rb<=exe_rb;
				 mem_rn<=exe_rn;
				 mem_wmem<=exe_wmem;
				 mem_m2reg<=exe_m2reg;
				 mem_wreg<=exe_wreg;
			end
endmodule