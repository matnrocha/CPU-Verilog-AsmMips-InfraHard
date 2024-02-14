module SignEx16to32 (
input wire[15:0] Ent0,      //from Offset
output reg[31:0] result     //extended signal
);

always @(*) begin
	result <= {{16'd0},Ent0};       //concatenate with 16 zeros
end

endmodule