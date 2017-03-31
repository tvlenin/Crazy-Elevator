
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:51:08 03/14/2017 
// Design Name: 
// Module Name:    Interface 
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
module Interface(
	 input clk,
	 input enable,
	 input reset,
	 input switch1,
	 input switch2,
	 input switch3,
    input Button1,
    input Button2,
    input Button3,
    input Button4,
    input Button5,
	 input Button6,
    input Button7,
    
	 output [7:0] sevenseg,
	 output [1:0] test_out,
	 output [1:0] Level,
	 output [3:0] reloj,
	 output exit
    );
	 
	 
wire wOCRequest;
wire wUDRequest;
wire wFRDelay;
wire wDelay;
wire [1:0] wSolicitudPiso;
wire [1:0] wPisoActual;
wire wSubiendoBajando;

wire wStop;
wire wNoStop;



wire [1:0]inte_1;
wire [1:0]inte_2;

wire reset_wire;
wire [3:0] actual_clock_wire;

wire [2:0] next_stage;
//hola

 up_down_button up_and_down (
	 .clk(Level),
    .btn5(Button5), 
    .switch_u_d(switch1),
	 .switchMSB(switch2),	 
	 .switchLSB(switch3),
	 .actualStage(inte_1),
    .up_or_down(inte_2)
    );

memory_manager instance_name (
    .Floor(inte_1), 
    .Request(inte_2), 
    .CurrentFloor(wPisoActual), 
    .UDIn(wSubiendoBajando), 
    .FloorRequest(wSolicitudPiso), 
    .FRDelay(wFRDelay), 
    .Delay(wDelay), 
    .OCRequest(wOCRequest), 
    .UDRequest(wUDRequest), 
    .exit(exit),
	 .Stop(wStop),
	 .NoStopRequest(wNoStop)
    );


F_S_M instance_FSM (
    .clk(clk), 
    .next_stage(next_stage), 
    .reset(reset), 
    .OC_Request(wOCRequest),
	 .UD_Request(wUDRequest),
    .actual_clock(actual_clock_wire), 
    .reset_clock(reset_wire), 
    .out(Level),
    .FR_Delay(wFRDelay), 
    .Solicitud_stage(wSolicitudPiso), 
    .Delay(wDelay), 
    .Actual_Stage(wPisoActual) , 
    .UD_Answer(wSubiendoBajando),
	 .STOP(wStop),
	 .NO_STOP(wNoStop)
    );
	 
	 
	 
	 

clock_sim instance_clock(
    .reseta(reset_wire), 
    .clk(clk), 
    .timeout(actual_clock_wire),
	 .exit(reloj)
    );

next_stage instance_stage(
    .btn1(Button1), 
    .btn2(Button2), 
    .btn3(Button3), 
    .btn4(Button4), 
    .n_stage(next_stage),
	 .exit(exit)
    );









	




endmodule