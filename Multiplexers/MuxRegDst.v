module MuxRegDst (
input wire[4:0] 
    RS,     // [25:21]
    RT,     // [20:16]
    RD,     // [15:11]
input wire[2:0] 
    RegDst,
output reg[4:0] 
    MuxRegDstOut
);
parameter 
    Ent0 = 0, 
    Ent1 = 1, 
    Ent2 = 2, 
    Ent3 = 3, 
    Ent4 = 4;

always @(*) begin
	case(RegDst)
		Ent0:
			MuxRegDstOut <= RS;
		Ent1:
			MuxRegDstOut <= RT;
		Ent2:
			MuxRegDstOut <= RD;
		Ent3:
			MuxRegDstOut <= 5'd29;
		Ent4:
			MuxRegDstOut <= 5'd31;
	endcase
end

endmodule