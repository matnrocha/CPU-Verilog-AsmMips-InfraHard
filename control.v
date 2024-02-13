module Control(

// Control Units Inputs/Outputs

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
    ShiftAmt,
    DivCtrl,
    MultCtrl,
    HICtrl,
    LOCtrl,
    WriteHI,
    WriteLO,
    MDRCtrl,

input wire
    DivDone,
    MultDone,
    Div0,
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
    estado,

) 
