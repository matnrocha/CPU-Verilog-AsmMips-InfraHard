module MuxPCSrc (
input wire[31:0] 
    RegAOut,
    AluResult,
    IncondJump, 
    RegAluOutOut,
    RegEPCOut,
    ExcpCode,           //exception code loaded from memory
input wire[2:0] 
    PCSrc,
output reg[31:0] 
    MuxPCSrcOut
);

parameter 
    Ent0 = 0, 
    Ent1 = 1, 
    Ent2 = 2, 
    Ent3 = 3, 
    Ent4 = 4, 
    Ent5 = 5;

always @(*) begin
	case(PCSrc)
		Ent0:
			MuxPCSrcOut <= RegAOut;
		Ent1:
			MuxPCSourceOut <= AluResult;
		Ent2:
			MuxPCSourceOut <= IncondJump;
		Ent3:
			MuxPCSourceOut <= RegAluOutOut;
		Ent4:
			MuxPCSourceOut <= RegEPCOut;
		Ent5:
			MuxPCSourceOut <= ExcpCode;
	endcase
end

endmodule