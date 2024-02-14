module MuxExcp (
input wire[1:0] 
    ExcpCtrl,
output reg[31:0] 
    MuxExpCtrlOut
);

parameter 
    Ent0 = 0, 
    Ent1 = 1, 
    Ent2 = 2;

always @(*) begin
	case(ExcpCtrl)
		Ent0:
			MuxExpCtrlOut <= 32'd253;
		Ent1:
			MuxExpCtrlOut <= 32'd254;
		Ent2:
			MuxExpCtrlOut <= 32'd255;
	endcase
end

endmodule