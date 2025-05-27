`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:28:55 05/15/2025 
// Design Name: 
// Module Name:    mem_wb_register 
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
module mem_wb_register(mem_Alu_Result,mem_m2reg,mem_wreg,mem_rn,mem_mo
    ,clk,clrn,wb_Alu_Result,wb_m2reg,wb_wreg,wb_rn,wb_mo);
input [31:0] mem_Alu_Result,mem_mo;
input mem_m2reg,mem_wreg;
input [4:0] mem_rn;
input clrn,clk;
output [31:0] wb_Alu_Result,wb_mo;
output [4:0]wb_rn;
output wb_m2reg,wb_wreg;
reg [31:0] wb_Alu_Result,wb_mo;
reg [4:0]wb_rn;
reg wb_m2reg,wb_wreg;
always @(posedge clk or negedge clrn)
		 if(clrn == 0)
			 begin
				 wb_Alu_Result<=0;
				 wb_mo<=0;
				 wb_rn<=0;
				 wb_m2reg<=0;
				 wb_wreg<=0;
			 end
		 else
			begin
			    wb_Alu_Result<=mem_Alu_Result;
				 wb_mo<=mem_mo;
				 wb_rn<=mem_rn;
				 wb_m2reg<=mem_m2reg;
				 wb_wreg<=mem_wreg;
			end
endmodule
