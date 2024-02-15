// module Div(
// input wire[31:0] RegAOut,       //receives RS
// input wire[31:0] RegBOut,       //receive RT

// input wire clock,
// input wire reset,

// input wire divCtrl,
// output reg divDone,
// output reg div0,                //excp

// output reg[31:0] DivHIOut,      //rest
// output reg[31:0] DivLOOut       //quocient

// );

// reg initialize;                 //ordered to divide
// reg signA;
// reg signB;
// reg signed[31:0] AuxA;
// reg signed[31:0] AuxB;
// reg signed[31:0] Counter;

// initial begin
//     initialize = 1'b1;           //load arguments
// end

// always @(posedge clock) begin
    
//     if(initialize && divCtrl) begin
//         if(RegBOut[32] == 32'b0) begin        //Div by 0 exception control
        
//             div0 = 1'b1;
//             divCtrl = 1'b0;
//             divDone = 1'b1;                                     

//             DivHIOut = 32'b01010101010101010101010101010101;    // for debug purposes
// 			DivLOOut = 32'b01010101010101010101010101010101;    
//         end

//         else begin                            //Set signals for division
//             initialize = 1'b0;
//             Counter = 32'b0;
//             DivHIOut = 32'b0;
// 			DivLOOut = 32'b0;
// 			div0 = 1'b0;
// 			divDone = 1'b0;

//             signA = (RegAOut[31] == 1'b1);
//             signB = (RegBOut[31] == 1'b1);

//             AuxA = signA ? (~RegAOut + 1) : RegAOut;        //aux recebe reg ou seu complemento de 2
//             AuxB = signB ? (~RegBOut + 1) : RegBOut;
//         end
//     end

//     else begin
//         if(divCtrl) begin             //process of division
//             if(AuxA < AuxB)
//             begin
//                 DivHIOut = signA ? (~AuxA + 1) : AuxA;                  //takes complemento de 2

//                 if(signA || signB)
//                 begin
//                 DivLOOut = (signA ^ signB) ? ~Counter + 1 : Counter;  //takes complemento de 2
//                 end

//                 else begin DivLOOut = Counter; end
//             end

//             divDone = 1'b1;
//         end
//         else begin                    //end of process of division
//             initialize = 1'b1;      
//         end
//     end

//     if(reset)
//     begin
//         Counter = 32'b0;
// 		initialize = 1'b1;
// 		DivHIOut = 32'b0;
// 		DivLOOut = 32'b0;
// 		div0 = 1'b0;
// 		AuxA = 32'b0;
// 		AuxB = 32'b0;
// 		divDone = 1'b0;
// 		signA = 1'b0;
// 		signB = 1'b0;
//         //coisas de reset
//     end
// end

// endmodule

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

reg Initialize;
reg signA;
reg signB;
reg signed[31:0] AuxA;
reg signed[31:0] AuxB;
reg signed[31:0] Contador;

initial begin//setar variaveis
	Initialize = 1'b1;
end

always @(posedge clock) begin
	if(reset == 1'd1) begin
			Contador = 32'b0;
			Initialize = 1'b1;
			DivHIOut = 32'b0;
			DivLOOut = 32'b0;
			Div0 = 1'b0;
			AuxA = 32'b0;
			AuxB = 32'b0;
			DivDone = 1'b0;
			signA = 1'b0;
			signB = 1'b0;
	end
	else if(DivCtrl == 1'd1 && Initialize == 1'b1) begin
			Contador = 32'b0;
			Initialize = 1'b0;//muda o valor de Initialize para nao resetar no clock seguinte
			DivHIOut = 32'b0;
			DivLOOut = 32'b0;
			Div0 = 1'b0;
			DivDone = 1'b0;
			signA = 1'b0;
			signB = 1'b0;
			if(RegAOut[31] == 1'b1) begin//Se for negativo, guarda informacao e faz complemento 2
				signA = 1'b1;
				AuxA = ~RegAOut + 1;
			end
			else begin
				AuxA = RegAOut;//Se n�o, pega o valor na tora
			end
			if(RegBOut[31] == 1'b1)begin//Realiza mesmo processo com B
				signB = 1'b1;
				AuxB = ~RegBOut + 1;
			end
			else begin
				AuxB = RegBOut;
			end
			
			if(AuxB == 32'b0) begin
				Div0 = 1'b1;//Coloca o maior valor possivel, facilitar debug, e foi o mais logico da Div0
				DivDone = 1'b1;
				DivHIOut = 32'b01111111111111111111111111111111;
				DivLOOut = 32'b01111111111111111111111111111111;
			end
	end
	else if(DivCtrl == 1'd1) begin
		if(AuxA < AuxB) begin
			//Se o resto for menor que o valor a ser dividido, para de dividir
			//7   3| 2  1
			//7  -3|-2  1
			//-7  3|-2 -1
			//-7 -3| 2 -1
			//Estes Ifs seguem este padrao
			if(signA == 1'b1)begin
				//Transforma negativo
				DivHIOut = ~AuxA + 1;
			end
			else begin
				DivHIOut = AuxA;
			end
			if(signB == 1'b1 && signA == 1'b1)begin
				//Transforma negativo, se A tiver sido negativo
				//vai colocar de volta para positivo
				DivLOOut = Contador;
			end
			else if(signA == 1'b1)begin
				//Transforma negativo
				DivLOOut = ~Contador + 1;
			end
			else if(signB == 1'b1)begin
				//Transforma negativo
				DivLOOut = ~Contador + 1;
			end
			else begin
				DivLOOut = Contador;
			end
			DivDone = 1'b1;//Informa que o Div foi finalizado
		end 
		else begin
			AuxA = AuxA - AuxB;//Salva a subtracao para poder ver qual o resto
			Contador = Contador + 1;//Incrementa resultado
		end
	end else begin
		Initialize = 1'b1;
	end
end

endmodule