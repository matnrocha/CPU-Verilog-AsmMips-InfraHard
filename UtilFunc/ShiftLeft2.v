module ShiftLeft2(
input wire [31:0] 
    Ent0,
output reg [31:0] 
    EntLeft2
);

always @(*) begin
	EntLeft2 <= Ent0 << 2;
end

endmodule
