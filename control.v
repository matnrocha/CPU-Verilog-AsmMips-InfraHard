module Control(
input 
    clock, 
    reset,

input wire [5:0] 
    Opcode, 
    Funct,

output reg
    WriteCond,
    PCWrite,
    RegWrite,
    Wr,
    IRWrite,
    WriteRegA,
    WriteRegB,
    AluOutControl,
    EPCWrite,
    ShiftSrc,
    DivCtrl,
    MultCtrl,
    HICtrl,
    LOCtrl,
    WriteHI,
    WriteLO,
    MDRCtrl,

input wire
    DivDone,
    Div0,
    MultDone,
    Overflow,
    Negativo,
    Zero,
    EQ,
    GT,
    LT,

output reg [1:0]
    LSControl,
    SSControl,
    ExceptionCtrl,
    AluSrcA,
	ShiftAmt,

output reg [2:0]
    AluSrcB,
    AluOp,
    PCSource,
    IorD,
    ShiftCtrl,
    RegDst,

output reg [3:0]
    MemToReg,

output reg [6:0]
    state
);


// ESTADOS
parameter FETCH = 7'd00;
parameter WAITFETCH = 7'd01;
parameter WAITFETCH2 = 7'd02;
parameter DECODE = 7'd03;
parameter OPERATE = 7'd04;
parameter ADDIUClk2 = 7'd05;
parameter ANDClk2 = 7'd06;
parameter SHIFTOperationClk3 = 7'd07;
parameter XCHGClk2 = 7'd08;
parameter SRAMClk2 = 7'd09;       
parameter SRAMClk3 = 7'd10;
parameter SRAMClk4 = 7'd11;
parameter SRAMClk5 = 7'd12;       
parameter SRAMClk6 = 7'd13;        
parameter LBClk2 = 7'd14;
parameter LBClk3 = 7'd15;
parameter LHClk2 = 7'd16;
parameter LHClk3 = 7'd17;
parameter LWClk2 = 7'd18;
parameter LWClk3 = 7'd19;
parameter SBClk2 = 7'd20;
parameter SBClk3 = 7'd21;
parameter SHClk2 = 7'd22;
parameter SHClk3 = 7'd23;
parameter SWClk2 = 7'd24;
parameter SWClk3 = 7'd25;
parameter BEQClk2 = 7'd26;
parameter BGTClk2 = 7'd27;
parameter BLEClk2 = 7'd28;
parameter SWClk4 = 7'd30;
parameter LHClk4 = 7'd31;
parameter LWClk4 = 7'd32;
parameter LBClk4 = 7'd33;
parameter SHClk4 = 7'd34;
parameter SLTClk2 = 7'd35;
parameter SBClk4 = 7'd36;
parameter SLTIClk2 = 7'd37;
parameter SLLClk2 = 7'd38;
parameter SLLVClk2 = 7'd39;
parameter SRLClk2 = 7'd40;
parameter SRAClk2 = 7'd41;
parameter SRAVClk2 = 7'd42;
parameter BNEClk2 = 7'd43;
parameter ADDIClk2 = 7'd44;
parameter ExceptionByteToPc = 7'd45;
parameter ExceptionWait = 7'd46;
parameter ADD_SUBClk2 = 7'd47;
parameter JALClk2 = 7'd48;
parameter SRAMClk7 = 7'd49;       
parameter MULTClk2 = 7'd64;
parameter DIVClk2 = 7'd65;
parameter DIVClk3 = 7'd66;
parameter WAIT = 7'd127;

// OPCODES
parameter RINSTRUCTION = 6'h00;
parameter SRAM = 6'h01;
parameter ADDI = 6'h08;
parameter ADDIU = 6'h09;
parameter BEQ = 6'h04;
parameter BNE = 6'h05;
parameter BLE = 6'h06;
parameter BGT = 6'h07;
parameter LB = 6'h20;
parameter LH = 6'h21;
parameter LUI = 6'h0f;
parameter LW = 6'h23;
parameter SB = 6'h28;
parameter SH = 6'h29;
parameter SLTI = 6'h0a;
parameter SW = 6'h2b;
parameter J = 6'h02;
parameter JAL = 6'h03;

// FUNCTS
parameter ADD = 6'h20;
parameter AND = 6'h24;
parameter DIV = 6'h1a;
parameter MULT = 6'h18;
parameter JR = 6'h08;
parameter MFHI = 6'h10;
parameter MFLO = 6'h12;
parameter SLL = 6'h00;
parameter SLLV = 6'h04;
parameter SLT = 6'h2a;
parameter SRA = 6'h03;
parameter SRAV = 6'h07;
parameter SRL = 6'h02;
parameter SUB = 6'h22;
parameter BREAK = 6'h0d;
parameter RTE = 6'h13;
parameter XCHG = 6'h05;


initial begin
	state = FETCH;
end


always @(posedge clock) begin
		if (reset) begin
			
                RegDst = 3'b011;
                MemToReg = 4'b0010;
                RegWrite = 1'b1;
                            
                PCSource = 3'b000;
                PCWrite = 1'b0;
                WriteCond = 1'b0;
                AluSrcA = 2'b00;
                IRWrite = 1'b0;
                WriteRegA = 1'b0;
                WriteRegB = 1'b0;
                IorD = 3'b000;
                AluSrcB = 3'b000;
                AluOp = 3'b000;
                AluOutControl = 1'b0;
                MDRCtrl = 1'b0;
                LSControl = 2'b00;
                SSControl = 2'b00;
                LOCtrl = 1'b0;
                WriteHI = 1'b0;
                WriteLO = 1'b0;
                ExceptionCtrl = 2'b00;
                HICtrl = 1'b0;
                ShiftSrc = 1'b0;
                MultCtrl = 1'b0;
                DivCtrl = 1'b0;
                Wr = 1'b0;
                ShiftCtrl = 3'b000;
                ShiftAmt = 1'b0;
                EPCWrite = 1'b0;
                state = FETCH;
		end			
		else begin
			case (state)
				FETCH: begin
				
                    IorD = 3'b000;
					PCSource = 3'b001;
                    PCWrite = 1'b1;
                    AluSrcA = 2'b00;
					AluSrcB = 3'b001;
                    AluOp = 3'b001;
                    Wr = 1'b0;
				
					WriteCond = 1'b0;
					IRWrite = 1'b0;
					WriteRegB = 1'b0;
					MemToReg = 4'b0000;
					RegWrite = 1'b0;
					MDRCtrl = 1'b0;
					LSControl = 2'b00;
					SSControl = 2'b00;
					WriteRegA = 1'b0;
					WriteLO = 1'b0;
					RegDst = 3'b000;
					WriteHI = 1'b0;
					AluOutControl = 1'b0;
					HICtrl = 1'b0;
					LOCtrl = 1'b0;
					DivCtrl = 1'b0;
					ExceptionCtrl = 2'b00;
					MultCtrl = 1'b0;
					ShiftAmt = 1'b0;
					ShiftCtrl = 3'b000;
					ShiftSrc = 1'b0;
					EPCWrite = 1'b0;
					state = WAITFETCH;
					end
				WAITFETCH: begin
					        
					    PCSource = 3'b000;
					    WriteCond = 1'b0;
					    IorD = 3'b000;
					    Wr = 1'b0;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b000;
					    AluOp = 3'b000;
					    PCWrite = 1'b0;
					    AluOutControl = 1'b0;
					    MemToReg = 4'b0000;
					    RegWrite = 1'b0;
					    RegDst = 3'b000;
					    LSControl = 2'b00;
					    SSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    MDRCtrl = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    WriteHI = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    MultCtrl = 1'b0;
					    EPCWrite = 1'b0;
					    ShiftCtrl = 3'b000;
					    state = WAITFETCH2;
					end
					
					WAITFETCH2: begin
					
                        IRWrite = 1'b1;
					           
					    PCSource = 3'b000;
					    PCWrite = 1'b0;
					    WriteCond = 1'b0;
					    Wr = 1'b0;
					    WriteRegA = 1'b0;
					    IorD = 3'b000;
					    AluSrcA = 2'b00;
					    WriteRegB = 1'b0;
					    AluSrcB = 3'b000;
					    AluOutControl = 1'b0;
					    RegDst = 3'b000;
					    AluOp = 3'b000;
					    RegWrite = 1'b0;
					    MDRCtrl = 1'b0;
					    MemToReg = 4'b0000;
					    LSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    WriteHI = 1'b0;
					    SSControl = 2'b00;
					    WriteLO = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    HICtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftCtrl = 3'b000;
					    ShiftAmt = 1'b0;
					    ShiftSrc = 1'b0;
					    EPCWrite = 1'b0;
					    state = DECODE;
					end
				DECODE: begin
					
                        WriteRegA = 1'b1;
					    WriteRegB = 1'b1;
                        AluOp = 3'b001;
                        AluOutControl = 1'b1;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b100;
					
					    PCSource = 3'b000;
					    PCWrite = 1'b0;
					    WriteCond = 1'b0;
					    Wr = 1'b0;
					    IorD = 3'b000;
					    MemToReg = 4'b0000;
					    RegDst = 3'b000;
					    SSControl = 2'b00;
					    IRWrite = 1'b0;
					    RegWrite = 1'b0;
					    MDRCtrl = 1'b0;
					    WriteLO = 1'b0;
					    ExceptionCtrl = 2'b00;
					    LSControl = 2'b00;
					    WriteHI = 1'b0;
					    MultCtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
						ShiftSrc = 1'b0;
					    HICtrl = 1'b0;
					    EPCWrite = 1'b0;
					    ShiftAmt = 1'b0;
						ShiftCtrl = 3'b000;
					    state = OPERATE;
					end
				OPERATE: begin
					case(Opcode)
						ADDI: begin
							
								AluSrcA = 2'b10;
								AluSrcB = 3'b010;
								AluOutControl = 1'b1;
								AluOp = 3'b001;
								
								PCSource = 3'b000;
								PCWrite = 1'b0;
								WriteCond = 1'b0;
								IorD = 3'b000;
								Wr = 1'b0;
								IRWrite = 1'b0;
								WriteRegA = 1'b0;
								WriteRegB = 1'b0;
								RegDst = 3'b000;
								MemToReg = 4'b0000;
								RegWrite = 1'b0;
								MDRCtrl = 1'b0;
								LSControl = 2'b00;
								SSControl = 2'b00;
								ExceptionCtrl = 2'b00;
								WriteHI = 1'b0;
								WriteLO = 1'b0;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								DivCtrl = 1'b0;
								MultCtrl = 1'b0;
								ShiftSrc = 1'b0;
								ShiftAmt = 1'b0;
								ShiftCtrl = 3'b000;
								EPCWrite = 1'b0;
								state = ADDIClk2;
							end
						ADDIU: begin
                            
                                AluSrcA = 2'b10;
					        	AluSrcB = 3'b010;
                                AluOutControl = 1'b1;
                                AluOp = 3'b001;
					        
					            PCSource = 3'b000;
					            PCWrite = 1'b0;
					            WriteCond = 1'b0;
					            IorD = 3'b000;
					            Wr = 1'b0;
					            IRWrite = 1'b0;
					            WriteRegA = 1'b0;
					            WriteRegB = 1'b0;
					            RegDst = 3'b000;
					            MemToReg = 4'b0000;
					            RegWrite = 1'b0;
					            MDRCtrl = 1'b0;
					            LSControl = 2'b00;
					            SSControl = 2'b00;
					            ExceptionCtrl = 2'b00;
					            WriteHI = 1'b0;
					            WriteLO = 1'b0;
					            HICtrl = 1'b0;
					            LOCtrl = 1'b0;
					            DivCtrl = 1'b0;
					            MultCtrl = 1'b0;
					            ShiftSrc = 1'b0;
					            ShiftAmt = 1'b0;
					            ShiftCtrl = 3'b000;
					            EPCWrite = 1'b0;
					            state = ADDIUClk2;
							end
						BEQ: begin
							
								PCSource = 3'b011;
								AluSrcA = 2'b10;
								AluSrcB = 3'b000;
								AluOp = 3'b111;
							
								PCWrite = 1'b0;
								WriteCond = 1'b0;
								IorD = 3'b000;
								Wr = 1'b0;
								IRWrite = 1'b0;
								WriteRegA = 1'b0;
								WriteRegB = 1'b0;
								AluOutControl = 1'b0;
								RegDst = 3'b000;
								MemToReg = 4'b0000;
								RegWrite = 1'b0;
								MDRCtrl = 1'b0;
								LSControl = 2'b00;
								SSControl = 2'b00;
								ExceptionCtrl = 2'b00;
								WriteHI = 1'b0;
								WriteLO = 1'b0;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								DivCtrl = 1'b0;
								MultCtrl = 1'b0;
								ShiftSrc = 1'b0;
								ShiftAmt = 1'b0;
								ShiftCtrl = 3'b000;
								EPCWrite = 1'b0;
								state = BEQClk2;
							end
						BNE: begin
							
								AluSrcA = 2'b10;
								AluSrcB = 3'b000;
								AluOp = 3'b111;
							 
								WriteCond = 1'b0;
								IorD = 3'b000;
								Wr = 1'b0;
								IRWrite = 1'b0;
								WriteRegA = 1'b0;
								WriteRegB = 1'b0;
								AluOutControl = 1'b0;
								RegDst = 3'b000;
								MemToReg = 4'b0000;
								RegWrite = 1'b0;
								MDRCtrl = 1'b0;
								LSControl = 2'b00;
								SSControl = 2'b00;
								ExceptionCtrl = 2'b00;
								WriteHI = 1'b0;
								WriteLO = 1'b0;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								DivCtrl = 1'b0;
								MultCtrl = 1'b0;
								ShiftSrc = 1'b0;
								ShiftAmt = 1'b0;
								ShiftCtrl = 3'b000;
								EPCWrite = 1'b0;
								state = BNEClk2;
							end
						SRAM: begin
							
								AluSrcA = 2'b10;
								AluSrcB = 3'b010;
								AluOp = 3'b001;
								AluOutControl = 1'b1;
							 
								WriteCond = 1'b0;
							
								IorD = 3'b000;
								Wr = 1'b0;
								IRWrite = 1'b0;
								WriteRegA = 1'b0;
								WriteRegB = 1'b0;
								RegDst = 3'b000;
								MemToReg = 4'b0000;
								RegWrite = 1'b0;
								MDRCtrl = 1'b0;
								LSControl = 2'b00;
								SSControl = 2'b00;
								ExceptionCtrl = 2'b00;
								WriteHI = 1'b0;
								WriteLO = 1'b0;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								DivCtrl = 1'b0;
								MultCtrl = 1'b0;
								ShiftSrc = 1'b0;
								ShiftAmt = 1'b0;
								ShiftCtrl = 3'b000;
								EPCWrite = 1'b0;
								state = SRAMClk2;
						end
						BLE: begin
							
								PCSource = 3'b011;
								AluSrcA = 2'b10;
								AluSrcB = 3'b000;
								AluOp = 3'b111;
							 
								PCWrite = 1'b0;
								WriteCond = 1'b0;
								IorD = 3'b000;
								Wr = 1'b0;
								IRWrite = 1'b0;
								WriteRegA = 1'b0;
								WriteRegB = 1'b0;
								AluOutControl = 1'b0;
								RegDst = 3'b000;
								MemToReg = 4'b0000;
								RegWrite = 1'b0;
								MDRCtrl = 1'b0;
								LSControl = 2'b00;
								SSControl = 2'b00;
								ExceptionCtrl = 2'b00;
								WriteHI = 1'b0;
								WriteLO = 1'b0;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								DivCtrl = 1'b0;
								MultCtrl = 1'b0;
								ShiftSrc = 1'b0;
								ShiftAmt = 1'b0;
								ShiftCtrl = 3'b000;
								EPCWrite = 1'b0;
								state = BLEClk2;
							end
						BGT: begin
							
								PCSource = 3'b011;
								AluSrcA = 2'b10;
								AluSrcB = 3'b000;
								AluOp = 3'b111;
								if(GT == 1) begin
									PCWrite = 1'b1;
								end
							
								PCWrite = 1'b0;
								WriteCond = 1'b0;
								IorD = 3'b000;
								Wr = 1'b0;
								IRWrite = 1'b0;
								WriteRegA = 1'b0;
								WriteRegB = 1'b0;
								AluOutControl = 1'b0;
								RegDst = 3'b000;
								MemToReg = 4'b0000;
								RegWrite = 1'b0;
								MDRCtrl = 1'b0;
								LSControl = 2'b00;
								SSControl = 2'b00;
								ExceptionCtrl = 2'b00;
								WriteHI = 1'b0;
								WriteLO = 1'b0;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								DivCtrl = 1'b0;
								MultCtrl = 1'b0;
								ShiftSrc = 1'b0;
								ShiftAmt = 1'b0;
								ShiftCtrl = 3'b000;
								EPCWrite = 1'b0;
								state = BGTClk2;
							end
						LW: begin
							
								IorD = 3'b010;
								Wr = 1'b0;
								AluOutControl = 1'b1;
								AluSrcA = 2'b10;
								AluSrcB = 3'b010;
								AluOp = 3'b001;
							        
								PCSource = 3'b000;
								PCWrite = 1'b0;
								WriteCond = 1'b0;
								//IorD = 3'b000;
								//Wr = 1'b0;
								IRWrite = 1'b0;
								WriteRegA = 1'b0;
								WriteRegB = 1'b0;
								RegDst = 3'b000;
								MemToReg = 4'b0000;
								RegWrite = 1'b0;
								MDRCtrl = 1'b0;
								LSControl = 2'b00;
								SSControl = 2'b00;
								ExceptionCtrl = 2'b00;
								WriteHI = 1'b0;
								WriteLO = 1'b0;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								DivCtrl = 1'b0;
								MultCtrl = 1'b0;
								ShiftSrc = 1'b0;
								ShiftAmt = 1'b0;
								ShiftCtrl = 3'b000;
								EPCWrite = 1'b0;
								state = LWClk2;
							end
						LH: begin
							
								IorD = 3'b010;
								Wr = 1'b0;
								AluOutControl = 1'b1;
								AluSrcA = 2'b10;
								AluSrcB = 3'b010;
								AluOp = 3'b001;
							        
								PCSource = 3'b000;
								PCWrite = 1'b0;
								WriteCond = 1'b0;
								IRWrite = 1'b0;
								WriteRegA = 1'b0;
								WriteRegB = 1'b0;
								RegDst = 3'b000;
								MemToReg = 4'b0000;
								RegWrite = 1'b0;
								MDRCtrl = 1'b0;
								LSControl = 2'b00;
								SSControl = 2'b00;
								ExceptionCtrl = 2'b00;
								WriteHI = 1'b0;
								WriteLO = 1'b0;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								DivCtrl = 1'b0;
								MultCtrl = 1'b0;
								ShiftSrc = 1'b0;
								ShiftAmt = 1'b0;
								ShiftCtrl = 3'b000;
								EPCWrite = 1'b0;
								state = LHClk2;
							end
						LB: begin
							
								IorD = 3'b010;
								Wr = 1'b0;
								AluOutControl = 1'b1;
								AluSrcA = 2'b10;
								AluSrcB = 3'b010;
								AluOp = 3'b001;
							        
								PCSource = 3'b000;
								PCWrite = 1'b0;
								WriteCond = 1'b0;
								IRWrite = 1'b0;
								WriteRegA = 1'b0;
								WriteRegB = 1'b0;
								RegDst = 3'b000;
								MemToReg = 4'b0000;
								RegWrite = 1'b0;
								MDRCtrl = 1'b0;
								LSControl = 2'b00;
								SSControl = 2'b00;
								ExceptionCtrl = 2'b00;
								WriteHI = 1'b0;
								WriteLO = 1'b0;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								DivCtrl = 1'b0;
								MultCtrl = 1'b0;
								ShiftSrc = 1'b0;
								ShiftAmt = 1'b0;
								ShiftCtrl = 3'b000;
								EPCWrite = 1'b0;
								state = LBClk2;
							end
						SW: begin
							
								IorD = 3'b010;
								Wr = 1'b0;
								AluOutControl = 1'b1;
								AluSrcA = 2'b10;
								AluSrcB = 3'b010;
								AluOp = 3'b001;
								SSControl = 2'b00;
							        
								PCSource = 3'b000;
								PCWrite = 1'b0;
								WriteCond = 1'b0;
								IRWrite = 1'b0;
								WriteRegA = 1'b0;
								WriteRegB = 1'b0;
								RegDst = 3'b000;
								MemToReg = 4'b0000;
								RegWrite = 1'b0;
								MDRCtrl = 1'b0;
								LSControl = 2'b00;
								ExceptionCtrl = 2'b00;
								WriteHI = 1'b0;
								WriteLO = 1'b0;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								DivCtrl = 1'b0;
								MultCtrl = 1'b0;
								ShiftSrc = 1'b0;
								ShiftAmt = 1'b0;
								ShiftCtrl = 3'b000;
								EPCWrite = 1'b0;
								state = SWClk2;
							end
						SH: begin
							
								IorD = 3'b010;
								Wr = 1'b0;
								AluOutControl = 1'b1;
								AluSrcA = 2'b10;
								AluSrcB = 3'b010;
								AluOp = 3'b001;
							    SSControl = 2'b01;
								
							    
								PCSource = 3'b000;
								PCWrite = 1'b0;
								WriteCond = 1'b0;
								IRWrite = 1'b0;
								WriteRegA = 1'b0;
								WriteRegB = 1'b0;
								RegDst = 3'b000;
								MemToReg = 4'b0000;
								RegWrite = 1'b0;
								MDRCtrl = 1'b0;
								LSControl = 2'b00;
								ExceptionCtrl = 2'b00;
								WriteHI = 1'b0;
								WriteLO = 1'b0;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								DivCtrl = 1'b0;
								MultCtrl = 1'b0;
								ShiftSrc = 1'b0;
								ShiftAmt = 1'b0;
								ShiftCtrl = 3'b000;
								EPCWrite = 1'b0;
								state = SHClk2;
							end
						SB: begin
							
								IorD = 3'b010;
								Wr = 1'b0;
								AluOutControl = 1'b1;
								AluSrcA = 2'b10;
								AluSrcB = 3'b010;
								AluOp = 3'b001;
								SSControl = 2'b10;
							        
								PCSource = 3'b000;
								PCWrite = 1'b0;
								WriteCond = 1'b0;
								IRWrite = 1'b0;
								WriteRegA = 1'b0;
								WriteRegB = 1'b0;
								RegDst = 3'b000;
								MemToReg = 4'b0000;
								RegWrite = 1'b0;
								MDRCtrl = 1'b0;
								LSControl = 2'b00;
								ExceptionCtrl = 2'b00;
								WriteHI = 1'b0;
								WriteLO = 1'b0;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								DivCtrl = 1'b0;
								MultCtrl = 1'b0;
								ShiftSrc = 1'b0;
								ShiftAmt = 1'b0;
								ShiftCtrl = 3'b000;
								EPCWrite = 1'b0;
								state = SBClk2;
							end
						LUI: begin
							
								RegDst = 3'b001;
								MemToReg = 4'b1010;
								RegWrite = 1'b1;
							
								PCSource = 3'b000;
								PCWrite = 1'b0;
								WriteCond = 1'b0;
								IorD = 3'b000;
								Wr = 1'b0;
								IRWrite = 1'b0;
								WriteRegA = 1'b0;
								WriteRegB = 1'b0;
								AluSrcA = 2'b00;
								AluSrcB = 3'b000;
								AluOp = 3'b000;
								AluOutControl = 1'b0;
								MDRCtrl = 1'b0;
								LSControl = 2'b00;
								SSControl = 2'b00;
								ExceptionCtrl = 2'b00;
								WriteHI = 1'b0;
								WriteLO = 1'b0;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								DivCtrl = 1'b0;
								MultCtrl = 1'b0;
								ShiftSrc = 1'b0;
								ShiftAmt = 1'b0;
								ShiftCtrl = 3'b000;
								EPCWrite = 1'b0;
								state = WAIT;
							end
						SLTI: begin
							
								AluSrcA = 2'b10;
								AluSrcB = 3'b010;
								AluOp = 3'b111;
							        
								PCSource = 3'b000;
								PCWrite = 1'b0;
								WriteCond = 1'b0;
								IorD = 3'b000;
								Wr = 1'b0;
								IRWrite = 1'b0;
								WriteRegA = 1'b0;
								WriteRegB = 1'b0;
								AluOutControl = 1'b0;
								MDRCtrl = 1'b0;
								LSControl = 2'b00;
								SSControl = 2'b00;
								ExceptionCtrl = 2'b00;
								WriteHI = 1'b0;
								WriteLO = 1'b0;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								DivCtrl = 1'b0;
								MultCtrl = 1'b0;
								ShiftSrc = 1'b0;
								ShiftAmt = 1'b0;
								ShiftCtrl = 3'b000;
								EPCWrite = 1'b0;
								state = SLTIClk2;
							end
						J: begin
							
								PCSource = 3'b010;
								PCWrite = 1'b1;
							
								WriteCond = 1'b0;
								IorD = 3'b000;
								Wr = 1'b0;
								IRWrite = 1'b0;
								WriteRegA = 1'b0;
								WriteRegB = 1'b0;
								AluSrcA = 2'b00;
								AluSrcB = 3'b000;
								AluOp = 3'b000;
								AluOutControl = 1'b0;
								RegDst = 3'b000;
								MemToReg = 4'b0000;
								RegWrite = 1'b0;
								MDRCtrl = 1'b0;
								LSControl = 2'b00;
								SSControl = 2'b00;
								ExceptionCtrl = 2'b00;
								WriteHI = 1'b0;
								WriteLO = 1'b0;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								DivCtrl = 1'b0;
								MultCtrl = 1'b0;
								ShiftSrc = 1'b0;
								ShiftAmt = 1'b0;
								ShiftCtrl = 3'b000;
								EPCWrite = 1'b0;
								state = WAIT;
							end
						JAL: begin
							
				                AluSrcA = 2'b00;
				                AluOp = 3'b000;
				                AluOutControl = 1'b1;      
								PCSource = 3'b010;
								PCWrite = 1'b1;
							
								WriteCond = 1'b0;
								IorD = 3'b000;
								Wr = 1'b0;
								IRWrite = 1'b0;
								WriteRegA = 1'b0;
								WriteRegB = 1'b0;
								AluSrcB = 3'b000;
								RegDst = 3'b000;
								MemToReg = 4'b0000;
								RegWrite = 1'b0;
								MDRCtrl = 1'b0;
								LSControl = 2'b00;
								SSControl = 2'b00;
								ExceptionCtrl = 2'b00;
								WriteHI = 1'b0;
								WriteLO = 1'b0;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								DivCtrl = 1'b0;
								MultCtrl = 1'b0;
								ShiftSrc = 1'b0;
								ShiftAmt = 1'b0;
								ShiftCtrl = 3'b000;
								EPCWrite = 1'b0;
								state = JALClk2;
							end
						RINSTRUCTION: begin
							case(Funct)
								ADD: begin
									
										AluSrcA = 2'b10;
										AluSrcB = 3'b000;
										AluOp = 3'b001;
										AluOutControl = 1'b1;
										
										PCSource = 3'b000;
										PCWrite = 1'b0;
										WriteCond = 1'b0;
										IorD = 3'b000;
										Wr = 1'b0;
										IRWrite = 1'b0;
										WriteRegA = 1'b0;
										WriteRegB = 1'b0;                               
										RegDst = 3'b000;
										MemToReg = 4'b0000;
										RegWrite = 1'b0;
										MDRCtrl = 1'b0;
										LSControl = 2'b00;
										SSControl = 2'b00;
										ExceptionCtrl = 2'b00;
										WriteHI = 1'b0;
										WriteLO = 1'b0;
										HICtrl = 1'b0;
										LOCtrl = 1'b0;
										DivCtrl = 1'b0;
										MultCtrl = 1'b0;
										ShiftSrc = 1'b0;
										ShiftAmt = 1'b0;
										ShiftCtrl = 3'b000;
										EPCWrite = 1'b0;
										state = ADD_SUBClk2;
									end
								AND: begin
									
										AluSrcA = 2'b10;
										AluSrcB = 3'b000;
										AluOp = 3'b011;
										AluOutControl = 1'b1;
											
										PCSource = 3'b000;
										PCWrite = 1'b0;
										WriteCond = 1'b0;
										IorD = 3'b000;
										Wr = 1'b0;
										IRWrite = 1'b0;
										WriteRegA = 1'b0;
										WriteRegB = 1'b0;
										RegDst = 3'b000;
										MemToReg = 4'b0000;
										RegWrite = 1'b0;
										MDRCtrl = 1'b0;
										LSControl = 2'b00;
										SSControl = 2'b00;
										ExceptionCtrl = 2'b00;
										WriteHI = 1'b0;
										WriteLO = 1'b0;
										HICtrl = 1'b0;
										LOCtrl = 1'b0;
										DivCtrl = 1'b0;
										MultCtrl = 1'b0;
										ShiftSrc = 1'b0;
										ShiftAmt = 1'b0;
										ShiftCtrl = 3'b000;
										EPCWrite = 1'b0;
										state = ANDClk2;
									end
								SUB: begin
									
										AluSrcA = 2'b10;
										AluSrcB = 3'b000;
										AluOp = 3'b010;
										AluOutControl = 1'b1;
													
										PCSource = 3'b000;
										PCWrite = 1'b0;
										WriteCond = 1'b0;
										IorD = 3'b000;
										Wr = 1'b0;
										IRWrite = 1'b0;
										WriteRegA = 1'b0;
										WriteRegB = 1'b0;
										RegDst = 3'b000;
										MemToReg = 4'b0000;
										RegWrite = 1'b0;
										MDRCtrl = 1'b0;
										LSControl = 2'b00;
										SSControl = 2'b00;
										ExceptionCtrl = 2'b00;
										WriteHI = 1'b0;
										WriteLO = 1'b0;
										HICtrl = 1'b0;
										LOCtrl = 1'b0;
										DivCtrl = 1'b0;
										MultCtrl = 1'b0;
										ShiftSrc = 1'b0;
										ShiftAmt = 1'b0;
										ShiftCtrl = 3'b000;
										EPCWrite = 1'b0;
										state = ADD_SUBClk2;
									end
								DIV: begin
									
										DivCtrl = 1'b1;
									        
										PCSource = 3'b000;
										PCWrite = 1'b0;
										WriteCond = 1'b0;
										IorD = 3'b000;
										Wr = 1'b0;
										IRWrite = 1'b0;
										WriteRegA = 1'b0;
										WriteRegB = 1'b0;
										AluSrcA = 2'b00;
										AluSrcB = 3'b000;
										AluOp = 3'b000;
										AluOutControl = 1'b0;
										RegDst = 3'b000;
										MemToReg = 4'b0000;
										RegWrite = 1'b0;
										MDRCtrl = 1'b0;
										LSControl = 2'b00;
										SSControl = 2'b00;
										ExceptionCtrl = 2'b00;
										WriteHI = 1'b0;
										WriteLO = 1'b0;
										HICtrl = 1'b0;
										LOCtrl = 1'b0;
										MultCtrl = 1'b0;
										ShiftSrc = 1'b0;
										ShiftAmt = 1'b0;
										ShiftCtrl = 3'b000;
										EPCWrite = 1'b0;
										state = DIVClk2;
									end
								MULT: begin
									
										MultCtrl = 1'b1;
									        
										PCSource = 3'b000;
										PCWrite = 1'b0;
										WriteCond = 1'b0;
										IorD = 3'b000;
										Wr = 1'b0;
										IRWrite = 1'b0;
										WriteRegA = 1'b0;
										WriteRegB = 1'b0;
										AluSrcA = 2'b00;
										AluSrcB = 3'b000;
										AluOp = 3'b000;
										AluOutControl = 1'b0;
										RegDst = 3'b000;
										MemToReg = 4'b0000;
										RegWrite = 1'b0;
										MDRCtrl = 1'b0;
										LSControl = 2'b00;
										SSControl = 2'b00;
										ExceptionCtrl = 2'b00;
										WriteHI = 1'b0;
										WriteLO = 1'b0;
										HICtrl = 1'b0;
										LOCtrl = 1'b0;
										DivCtrl = 1'b0;
										ShiftSrc = 1'b0;
										ShiftAmt = 1'b0;
										ShiftCtrl = 3'b000;
										EPCWrite = 1'b0;
										state = MULTClk2;
									end
								MFHI: begin
									
										RegDst = 3'b010;
										MemToReg = 4'b0100;
										RegWrite = 1'b1;
									        
										PCSource = 3'b000;
										PCWrite = 1'b0;
										WriteCond = 1'b0;
										IorD = 3'b000;
										Wr = 1'b0;
										IRWrite = 1'b0;
										WriteRegA = 1'b0;
										WriteRegB = 1'b0;
										AluSrcA = 2'b00;
										AluSrcB = 3'b000;
										AluOp = 3'b000;
										AluOutControl = 1'b0;
										MDRCtrl = 1'b0;
										LSControl = 2'b00;
										SSControl = 2'b00;
										ExceptionCtrl = 2'b00;
										WriteHI = 1'b0;
										WriteLO = 1'b0;
										HICtrl = 1'b0;
										LOCtrl = 1'b0;
										DivCtrl = 1'b0;
										MultCtrl = 1'b0;
										ShiftSrc = 1'b0;
										ShiftAmt = 1'b0;
										ShiftCtrl = 3'b000;
										EPCWrite = 1'b0;
										state = WAIT;
									end
								MFLO: begin
									
										RegDst = 3'b010;
										MemToReg = 4'b0101;
										RegWrite = 1'b1;
									        
										PCSource = 3'b000;
										PCWrite = 1'b0;
										WriteCond = 1'b0;
										IorD = 3'b000;
										Wr = 1'b0;
										IRWrite = 1'b0;
										WriteRegA = 1'b0;
										WriteRegB = 1'b0;
										AluSrcA = 2'b00;
										AluSrcB = 3'b000;
										AluOp = 3'b000;
										AluOutControl = 1'b0;
										MDRCtrl = 1'b0;
										LSControl = 2'b00;
										SSControl = 2'b00;
										ExceptionCtrl = 2'b00;
										WriteHI = 1'b0;
										WriteLO = 1'b0;
										HICtrl = 1'b0;
										LOCtrl = 1'b0;
										DivCtrl = 1'b0;
										MultCtrl = 1'b0;
										ShiftSrc = 1'b0;
										ShiftAmt = 1'b0;
										ShiftCtrl = 3'b000;
										EPCWrite = 1'b0;
										state = WAIT;
									end
								SLL: begin
									
										ShiftSrc = 1'b0;
										ShiftCtrl = 3'b001;
										ShiftAmt = 1'b1;
									        
										PCSource = 3'b000;
										PCWrite = 1'b0;
										WriteCond = 1'b0;
										IorD = 3'b000;
										Wr = 1'b0;
										IRWrite = 1'b0;
										WriteRegA = 1'b0;
										WriteRegB = 1'b0;
										AluSrcA = 2'b00;
										AluSrcB = 3'b000;
										AluOp = 3'b000;
										AluOutControl = 1'b0;
										RegDst = 3'b000;
										MemToReg = 4'b0000;
										RegWrite = 1'b0;
										MDRCtrl = 1'b0;
										LSControl = 2'b00;
										SSControl = 2'b00;
										ExceptionCtrl = 2'b00;
										WriteHI = 1'b0;
										WriteLO = 1'b0;
										HICtrl = 1'b0;
										LOCtrl = 1'b0;
										DivCtrl = 1'b0;
										MultCtrl = 1'b0;
										
										EPCWrite = 1'b0;
										state = SLLClk2;
									end
								SLLV: begin
									
										ShiftSrc = 1'b1;
										ShiftCtrl = 3'b001;
									        
										PCSource = 3'b000;
										PCWrite = 1'b0;
										WriteCond = 1'b0;
										IorD = 3'b000;
										Wr = 1'b0;
										IRWrite = 1'b0;
										WriteRegA = 1'b0;
										WriteRegB = 1'b0;
										AluSrcA = 2'b00;
										AluSrcB = 3'b000;
										AluOp = 3'b000;
										AluOutControl = 1'b0;
										RegDst = 3'b000;
										MemToReg = 4'b0000;
										RegWrite = 1'b0;
										MDRCtrl = 1'b0;
										LSControl = 2'b00;
										SSControl = 2'b00;
										ExceptionCtrl = 2'b00;
										WriteHI = 1'b0;
										WriteLO = 1'b0;
										HICtrl = 1'b0;
										LOCtrl = 1'b0;
										DivCtrl = 1'b0;
										MultCtrl = 1'b0;
										ShiftAmt = 1'b0;
										EPCWrite = 1'b0;
										state = SLLVClk2;
									end
								SRL: begin
									
										ShiftSrc = 1'b0;
										ShiftCtrl = 3'b001;
										ShiftAmt = 1'b1;
									        
										PCSource = 3'b000;
										PCWrite = 1'b0;
										WriteCond = 1'b0;
										IorD = 3'b000;
										Wr = 1'b0;
										IRWrite = 1'b0;
										WriteRegA = 1'b0;
										WriteRegB = 1'b0;
										AluSrcA = 2'b00;
										AluSrcB = 3'b000;
										AluOp = 3'b000;
										AluOutControl = 1'b0;
										RegDst = 3'b000;
										MemToReg = 4'b0000;
										RegWrite = 1'b0;
										MDRCtrl = 1'b0;
										LSControl = 2'b00;
										SSControl = 2'b00;
										ExceptionCtrl = 2'b00;
										WriteHI = 1'b0;
										WriteLO = 1'b0;
										HICtrl = 1'b0;
										LOCtrl = 1'b0;
										DivCtrl = 1'b0;
										MultCtrl = 1'b0;
									
										EPCWrite = 1'b0;
										state = SRLClk2;
									end
								SRA: begin
									
										ShiftSrc = 1'b0;
										ShiftCtrl = 3'b001;
										ShiftAmt = 1'b1;
									        
										PCSource = 3'b000;
										PCWrite = 1'b0;
										WriteCond = 1'b0;
										IorD = 3'b000;
										Wr = 1'b0;
										IRWrite = 1'b0;
										WriteRegA = 1'b0;
										WriteRegB = 1'b0;
										AluSrcA = 2'b00;
										AluSrcB = 3'b000;
										AluOp = 3'b000;
										AluOutControl = 1'b0;
										RegDst = 3'b000;
										MemToReg = 4'b0000;
										RegWrite = 1'b0;
										MDRCtrl = 1'b0;
										LSControl = 2'b00;
										SSControl = 2'b00;
										ExceptionCtrl = 2'b00;
										WriteHI = 1'b0;
										WriteLO = 1'b0;
										HICtrl = 1'b0;
										LOCtrl = 1'b0;
										DivCtrl = 1'b0;
										MultCtrl = 1'b0;
										
										EPCWrite = 1'b0;
										state = SRAClk2;
									end
								SRAV: begin
									
										ShiftSrc = 1'b1;
										ShiftCtrl = 3'b001;
									        
										PCSource = 3'b000;
										PCWrite = 1'b0;
										WriteCond = 1'b0;
										IorD = 3'b000;
										Wr = 1'b0;
										IRWrite = 1'b0;
										WriteRegA = 1'b0;
										WriteRegB = 1'b0;
										AluSrcA = 2'b00;
										AluSrcB = 3'b000;
										AluOp = 3'b000;
										AluOutControl = 1'b0;
										RegDst = 3'b000;
										MemToReg = 4'b0000;
										RegWrite = 1'b0;
										MDRCtrl = 1'b0;
										LSControl = 2'b00;
										SSControl = 2'b00;
										ExceptionCtrl = 2'b00;
										WriteHI = 1'b0;
										WriteLO = 1'b0;
										HICtrl = 1'b0;
										LOCtrl = 1'b0;
										DivCtrl = 1'b0;
										MultCtrl = 1'b0;
										ShiftAmt = 1'b0;
										EPCWrite = 1'b0;
										state = SRAVClk2;
									end
								SLT: begin
									
				                        AluSrcA = 2'b10;
										AluSrcB = 3'b000;
										AluOp = 3'b111;
									        
										PCSource = 3'b000;
										PCWrite = 1'b0;
										WriteCond = 1'b0;
										IorD = 3'b000;
										Wr = 1'b0;
										IRWrite = 1'b0;
										WriteRegA = 1'b0;
										WriteRegB = 1'b0;
										AluOutControl = 1'b0;
										MDRCtrl = 1'b0;
										LSControl = 2'b00;
										SSControl = 2'b00;
										ExceptionCtrl = 2'b00;
										WriteHI = 1'b0;
										WriteLO = 1'b0;
										HICtrl = 1'b0;
										LOCtrl = 1'b0;
										DivCtrl = 1'b0;
										MultCtrl = 1'b0;
										ShiftSrc = 1'b0;
										ShiftAmt = 1'b0;
										ShiftCtrl = 3'b000;
										EPCWrite = 1'b0;
										state = SLTClk2;
									end
								JR: begin
									
										PCSource = 3'b001;
										PCWrite = 1'b1;
										AluSrcA = 2'b10;
										AluSrcB = 3'b000;
										AluOp = 3'b000;
									
										WriteCond = 1'b0;
										IorD = 3'b000;
										Wr = 1'b0;
										IRWrite = 1'b0;
										WriteRegA = 1'b0;
										WriteRegB = 1'b0;
										AluOutControl = 1'b0;
										RegDst = 3'b000;
										MemToReg = 4'b0000;
										RegWrite = 1'b0;
										MDRCtrl = 1'b0;
										LSControl = 2'b00;
										SSControl = 2'b00;
										ExceptionCtrl = 2'b00;
										WriteHI = 1'b0;
										WriteLO = 1'b0;
										HICtrl = 1'b0;
										LOCtrl = 1'b0;
										DivCtrl = 1'b0;
										MultCtrl = 1'b0;
										ShiftSrc = 1'b0;
										ShiftAmt = 1'b0;
										ShiftCtrl = 3'b000;
										EPCWrite = 1'b0;
										state = WAIT;
									end
								RTE: begin
									
										PCSource = 3'b100;
										PCWrite = 1'b1;
									
										WriteCond = 1'b0;
										IorD = 3'b000;
										Wr = 1'b0;
										IRWrite = 1'b0;
										WriteRegA = 1'b0;
										WriteRegB = 1'b0;
										AluSrcA = 2'b00;
										AluSrcB = 3'b000;
										AluOp = 3'b000;
										AluOutControl = 1'b0;
										RegDst = 3'b000;
										MemToReg = 4'b0000;
										RegWrite = 1'b0;
										MDRCtrl = 1'b0;
										LSControl = 2'b00;
										SSControl = 2'b00;
										ExceptionCtrl = 2'b00;
										WriteHI = 1'b0;
										WriteLO = 1'b0;
										HICtrl = 1'b0;
										LOCtrl = 1'b0;
										DivCtrl = 1'b0;
										MultCtrl = 1'b0;
										ShiftSrc = 1'b0;
										ShiftAmt = 1'b0;
										ShiftCtrl = 3'b000;
										EPCWrite = 1'b0;
										state = WAIT;
									end
								XCHG: begin
									
										WriteRegA = 1'b0;
										WriteRegB = 1'b0;
										RegDst = 3'b000;
										MemToReg = 4'b0110;
										RegWrite = 1'b1;
									
										PCSource = 3'b000;
										PCWrite = 1'b0;
										WriteCond = 1'b0;
										IorD = 3'b000;
										Wr = 1'b0;
										IRWrite = 1'b0;
										AluSrcA = 2'b00;
										AluSrcB = 3'b000;
										AluOp = 3'b000;
										AluOutControl = 1'b0;
										MDRCtrl = 1'b0;
										LSControl = 2'b00;
										SSControl = 2'b00;
										ExceptionCtrl = 2'b00;
										WriteHI = 1'b0;
										WriteLO = 1'b0;
										HICtrl = 1'b0;
										LOCtrl = 1'b0;
										DivCtrl = 1'b0;
										MultCtrl = 1'b0;
										ShiftSrc = 1'b0;
										ShiftAmt = 1'b0;
										ShiftCtrl = 3'b000;
										EPCWrite = 1'b0;
										state = XCHGClk2;
									end
								BREAK: begin
                                    
                                        PCWrite = 1'b1;
                                        AluSrcB = 4'b0001;
                                        AluOp = 3'b010;
									    PCSource = 3'b001;
					                
					                    WriteCond = 1'b0;
					                    IorD = 3'b000;
					                    Wr = 1'b0;
					                    IRWrite = 1'b0;
					                    WriteRegA = 1'b0;
					                    WriteRegB = 1'b0;
					                    AluSrcA = 2'b00;
					                    AluOutControl = 1'b0;
					                    RegDst = 3'b000;
					                    MemToReg = 4'b0000;
					                    RegWrite = 1'b0;
					                    MDRCtrl = 1'b0;
					                    LSControl = 2'b00;
					                    SSControl = 2'b00;
					                    ExceptionCtrl = 2'b00;
					                    WriteHI = 1'b0;
					                    WriteLO = 1'b0;
					                    HICtrl = 1'b0;
					                    LOCtrl = 1'b0;
					                    DivCtrl = 1'b0;
					                    MultCtrl = 1'b0;
					                    ShiftSrc = 1'b0;
					                    ShiftAmt = 1'b0;
					                    ShiftCtrl = 3'b000;
					                    EPCWrite = 1'b0;
					                    state = FETCH;
									end
									default: begin
										
										IorD = 3'b001;
										Wr = 1'b0;
										AluSrcA = 2'b00;
										AluSrcB = 3'b001;
										AluOp = 3'b010;
										ExceptionCtrl = 2'b00;
										EPCWrite = 1'b1;
										        
										PCSource = 3'b000;
										PCWrite = 1'b0;
										WriteCond = 1'b0;
										IRWrite = 1'b0;
										WriteRegA = 1'b0;
										WriteRegB = 1'b0;
										AluOutControl = 1'b0;
										RegDst = 3'b000;
										MemToReg = 4'b0000;
										RegWrite = 1'b0;
										MDRCtrl = 1'b0;
										LSControl = 2'b00;
										SSControl = 2'b00;
										WriteHI = 1'b0;
										WriteLO = 1'b0;
										HICtrl = 1'b0;
										LOCtrl = 1'b0;
										DivCtrl = 1'b0;
										MultCtrl = 1'b0;
										ShiftSrc = 1'b0;
										ShiftAmt = 1'b0;
										ShiftCtrl = 3'b000;
										state = ExceptionWait;
									end

								endcase
							end
						default: begin
							
								IorD = 3'b001;
								Wr = 1'b0;
								AluSrcA = 2'b00;
								AluSrcB = 3'b001;
								AluOp = 3'b010;
								ExceptionCtrl = 2'b00;
								EPCWrite = 1'b1;
							        
								PCSource = 3'b000;
								PCWrite = 1'b0;
								WriteCond = 1'b0;
								IRWrite = 1'b0;
								WriteRegA = 1'b0;
								WriteRegB = 1'b0;
								AluOutControl = 1'b0;
								RegDst = 3'b000;
								MemToReg = 4'b0000;
								RegWrite = 1'b0;
								MDRCtrl = 1'b0;
								LSControl = 2'b00;
								SSControl = 2'b00;
								WriteHI = 1'b0;
								WriteLO = 1'b0;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								DivCtrl = 1'b0;
								MultCtrl = 1'b0;
								ShiftSrc = 1'b0;
								ShiftAmt = 1'b0;
								ShiftCtrl = 3'b000;
								state = ExceptionWait;
							end
					endcase
					
				end
				ADDIUClk2: begin
                    
                        RegDst = 3'b001;
                        RegWrite = 1'b1;
                        MemToReg = 4'b1000;
					
					    PCSource = 3'b000;
					    PCWrite = 1'b0;
					    WriteCond = 1'b0;
					    IorD = 3'b000;
					    Wr = 1'b0;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b000;
					    AluOp = 3'b000;
					    AluOutControl = 1'b0;
					    MDRCtrl = 1'b0;
					    LSControl = 2'b00;
					    SSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    WriteHI = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    ShiftCtrl = 3'b000;
					    EPCWrite = 1'b0;
					    state = WAIT;
					end
				ANDClk2: begin
					
						RegDst = 3'b010; 
						MemToReg = 4'b1000;
						RegWrite = 1'b1;
					
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IorD = 3'b000;
						Wr = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						MDRCtrl = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						ShiftSrc = 1'b0;
						ShiftAmt = 1'b0;
						ShiftCtrl = 3'b000;
						EPCWrite = 1'b0;
						state = WAIT;
					end
				SRAMClk2: begin
					
						IorD = 3'b011;
						Wr = 1'b0;
					
						MDRCtrl = 1'b0;
						MemToReg = 4'b0000;
						RegWrite = 1'b0;
						RegDst = 3'b000; 
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						ShiftSrc = 1'b0;
						ShiftAmt = 1'b0;
						ShiftCtrl = 3'b000;
						EPCWrite = 1'b0;
						state = SRAMClk3;
				end
				SRAMClk3: begin
					
					
						MDRCtrl = 1'b0;
						ShiftSrc = 1'b0;
						ShiftAmt = 2'b00;
						ShiftCtrl = 3'b000;		//corrigido pra LOAD no regDeslocamento
						IorD = 3'b000;
						Wr = 1'b0;
						
						MemToReg = 4'b0000;
						RegWrite = 1'b0;
						RegDst = 3'b000; 
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						EPCWrite = 1'b0;
						state = SRAMClk4;
				end
				SRAMClk4: begin
					
						MDRCtrl = 1'b1;

					
						ShiftSrc = 1'b0;
						ShiftAmt = 2'b00;
						ShiftCtrl = 3'b000;		//corrigido pra LOAD no regDeslocamento
						IorD = 3'b000;
						Wr = 1'b0;
						
						MemToReg = 4'b0000;
						RegWrite = 1'b0;
						RegDst = 3'b000; 
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						EPCWrite = 1'b0;
						state = SRAMClk5;
				end

				SRAMClk5: begin
					
						ShiftSrc = 1'b0;
						ShiftAmt = 2'b10;
						ShiftCtrl = 3'b001;
					
						IorD = 3'b000;				
						Wr = 1'b0;
						MDRCtrl = 1'b0;
						MemToReg = 4'b0000;
						RegDst = 3'b000; 
						RegWrite = 1'b0;
						
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						EPCWrite = 1'b0;
						state = SRAMClk6;
				end
				SRAMClk6:
				begin
					
						ShiftSrc = 1'b0;		//faz o calculo do deslocamento
						ShiftAmt = 2'b10;
						ShiftCtrl = 3'b100;
					
						IorD = 3'b000;				
						Wr = 1'b0;
						MDRCtrl = 1'b0;
						MemToReg = 4'b0000;
						RegDst = 3'b000; 
						RegWrite = 1'b0;
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						EPCWrite = 1'b0;
						state = SRAMClk7;
				end

				SRAMClk7:
				begin
					
						IorD = 3'b011;				
						Wr = 1'b0;
						MDRCtrl = 1'b1;
						MemToReg = 4'b0011;
						RegDst = 3'b001; 
						RegWrite = 1'b1;
					
						ShiftSrc = 1'b0;		
						ShiftAmt = 2'b00;
						ShiftCtrl = 3'b000;
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						EPCWrite = 1'b0;
						state = WAIT;
				end
				SLLClk2: begin
					
						ShiftAmt = 1'b1;
						ShiftCtrl = 3'b010;
					        
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IorD = 3'b000;
						Wr = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						RegDst = 3'b000;
						MemToReg = 4'b0000;
						RegWrite = 1'b0;
						MDRCtrl = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						ShiftSrc = 1'b0;
						EPCWrite = 1'b0;
						state = SHIFTOperationClk3;
					end
				SLLVClk2: begin
					
						ShiftAmt = 1'b0;
						ShiftCtrl = 3'b010;
					        
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IorD = 3'b000;
						Wr = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						RegDst = 3'b000;
						MemToReg = 4'b0000;
						RegWrite = 1'b0;
						MDRCtrl = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						ShiftSrc = 1'b0;
						EPCWrite = 1'b0;
						state = SHIFTOperationClk3;
					end
				SRLClk2: begin
					
						ShiftAmt = 1'b1;
						ShiftCtrl = 3'b011;
					        
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IorD = 3'b000;
						Wr = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						RegDst = 3'b000;
						MemToReg = 4'b0000;
						RegWrite = 1'b0;
						MDRCtrl = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						ShiftSrc = 1'b0;
						EPCWrite = 1'b0;
						state = SHIFTOperationClk3;
					end
				SRAClk2: begin
					
						ShiftAmt = 1'b1;
						ShiftCtrl = 3'b100;
					        
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IorD = 3'b000;
						Wr = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						RegDst = 3'b000;
						MemToReg = 4'b0000;
						RegWrite = 1'b0;
						MDRCtrl = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						ShiftSrc = 1'b0;
						EPCWrite = 1'b0;
						state = SHIFTOperationClk3;
					end
				SRAVClk2: begin
					
						ShiftAmt = 1'b0;
						ShiftCtrl = 3'b100;
					        
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IorD = 3'b000;
						Wr = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						RegDst = 3'b000;
						MemToReg = 4'b0000;
						RegWrite = 1'b0;
						MDRCtrl = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						ShiftSrc = 1'b0;
						EPCWrite = 1'b0;
						state = SHIFTOperationClk3;
					end
				SHIFTOperationClk3:begin
					
						ShiftAmt = 1'b1;
						RegDst = 3'b010;
						MemToReg = 4'b0011;
						RegWrite = 1'b1;
					
						ShiftCtrl = 3'b000;
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IorD = 3'b000;
						Wr = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						MDRCtrl = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						ShiftSrc = 1'b0;
						EPCWrite = 1'b0;
						state = WAIT;
					end
				
				XCHGClk2: begin
					
						RegDst = 3'b001;
						MemToReg = 4'b0111;
						RegWrite = 1'b1;
					
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IorD = 3'b000;
						Wr = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						MDRCtrl = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						ShiftSrc = 1'b0;
						ShiftAmt = 1'b0;
						ShiftCtrl = 3'b000;
						EPCWrite = 1'b0;
						state = WAIT;
					end
				JALClk2: begin
					
						RegDst = 3'b100;
						MemToReg = 4'b1000;
						RegWrite = 1'b1;
					        
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IorD = 3'b000;
						Wr = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						MDRCtrl = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						ShiftSrc = 1'b0;
						ShiftAmt = 1'b0;
						ShiftCtrl = 3'b000;
						EPCWrite = 1'b0;
						state = WAIT;
					end
				LWClk2: begin
					
						IorD = 3'b011;
					        
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						Wr = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						MDRCtrl = 1'b0;
						RegDst = 3'b000;
						MemToReg = 4'b0000;
						RegWrite = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						ShiftSrc = 1'b0;
						ShiftAmt = 1'b0;
						ShiftCtrl = 3'b000;
						EPCWrite = 1'b0;
						state = LWClk3;
					end
				LWClk3: begin
					
					    IorD = 3'b011;
                        MDRCtrl = 1'b1;
					        
					    PCSource = 3'b000;
					    PCWrite = 1'b0;
					    WriteCond = 1'b0;
					    Wr = 1'b0;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b000;
					    AluOp = 3'b000;
					    AluOutControl = 1'b0;
					    RegDst = 3'b000;
					    MemToReg = 4'b0000;
					    RegWrite = 1'b0;
					    LSControl = 2'b00;
					    SSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    WriteHI = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    ShiftCtrl = 3'b000;
					    EPCWrite = 1'b0;
					    state = LWClk4;
					end
				LWClk4: begin
					
	                    RegDst = 3'b001;
						MemToReg = 4'b0001;
						RegWrite = 1'b1;
						LSControl = 2'b00;
					        
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IorD = 3'b000;
						Wr = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						MDRCtrl = 1'b0;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						ShiftSrc = 1'b0;
						ShiftAmt = 1'b0;
						ShiftCtrl = 3'b000;
						EPCWrite = 1'b0;
						state = WAIT;
					end
				LHClk2: begin
					
						IorD = 3'b011;
					        
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						Wr = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						MDRCtrl = 1'b0;
						RegDst = 3'b000;
						MemToReg = 4'b0000;
						RegWrite = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						ShiftSrc = 1'b0;
						ShiftAmt = 1'b0;
						ShiftCtrl = 3'b000;
						EPCWrite = 1'b0;
						state = LHClk3;
					end
				LHClk3: begin
					
						IorD = 3'b011;
                        MDRCtrl = 1'b1;
					        
					    PCSource = 3'b000;
					    PCWrite = 1'b0;
					    WriteCond = 1'b0;
					    Wr = 1'b0;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b000;
					    AluOp = 3'b000;
					    AluOutControl = 1'b0;
					    RegDst = 3'b000;
					    MemToReg = 4'b0000;
					    RegWrite = 1'b0;
					    LSControl = 2'b00;
					    SSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    WriteHI = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    ShiftCtrl = 3'b000;
					    EPCWrite = 1'b0;
					    state = LHClk4;
					end
				LHClk4: begin
					
	                    RegDst = 3'b001;
						MemToReg = 4'b0001;
						RegWrite = 1'b1;
						LSControl = 2'b01;
					        
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IorD = 3'b000;
						Wr = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						MDRCtrl = 1'b0;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						ShiftSrc = 1'b0;
						ShiftAmt = 1'b0;
						ShiftCtrl = 3'b000;
						EPCWrite = 1'b0;
						state = WAIT;
					end
				LBClk2: begin
					
						IorD = 3'b011;
					        
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						Wr = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						MDRCtrl = 1'b0;
						RegDst = 3'b000;
						MemToReg = 4'b0000;
						RegWrite = 1'b0;
						LSControl = 2'b00;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						ShiftSrc = 1'b0;
						ShiftAmt = 1'b0;
						ShiftCtrl = 3'b000;
						EPCWrite = 1'b0;
						state = LBClk3;
					end
				LBClk3: begin
					
						IorD = 3'b011;
                        MDRCtrl = 1'b1;
					        
					    PCSource = 3'b000;
					    PCWrite = 1'b0;
					    WriteCond = 1'b0;
					    Wr = 1'b0;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b000;
					    AluOp = 3'b000;
					    AluOutControl = 1'b0;
					    RegDst = 3'b000;
					    MemToReg = 4'b0000;
					    RegWrite = 1'b0;
					    LSControl = 2'b00;
					    SSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    WriteHI = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    ShiftCtrl = 3'b000;
					    EPCWrite = 1'b0;
					    state = LBClk4;
					end
				LBClk4: begin
					
	                    RegDst = 3'b001;
						MemToReg = 4'b0001;
						RegWrite = 1'b1;
						LSControl = 2'b10;
					        
						PCSource = 3'b000;
						PCWrite = 1'b0;
						WriteCond = 1'b0;
						IorD = 3'b000;
						Wr = 1'b0;
						IRWrite = 1'b0;
						WriteRegA = 1'b0;
						WriteRegB = 1'b0;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						AluOutControl = 1'b0;
						MDRCtrl = 1'b0;
						SSControl = 2'b00;
						ExceptionCtrl = 2'b00;
						WriteHI = 1'b0;
						WriteLO = 1'b0;
						HICtrl = 1'b0;
						LOCtrl = 1'b0;
						DivCtrl = 1'b0;
						MultCtrl = 1'b0;
						ShiftSrc = 1'b0;
						ShiftAmt = 1'b0;
						ShiftCtrl = 3'b000;
						EPCWrite = 1'b0;
						state = WAIT;
					end
					
				SWClk2: begin
					
						IorD = 3'b011;
					        
					    PCSource = 3'b000;
					    PCWrite = 1'b0;
					    WriteCond = 1'b0;
					    Wr = 1'b0;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b000;
					    AluOp = 3'b000;
					    AluOutControl = 1'b0;
                        MDRCtrl = 1'b0;
					    RegDst = 3'b000;
					    MemToReg = 4'b0000;
					    RegWrite = 1'b0;
					    LSControl = 2'b00;
					    SSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    WriteHI = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    ShiftCtrl = 3'b000;
					    EPCWrite = 1'b0;
					    state = SWClk3;
					end
				SWClk3: begin
					
						IorD = 3'b011;
                        MDRCtrl = 1'b1;
					        
					    PCSource = 3'b000;
					    PCWrite = 1'b0;
					    WriteCond = 1'b0;
					    Wr = 1'b0;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b000;
					    AluOp = 3'b000;
					    AluOutControl = 1'b0;
					    RegDst = 3'b000;
					    MemToReg = 4'b0000;
					    RegWrite = 1'b0;
					    LSControl = 2'b00;
					    SSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    WriteHI = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    ShiftCtrl = 3'b000;
					    EPCWrite = 1'b0;
					    state = SWClk4;
					end
				SWClk4: begin
					
					    IorD = 3'b011;
					    Wr = 1'b1;
					    SSControl = 2'b00;
					        
					    PCSource = 3'b000;
					    PCWrite = 1'b0;
					    WriteCond = 1'b0;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b000;
					    AluOp = 3'b000;
					    AluOutControl = 1'b0;
					    RegDst = 3'b000;
					    MemToReg = 4'b0000;
					    RegWrite = 1'b0;
					    MDRCtrl = 1'b0;
					    LSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    WriteHI = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    ShiftCtrl = 3'b000;
					    EPCWrite = 1'b0;
					    state = WAIT;
					end
				SHClk2: begin
					
						IorD = 3'b011;
					        
					    PCSource = 3'b000;
					    PCWrite = 1'b0;
					    WriteCond = 1'b0;
					    Wr = 1'b0;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b000;
					    AluOp = 3'b000;
					    AluOutControl = 1'b0;
                        MDRCtrl = 1'b0;
					    RegDst = 3'b000;
					    MemToReg = 4'b0000;
					    RegWrite = 1'b0;
					    LSControl = 2'b00;
					    SSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    WriteHI = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    ShiftCtrl = 3'b000;
					    EPCWrite = 1'b0;
					    state = SHClk3;
					end
				SHClk3: begin
					
						IorD = 3'b011;
                        MDRCtrl = 1'b1;
					        
					    PCSource = 3'b000;
					    PCWrite = 1'b0;
					    WriteCond = 1'b0;
					    Wr = 1'b0;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b000;
					    AluOp = 3'b000;
					    AluOutControl = 1'b0;
					    RegDst = 3'b000;
					    MemToReg = 4'b0000;
					    RegWrite = 1'b0;
					    LSControl = 2'b00;
					    SSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    WriteHI = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    ShiftCtrl = 3'b000;
					    EPCWrite = 1'b0;
					    state = SHClk4;
					end
				SHClk4: begin
					
					    IorD = 3'b011;
					    Wr = 1'b1;
					    SSControl = 2'b01;
					        
					    PCSource = 3'b000;
					    PCWrite = 1'b0;
					    WriteCond = 1'b0;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b000;
					    AluOp = 3'b000;
					    AluOutControl = 1'b0;
					    RegDst = 3'b000;
					    MemToReg = 4'b0000;
					    RegWrite = 1'b0;
					    MDRCtrl = 1'b0;
					    LSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    WriteHI = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    ShiftCtrl = 3'b000;
					    EPCWrite = 1'b0;
					    state = WAIT;
					end
					
				SBClk2: begin
					
						IorD = 3'b011;
					        
					    PCSource = 3'b000;
					    PCWrite = 1'b0;
					    WriteCond = 1'b0;
					    Wr = 1'b0;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b000;
					    AluOp = 3'b000;
					    AluOutControl = 1'b0;
                        MDRCtrl = 1'b0;
					    RegDst = 3'b000;
					    MemToReg = 4'b0000;
					    RegWrite = 1'b0;
					    LSControl = 2'b00;
					    SSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    WriteHI = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    ShiftCtrl = 3'b000;
					    EPCWrite = 1'b0;
					    state = SBClk3;
					end
				SBClk3: begin
					
						IorD = 3'b011;
                        MDRCtrl = 1'b1;
					        
					    PCSource = 3'b000;
					    PCWrite = 1'b0;
					    WriteCond = 1'b0;
					    Wr = 1'b0;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b000;
					    AluOp = 3'b000;
					    AluOutControl = 1'b0;
					    RegDst = 3'b000;
					    MemToReg = 4'b0000;
					    RegWrite = 1'b0;
					    LSControl = 2'b00;
					    SSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    WriteHI = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    ShiftCtrl = 3'b000;
					    EPCWrite = 1'b0;
					    state = SBClk4;
					end
				SBClk4: begin
					
					    IorD = 3'b011;
					    Wr = 1'b1;
					    SSControl = 2'b10;
					        
					    PCSource = 3'b000;
					    PCWrite = 1'b0;
					    WriteCond = 1'b0;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b000;
					    AluOp = 3'b000;
					    AluOutControl = 1'b0;
					    RegDst = 3'b000;
					    MemToReg = 4'b0000;
					    RegWrite = 1'b0;
					    MDRCtrl = 1'b0;
					    LSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    WriteHI = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    ShiftCtrl = 3'b000;
					    EPCWrite = 1'b0;
					    state = WAIT;
					end
				
				BEQClk2: begin
					
					PCSource = 3'b011;
					AluSrcA = 2'b10;
					AluSrcB = 3'b000;
					AluOp = 3'b111;
					if(EQ == 1) begin
						PCWrite = 1'b1;
					end
					
					WriteCond = 1'b0;
					IorD = 3'b000;
					Wr = 1'b0;
					IRWrite = 1'b0;
					WriteRegA = 1'b0;
					WriteRegB = 1'b0;
					AluOutControl = 1'b0;
					RegDst = 3'b000;
					MemToReg = 4'b0000;
					RegWrite = 1'b0;
					MDRCtrl = 1'b0;
					LSControl = 2'b00;
					SSControl = 2'b00;
					ExceptionCtrl = 2'b00;
					WriteHI = 1'b0;
					WriteLO = 1'b0;
					HICtrl = 1'b0;
					LOCtrl = 1'b0;
					DivCtrl = 1'b0;
					MultCtrl = 1'b0;
					ShiftSrc = 1'b0;
					ShiftAmt = 1'b0;
					ShiftCtrl = 3'b000;
					EPCWrite = 1'b0;
					state = WAIT;
					end
				BNEClk2: begin
					
                        if(EQ == 0) begin
							PCWrite = 1'b1;
							PCSource = 3'b011;
						end
					
						WriteCond = 1'b0;
					    IorD = 3'b000;
					    Wr = 1'b0;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b000;
					    AluOp = 3'b000;
					    AluOutControl = 1'b0;
					    RegDst = 3'b000;
					    MemToReg = 4'b0000;
					    RegWrite = 1'b0;
					    MDRCtrl = 1'b0;
					    LSControl = 2'b00;
					    SSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    WriteHI = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    ShiftCtrl = 3'b000;
					    EPCWrite = 1'b0;
					    state = WAIT;
					end
				BGTClk2: begin
					
					PCSource = 3'b011;
					AluSrcA = 2'b10;
					AluSrcB = 3'b000;
					AluOp = 3'b111;
					if(GT == 1) begin
						PCWrite = 1'b1;
					end
					
					WriteCond = 1'b0;
					IorD = 3'b000;
					Wr = 1'b0;
					IRWrite = 1'b0;
					WriteRegA = 1'b0;
					WriteRegB = 1'b0;
					AluOutControl = 1'b0;
					RegDst = 3'b000;
					MemToReg = 4'b0000;
					RegWrite = 1'b0;
					MDRCtrl = 1'b0;
					LSControl = 2'b00;
					SSControl = 2'b00;
					ExceptionCtrl = 2'b00;
					WriteHI = 1'b0;
					WriteLO = 1'b0;
					HICtrl = 1'b0;
					LOCtrl = 1'b0;
					DivCtrl = 1'b0;
					MultCtrl = 1'b0;
					ShiftSrc = 1'b0;
					ShiftAmt = 1'b0;
					ShiftCtrl = 3'b000;
					EPCWrite = 1'b0;
					state = WAIT;
				end
				ADDIClk2: begin
						if(Overflow == 0) begin
							RegDst = 3'b001;
							RegWrite = 1'b1;
							MemToReg = 4'b1000;
							state = WAIT;
							
							ExceptionCtrl = 2'b00;
							IorD = 2'b00;
							AluSrcA = 2'b00;
							AluSrcB = 3'b000;
							AluOp = 3'b000;
							EPCWrite = 1'b0;
						end else begin
							ExceptionCtrl = 2'b01;
							IorD = 2'b01;
							AluSrcA = 2'b00;
							AluSrcB = 3'b001;
							AluOp = 3'b010;
							EPCWrite = 1'b1;
							state = ExceptionWait;
							
							RegDst = 3'b000;
							RegWrite = 1'b0;
							MemToReg = 4'b0000;
						end
						PCSource = 3'b000;
					    PCWrite = 1'b0;
					    WriteCond = 1'b0;
					    Wr = 1'b0;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluOutControl = 1'b0;
					    MDRCtrl = 1'b0;
					    LSControl = 2'b00;
					    SSControl = 2'b00;
					    WriteHI = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    ShiftCtrl = 3'b000;					    
					end
				ExceptionWait: begin
					
						//Espera clock
						Wr = 1'b0;
					
						PCSource = 3'b000;
					    PCWrite = 1'b0;
					    WriteCond = 1'b0;
					    IorD = 3'b000;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b000;
					    AluOp = 3'b000;
					    AluOutControl = 1'b0;
					    RegDst = 3'b000;
					    MemToReg = 4'b0000;
					    RegWrite = 1'b0;
					    MDRCtrl = 1'b0;
					    LSControl = 2'b00;
					    SSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    WriteHI = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    ShiftCtrl = 3'b000;
					    EPCWrite = 1'b0;
						state = ExceptionByteToPc;
					end

				BLEClk2: begin
					
					PCSource = 3'b011;
					AluSrcA = 2'b10;
					AluSrcB = 3'b000;
					AluOp = 3'b111;
					if(GT == 0) begin
						PCWrite = 1'b1;
					end
					
					WriteCond = 1'b0;
					IorD = 3'b000;
					Wr = 1'b0;
					IRWrite = 1'b0;
					WriteRegA = 1'b0;
					WriteRegB = 1'b0;
					AluOutControl = 1'b0;
					RegDst = 3'b000;
					MemToReg = 4'b0000;
					RegWrite = 1'b0;
					MDRCtrl = 1'b0;
					LSControl = 2'b00;
					SSControl = 2'b00;
					ExceptionCtrl = 2'b00;
					WriteHI = 1'b0;
					WriteLO = 1'b0;
					HICtrl = 1'b0;
					LOCtrl = 1'b0;
					DivCtrl = 1'b0;
					MultCtrl = 1'b0;
					ShiftSrc = 1'b0;
					ShiftAmt = 1'b0;
					ShiftCtrl = 3'b000;
					EPCWrite = 1'b0;
					state = WAIT;
				end
				
				ExceptionByteToPc: begin
					
                        PCSource = 3'b101;
					    PCWrite = 1'b1;
					
					    WriteCond = 1'b0;
					    IorD = 3'b000;
					    Wr = 1'b0;
					    IRWrite = 1'b0;
					    WriteRegA = 1'b0;
					    WriteRegB = 1'b0;
					    AluSrcA = 2'b00;
					    AluSrcB = 3'b000;
					    AluOp = 3'b000;
					    AluOutControl = 1'b0;
					    RegDst = 3'b000;
					    MemToReg = 4'b0000;
					    RegWrite = 1'b0;
					    MDRCtrl = 1'b0;
					    LSControl = 2'b00;
					    SSControl = 2'b00;
					    ExceptionCtrl = 2'b00;
					    WriteHI = 1'b0;
					    WriteLO = 1'b0;
					    HICtrl = 1'b0;
					    LOCtrl = 1'b0;
					    DivCtrl = 1'b0;
					    MultCtrl = 1'b0;
					    ShiftSrc = 1'b0;
					    ShiftAmt = 1'b0;
					    ShiftCtrl = 3'b000;
					    EPCWrite = 1'b0;
					    state = FETCH;
					end
				MULTClk2: begin
					
						if(MultDone == 1'b0) begin
							state = MULTClk2;
						end
					    else begin
							MultCtrl = 1'b0;
							WriteHI = 1'b1;
							WriteLO = 1'b1;
							HICtrl = 1'b1;
							LOCtrl = 1'b1;
							state = WAIT;
						end
					end
				DIVClk2: begin
					
						if(DivDone == 1'b0) begin
							state = DIVClk2;
						end
					    else begin
							if(Div0 == 1'b1) begin
								DivCtrl = 1'b0;
								ExceptionCtrl = 2'b10;
								IorD = 2'b01;
								Wr = 1'b0;
								AluSrcA = 2'b00;
								AluSrcB = 3'b001;
								AluOp = 3'b010;
								EPCWrite = 1'b1;
								state = ExceptionWait;
							end 
							else begin
								DivCtrl = 1'b0;
								WriteHI = 1'b1;
								WriteLO = 1'b1;
								HICtrl = 1'b0;
								LOCtrl = 1'b0;
								state = WAIT;
							end
						end
					end
				ADD_SUBClk2: begin
					
					if(Overflow) begin
						ExceptionCtrl = 2'b01;
						IorD = 2'b01;
						AluSrcA = 2'b00;
						AluSrcB = 3'b001;
						AluOp = 3'b010;
						EPCWrite = 1'b1;
						state = ExceptionWait;
						
						RegDst = 3'b000;
						MemToReg = 4'b0000;
						RegWrite = 1'b0;
					end else begin	
						RegDst = 3'b010;
						MemToReg = 4'b1000;
						RegWrite = 1'b1;
						state = WAIT;
						
						ExceptionCtrl = 2'b00;
						IorD = 2'b00;
						AluSrcA = 2'b00;
						AluSrcB = 3'b000;
						AluOp = 3'b000;
						EPCWrite = 1'b0;
					end
				
					PCSource = 3'b000;
					PCWrite = 1'b0;
					WriteCond = 1'b0;
					Wr = 1'b0;
					IRWrite = 1'b0;
					WriteRegA = 1'b0;
					WriteRegB = 1'b0;
					AluOutControl = 1'b0;
					MDRCtrl = 1'b0;
					LSControl = 2'b00;
					SSControl = 2'b00;
					WriteHI = 1'b0;
					WriteLO = 1'b0;
					HICtrl = 1'b0;
					LOCtrl = 1'b0;
					DivCtrl = 1'b0;
					MultCtrl = 1'b0;
					ShiftSrc = 1'b0;
					ShiftAmt = 1'b0;
					ShiftCtrl = 3'b000;
				end
				SLTClk2: begin
					
					RegDst = 3'b010;
					MemToReg = 4'b0000;
					RegWrite = 1'b1;
					state = WAIT;
				end
				SLTIClk2: begin
					
					RegDst = 3'b001;
					MemToReg = 4'b0000;
					RegWrite = 1'b1;
					
					state = WAIT;
				end
					
					
				WAIT: begin
					state = FETCH;
					end
					
			endcase
		end
	end
endmodule