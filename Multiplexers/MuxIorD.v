module MuxIorD (
input wire[31:0] 
    RegPCOut,
    MuxExcepCtrlOut,
    AluResult,
    RegAluOutOut,
    RegAOut,
input wire[2:0] 
    IorD,
output reg[31:0] 
    MuxIorDOut
);
parameter 
    Ent0 = 0, 
    Ent1 = 1, 
    Ent2 = 2, 
    Ent3 = 3, 
    Ent4 = 4;

always @(*) begin
	case(IorD)
		Ent0:
			MuxIorDOut <= RegPCOut;
		Ent1:
			MuxIorDOut <= MuxExcepCtrlOut;
		Ent2:
			MuxIorDOut <= AluResult;
		Ent3:
			MuxIorDOut <= RegAluOutOut;
		Ent4:
			MuxIorDOut <= RegAOut;
	endcase
end

endmodule