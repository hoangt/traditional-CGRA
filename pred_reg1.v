`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:10:17 08/18/2013 
// Design Name: 
// Module Name:    pred_reg1 
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
module pred_reg1( edge1_p_in, edge3_p_in, bus_p_in, edge1_p_out, edge3_p_out, bus_p_out, write_back_p, control_in_p, control_put_in_p, out2pred, control_put_out_p,
		control_pred, pred_out, CLK, control_out_p, control_send_p, control_pe2fu_p
    );
	 
	 input CLK , write_back_p;
	 
	 input [3:0] out2pred;
	 input [8:0] control_in_p, control_out_p;
	 input [5:0] control_put_in_p, control_put_out_p, control_pred, control_send_p;
	 output [3:0] pred_out;
	 
	 input [3:0] control_pe2fu_p;
	 
	 input [3:0] edge1_p_in, edge3_p_in, bus_p_in;
	 output [3:0] edge1_p_out, edge3_p_out, bus_p_out;
	 
	 reg [3:0] pred_reg_file [63:0];
	 wire [3:0] mux2pred, demux_out_p;
	 
	 // counter
	 //reg [3:0] counter;
	 //
	 
	 
	 
	 //////////// MUX
	 assign mux2pred = (control_in_p == 9'b000000001 )? edge1_p_in :
							 (control_in_p == 9'b000000010 )? edge3_p_in :
							 (control_in_p == 9'b000010000 )? bus_p_in	: 0;
	///////////////////////////////////////////////////////
	
	assign pred_out = (control_pe2fu_p == 4'b0001)? edge1_p_in:
							(control_pe2fu_p == 4'b0010)? edge3_p_in:
							(control_pe2fu_p == 4'b1000)?	bus_p_in:
							(control_pe2fu_p == 4'b0000)? pred_reg_file [control_pred] : 0;
	
	
	always @ (negedge CLK)
	begin
		//別人PE送進來的pred
					pred_reg_file [control_put_in_p] <= mux2pred;
		//FU算完送進來的pred
					if(write_back_p == 1'b1)
					pred_reg_file[control_put_out_p] <=  out2pred;
					else
					pred_reg_file[control_put_out_p] <= pred_reg_file[control_put_out_p];
					
					//demux_out_p = pred_reg_file[control_send_p];
					
	end
	assign demux_out_p = pred_reg_file[control_send_p];
	
	
	/////// DEMUX////////////////////
	assign edge1_p_out = (control_out_p[0] == 1 )? demux_out_p : 0;
	assign edge3_p_out = (control_out_p[1] == 1 )? demux_out_p : 0;
	assign bus_p_out = 	(control_out_p[4] == 1 )? demux_out_p : 0;
	
	//////////////////////////////////////////////////////////////////////
	
	
endmodule
