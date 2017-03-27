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
	 input [1:0] testPActual,
	 input [1:0] testSolicitud,
	 input [1:0] Butt6,
	 input [1:0] Butt7,
	 output [7:0] sevenseg,
	 output [1:0] test_out,
	 output [1:0] Level,
	 output AbreCierra,
    output SubeBaja,
    output exit
    );
	 
wire [1:0] FloorRequestCable;
wire [1:0] FloorRequestCable2;
	 

up_down_button up_and_down (
    .btn5(Button5), 
    .switch_u_d(switch1),
	 .switchMSB(switch2),	 
	 .switchLSB(switch3),
	 .actualStage(FloorRequestCable),
    .up_or_down(FloorRequestCable2),
	 .exit(exit)
    );

// Instantiate the module Comparator
comparator instance_comparator (
    .DataA(Butt6), 
    .DataB(Butt7), 
    .equal(equal),
    .lower(lower),
    .greater(greater)
    );


// Instantiate the module
memory_manager instance_memory (
    .Floor(FloorRequestCable), 
    .Request(FloorRequestCable2), 
    .CurrentFloor(testPActual), 
    .UDIn(Button2), 
    .FloorRequest(testSolicitud), 
    .FRDelay(Button3), 
    .Delay(Button4), 
    .OCRequest(AbreCierra), //output
    .UDRequest(SubeBaja), //output
    .exit(exit)				//output
    );
	




endmodule
