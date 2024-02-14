module LoadSize (
input wire[31:0]
    RegMDROut,
input wire[1:0]
    LSCtrl,
output reg[31:0]
    LSCtrlOut
);

parameter
    Ent0 = 0, 
    Ent1 = 1, 
    Ent2 = 2;

always @(*) begin
	case(LSCtrl)
		Ent0:
			LSCtrlOut <= RegMDROut;                 //FullWord
		Ent1:
			LSCtrlOut <= {16'd0,RegMDROut[15:0]};   //HalfWord
		Ent2:
			LSCtrlOut <= {24'd0,RegMDROut[7:0]};    //ByteWord
	endcase
end
endmodule