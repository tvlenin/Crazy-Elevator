`timescale 1ns / 1ps

module clock_sim(
	 input reseta,
	 input clk,
    output [3:0] timeout,
	 output DoneResetClock,
	 output [3:0] exit
    );

reg DoneReset;
reg [26:0]pulse;
reg [3:0]sec;
initial begin
	pulse = 0;
	DoneReset = 0;
	sec = 0;
end// initial

always@(posedge clk )begin
	if (reseta == 1) begin
		DoneReset = 1;
		pulse = 0;
		sec = 0;
	end
	//else if (pulse != 100000000)begin
	else if (pulse != 50000000)begin
	//else if (pulse != 1 )begin
		DoneReset = 0;
		pulse = pulse + 27'd1;
	end
	else begin
		DoneReset = 0;
		sec = sec + 4'd1;
		pulse = 0;
	end
	
end//always

assign timeout = sec;
assign exit = sec;
assign DoneResetClock = DoneReset;

endmodule
