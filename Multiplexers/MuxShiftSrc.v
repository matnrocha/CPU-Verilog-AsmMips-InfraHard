module MuxShiftSrc (
input wire[31:0] 
    RegAOut,
    RegBOut,
input wire 
    ShiftSrc,
output reg[31:0] 
    MuxSSrcOut
);

parameter 
    Ent0 = 0, 
    Ent1 = 1;
always @(*) begin
	case(ShiftSrc)
		Ent0:
			MuxSSrcOut <= RegBOut;
		Ent1:
			MuxSSrcOut <= RegAOut;
	endcase
end

endmodule