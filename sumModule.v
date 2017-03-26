`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:07:28 03/18/2017 
// Design Name: 
// Module Name:    sumModule 
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
module sumModule(
    input dig1,
    input dig2,
    output [7:0] sum 
    );
	 reg  reg_dig1;
	 reg [7:0] reg_sum;
	 always@(*)begin
	 reg_dig1 = dig1;
		if (reg_dig1 == 1)
			reg_sum = 8'b10101010;
		else
			reg_sum = 8'b11111111;
		
	 end
	 
	 
	 assign sum = reg_sum;
	//assign sum [7:0] = dig1 + dig2;
	 


endmodule
