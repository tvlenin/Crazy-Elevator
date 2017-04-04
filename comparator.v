`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:11:06 03/26/2017 
// Design Name: 
// Module Name:    comparator 
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
module comparator(
	input [1:0] DataA,
	input [1:0] DataB,
   output reg equal,
   output reg lower,
   output reg greater
   );
	
	always @* begin
      if (DataA<DataB) begin
        equal = 0;
        lower = 1;
        greater = 0;
      end
      else if (DataA==DataB) begin
        equal = 1;
        lower = 0;
        greater = 0;
      end
      else begin
        equal = 0;
        lower = 0;
        greater = 1;
      end
    end

endmodule
