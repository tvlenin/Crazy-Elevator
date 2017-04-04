
`timescale 1ns / 1ps

module Interface(
	 input clk,
	 input reset,
	 input switch1,
	 input switch2,
	 input switch3,
    input Button1,
    input Button2,
    input Button3,
    input Button4,
    input Button5,
	 output [3:0] seg_selector,
	 output [7:0] sevenseg,
	 output [3:0] outRegDW,
	 output [3:0] outRegUP
    );

wire w1DoneNSDelay;
wire w2DoneNSDelay;
wire wDoneFRDelay;
wire wDoneResetClock;
wire wDoneDelay;
wire wOCRequest;
wire wUDRequest;
wire wFRDelay;
wire wDelay;
wire [1:0] wPisoActual;
wire wSubiendoBajando;
wire wStop;
wire wNoStop;
wire [1:0]inte_1;
wire [1:0]inte_2;
wire [3:0] actual_clock_wire;
wire [2:0] next_stage;
wire reset_wire;

up_down_button up_and_down (
    .btn5(Button5), 
    .switch_u_d(switch1),
	 .switchMSB(switch2),	 
	 .switchLSB(switch3),
	 .actualStage(inte_1),
    .up_or_down(inte_2)
    );

memory_manager instance_name (
	 .clk(clk), 
	 .reset(reset),
    .Floor(inte_1), 
    .Request(inte_2), 
    .CurrentFloor(wPisoActual), 
    .UDIn(wSubiendoBajando),
	 .FloorRequest(next_stage), 
    .FRDelay(wFRDelay), 
    .Delay(wDelay), 
    .OCRequest(wOCRequest), 
    .UDRequest(wUDRequest), 
	 .Stop(wStop),
	 .NoStopRequest(wNoStop),
	 .DoneDelay(wDoneDelay),
	 .DoneFRDelay(wDoneFRDelay),
	 .NextStageDelay(w1DoneNSDelay),//Input
	 .DoneNextStageDelay(w2DoneNSDelay),//Output
	 .TestStopsUP(outRegUP),
	 .TestStopsDW(outRegDW)
	 //.TestStopsDW()
    );


F_S_M instance_FSM (
    .clk(clk), 
    .next_stage(next_stage), 
    .reset(reset), 
    .OC_Request(wOCRequest),
	 .UD_Request(wUDRequest),
    .actual_clock(actual_clock_wire), 
    .reset_clock(reset_wire),
    .FR_Delay(wFRDelay),
    .Delay(wDelay), 
    .Actual_Stage(wPisoActual) , 
    .UD_Answer(wSubiendoBajando),
	 .STOP(wStop),
	 .NO_STOP(wNoStop),
	 .DoneDelay(wDoneDelay),
	 .DoneFRDelay(wDoneFRDelay),
	 .DoneResetClock(wDoneResetClock)
    );
	 

clock_sim instance_clock(
    .reseta(reset_wire), 
    .clk(clk), 
    .timeout(actual_clock_wire),
	 .DoneResetClock(wDoneResetClock)
    );

next_stage instance_stage(
	 .clk(clk),
    .btn1(Button1), 
    .btn2(Button2), 
    .btn3(Button3), 
    .btn4(Button4), 
    .n_stage(next_stage),
	 .DoneNextStage(w2DoneNSDelay),//input
	 .NextStageDelay(w1DoneNSDelay)//ouput
    );

segment_controller instance_segment (
    .clk(clk), 
    .currentFloor(wPisoActual), 
    .UD_state(wSubiendoBajando), 
    .OC_state(wOCRequest), 
    .seg_selector(seg_selector), 
    .segments(sevenseg),
	 .Stop(wStop),
	 .pClockTime(actual_clock_wire[0])
    );

endmodule