`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:27:13 05/15/2025 
// Design Name: 
// Module Name:    instruction_register 
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
module instruction_register(if_pc4,if_inst,clk,clrn,id_pc4,id_inst,stall
    );
	 input [31:0] if_pc4,if_inst;
	 input clk,clrn;
	 input stall;
	 output [31:0] id_pc4,id_inst;
	 
	 reg [31:0] id_pc4,id_inst;
	 
	 always @(posedge clk or negedge clrn)
		 if(clrn == 0)
			 begin
				 id_pc4<=0;
				 id_inst<=0;
			 end
		 else
			 begin
				if(stall==0)
					begin
						id_pc4<=if_pc4;
						id_inst<=if_inst;
					end
			 end

endmodule