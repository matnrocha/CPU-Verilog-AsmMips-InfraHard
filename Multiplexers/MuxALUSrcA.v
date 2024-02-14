module MuxAluSrcA (
input wire[31:0] 
    RegPCOut,
    RegBOut,
    RegAOut,
    RegMDROut,
input wire[1:0] 
    AluSrcA,
output reg[31:0] 
    MuxAluSrcAOut
);

parameter 
Ent0 = 0, 
Ent1 = 1, 
Ent2 = 2, 
Ent3 = 3;

always @(*) begin
	case(AluSrcA)
		Ent0:
			MuxAluSrcAOut <= RegPCOut;
		Ent1:
			MuxAluSrcAOut <= RegBOut;
		Ent2:
			MuxAluSrcAOut <= RegAOut;
		Ent3:
			MuxAluSrcAOut <= RegMDROut;
	endcase
end

endmodule