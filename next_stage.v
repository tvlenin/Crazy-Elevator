`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:20:43 03/26/2017 
// Design Name: 
// Module Name:    next_stage 
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
module next_stage(
    input btn1,
    input btn2,
    input btn3,
    input btn4,
    output [2:0] n_stage,
	 output exit
    );
	 
	reg [2:0]reg_stage;
	 always@(*)begin
		if(btn1 == 1)
			reg_stage <= 3'b100;
		else if(btn2 == 1)
			reg_stage <= 3'b101;
		else if(btn3 == 1)
			reg_stage <= 3'b110;
		else if(btn4 == 1)
			reg_stage <= 3'b111;
		else
			reg_stage <= 3'b000;
	 end

assign n_stage = reg_stage;
endmodule
