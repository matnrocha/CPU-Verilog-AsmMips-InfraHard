module Mult (
input wire[31:0] RegAOut,
input wire[31:0] RegBOut,
input wire clock,
input wire reset,
input wire MultCtrl,
output reg MultDone,
output reg[31:0] MultHIOut,
output reg[31:0] MultLOOut
);


reg init;
reg [6:0] counter;
reg signed [64:0] AMultCompPos;
reg signed [64:0] Multiplier;
reg signed [31:0] NegativeBTemp;
reg signed [64:0] Temp;

initial begin
	init = 1'b1;
end

always @ (posedge clock) begin
	if(reset == 1'd1) begin
		AMultCompPos[64:0] = 65'b0;
		Multiplier[64:0] = 65'b0;
		counter = 7'b0;
		init = 1'b1;
		NegativeBTemp[31:0] = 32'b0;
		Temp[64:0] = 65'b0;
		MultDone = 1'b0;
		MultHIOut[31:0] = 32'b0;
		MultLOOut[31:0] = 32'b0;
	end 
	else if(MultDone == 1'b1) begin
		AMultCompPos = {32'b0, RegAOut[31:0], 1'b0};
		Multiplier = {RegBOut[31:0], 33'b0};
		NegativeBTemp = ~RegBOut + 1'b1;
		Temp = {NegativeBTemp, 33'b0};
		counter = 7'b0;
		MultDone = 1'b0;
	end
	else if(MultCtrl == 1'd1 && init == 1'b1) begin
		AMultCompPos = {32'b0, RegAOut[31:0], 1'b0};
		Multiplier = {RegBOut[31:0], 33'b0};
		NegativeBTemp = ~RegBOut + 1'b1;
		Temp = {NegativeBTemp, 33'b0};
		counter = 7'b0;
		MultDone = 1'b0;
		init = 1'b0;
	end 
	else if(MultCtrl == 1'd1) begin
		if (counter < 7'b0100000) begin
			if(AMultCompPos[1] == AMultCompPos[0]) begin
			end
			else if (AMultCompPos[1] == 1'b1) begin
				AMultCompPos = AMultCompPos + Temp;
			end
			else if (AMultCompPos[1] == 1'b0) begin
				AMultCompPos = AMultCompPos + Multiplier;
			end
			AMultCompPos = AMultCompPos >>> 1;
			counter = counter + 1;
		end else if (counter == 7'b0100000) begin
			MultHIOut[31:0] = AMultCompPos[64:33];
			MultLOOut[31:0] = AMultCompPos[32:1];
			MultDone = 1'b1;
			init = 1'b1;
		end
	end
	
end

endmodule