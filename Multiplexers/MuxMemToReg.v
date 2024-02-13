module MuxMemToReg (
input wire[31:0]                                    //Inputs
LT, 
Load,
RegDOut,
RegHIOut,
RegLOOut,
RegBOut,
RegAOut,
RegAluOut,
OffsetLeft16, 
OffsetLeft2,
input wire[3:0] MemToReg,                           //controler		
output reg[31:0] MuxMemToRegOut                     // Output
);

parameter 
Ent0 = 0, 
Ent1 = 1, 
Ent2 = 2, 
Ent3 = 3, 
Ent4 = 4, 
Ent5 = 5, 
Ent6 = 6, 
Ent7 = 7, 
Ent8 = 8, 
Ent9 = 9, 
Ent10 = 10;

always @(*) begin
	case(MemToReg)
		Ent0:
			MuxMemToRegOut <= LT;
		Ent1:
			MuxMemToRegOut <= Load;
		Ent2:
			MuxMemToRegOut <= 32'd227;
		Ent3:
			MuxMemToRegOut <= RegDOut;
		Ent4:
			MuxMemToRegOut <= RegHIOut;
		Ent5:
			MuxMemToRegOut <= RegLOOut;
		Ent6:
			MuxMemToRegOut <= RegBOut;
		Ent7:
			MuxMemToRegOut <= RegAOut;
		Ent8:
			MuxMemToRegOut <= RegAluOut;
		Ent9:
			MuxMemToRegOut <= OffsetLeft16;
		Ent10:
			MuxMemToRegOut <= OffsetLeft2;
	endcase
end

endmodule