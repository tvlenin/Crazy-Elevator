`timescale 1ns / 1ps

module F_S_M(
	input clk,
	input [2:0]next_stage,
	input reset,
	input OC_Request,
	input UD_Request,
	input [3:0]actual_clock,
	input NO_STOP,
	input DoneDelay,
	input DoneFRDelay,
	input DoneResetClock,
	output reset_clock,
	output FR_Delay,
	output Delay,
	output [1:0]Actual_Stage,
	output UD_Answer,
	output STOP
);
reg [1:0]first_time;
reg time_flag;
reg c_reset;
reg [2:0] state;
reg reg_stop;
reg reg_UDAnswer;					//UD_Answer
reg [1:0] reg_ActualStage;		//Actual_Stage
reg reg_Delay;						//Delay
reg reg_FRDelay;					//FR_Delay


parameter SA = 0,SB = 1,SC = 2,SD = 3,SE = 4,SF = 5,SS=6;

initial begin
	first_time = 0;
	reg_FRDelay = 0 ;
	reg_ActualStage = 0;
	reg_UDAnswer = 1;
	reg_Delay = 0 ;
	time_flag = 0;
	reg_stop = 1;
	state <= SS;
end //if reset

always @ (posedge clk or posedge reset) begin
	if(reset==1)begin
		first_time = 0;
		reg_FRDelay = 0 ;
		reg_ActualStage = 0;
		reg_UDAnswer = 1;
		reg_Delay = 0 ;
		time_flag = 0;
		reg_stop = 1;
		state <= SS;
	end //if reset
	
	else begin
		if(DoneDelay == 1)			//Verificar fin del controlador
			reg_Delay = 0;
		if(DoneResetClock == 1) 	//Verificar fin del clock
			c_reset = 0;
		if(DoneFRDelay == 1)			//Verificar fin la verificacion de los botones(1-4)
			reg_FRDelay = 0;
		
		case(state)
			SA:
				if(first_time == 1)begin
					first_time = 2;
					c_reset = 1;
					time_flag = 0;
				end
				else if(first_time == 0)begin //Primera Ejecución del Ascensor
					reg_ActualStage = 0;
					reg_UDAnswer = 1;
					first_time=2;
					time_flag =0;
					reg_Delay = 1;
					
				end
				
				else if(OC_Request == 1 && time_flag == 0 )begin
					c_reset = 1; //Inicia el contador de 10 segundos
					time_flag = 1;
				end
				else if(actual_clock < 10 && next_stage != 0 && OC_Request == 1) begin
						reg_FRDelay = 1;
						time_flag = 0;
				end
				
				else if(OC_Request == 0)begin //Cuando se cierran las puertas
					if (time_flag == 0) begin	//Comienza a subir durante 10s
						c_reset = 1;				//Inicia el contador de 10 segundos
						time_flag = 1;
					end
					else if(actual_clock >= 10)begin //Pasar al siguiente estado 
						first_time = 0;
						c_reset = 1;
						state <= SB;
					end
					
				end//else if(OC_Request == 0)
				
				else if(actual_clock >= 10)begin
					first_time = 0;
					reg_stop = 1;
					c_reset = 1;
					state <= SS;
				end
				
			SB:
				if(first_time == 1)begin
					first_time = 2;
					c_reset = 1;
					time_flag = 0;
				end
				
				else if(first_time == 0)begin//Llega al piso 2, notifica al controlador
					first_time = 2;
					time_flag = 0;
					reg_ActualStage = 1;
					reg_UDAnswer = 1;
					reg_Delay = 1;
				
				end//if(first_time == 0)
				
				else if(OC_Request == 1 && time_flag == 0 )begin///si habia una solicitud para subir abre las puertas
					c_reset = 1; //Inicia el contador de 10 segundos
					time_flag = 1;
				end //if(OC_Request == 1)
				
				else if(actual_clock < 10 && next_stage != 0 && OC_Request == 1) begin
					if (next_stage[1:0] < reg_ActualStage)begin
						first_time = 0;
						reg_FRDelay = 1;
						state <= SC;
					end
					else begin
						reg_FRDelay = 1;
					end 
				end //else if(actual_clock)
							

				else if(OC_Request == 0)begin		//Cuando se cierran las puertas
					if (time_flag == 0) begin		//Comienza a subir durante 10s
						c_reset = 1;					//Inicia el contador de 10 segundos
						time_flag = 1;
					end
					else if(actual_clock >= 10)begin	//Pasar al siguiente estado
						first_time = 0;
						c_reset = 1;
						state <= SD;
					end
					
				end//else if(OC_Request == 0)
				else if(actual_clock >= 10)begin
						c_reset = 1;				
						first_time = 0;
						reg_stop = 1;
						state <= SS;
					
				end
				
				//state <= SA;
			SC:
				if(first_time == 1)begin
					first_time = 2;
					c_reset = 1;
					time_flag = 0;
				end
				else if(first_time == 0)begin //Llega al piso 2, notifica al controlador
					first_time = 2;
					time_flag = 0;
					reg_ActualStage = 1;
					time_flag = 0;
					reg_UDAnswer = 0;
					reg_Delay = 1;
				
				end//if(first_time == 0)begin
				else if(OC_Request == 1 && time_flag == 0 )begin///si habia una solicitud para subir abre las puertas
					c_reset = 1;//Inicia el contador de 10 segundos
					time_flag = 1;
				end //if(OC_Request == 1)
				
				else if(actual_clock < 10 && next_stage != 0 && OC_Request == 1) begin
					
					if (next_stage[1:0] > reg_ActualStage)begin
						reg_FRDelay = 1;
						state <= SB;
					end
					else begin
						reg_FRDelay = 1;
					end
				end //else if(actual_clock)
							

				else if(OC_Request == 0)begin		//Cuando se cierran las puertas
					if (time_flag == 0) begin		//Comienza a subir durante 10s
						c_reset = 1;					//Inicia el contador de 10 segundos
						time_flag = 1;
					end
					else if(actual_clock >= 10)begin		//Pasar al siguiente estado
						c_reset = 1;
						first_time = 0;
						state <= SA;
					end
				end//else if(OC_Request == 0)
				
				else if(actual_clock >= 10)begin
					c_reset = 1;
					first_time = 0;
					reg_stop = 1;
					state <= SS;
				end
				
				
			SD:
			
				if(first_time == 1)begin
					first_time = 2;
					c_reset = 1;
					time_flag = 0;
				end
				else if(first_time == 0)begin //Llega al piso 3, notifica al controlador
					
					first_time = 2;
					time_flag = 0;
					reg_ActualStage = 2;
					reg_UDAnswer = 1;
					reg_Delay = 1;
				
				end//if(first_time == 0)begin

				else if(OC_Request == 1 && time_flag == 0 )begin///si habia una solicitud para subir abre las puertas
					c_reset = 1;//#3;c_reset = 0; //Inicia el contador de 10 segundos
					time_flag = 1;
				end //if(OC_Request == 1)
				
				else if(actual_clock < 10 && next_stage != 0 && OC_Request == 1) begin
					if (next_stage[1:0] < reg_ActualStage)begin
						first_time = 0;
						reg_FRDelay = 1;
						state <= SE;
					end
					else begin
						reg_FRDelay = 1;
					end
				end //else if(actual_clock)
							

				else if(OC_Request == 0)begin		//Cuando se cierran las puertas
					if (time_flag == 0) begin		//Comienza a subir durante 10s
						c_reset = 1;					//Inicia el contador de 10 segundos
						time_flag = 1;
					end
					else if(actual_clock >= 10)begin		//Pasar al siguiente estado
						c_reset = 1;
						first_time = 0;
						state <= SF;
					end
				end//else if(OC_Request == 0)
				else if(actual_clock >= 10)begin
					c_reset = 1;
					first_time = 0;
					reg_stop = 1;
					state <= SS;
				end
				
				
			SE:
				if(first_time == 1)begin
					first_time = 2;			
					c_reset = 1;
					time_flag = 0;
				end
				else if(first_time == 0)begin//Llega al piso 3, notifica al controlador
					first_time = 2;
					time_flag = 0;
					reg_ActualStage = 2;
					reg_UDAnswer = 0;
					reg_Delay = 1;
				
				end//if(first_time == 0)begin
					
				
				else if(OC_Request == 1 && time_flag == 0 )begin///si habia una solicitud para subir abre las puertas
					c_reset = 1;//#3;c_reset = 0; //Inicia el contador de 10 segundos
					time_flag = 1;
				end //if(OC_Request == 1)
				else if(actual_clock < 10 && next_stage != 0 && OC_Request == 1) begin
					if (next_stage > reg_ActualStage)begin
						first_time = 0;
						reg_FRDelay = 1;
						state <= SD;
					end
					else begin
						reg_FRDelay = 1;
					end
				end //else if(actual_clock)
							

				else if(OC_Request == 0)begin		//Cuando se cierran las puertas
					if (time_flag == 0) begin		//Comienza a subir durante 10s
						c_reset = 1;					//Inicia el contador de 10 segundos
						time_flag = 1;
					end
					else if(actual_clock >= 10)begin		//Pasar al siguiente estado
						c_reset = 1;
						first_time = 0;
						state <= SC;
					end
				end//else if(OC_Request == 0)
				else if(actual_clock >= 10)begin
					c_reset = 1;
					first_time = 0;
					reg_stop = 1;
					state <= SS;
				end
			
			SF:
				if(first_time == 1)begin
					first_time = 2;			
					c_reset = 1;
					time_flag = 0;
				end
				else if(first_time == 0)begin //Llega al piso 4, notifica al controlador
					first_time = 2;
					time_flag = 0;
					reg_ActualStage = 3;
					reg_UDAnswer = 0;
					reg_Delay = 1;
				
				end//if(first_time == 0)begin
				
				else if(OC_Request == 1 && time_flag == 0 )begin///si habia una solicitud para subir abre las puertas
					c_reset = 1;	 //Inicia el contador de 10 segundos
					time_flag = 1;
				end //if(OC_Request == 1)
				
				else if(actual_clock < 10 && next_stage != 0 && OC_Request == 1) begin
						reg_FRDelay = 1;
				end //else if(actual_clock)
							

				else if(OC_Request == 0)begin		//Cuando se cierran las puertas
					if (time_flag == 0) begin		//Comienza a subir durante 10s
						c_reset = 1;					//Inicia el contador de 10 segundos
						time_flag = 1;
					end
					else if(actual_clock >= 10)begin		//Pasar al siguiente estado
						c_reset = 1;
						first_time = 0;
						state <= SE;
					end
				end//else if(OC_Request == 0)
				else if(actual_clock >= 10)begin
					c_reset = 1;
					first_time = 0;
					reg_stop = 1;
					state <= SS;
				end
				
				
			SS:
				if(NO_STOP == 1)begin
					reg_stop = 0;
					first_time = 1;
					case (reg_ActualStage)
						0:
							state <= SA;
						1:
							if(UD_Request == 1)
								state <= SB;
							else
								state <= SC;
						2:
							if(UD_Request == 1)
								state <= SD;
							else
								state <= SE;
						3:
							state <= SF;
					endcase
				end
		endcase
	end

end//always @ (posedge clk or posedge reset) begin 

assign reset_clock = c_reset;
assign UD_Answer = reg_UDAnswer;
assign Actual_Stage = reg_ActualStage;
assign Delay = reg_Delay;
assign FR_Delay = reg_FRDelay;
assign STOP = reg_stop;

endmodule