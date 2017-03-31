`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:23:58 03/26/2017 
// Design Name: 
// Module Name:    clock_sim 
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

module clock_sim(
	 input reseta,
	 input clk,
    output [3:0] timeout,
	 output [3:0] exit
    );

reg [28:0]pulse;
reg [3:0]sec;
initial begin
	pulse = 0;
	sec = 0;
end// initial

always@(posedge clk )begin
	if (reseta == 1) begin
		pulse = 0;
		sec = 0;
	end
	else if (pulse != 1 )
		pulse = pulse +1;
	else begin
		sec = sec + 1;
		pulse = 0;
	end
	
end//always

assign timeout = sec;
assign exit = sec;

endmodule
