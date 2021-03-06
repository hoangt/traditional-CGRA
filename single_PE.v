`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:56:13 04/30/2013 
// Design Name: 
// Module Name:    single_PE 
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
module single_PE1(	CLK, data, start, ld_write, edge1_in, edge3_in , bus_in, edge1_p_in, edge3_p_in , bus_p_in,
	edge1_out, edge3_out , bus_out, edge1_p_out, edge3_p_out , bus_p_out 
//, PC, out  //PC,out will remove
    );
	 
	parameter width = 120;
	//input [15:0] PC;
	input CLK, start, ld_write;
	input [width:0] data;
	input [31:0] edge1_in, edge3_in, bus_in;
	input [3:0] edge1_p_in, edge3_p_in, bus_p_in;
	
	output [31:0] edge1_out, edge3_out, bus_out;
	output [3:0] edge1_p_out, edge3_p_out, bus_p_out;
	
	wire  [width:0] cache_buffer, buffer_out;
	wire 	[15:0] CP;
	
	
	
	//  Reg
	wire [8:0] control_in, control_out;
	wire [5:0] control_put_in, control_put_out, control_reg_1, control_reg_2, control_send;
	wire [31:0] reg2fu_1, reg2fu_2;
	wire [3:0] control_pe2fu_1, control_pe2fu_2;
	wire ld;
	//
	
	// Pred_reg
	wire [8:0] control_in_p, control_out_p;
	wire [5:0] control_put_in_p, control_put_out_p, control_pred, control_send_p;
	wire [3:0] pred2fu;
	wire [3:0] control_pe2fu_p;
	//
	
	//FU
	wire write_back, write_back_p, pred_control;
	wire [7:0] op_mode_1;
	wire [31:0] outvalue;
	wire [3:0] outpred;
	wire [7:0] imm_val;
	wire imm;
	//
	
	//output [width:0] out;
	
	PE_context_cache i_PE_cc (data,cache_buffer,start,CLK,CP);
	
	buffer i_buffer(CLK, cache_buffer, control_in, control_put_in, control_put_out, control_reg_1, control_reg_2,
					control_out, control_send, control_in_p, control_put_in_p, control_put_out_p, control_pred,
					control_out_p, control_send_p, pred_control, op_mode_1 , imm, imm_val,
					control_pe2fu_1, control_pe2fu_2, control_pe2fu_p, ld);
					
	context_pointer i_CP(CLK, start, CP);
	
	PE_reg1 i_PE_reg1 (edge1_in, edge3_in , bus_in, edge1_out, edge3_out , bus_out,
							 write_back, control_in, control_put_in, outvalue, control_put_out, 
							 control_reg_1, control_reg_2, reg2fu_1, reg2fu_2, CLK , 
							 control_out, control_send, control_pe2fu_1, control_pe2fu_2, ld, ld_write);
	
	pred_reg1 i_pred_reg1(edge1_p_in, edge3_p_in, bus_p_in, edge1_p_out, edge3_p_out, bus_p_out,
								 write_back_p, control_in_p, control_put_in_p, outpred, 
								 control_put_out_p, control_pred, pred2fu, CLK , 
								 control_out_p, control_send_p, control_pe2fu_p);
	
	FU i_FU( pred_control, pred2fu, op_mode_1, reg2fu_1, reg2fu_2, outvalue, outpred, 
				write_back, write_back_p, imm, imm_val );
	
endmodule
