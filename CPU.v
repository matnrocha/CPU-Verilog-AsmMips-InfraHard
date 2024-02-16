module CPU (
    clock, 
    reset, 
    RegAOut, 
    RegBOut, 
    RegPCOut, 
    MuxMemToRegOut, 
    AluResult, 
    estado, 
    AluOp, 
    Opcode,
    Funct,
    RegDst, 
    DivCtrlHIOut, 
    DivCtrlLOOut, 
    Overflow, 
    ExceptionBitExtendido, 
    RegMDROut, 
    MemData);

input clock;
input reset;

//variaveis a printar OBS: tambem precisa especificar elas no parenteses apos CPU
output wire [31:0] 
    RegAOut, RegBOut, 
    RegPCOut, 
    MuxMemToRegOut, 
    AluResult, 
    ExceptionBitExtendido, 
    DivCtrlHIOut, DivCtrlLOOut, 
    RegMDROut, 
    MemData;
output wire [6:0] 
    estado;
output wire [5:0] 
    Opcode, 
    Funct;
wire [4:0] 
    Shamt;

// declaracao das variaveis do programa
wire [31:0] VMControlOut, RegWriteOutA, MuxPCSourceOut, RegAluOutOut, RegEPCOut, MuxIorDOut, LSControlOut, MultCtrlLOOut, MultCtrlHIOut, MuxExceptionsCtrlOut, MuxShiftSrcOut, RegDeslocOut;
wire [31:0] MuxHICtrlOut, RegHIOut, MuxLOCtrlOut, RegLOOut, MuxAluSrcAOut, MuxAluSrcBOut, OffsetExtendidoLeft2, OffsetExtendido, OffsetSamtExtendido, LTExtendido, OffsetExtendidoLeft16, JumpAddress, RegWriteOutB;
wire [4:0] RS, RT, RD, MuxRegDstOut, RegBOutCortado, MuxShiftAmtOut;
wire [15:0] Offset;

wire Negativo, Zero, GT, LT, EQ; // 1bit da ALU
output wire Overflow;

// flags de controle
wire WriteCond;
wire PCWrite;
wire RegWrite;
wire Wr;
wire IRWrite;
wire WriteRegA;
wire WriteRegB;
wire AluOutControl;
wire EPCWrite;
wire ShiftSrc;
wire DivCtrl;
wire DivDone;
wire Div0;
wire MultCtrl;
wire MultDone;
wire HICtrl;
wire LOCtrl;
wire WriteHI;
wire WriteLO;
wire MDRCtrl;
wire [1:0] ShiftAmt;
wire [1:0] ExceptionsCtrl;
wire [1:0] LSControl;
wire [1:0] VMControl;
wire [1:0] AluSrcA;
wire [2:0] AluSrcB;
output wire [2:0] AluOp;
wire [2:0] PCSource;
wire [2:0] IorD;
wire [2:0] ShiftCtrl;
output wire [2:0] RegDst;
wire [3:0] MemToReg;

assign RegBOutCortado = RegBOut[4:0];
assign OffsetExtendido = {{17{Offset[15]}}, Offset[14:0]};      
assign OffsetExtendidoLeft2 = OffsetExtendido << 2;
assign OffsetExtendidoLeft16 = OffsetExtendido << 16;
assign Funct = Offset[5:0];
assign Shamt = Offset[10:6];
assign RD = Offset[15:11];
assign JumpAddress = {RegPCOut[31:28], RS[4:0], RT[4:0], Offset[15:0] ,2'b0};
assign LTExtendido = {31'b0, LT};
assign ExceptionBitExtendido = {31'b0, MemData[0]};

Registrador A(clock, reset, WriteRegA, RegWriteOutA, RegAOut);
 
Registrador B(clock, reset, WriteRegB, RegWriteOutB, RegBOut);

Registrador PC (clock, reset, PCWrite, MuxPCSourceOut, RegPCOut);

Registrador EPC (clock, reset, EPCWrite, AluResult, RegEPCOut);
 
Registrador AluOut (clock, reset, AluOutControl, AluResult, RegAluOutOut);
 
Registrador MDR(clock, reset, MDRCtrl, MemData, RegMDROut);
 
Registrador HI(clock, reset, WriteHI, MuxHICtrlOut, RegHIOut);
 
Registrador LO(clock, reset, WriteLO, MuxLOCtrlOut, RegLOOut);
 
Banco_reg banco_registradores(clock, reset, RegWrite, RS, RT, MuxRegDstOut, MuxMemToRegOut, RegWriteOutA, RegWriteOutB);
 
RegDesloc regdesloc(clock, reset, ShiftCtrl, MuxShiftAmtOut, MuxShiftSrcOut, RegDeslocOut);
 
Control controle(
    
    .clock(clock), 
    .reset(reset), 
    .Opcode(Opcode), 
    .Funct(Funct), 
    .WriteCond(WriteCond), 
    .PCWrite(PCWrite), 
    .RegWrite(RegWrite), 
    .Wr(Wr), 
    .IRWrite(IRWrite), 
    .WriteRegA(WriteRegA), 
    .WriteRegB(WriteRegB),
	.AluOutControl(AluOutControl), 
    .EPCWrite(EPCWrite), 
    .ShiftSrc(ShiftSrc), 
    .DivCtrl(DivCtrl), 
    .MultCtrl(MultCtrl), 
    .HICtrl(HICtrl), 
    .LOCtrl(LOCtrl), 
    .WriteHI(WriteHI),
    .WriteLO(WriteLO), 
    .MDRCtrl(MDRCtrl), 
    .DivDone(DivDone), 
    .Div0(Div0), 
    .MultDone(MultDone), 
    .Overflow(Overflow), 
    .Negativo(Negativo), 
    .Zero(Zero), 
    .EQ(EQ), 
    .GT(GT), 
    .LT(LT), 
    .LSControl(LSControl), 
    .SSControl(VMControl), 
    .ExceptionCtrl(ExceptionsCtrl),
    .AluSrcA(AluSrcA), 
    .ShiftAmt(ShiftAmt), 
    .AluSrcB(AluSrcB), 
    .AluOp(AluOp), 
    .PCSource(PCSource), 
    .IorD(IorD), 
    .ShiftCtrl(ShiftCtrl), 
    .RegDst(RegDst), 
    .MemToReg(MemToReg), 
    .estado(estado));

 
Memoria memoria(MuxIorDOut, clock, Wr, VMControlOut, MemData);
 
Instr_Reg InstructionRegisters (clock, reset, IRWrite, MemData, Opcode, RS, RT, Offset);	

ula32 Alu(MuxAluSrcAOut, MuxAluSrcBOut, AluOp, AluResult, Overflow, Negativo, Zero, EQ, GT, LT);

MuxIorD MuxIorD(RegPCOut, MuxExceptionsCtrlOut, AluResult, RegAluOutOut, RegAOut, IorD, MuxIorDOut);
 
MuxRegDst MuxRegDst(RS, RT, RD, RegDst, MuxRegDstOut);
 
MuxAluSrcA MuxAluSrcA(RegPCOut, RegBOut, RegAOut, RegMDROut, AluSrcA, MuxAluSrcAOut);

MuxAluSrcB MuxAluSrcB(RegBOut, OffsetExtendido, LSControlOut, OffsetExtendidoLeft2, AluSrcB, MuxAluSrcBOut);

MuxPCSrc MuxPCSource(RegAOut, AluResult, JumpAddress, RegAluOutOut, RegEPCOut, ExceptionBitExtendido, PCSource, MuxPCSourceOut); //depos faï¿½o essses

MuxExcp MuxExceptionsCtrl(ExceptionsCtrl, MuxExceptionsCtrlOut);

MuxShiftSrc MuxShiftSrc(RegAOut, RegBOut, ShiftSrc, MuxShiftSrcOut);

MuxShiftAmt MuxShiftAmt(RegBOutCortado, Shamt, RegMDROut[4:0], ShiftAmt, MuxShiftAmtOut);

MuxMemToReg MuxMemToReg(LTExtendido, LSControlOut, RegDeslocOut, RegHIOut, RegLOOut, RegBOut, RegAOut, RegAluOutOut, OffsetExtendidoLeft2, OffsetExtendidoLeft16, MemToReg, MuxMemToRegOut);

MuxHI MuxHICtrl(DivCtrlHIOut, MultCtrlHIOut, HICtrl, MuxHICtrlOut);

MuxLO MuxLOCtrl(DivCtrlLOOut, MultCtrlLOOut, LOCtrl, MuxLOCtrlOut);

LoadSize LS(RegMDROut, LSControl, LSControlOut);

StoreSize VM(RegBOut, RegMDROut, VMControl, VMControlOut);

Mult Mult(RegAOut, RegBOut, clock, reset, MultCtrl, MultDone, MultCtrlHIOut, MultCtrlLOOut);

Div Div(RegAOut, RegBOut, clock, reset, DivCtrl, DivDone, Div0, DivCtrlHIOut, DivCtrlLOOut);

endmodule