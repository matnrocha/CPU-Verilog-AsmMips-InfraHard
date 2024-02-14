module MuxAluSrcB (
input wire[31:0] 
    RegBOut,
    ExtendedOffset,
    RegMDROut,
    ExtendedOffsetLeft2,
input wire[2:0] 
    AluSrcB,
output reg[31:0] 
    MuxAluSrcBOut
);

parameter 
Ent0 = 3'b000, 
Ent1 = 3'b001, 
Ent2 = 3'b010, 
Ent3 = 3'b011, 
Ent4 = 3'b100;

always @(*) begin
	case(AluSrcB)
		Ent0:
			MuxAluSrcBOut <= RegBOut;
		Ent1:
			MuxAluSrcBOut <= 32'd4;
		Ent2:
			MuxAluSrcBOut <= ExtendedOffset;
		Ent3:
			MuxAluSrcBOut <= RegMDROut;
		Ent4:
			MuxAluSrcBOut <= ExtendedOffsetLeft2;
	endcase
end

endmodule