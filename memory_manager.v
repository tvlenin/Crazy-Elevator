`timescale 1ns / 1ps

module memory_manager(
	 input clk,
    input [1:0] Floor,			//Piso de Solicitud
    input [1:0] Request,		//Solicitud MSB: Si(1) No(0) LSB: Sube(1) Baja(0)
    input [1:0] CurrentFloor,	//Piso Actual
	 input UDIn,					//Subiendo o Bajando
	 input [1:0] FloorRequest,	//Solicitud de Piso
	 input FRDelay,				//Se presiono un boton de ir a un piso
	 input Delay,					//Llego a un piso
	 input Stop,					//Termino ejecucion y se detuvo en el piso
	 output OCRequest,			//Open or Closed Request
	 output UDRequest,			//Up or Down Request
	 output NoStopRequest,
	 output exit,
	 output DoneDelay
    );
	 
	 localparam NCola = 4;
	 reg reg_DoneDelay;
	 reg reg_OCRequest;
	 reg reg_UDRequest;
	 reg reg_NoStopRequest;
	 reg [3:0] index;
	 reg [3:0] Counter;			//Contador de Posicion de Memoria
	 reg [3:0] Stops;				//Pisos en los que hay que parar
	 reg [1:0] topHeap;
	 reg [3:0] RegFloor1;		//Información de Request Piso1
	 reg [3:0] RegFloor2;		//Información de Request Piso2
	 reg [3:0] RegFloor3;		//Información de Request Piso3
	 reg [3:0] RegFloor4;		//Información de Request Piso4
	 reg [3:0] Heap[4:0];		//Heap de Instrucciones
	 reg [3:0] tempH;
	 
	 initial begin
	 for (index=0; index < NCola; index = index + 1)
		Heap[index] = 4'b0000;
	 Counter = 0;
	 topHeap = 0;
	 tempH = 0;
	 Stops = 0;
	 reg_OCRequest = 0;
	 reg_UDRequest = 0;
	 reg_NoStopRequest = 0;
	 RegFloor1 = 4'd0;
	 RegFloor2 = 4'd1;
	 RegFloor3 = 4'd2;
	 RegFloor4 = 4'd3;
	 reg_DoneDelay = 0;
	 end
	 
	 always@(posedge clk )begin
	 
	 if(Request[1] == 1)//Interrupción Request en Algun Piso
		begin
		reg_NoStopRequest = 0; //Reunicia la maquina
		if(Floor == 0)
			begin
			RegFloor1[3] = Request[1];
			RegFloor1[2] = Request[0];
			if(Stop == 1 && CurrentFloor >= 0)begin
				reg_UDRequest = 0;
				reg_NoStopRequest = 1; //Reunicia la maquina
				Stops[0] = 1;			  //Como estaba detenida, asignar parada en este piso
			end
			end
		else if(Floor == 1)
			begin
			RegFloor2[3] = Request[1];
			RegFloor2[2] = Request[0];
			if(Stop == 1 && CurrentFloor >= 1)begin
				reg_UDRequest = 0;
				Stops[1] = 1;			  //Como estaba detenida, asignar parada en este piso
			end
			else if(Stop == 1)begin
				reg_UDRequest = 1;
				Stops[1] = 1;			  //Como estaba detenida, asignar parada en este piso
			end
			reg_NoStopRequest = 1; //Reunicia la maquina
			end
		else if(Floor == 2)
			begin
			RegFloor3[3] = Request[1];
			RegFloor3[2] = Request[0];
			if(Stop == 1 && CurrentFloor >= 2)begin
				reg_UDRequest = 0;
				Stops[2] = 1;			  //Como estaba detenida, asignar parada en este piso
			end
			else if (Stop == 1) begin
				reg_UDRequest = 1;
				Stops[2] = 1;			  //Como estaba detenida, asignar parada en este piso
			end
			reg_NoStopRequest = 1; //Reunicia la maquina
			end
		else
			begin
			RegFloor4[3] = Request[1];
			RegFloor4[2] = Request[0];
			if(Stop == 1 && CurrentFloor <= 3)begin
				reg_UDRequest = 1;
				Stops[3] = 1;			  //Como estaba detenida, asignar parada en este piso
			end
			else
				Stops[3] = 0;
			
			reg_NoStopRequest = 1; //Reunicia la maquina
			end
		end//end bloque ifs
	
	 if(Stops == 0)//No hay mas instrucciones que verificar, verificar la cola
	 begin
		tempH = Heap[0];
		//reg_OCRequest = 0;
		if(tempH[3] == 1)//Solo si hay instruccion esperando en la cola (Heap)
		begin
			topHeap[0] = tempH[0];
			topHeap[1] = tempH[1];
			if(topHeap > CurrentFloor)
				reg_UDRequest = 1;
			else
				reg_UDRequest = 0;
				
			if(topHeap == 0)
				Stops[0] = 1;
			else if(topHeap == 1)
				Stops[1] = 1;
			else if(topHeap == 2)
				Stops[2] = 1;
			else
				Stops[3] = 1;
		 end
		 else
			topHeap = 0;
	 end
	
	
	 if(Stop == 1)//Interrupcion de fin de ejecucion y esta en espera
		reg_OCRequest = 0;
	 else
		reg_NoStopRequest = 0; //Reunicia la maquina
	
	 if(Delay == 1)//Interrupcion de Abrir o Cerrar Puertas
		begin
		if(CurrentFloor == 0)			//Piso 1
			begin
				if(RegFloor1[3] == 1 || Stops[0] == 1) 	//Si hay solicitud en este piso
					begin
						if(Stops[0] == 1)					//Hay que parar en este piso
							begin
							Stops[0] = 0;
							for (index=0; index < NCola; index = index + 1)//Busca coincidencias
							begin
							tempH = Heap[index];
							if(tempH[1] == 0 && tempH[0] == 0)
								begin
									tempH = 0;
									Heap[index] = tempH;
									if(Counter > 0)
										Counter = Counter - 4'd1;
								end
							end
							for (index=0; index < NCola; index = index + 1)//Defrag de la memoria
							begin
							if(index == 7)
								Heap[index] = 0;
							else
								Heap[index]=Heap[index+1];
							end
							
							reg_OCRequest = 1;
							end
							
						else if(RegFloor1[2] == UDIn) 	//La solicitud coincide con el proceso
							begin
							RegFloor1[3] = 0;
							RegFloor1[2] = 0;
							for (index=0; index < NCola; index = index + 1)//Busca coincidencias
							begin
							tempH = Heap[index];
							if(tempH[1] == 0 && tempH[0] == 0)
								begin
									tempH = 0;
									Heap[index] = tempH;
									if(Counter > 0)
										Counter = Counter - 4'd1;
								end
							end
							for (index=0; index < NCola; index = index + 1)//Defrag de la memoria
							begin
							if(index == 7)
								Heap[index] = 0;
							else
								Heap[index]=Heap[index+1];
							end
							
							reg_OCRequest = 1;
							end
						else								//La solicitud NO coincide con el proceso
							begin
							Heap[Counter] = RegFloor1;
							Counter = Counter + 4'd1;
							reg_UDRequest = UDIn;
							end
					end
				else							//No hay solicitud en este piso
					reg_UDRequest = UDIn;
			end
		//#############################################################################
		if(CurrentFloor == 1)			//Piso 2
			begin
				if(RegFloor2[3] == 1 || Stops[1] == 1) 	//Si hay solicitud en este piso
					begin
						if(Stops[1] == 1)					//Hay que parar en este piso
							begin
							Stops[1] = 0;
							for (index=0; index < NCola; index = index + 1)//Busca coincidencias
							begin
							tempH = Heap[index];
							if(tempH[1] == 0 && tempH[0] == 1)
								begin
									tempH = 0;
									Heap[index] = tempH;
									if(Counter > 0)
										Counter = Counter - 4'd1;
								end
							end
							for (index=0; index < NCola; index = index + 1)//Defrag de la memoria
							begin
							if(index == 7)
								Heap[index] = 0;
							else
								Heap[index]=Heap[index+1];
							end
							
							reg_OCRequest = 1;
							end
							
						else if(RegFloor2[2] == UDIn) 	//La solicitud coincide con el proceso
							begin
							RegFloor2[3] = 0;
							RegFloor2[2] = 0;
							for (index=0; index < NCola; index = index + 1)//Busca coincidencias
							begin
							tempH = Heap[index];
							if(tempH[1] == 0 && tempH[0] == 1)
								begin
									tempH = 0;
									Heap[index] = tempH;
									if(Counter > 0)
										Counter = Counter - 4'd1;
								end
							end
							for (index=0; index < NCola; index = index + 1)//Defrag de la memoria
							begin
							if(index == 7)
								Heap[index] = 0;
							else
								Heap[index]=Heap[index+1];
							end
							
							reg_OCRequest = 1;
							end
						else								//La solicitud NO coincide con el proceso
							begin
							Heap[Counter] = RegFloor2;		//NOTA CAMBIAR A COUNTER
							Counter = Counter + 4'd1;
							reg_UDRequest = UDIn;
							end
					end
				else							//No hay solicitud en este piso
					reg_UDRequest = UDIn;
			end
		//################################################################################
		if(CurrentFloor == 2)			//Piso 3
			begin
				if(RegFloor3[3] == 1 || Stops[2] == 1) 	//Si hay solicitud en este piso
					begin
						if(Stops[2] == 1)					//Hay que parar en este piso
							begin
							Stops[2] = 0;
							for (index=0; index < NCola; index = index + 1)//Busca coincidencias
							begin
							tempH = Heap[index];
							if(tempH[1] == 1 && tempH[0] == 0)
								begin
									tempH = 0;
									Heap[index] = tempH;
									if(Counter > 0)
										Counter = Counter - 4'd1;
								end
							end
							for (index=0; index < NCola; index = index + 1)//Defrag de la memoria
							begin
							if(index == 7)
								Heap[index] = 0;
							else
								Heap[index]=Heap[index+1];
							end
							
							reg_OCRequest = 1;
							end
							
						else if(RegFloor3[2] == UDIn) 	//La solicitud coincide con el proceso
							begin
							RegFloor3[3] = 0;
							RegFloor3[2] = 0;
							for (index=0; index < NCola; index = index + 1)//Busca coincidencias
							begin
							tempH = Heap[index];
							if(tempH[1] == 1 && tempH[0] == 0)
								begin
									tempH = 0;
									Heap[index] = tempH;
									if(Counter > 0)
										Counter = Counter - 4'd1;
								end
							end
							for (index=0; index < NCola; index = index + 1)//Defrag de la memoria
							begin
							if(index == 7)
								Heap[index] = 0;
							else
								Heap[index]=Heap[index+1];
							end
							
							reg_OCRequest = 1;
							end
						else								//La solicitud NO coincide con el proceso
							begin
							Heap[Counter] = RegFloor3;
							Counter = Counter + 4'd1;
							reg_UDRequest = UDIn;
							end
					end
				else							//No hay solicitud en este piso
					reg_UDRequest = UDIn;
			end
		//#################################################################################
		if(CurrentFloor == 3)			//Piso 4
			begin
				if(RegFloor4[3] == 1 || Stops[3] == 1) 	//Si hay solicitud en este piso
					begin
						if(Stops[3] == 1)					//Hay que parar en este piso
							begin
							Stops[3] = 0;
							for (index=0; index < NCola; index = index + 1)//Busca coincidencias
							begin
							tempH = Heap[index];
							if(tempH[1] == 1 && tempH[0] == 1)
								begin
									tempH = 0;
									Heap[index] = tempH;
									if(Counter > 0)
										Counter = Counter - 4'd1;
								end
							end
							for (index=0; index < NCola; index = index + 1)//Defrag de la memoria
							begin
							if(index == 7)
								Heap[index] = 0;
							else
								Heap[index]=Heap[index+1];
							end
							
							
							reg_OCRequest = 1;
							end
							
						else if(RegFloor4[2] == UDIn) 	//La solicitud coincide con el proceso
							begin
							RegFloor4[3] = 0;
							RegFloor4[2] = 0;
							for (index=0; index < NCola; index = index + 1)//Busca coincidencias
							begin
							tempH = Heap[index];
							if(tempH[1] == 1 && tempH[0] == 1)
								begin
									tempH = 0;
									Heap[index] = tempH;
									if(Counter > 0)
										Counter = Counter - 4'd1;
								end
							end
							for (index=0; index < NCola; index = index + 1)//Defrag de la memoria
							begin
							if(index == 7)
								Heap[index] = 0;
							else
								Heap[index]=Heap[index+1];
							end
							
							reg_OCRequest = 1;
							end
						else								//La solicitud NO coincide con el proceso
							begin
							Heap[Counter] = RegFloor4;
							Counter = Counter + 4'd1;
							reg_UDRequest = UDIn;
							Stops[3] = 1;
							end
					end
				else							//No hay solicitud en este piso
					reg_UDRequest = UDIn;
			end
			reg_DoneDelay=1;
		end//end current floor ifs
	 
    if(FRDelay == 1)//Nuevo Request de Destino de Piso
		begin
		reg_OCRequest = 0;
		if(FloorRequest == 0)
			Stops[0] = 1;
		else if(FloorRequest == 1)
			Stops[1] = 1;
		else if(FloorRequest == 2)
			Stops[2] = 1;
		else// if(FloorRequest == 3)
			Stops[3] = 1;
		reg_UDRequest = UDIn;
		
		end
		
	 end//end always

assign DoneDelay = reg_DoneDelay;
assign UDRequest = reg_UDRequest;
assign OCRequest = reg_OCRequest;
assign NoStopRequest = reg_NoStopRequest;
endmodule
