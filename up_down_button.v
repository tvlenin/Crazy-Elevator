`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:03:55 03/18/2017 
// Design Name: 
// Module Name:    up_down_button 
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
module up_down_button(
    input btn5,
	 input switchLSB,
	 input switchMSB,
    input switch_u_d,
    output [1:0] up_or_down,
	 output [1:0] actualStage,
	 output exit
    );
	 
	 
	 reg reg_btn5;
	 reg reg_switch;
	 reg reg_switchLSB;
	 reg reg_switchMSB;
	 reg [1:0] reg_out;
	 reg [1:0] reg_actual_stage;
	 always@(*)begin
		reg_btn5 = btn5;
		reg_switch = switch_u_d;
		reg_switchLSB = switchLSB;
		reg_switchMSB = switchMSB;
		if ((reg_btn5 == 1) & (reg_switch == 1)) //Condicion para subir 11
			begin
				reg_actual_stage[1] = reg_switchMSB;///////
				reg_actual_stage[0] = reg_switchLSB;
				reg_out[1] = 1;
				reg_out[0] = 1;
			end
		else if ((reg_btn5 == 1) & (reg_switch == 0))//Condicion para bajar 01
			begin
				reg_actual_stage[1] = reg_switchMSB;///////
				reg_actual_stage[0] = reg_switchLSB;
				reg_out[1] = 0;
				reg_out[0] = 1;
			end
		else 
			begin // Permanece donde esta 00
				reg_out[1] = 0;
				reg_out[0] = 0;
			end
	end
	 
	 
	 assign up_or_down = reg_out;
	 assign actualStage = reg_actual_stage;


endmodule
