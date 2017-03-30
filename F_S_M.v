`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:10:34 03/26/2017 
// Design Name: 
// Module Name:    F_S_M 
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
module F_S_M(
input clk,
input [2:0]next_stage,
input reset,
input OC_Request,
input UD_Request,
input [3:0]actual_clock,
output reset_clock,
output reg [1:0] out,
output FR_Delay,
output [2:0] Solicitud_stage,
output Delay,
output [1:0]Actual_Stage,
output UD_Answer


);
reg [1:0]first_time;
reg time_flag;
reg c_reset;
reg [2:0] state;

reg reg_UDAnswer;///////////////UD_Answer
reg [1:0] reg_ActualStage;///////Actual_Stage
reg reg_Delay;//////////////////Delay
reg reg_FRDelay;////////////////FR_Delay
reg [2:0]reg_SolicitudStage;/////////Solicitud_stage




parameter SA = 0,SB = 1,SC = 2,SD = 3,SE = 4,SF = 5;

always @ (posedge clk or posedge reset) begin
	if(reset)begin
		state <= SA;
		first_time = 0;
		reg_FRDelay = 0 ;
		reg_SolicitudStage = 0;
		reg_ActualStage = 0;
		reg_UDAnswer = 0;
		reg_Delay = 0 ;
		time_flag = 0;
	end //if reset
	else
		case(state)
			SA:
				
				if(first_time == 0)begin // primera vez del ascensor
					reg_UDAnswer = 1;
					first_time=2;
					reg_ActualStage = 0;
					reg_Delay = 1;
					#2;
					//reg_UDAnswer = 0;
					reg_Delay = 0;
				end//if(first_time == 0)
				
				else if(OC_Request == 1 && time_flag == 0 )begin
					c_reset = 1;#3;c_reset = 0; //Inicia el contador de 10 segundos
					
					if (time_flag == 0) begin
						time_flag = 1;
						
					end //if(time_flag ==0)
					
				end //if(OC_Request == 1)
				else if(actual_clock <= 10 && next_stage != 0 ) begin
						reg_SolicitudStage = next_stage;
						reg_FRDelay = 1;
						#3 ;
						reg_FRDelay = 0;
						reg_SolicitudStage = 0;
						time_flag = 0;
				end //else if(actual_clock)
				else if(OC_Request == 0)begin  /////cuando se cierran las puertas
					if (time_flag == 0) begin///comienzo a subir durante 10 segundos
						c_reset = 1;#3;c_reset = 0; //Inicia el contador de 10 segundos
						time_flag = 1;
					end
					else if (actual_clock <= 10) begin // durante esos 10 segundos 7s dice que voy subiendo
						////LOGICA PARA EL SEVENSEG
					end
					else if(actual_clock > 10)begin// cuando pasan los diez segundos paso al siguiente estado, piso 2 subiendo
						first_time = 0;
						state <= SB;
					end
				end//else if(OC_Request == 0)
				
				else if(OC_Request == 1 && time_flag == 0 )begin
					c_reset = 1;#3;c_reset = 0; //Inicia el contador de 10 segundos
					
					if (time_flag == 0) begin
						time_flag = 1;
						
					end //if(time_flag ==0)
					
				end //if(OC_Request == 1)
			SB:
				if(first_time == 1)begin
					first_time = 2;
					//no hago nada solo no entro al reset inicial
				end
				
				else if(first_time == 0)begin// acaba de llegar al piso 2 y avisa al controlador
					first_time = 2;
					time_flag = 0;
					reg_ActualStage = 1;
					reg_UDAnswer = 1;
					reg_Delay = 1;
					#3;
					reg_Delay = 0;
				
				end//if(first_time == 0)
				
				else if(OC_Request == 1 && time_flag == 0 )begin///si habia una solicitud para subir abre las puertas
					c_reset = 1;#3;c_reset = 0; //Inicia el contador de 10 segundos
					
					if (time_flag == 0) begin
						time_flag = 1;
						
					end //if(time_flag ==0)
					
				end //if(OC_Request == 1)
				
				else if(actual_clock <= 10 && next_stage != 0 ) begin
					if (next_stage < reg_ActualStage)begin
						//first_time = 0;
						state <= SC;
					end
					else begin
						reg_SolicitudStage = next_stage;
						reg_FRDelay = 1;
						#2 ;
						reg_FRDelay = 0;
						reg_SolicitudStage = 0;
						//time_flag = 0;
					end 
				end //else if(actual_clock)
							

				else if(OC_Request == 0)begin  /////cuando se cierran las puertas
					if (time_flag == 0) begin///comienzo a subir durante 10 segundos
						c_reset = 1;#3;c_reset = 0; //Inicia el contador de 10 segundos
						time_flag = 1;
					end
					else if (actual_clock <= 10) begin // durante esos 10 segundos 7s dice que voy subiendo
						////LOGICA PARA EL SEVENSEG
					end
					else if(actual_clock > 10)begin// cuando pasan los diez segundos paso al siguiente estado, piso 3 subiendo
						first_time = 0;
						state <= SD;
					end
				end//else if(OC_Request == 0)
				
				
				
				
				
				//state <= SA;
			SC:
				if(first_time == 1)begin
					first_time = 2;
					//no hago nada solo no entro al reset inicial
				end
				else if(first_time == 0)begin// acaba de llegar al piso 2 y avisa al controlador
					first_time = 2;
					time_flag = 0;
					reg_ActualStage = 1;
					reg_UDAnswer = 0;
					reg_Delay = 1;
					#3;
					reg_Delay = 0;
				
				end//if(first_time == 0)begin
				else if(OC_Request == 1 && time_flag == 0 )begin///si habia una solicitud para subir abre las puertas
					c_reset = 1;#3;c_reset = 0; //Inicia el contador de 10 segundos
					
					if (time_flag == 0) begin
						time_flag = 1;
						
					end //if(time_flag ==0)
					
				end //if(OC_Request == 1)
				
				else if(actual_clock <= 10 && next_stage != 0 ) begin
					if (next_stage < reg_ActualStage)begin
						//first_time = 0;
						state <= SB;
					end
					else begin
						reg_SolicitudStage = next_stage;
						reg_FRDelay = 1;
						#2 ;
						reg_FRDelay = 0;
						reg_SolicitudStage = 0;
						//time_flag = 0;
					end
				end //else if(actual_clock)
							

				else if(OC_Request == 0)begin  /////cuando se cierran las puertas
					if (time_flag == 0) begin///comienzo a subir durante 10 segundos
						c_reset = 1;#3;c_reset = 0; //Inicia el contador de 10 segundos
						time_flag = 1;
					end
					else if (actual_clock <= 10) begin // durante esos 10 segundos 7s dice que voy subiendo
						////LOGICA PARA EL SEVENSEG
					end
					else if(actual_clock > 10)begin// cuando pasan los diez segundos paso al siguiente estado, piso 3 subiendo
						first_time = 0;
						state <= SA;
					end
				end//else if(OC_Request == 0)
				
				
				
			SD:
				if(first_time == 1)begin
					// paso
					first_time = 2;
				end
				else if(first_time == 0)begin// acaba de llegar al piso 3 y avisa al controlador
					first_time = 2;
					time_flag = 0;
					reg_ActualStage = 2;
					reg_UDAnswer = 1;
					reg_Delay = 1;
					#3;
					reg_Delay = 0;
				
				end//if(first_time == 0)begin

				else if(OC_Request == 1 && time_flag == 0 )begin///si habia una solicitud para subir abre las puertas
					c_reset = 1;#3;c_reset = 0; //Inicia el contador de 10 segundos
					
					if (time_flag == 0) begin
						time_flag = 1;
						
					end //if(time_flag ==0)
					
				end //if(OC_Request == 1)
				
				else if(actual_clock <= 10 && next_stage != 0 ) begin
					if (next_stage < reg_ActualStage)begin
						//first_time = 0;
						state <= SE;
					end
					else begin
						reg_SolicitudStage = next_stage;
						reg_FRDelay = 1;
						#2 ;
						reg_FRDelay = 0;
						reg_SolicitudStage = 0;
						//time_flag = 0;
					end
				end //else if(actual_clock)
							

				else if(OC_Request == 0)begin  /////cuando se cierran las puertas
					if (time_flag == 0) begin///comienzo a subir durante 10 segundos
						c_reset = 1;#3;c_reset = 0; //Inicia el contador de 10 segundos
						time_flag = 1;
					end
					else if (actual_clock <= 10) begin // durante esos 10 segundos 7s dice que voy subiendo
						////LOGICA PARA EL SEVENSEG
					end
					else if(actual_clock > 10)begin// cuando pasan los diez segundos paso al siguiente estado, piso 3 subiendo
						first_time = 0;
						state <= SF;
					end
				end//else if(OC_Request == 0)
				
				
				
			SE:
				if(first_time == 1)begin
					first_time = 2;			

					//no hago nada solo no entro al reset inicial
				end
				else if(first_time == 0)begin// acaba de llegar al piso 2 y avisa al controlador
					first_time = 2;
					time_flag = 0;
					reg_ActualStage = 2;
					reg_UDAnswer = 0;
					reg_Delay = 1;
					#3;
					reg_Delay = 0;
				
				end//if(first_time == 0)begin
					
				
				else if(OC_Request == 1 && time_flag == 0 )begin///si habia una solicitud para subir abre las puertas
					c_reset = 1;#3;c_reset = 0; //Inicia el contador de 10 segundos
					
					if (time_flag == 0) begin
						time_flag = 1;
						
					end //if(time_flag ==0)
					
				end //if(OC_Request == 1)
				else if(actual_clock <= 10 && next_stage != 0 ) begin
					if (next_stage < reg_ActualStage)begin
						//first_time = 0;
						state <= SD;
					end
					else begin
						reg_SolicitudStage = next_stage;
						reg_FRDelay = 1;
						#2 ;
						reg_FRDelay = 0;
						reg_SolicitudStage = 0;
						//time_flag = 0;
					end
				end //else if(actual_clock)
							

				else if(OC_Request == 0)begin  /////cuando se cierran las puertas
					if (time_flag == 0) begin///comienzo a subir durante 10 segundos
						c_reset = 1;#3;c_reset = 0; //Inicia el contador de 10 segundos
						time_flag = 1;
					end
					else if (actual_clock <= 10) begin // durante esos 10 segundos 7s dice que voy subiendo
						////LOGICA PARA EL SEVENSEG
					end
					else if(actual_clock > 10)begin// cuando pasan los diez segundos paso al siguiente estado, piso 3 subiendo
						first_time = 0;
						state <= SC;
					end
				end//else if(OC_Request == 0)
			
			SF:
				if(first_time == 0)begin// acaba de llegar al piso 2 y avisa al controlador
					first_time = 2;
					time_flag = 0;
					reg_ActualStage = 3;
					reg_UDAnswer = 0;
					reg_Delay = 1;
					#3;
					reg_Delay = 0;
				
				end//if(first_time == 0)begin
				
				else if(OC_Request == 1 && time_flag == 0 )begin///si habia una solicitud para subir abre las puertas
					c_reset = 1;#3;c_reset = 0; //Inicia el contador de 10 segundos
					
					if (time_flag == 0) begin
						time_flag = 1;
						
					end //if(time_flag ==0)
					
				end //if(OC_Request == 1)
				
				else if(actual_clock <= 10 && next_stage != 0 ) begin
						reg_SolicitudStage = next_stage;
						reg_FRDelay = 1;
						#2 ;
						reg_FRDelay = 0;
						reg_SolicitudStage = 0;
						//time_flag = 0;
				end //else if(actual_clock)
							

				else if(OC_Request == 0)begin  /////cuando se cierran las puertas
					if (time_flag == 0) begin///comienzo a subir durante 10 segundos
						c_reset = 1;#3;c_reset = 0; //Inicia el contador de 10 segundos
						time_flag = 1;
					end
					else if (actual_clock <= 10) begin // durante esos 10 segundos 7s dice que voy subiendo
						////LOGICA PARA EL SEVENSEG
					end
					else if(actual_clock > 10)begin// cuando pasan los diez segundos paso al siguiente estado, piso 3 subiendo
						first_time = 0;
						state <= SE;
					end
				end//else if(OC_Request == 0)
				
				
				

				
		endcase
			

end//always @ (posedge clk or posedge reset) begin 


always @ (state) begin
	case (state)
		SA:
			out = 2'b10;		
      SB:
         out = 2'b10;
      SC:
         out = 2'b00;
      SD:
         out = 2'b10;
      SE:
         out = 2'b10; 
		SF:
         out = 2'b10; 			
      default:
         out = 2'b00;
   endcase // case (state)
end // always @ (state)
assign reset_clock = c_reset;
assign UD_Answer = reg_UDAnswer;
assign Actual_Stage = reg_ActualStage;
assign Delay = reg_Delay;
assign FR_Delay = reg_FRDelay;
assign Solicitud_stage = reg_SolicitudStage;


endmodule
