`timescale 1ns / 1ps


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
	reg [1:0] testPActual;
	reg [1:0] testSolicitud;

	// Outputs
	wire [1:0]test_out;
	wire [7:0] sevenseg;
	wire [1:0] Level;
	wire AbreCierra;
   wire SubeBaja;

	// Instantiate the Unit Under Test (UUT)
	Interface uut (
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
		.testPActual(testPActual),
		.testSolicitud(testSolicitud),
		.test_out(test_out),
		.sevenseg(sevenseg),
		.Level(Level),
		.AbreCierra(AbreCierra),
		.SubeBaja(SubeBaja)
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
		testPActual=0;
	   testSolicitud=0;

		//Estoy en el piso 1 y quiero subir
		#10;
		switch1 = 1;
		Button5 = 1;
		switch2 = 0;
		switch3 = 0;

		// La maquina esta en el piso 1 y va subiendo
		testPActual = 0;
		Button2 = 1;
		Button4 = 1;
		
		#2;
		Button4 = 0; //Suelta el boton
		Button5 = 0; //Suelta la interrupcion
		
		#2;
		Button3 = 1;	//Solicitud de subir al piso 4 dentro del ascensor
		testSolicitud = 3;
		
		#2;
		Button3 = 0;	//Suelta el boton 
		switch1 = 0;
		Button5 = 1;
		switch2 = 0;
		switch3 = 1;
		
		#2;
		Button5 = 0;
		
		#2;
		testPActual = 1;//Indica que esta en el piso 2
		Button4 = 1;
		
		#2;
		Button4 = 0;	//Suelta el boton
		
		#2;
		testPActual = 2;//Indica que esta en el piso 3
		Button4 = 1;
		
		#2;
		Button4 = 0;	//Suelta el boton
		
		#2;
		testPActual = 3;	//Indica que esta en el piso 4
		Button4 = 1;
		
		#2;
		Button4 = 0;		//Suelta el boton
		
		
		
		#2;				//Solicitud del piso 3 para subir
		switch1 = 1;
		Button5 = 1;
		switch2 = 1;
		switch3 = 0;
		
		#2;
		Button5 = 0;
		
		
		
		#2;
		testPActual = 2;//Indica que esta en el piso 3
		Button2 = 0;
		Button4 = 1;
		
		#2;
		Button4 = 0;	//Suelta el boton
		
		
		#2;
		testPActual = 1;//Indica que esta en el piso 2
		Button2 = 0;
		Button4 = 1;
		
		#2;
		Button4 = 0;	//Suelta el boton
		
		#2;
		Button3 = 1;	//Solicitud de subir al piso 4 dentro del ascensor
		testSolicitud = 3;
		
		#2;
		Button3 = 0;
		testPActual = 2;//Indica que esta en el piso 3
		Button2 = 0;
		Button4 = 1;
		
		#2;
		Button4 = 0;	//Suelta el boton
		
		//PROBAR 2 SOLICTUDES AQUI
		
		#2;
		testPActual = 3;	//Indica que esta en el piso 4
		Button4 = 1;
		
		#2;
		Button4 = 0;		//Suelta el boton
		
		
	end
      
endmodule