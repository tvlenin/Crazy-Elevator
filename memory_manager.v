`timescale 1ns / 1ps

module memory_manager(
	 input clk,
    input [1:0] Floor,			//Piso de Solicitud
    input [1:0] Request,		//Solicitud MSB: Si(1) No(0) LSB: Sube(1) Baja(0)
    input [1:0] CurrentFloor,	//Piso Actual
	 input UDIn,					//Subiendo o Bajando
	 input [2:0] FloorRequest,	//Solicitud de Piso
	 input FRDelay,				//Se presiono un boton de ir a un piso
	 input Delay,					//Llego a un piso
	 input NextStageDelay,
	 input Stop,					//Termino ejecucion y se detuvo en el piso
	 output OCRequest,			//Open or Closed Request
	 output UDRequest,			//Up or Down Request
	 output NoStopRequest,
	 output DoneDelay,
	 output DoneFRDelay,
	 output DoneNextStageDelay,
	 output [3:0]TestStopsUP,
	 output [3:0]TestStopsDW
    );
	 
	 localparam NCola = 4;
	 reg reg_DoneNextStageDelay;
	 reg reg_DoneDelay;
	 reg reg_DoneFRDelay;
	 reg reg_OCRequest;
	 reg reg_UDRequest;
	 reg reg_NoStopRequest;
	 reg [3:0] index;
	 reg [3:0] Counter;			//Contador de Posicion de Memoria
	 reg [3:0] Stops[1:0];			//Pisos en los que hay que parar subiendo
	 
	 initial begin
	 Stops[0] = 0;
	 Stops[1] = 0;
	 reg_OCRequest = 0;
	 reg_UDRequest = 0;
	 reg_NoStopRequest = 0;
	 reg_DoneDelay = 0;
	 reg_DoneFRDelay = 0;
	 reg_DoneNextStageDelay = 0;
	 end
	 
	 always@(posedge clk )begin
	 
	 if(NextStageDelay == 1)//Verifica que ya no está presionando un boton de ir a Piso
		reg_DoneNextStageDelay = 0;
	 
	 if(Request[1] == 1)begin//Interrupción Request en Algun Piso
		reg_NoStopRequest = 0; //Detiene la maquina
		if(Floor == CurrentFloor)begin
			reg_OCRequest = 1;
			reg_UDRequest = UDIn;
			if(Stop == 1)
				reg_NoStopRequest = 1; //Reunicia la maquin
		end
		else begin
			if(Floor == 0) begin
				Stops[0][0] = 1;
				if(Stop == 1 && CurrentFloor > 0)
					reg_NoStopRequest = 1; //Reunicia la maquina
				if(CurrentFloor > 0)
					reg_UDRequest = 0;
			end
			else if(Floor == 1) begin
				if(Request[0] == 1)
					Stops[1][1] = 1;
				else if(Request[0] == 0)
					Stops[0][1] = 1;
				if(Stop == 1)
					reg_NoStopRequest = 1; //Reunicia la maquin
				if(CurrentFloor > 1)
					reg_UDRequest = 0;
				else if(CurrentFloor < 1)
					reg_UDRequest = 1;
			end
			else if(Floor == 2)begin
				if(Request[0] == 1)
					Stops[1][2] = 1;
				else if(Request[0] == 0)
					Stops[0][2] = 1;
				if(Stop == 1)
					reg_NoStopRequest = 1; //Reunicia la maquina
				if(CurrentFloor > 2)
					reg_UDRequest = 0;
				else if(CurrentFloor < 2)
					reg_UDRequest = 1;
			end
			else if(Floor == 3)begin
				Stops[1][3] = 1;
				if(Stop == 1)
					reg_NoStopRequest = 1; //Reunicia la maquina
				if(CurrentFloor < 3)
					reg_UDRequest = 1;
			end
		end
	end//end bloque ifs
	
	 
	 /*if(Stops[0] == 0 && Stops[1] == 0)begin//No hay mas instrucciones que verificar
		reg_NoStopRequest = 0;
	 end*/
	
	
	 if(Stop == 1)begin//Interrupcion de fin de ejecucion y esta en espera
		reg_OCRequest = 0;
		if(Stops[1] != 0)begin
			reg_UDRequest = 1;
			reg_NoStopRequest = 1; //Reunicia la maquina
		end
		else if(Stops[0] != 0)begin
			reg_UDRequest = 0;
			reg_NoStopRequest = 1; //Reunicia la maquina
		end
	 end
	 else
		reg_NoStopRequest = 0;
	
	 if(Delay == 1)//Interrupcion de Abrir o Cerrar Puertas
		begin
			if(CurrentFloor == 0)begin				//Piso 1
				if(Stops[0][0] == 1)begin				//Hay que parar en este piso
					reg_OCRequest = 1;
					Stops[0][0] = 0;
				end
				else
					reg_UDRequest = UDIn;
			end
			else if(CurrentFloor == 1)begin		//Piso 2
				if(Stops[reg_UDRequest][1] == 1)begin				//Hay que parar en este piso
					reg_OCRequest = 1;
					Stops[reg_UDRequest][1] = 0;
				end
				else if(Stops[0][1] && Stops[1][2] == 0 && Stops[1][3] == 0)begin
					reg_OCRequest = 1;
					Stops[1][1] = 0;
				end
				else if(Stops[1][1] && Stops[0][0] == 0)begin
					reg_OCRequest = 1;
					Stops[0][1] = 0;
				end
				else
					reg_UDRequest = UDIn;
			end
			else if(CurrentFloor == 2)begin		//Piso 3
				if(Stops[reg_UDRequest][2] == 1)begin//Hay que parar en este piso
					reg_OCRequest = 1;
					Stops[reg_UDRequest][2] = 0;
				end
				else if(Stops[1][2] == 1 && Stops[1][3] == 0)begin
					reg_OCRequest = 1;
					Stops[0][2] = 0;
				end
				else if(Stops[0][2] == 1 && Stops[0][0] == 0 && Stops[0][1] == 0)begin
					reg_OCRequest = 1;
					Stops[1][2] = 0;
				end
				else
					reg_UDRequest = UDIn;
			end
			else if(CurrentFloor == 3)begin		//Piso 4
				if(Stops[1][3] == 1)begin			//Hay que parar en este piso
					reg_OCRequest = 1;
					Stops[1][3] = 0;
				end
				else
					reg_UDRequest = UDIn;
			end
		reg_DoneDelay=1;
		end//end current floor ifs
	 
	 
    if(FRDelay == 1)begin//Nuevo Request de Destino de Piso
		if(FloorRequest-4'd4 == CurrentFloor)begin
			reg_DoneNextStageDelay = 1;
			reg_DoneFRDelay = 1;
		end
		else begin
			if(FloorRequest == 4)begin
				if(Stop == 1 && CurrentFloor >= 0)
					reg_NoStopRequest = 1; //Reunicia la maquina
				if(CurrentFloor > 0)begin
					Stops[0][0] = 1;
					reg_UDRequest = 0;
				end
			end
			else if(FloorRequest == 5)begin
				if(Stop == 1)
					reg_NoStopRequest = 1; //Reunicia la maquin
				if(CurrentFloor > 1)begin
					Stops[0][1] = 1;
					reg_UDRequest = 0;
				end
				else if(CurrentFloor < 1)begin
					Stops[1][1] = 1;
					reg_UDRequest = 1;
				end
			end
			else if(FloorRequest == 6)begin
				if(Stop == 1)
					reg_NoStopRequest = 1; //Reunicia la maquina
				if(CurrentFloor > 2)begin
					Stops[0][2] = 1;
					reg_UDRequest = 0;
				end
				else if(CurrentFloor < 2)begin
					Stops[1][2] = 1;
					reg_UDRequest = 1;
				end
			end
			else if(FloorRequest == 7)begin
				if(Stop == 1)
					reg_NoStopRequest = 1; //Reunicia la maquina
				if(CurrentFloor < 3)begin
					Stops[1][3] = 1;
					reg_UDRequest = 1;
				end
			end
			reg_OCRequest = 0;
			reg_DoneNextStageDelay = 1;
			reg_DoneFRDelay = 1;
		end
	end
		
	end//end always

assign DoneNextStageDelay = reg_DoneNextStageDelay;
assign DoneFRDelay = reg_DoneFRDelay;
assign DoneDelay = reg_DoneDelay;
assign UDRequest = reg_UDRequest;
assign OCRequest = reg_OCRequest;
assign NoStopRequest = reg_NoStopRequest;
assign TestStopsUP = Stops[1][3:1];
assign TestStopsDW = Stops[0];
endmodule
