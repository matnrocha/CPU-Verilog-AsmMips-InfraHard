module LoadFunct(
input wire [15:0] 
    Offset,
output reg [5:0] 
    Funct
);

always @(*) begin
	Funct <= Offset[5:0];
end

endmodule
