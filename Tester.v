`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:41:41 03/18/2017
// Design Name:   Interface
// Module Name:   /home/tvlenin/Projects/XILINX/Prueba2/Tester.v
// Project Name:  Prueba2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Interface
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Tester;

	// Inputs
	reg clk;
	reg enable;
	reg reset;
	reg switch1;
	reg switch2;
	reg switch3;
	reg Button1;
	reg Button2;
	reg Button3;
	reg Button4;
	reg Button5;
	reg Button6;
	reg Button7;
	

	// Outputs
	wire [1:0] test_out;
	wire [7:0] sevenseg;
	wire [1:0] Level;
	wire [3:0] reloj;

	// Instantiate the Unit Under Test (UUT)
	Interface uut (
		.exit(exit),
		.clk(clk), 
		.enable(enable), 
		.reset(reset), 
		.switch1(switch1), 
		.switch2(switch2), 
		.switch3(switch3), 
		.Button1(Button1), 
		.Button2(Button2), 
		.Button3(Button3), 
		.Button4(Button4), 
		.Button5(Button5), 
		.Button6(Button6), 
		.Button7(Button7), 
		.test_out(test_out),
		.sevenseg(sevenseg),
		.Level(Level),
		.reloj(reloj)
	);
	
	//always 
		always #1clk = ~clk;  // 100 MHz
	initial begin
	
		// Initialize Inputs
		clk = 0;
		enable = 0;
		reset = 0;
		switch1 = 0;
		switch2 = 0;
		switch3 = 0;
		Button1 = 0;
		Button2 = 0;
		Button3 = 0;
		Button4 = 0;
		Button5 = 0;
		Button6 = 0;
		Button7 = 0;
		//test_out = 0;

		// Wait 100 ns for global reset to finish
		/*#200;
		reset=1;
		#2;
		reset=0;
		#30;
		Button6 = 1;
		#5
		Button4 = 1;
		#2
		Button4 = 0;
		#3;
		Button6 = 0;
		////////////////solicitud para subir del segundo al cuarto
		#50;
		Button6 = 1;
		#5
		Button4 = 1;
		#2
		Button4 = 0;
		#3;
		Button6 = 0;
		////////////////solicitud para subir del tercer al cuarto
		#41;
		Button6 = 1;
		#5
		Button4 = 1;
		#5
		Button4 = 0;
		#3;
		Button6 = 0;
		////////////////solicitud para bajar del cuarto al tercero  
		#41;
		Button6 = 1;
		#5
		Button1 = 1;
		#5
		Button1  = 0;
		#3;
		Button6 = 0;
		#41;////////////////solicitud para bajar del tercero al segundo
		Button6 = 1;
		#5
		Button1 = 1;
		#5
		Button1  = 0;
		#3;
		Button6 = 0;
		#41;////////////////solicitud para bajar del segundo al primer piso
		Button6 = 1;
		#5
		Button1 = 1;
		#5
		Button1  = 0;
		#3;
		Button6 = 0;
		#45;
		Button6 = 1;
	*/
	#2
	reset = 1;
	#3
	reset = 0;
	#5;
	switch1 = 1;
	Button5 = 1;
	switch2 = 1;
	switch3 = 1;
	#3
	Button5 = 0;
	#225;
	switch1 = 0;
	Button5 = 1;
	switch2 = 1;
	switch3 = 0;
	#3
	Button5 = 0;
	#80;
	switch1 = 1;
	Button5 = 1;
	switch2 = 0;
	switch3 = 0;
	#3
	Button5 = 0;
	#115;
	Button4 = 1;
	#3;
	Button4 = 0;

	

	end 
      
endmodule

