`timescale 1ns / 1ps

module next_stage(
	 input clk,
    input btn1,
    input btn2,
    input btn3,
    input btn4,
	 input DoneNextStage,
	 output NextStageDelay,
    output [2:0] n_stage,
	 output exit
    );
	
	reg reg_NextStageDelay;
	reg [2:0]reg_stage;
	 always@(posedge clk)begin
		if(DoneNextStage == 1)begin
			reg_NextStageDelay = 1;
			reg_stage = 0;
		end
		if(btn1 == 1)begin
			reg_stage = 3'd4;
			reg_NextStageDelay = 0;
		end
		else if(btn2 == 1)begin
			reg_stage = 3'd5;
			reg_NextStageDelay = 0;
		end
		else if(btn3 == 1)begin
			reg_stage = 3'd6;
			reg_NextStageDelay = 0;
		end
		else if(btn4 == 1)begin
			reg_stage = 3'd7;
			reg_NextStageDelay = 0;
		end
	 end

assign NextStageDelay = reg_NextStageDelay;
assign n_stage = reg_stage;
endmodule
