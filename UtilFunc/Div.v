module Div (
input wire[31:0] RegAOut,
input wire[31:0] RegBOut,
input wire clock,
input wire reset,
input wire DivCtrl,
output reg DivDone,
output reg Div0,
output reg[31:0] DivHIOut,
output reg[31:0] DivLOOut
);

reg init;
reg signA;
reg signB;
reg signed[31:0] regAuxA;
reg signed[31:0] regAuxB;
reg signed[31:0] counter;

initial begin
	init = 1'b1;
end

always @(posedge clock) begin
	if(reset == 1'd1) begin
			counter = 32'b0;
			init = 1'b1;
			DivHIOut = 32'b0;
			DivLOOut = 32'b0;
			Div0 = 1'b0;
			regAuxA = 32'b0;
			regAuxB = 32'b0;
			DivDone = 1'b0;
			signA = 1'b0;
			signB = 1'b0;
	end
	else if(DivCtrl == 1'd1 && init == 1'b1) begin	//primeiro ciclo para setar sinais
			counter = 32'b0;
			init = 1'b0;
			DivHIOut = 32'b0;
			DivLOOut = 32'b0;
			Div0 = 1'b0;
			DivDone = 1'b0;
			signA = 1'b0;
			signB = 1'b0;
			if(RegAOut[31] == 1'b1) begin
				signA = 1'b1;
				regAuxA = ~RegAOut + 1;	// complemento de 2 se negativo
			end
			else begin
				regAuxA = RegAOut;
			end
			if(RegBOut[31] == 1'b1)begin
				signB = 1'b1;
				regAuxB = ~RegBOut + 1;
			end
			else begin
				regAuxB = RegBOut;
			end
			
			if(regAuxB == 32'b0) begin
				Div0 = 1'b1;
				DivDone = 1'b1;
				DivHIOut = 32'b01111111111111111111111111111111;
				DivLOOut = 32'b01111111111111111111111111111111;
			end
	end
	else if(DivCtrl == 1'd1) begin
		if(regAuxA < regAuxB) begin
			
			if(signA == 1'b1)begin
				DivHIOut = ~regAuxA + 1;
			end
			else begin
				DivHIOut = regAuxA;
			end
			if(signB == 1'b1 && signA == 1'b1)begin
				DivLOOut = counter;
			end
			else if(signA == 1'b1)begin
				DivLOOut = ~counter + 1;
			end
			else if(signB == 1'b1)begin
				DivLOOut = ~counter + 1;
			end
			else begin
				DivLOOut = counter;
			end
			DivDone = 1'b1;	//Divisao finalizada
		end 
		else begin
			regAuxA = regAuxA - regAuxB;
			counter = counter + 1;
		end
	end else begin

		DivDone = 1'b0;
		init = 1'b1;

	end
end

endmodule