`timescale 1ns / 1ps

module segment_controller(
	 input clk,
	 input [1:0] currentFloor,
	 input UD_state,
	 input OC_state,
	 input Stop,
	 output [3:0] seg_selector,
    output [8:0] segments
    );
	 
	 reg [8:0] out_reg;
	 reg [3:0] sel_reg;
	
	initial begin
		sel_reg = 4'b1110;
		segData=0;//Ojo antes no estaba
	end
	
	localparam N = 18;
	reg [N-1:0]count;
	reg [4:0]segData;
	
	always @ (posedge clk)
		count <= count + 1'd1;
		always @ (*)begin
			case(count[N-1:N-2])
			
			2'b00 :
				begin
					segData[0] <= currentFloor[0];
					segData[1] <= currentFloor[1];
					segData[2] <= 0;
					segData[3] <= 0;
					sel_reg = 4'b1110;
				end
			2'b01:	
				begin
					segData <= 4'd6;
					sel_reg = 4'b1101;
				end
			2'b10:	
				begin
					segData[0] <= OC_state;
					segData[1] <= 0;
					segData[2] <= 1;
					segData[3] <= 0;
					sel_reg = 4'b1011;
				end
			2'b11:	
				begin
					if(Stop == 1)
						segData <= 4'd10;
					else begin
						segData[0] <= UD_state;
						segData[1] <= 0;
						segData[2] <= 0;
						segData[3] <= 1;
					end
					sel_reg = 4'b0111;
				end
			endcase
	end
	
	
	always @ (*)
	begin
	case (segData)
		0 : out_reg = 8'b10011111; //Piso 1 : 1
		1 : out_reg = 8'b00100101; //Piso 2 : 2
		2 : out_reg = 8'b00001101; //Piso 3 : 3
		3 : out_reg = 8'b10011001; //Piso 4 : 4
		4 : out_reg = 8'b01100011; //Puertas Cerradas : C
		5 : out_reg = 8'b00010001; //Puertas Abiertas : A
		6 : out_reg = 8'b00110001; //Piso : P
		8 : out_reg = 8'b11000001; //Bajando : b
		9 : out_reg = 8'b01001001; //Subiendo : S
		10: out_reg = 8'b11111101; // - En espera
		default : out_reg = 8'b11111111;
	endcase
	end
	
	assign segments = out_reg;
	assign seg_selector = sel_reg;
endmodule