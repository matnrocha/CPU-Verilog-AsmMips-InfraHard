module MuxShiftAmt (
input wire[4:0] 
    RegBOutC,
    Shamt, 
    ExtendedOffset,
input wire[1:0] 
    ShiftAmt,
output reg[4:0] 
    MuxShiftAmtOut
);

parameter 
    Ent0 = 0, 
    Ent1 = 1,
    Ent2 = 2;

always @(*) begin
	case(ShiftAmt)
		Ent0:
			MuxShiftAmtOut <= RegBOutC;
		Ent1:
			MuxShiftAmtOut <= Shamt;
        Ent2:
            MuxShiftAmtOut <= ExtendedOffset;
	endcase
end

endmodule