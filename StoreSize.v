module StoreSize (
input wire[31:0] 
    RegBOut,
    RegMDROut,
input wire[1:0] 
    VMCtrl,
output reg[31:0] 
    VMCtrlOut
);

parameter 
    Ent0 = 0, 
    Ent1 = 1, 
    Ent2 = 2;

always @(*) begin
	case(VMCtrl)
		Ent0:
			VMCtrlOut <= RegBOut;                               //Store FullWord
		Ent1:
			VMCtrlOut <= {RegMDROut[31:16],RegBOut[15:0]};      //Store HalfWord
		Ent2:
			VMCtrlOut <= {RegMDROut[31:8],RegBOut[7:0]};        //Store ByteWord
	endcase
end

endmodule
