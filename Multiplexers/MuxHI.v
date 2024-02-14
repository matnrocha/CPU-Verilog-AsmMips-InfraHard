module MuxHI (
input wire[31:0] 
    DivHIOut,
    MUltHIOut,
input wire 
    HICtrl,
output reg[31:0] 
    MuxHIOut
);

parameter 
Ent0 = 0, 
Ent1 = 1;

always @(*) begin
	case(HICtrl)
		Ent0:
			MuxHIOut <= DivHIOut;
		Ent1:
			MuxHIOut <= MUltHIOut;
	endcase
end

endmodule
