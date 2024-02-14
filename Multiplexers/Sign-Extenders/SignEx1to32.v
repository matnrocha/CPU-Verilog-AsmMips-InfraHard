module SignEx1to32 (
input wire ent0,			
output reg[31:0] result	    //extended signal	
);

always @(*) begin
	result <= {{31'd0},ent0};       //concatenate with 31 zeros
end

endmodule