`timescale 1ns/10ps
module InstructionDecode(clk, reset, InstrD, Reg2LocD, RegWriteW, RdW, MemToRegOutM, ALUOutE, MemToRegOutW, ForwardA, ForwardB, pcD, UncondBrD,
								 Aa, Ab, RdD, DaD, DbD, ShAmtD, DAddr9ExtendedD, Imm12ExtendedD, pcBrD);
	
	
	input logic [31:0] InstrD;
	input logic clk, reset, Reg2LocD, RegWriteW, UncondBrD;
	input logic [4:0] RdW;
	input logic [63:0] MemToRegOutW, MemToRegOutM;
	input logic [1:0] ForwardA, ForwardB;
	input logic [63:0] pcD;
	input logic [63:0] ALUOutE;
	
	output logic [4:0] RdD;
	output logic [5:0] ShAmtD;
	output logic [63:0] DaD, DbD, DAddr9ExtendedD, Imm12ExtendedD;
	output logic [63:0] pcBrD;
	
	output logic [4:0] Aa, Ab;
	
	genvar i;
	//Rd to Aw wire
	assign RdD = InstrD[4:0];
	//Rn to Aa wire
	assign Aa = InstrD[9:5];
	
	//Reg2Loc 5 bit 2 to 1 mux to get Ab (Either Rd or Rm =InstrD[20:16])
	generate 
		for (i = 0; i < 5; i++) begin: Muxer
			mux2_1 Reg2LocMux (.out(Ab[i]), .i0(InstrD[i]), .i1(InstrD[i+16]), .sel(Reg2LocD));
		end
	endgenerate
	
	
	
	//Da, Db are outputs of Regfile, Rd is variable to be written to regfile=. 
	
	logic [63:0] Da, Db, Dw;
	regfile REGFILE (.ReadData1(Da), .ReadData2(Db), .WriteData(MemToRegOutW), .ReadRegister1(Aa), .ReadRegister2(Ab), .WriteRegister(RdW), .RegWrite(RegWriteW), .clk(~clk));
	
	//extend the potential operators for the ALU
	logic [63:0] DAddr9Extended, Imm19Extended;
	
	signExtend #(.inputSize(9)) DADDR9EXTEND (.in(InstrD[20:12]), .isSigned(1), .out(DAddr9ExtendedD));
	
	signExtend #(.inputSize(12)) IMM12EXTEND (.in(InstrD[21:10]), .isSigned(0), .out(Imm12ExtendedD));
	
	
	
	// branching path
	
	logic [63:0] brAddr, condAddr, condAddrMuxOut, shiftedOut;
//	output logic[63:0] BrAddr; 
	// extend br and cond addr
	signExtend #(.inputSize(19)) condAddrExtenderID (.in(InstrD[23:5]), .isSigned(1'b1), .out(condAddr));
	signExtend #(.inputSize(26)) brAddrExtenderID (.in(InstrD[25:0]), .isSigned(1'b1), .out(brAddr));
	
	// choose between cond and br addr
	mux128_64 conditionalBranchMuxID (.A(condAddr), .B(brAddr), .out(condAddrMuxOut), .sel(UncondBrD));
	
	
	// left shift output from condional mux by 2is ther
	leftShift2 leftShifterID (.value(condAddrMuxOut), .out(shiftedOut));
	
	// pc plus output from left shifter (pc plus the address to branch to)
	fullAdder64 instructionPlusBranchDestID (.A(pcD), .B(shiftedOut), .out(pcBrD));
		
	
//	logic [5:0] ShAmtD;
	assign ShAmtD = InstrD[15:10];
	
	
	//FORWARDING MULTIPLEXERS:
	genvar j; 
	generate 
		for (j = 0; j < 64; j++) begin: ForwardingMux
			mux4_1 AForward (.out(DaD[j]), .i0(Da[j]), .i1(ALUOutE[j]), .i2(MemToRegOutM[j]), .i3(1'b1), .sel(ForwardA));
			mux4_1 BForward (.out(DbD[j]), .i0(Db[j]), .i1(ALUOutE[j]), .i2(MemToRegOutM[j]), .i3(1'b1), .sel(ForwardB));
		end
	endgenerate
	
	
	
endmodule 
