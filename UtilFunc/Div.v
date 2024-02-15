module Div(
input wire[31:0] RegAOut,       //receives RS
input wire[31:0] RegBOut,       //receive RT

input wire clock,
input wire reset,   

input wire divCtrl,
output reg divDone,
output reg div0,                //excp

output reg[31:0] DivHIOut,      //rest
output reg[31:0] DivLOOut       //quocient

);

reg initialize;                 //ordered to divide
reg signA;
reg signB;
reg signed[31:0] AuxA;
reg signed[31:0] AuxB;
reg signed[31:0] Counter;

initial begin
    initialize = 1'b1;           //load arguments
end

always @(posedge clock) begin
    
    if(initialize && divCtrl) begin
        if(RegBOut[32] == 32'b0) begin        //Div by 0 exception control
        
            div0 = 1'b1;
            divCtrl = 1'b0;
            divDone = 1'b1;                                     

            DivHIOut = 32'b01010101010101010101010101010101;    // for debug purposes
			DivLOOut = 32'b01010101010101010101010101010101;    
        end

        else begin                            //Set signals for division
            initialize = 1'b0;
            Counter = 32'b0;
            DivHIOut = 32'b0;
			DivLOOut = 32'b0;
			div0 = 1'b0;
			divDone = 1'b0;

            signA = (RegAOut[31] == 1'b1);
            signB = (RegBOut[31] == 1'b1);

            AuxA = signA ? (~RegAOut + 1) : RegAOut;        //aux recebe reg ou seu complemento de 2
            AuxB = signB ? (~RegBOut + 1) : RegBOut;
        end
    end

    else begin
        if(divCtrl) begin             //process of division
            if(AuxA < AuxB)
            begin
                DivHIOut = signA ? (~AuxA + 1) : AuxA;                  //takes complemento de 2

                if(signA || signB)
                begin
                DivLOOut = (signA ^ signB) ? ~Counter + 1 : Counter;  //takes complemento de 2
                end

                else begin DivLOOut = Counter; end
            end

            divDone = 1'b1;
        end
        else begin                    //end of process of division
            initialize = 1'b1;      
        end
    end

    if(reset)
    begin
        Counter = 32'b0;
		initialize = 1'b1;
		DivHIOut = 32'b0;
		DivLOOut = 32'b0;
		div0 = 1'b0;
		AuxA = 32'b0;
		AuxB = 32'b0;
		divDone = 1'b0;
		signA = 1'b0;
		signB = 1'b0;
        //coisas de reset
    end
end

endmodule
