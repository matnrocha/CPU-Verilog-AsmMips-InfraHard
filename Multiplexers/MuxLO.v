module MuxLO (
input wire[31:0] 
    DivLOOut,
    MultLOOut,
input wire 
    LOCtrl,
output reg[31:0] 
    MuxLOOut
);

parameter 
Ent0 = 0, 
Ent1 = 1;

always @(*) begin
	case(LOCtrl)
		Ent0:
			MuxLOOut <= DivLOOut;
		Ent1:
			MuxLOCtrlOut <= MultLOOut;
	endcase
end

endmodule
