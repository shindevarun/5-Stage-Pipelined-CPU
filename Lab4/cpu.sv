`timescale 1ns/10ps
//module cpu(clk, reset);
//	input logic clk, reset;
//	
//	logic [31:0] instruction;
//	
//	logic zero, negative, overflow, carry_out, zero_flag, negative_flag, overflow_flag, carry_out_flag, xorNegFlag;
//	logic Reg2Loc, MemToReg, RegWrite, MemWrite, UncondBr, BrTaken, SInstr, RShift;
//	logic [1:0] ALUSrc, ALUSel, BrSelect;
//	logic [2:0] ALUOp;
//	
//	instructionPath InstructionFetch (.UncondBr(UncondBr), .BrTaken(BrTaken), .clk(clk), .reset(reset), .instruction(instruction));
//	
//	controlLogic Controller (.instruction, .Reg2Loc, .ALUSrc, .MemToReg, .RegWrite, .MemWrite, .BrSelect, .UncondBr, .ALUOp, .SInstr, .ALUSel, .RShift);
//								
//	datapath MainDataPath (.instruction, .Reg2Loc, .ALUSrc, .ALUSel, .RegWrite, .MemToReg, .MemWrite, .ALUOp, .clk,
//					  .negative, .zero, .overflow, .carry_out, .RShift);
//				 
//	flagRegister Flags (.negative, .zero, .overflow, .carry_out, .SInstr, .negative_flag, .zero_flag, .overflow_flag, .carry_out_flag, .clk);
//	
//	//sets Branch Taken variable for the control path (instuct path)
//	//zero is for cbz, negative flag is for B.lt
//	xor #(50ps) XORnegFlag (xorNegFlag, negative_flag, overflow_flag);
//	mux4_1 BrTakenMux (.out(BrTaken), .i0(0), .i1(1), .i2(zero), .i3(xorNegFlag), .sel(BrSelect));
//	
//endmodule 





// pipeline CPU work in progress. Comment this out and uncomment the top (Lab 3 CPU) if trying to compile
module cpu(clk, reset);
	input logic clk, reset;
	
//	logic BrAddr26ExtendedD;
//	logic CondAddr19ExtendedD;
//	
//	register_Nbit #(.N(26)) BrAddr_CondAddr_Pipeline(.q(InstrD), .d(BrAddr26ExtendedD), .clk(clk), .reset(reset));
	
	
	
	//-----------------------------------------------Instruction Fetch Stage--------------------------------------------------------//
	logic[31:0] InstrF;
	logic[63:0] pcIF, pcBrD;
	logic BranchTaken;
	//---------------//
	logic[31:0] InstrD;
	logic[63:0] pcD;
	//----------------//
	logic [1:0] ALUSelD, BrSelectD, ALUSrcD;
	logic UncondBrD, RegWriteD, MemToRegD, MemWriteD, SInsrtD, RShiftD, Reg2LocD;
	logic [2:0] ALUOpD;
	//-----------------//
	logic [1:0] ForwardA, ForwardB;
	logic [4:0] RdD;
	logic [5:0] ShAmtD;
	logic [63:0] DaD, DbD, DAddr9ExtendedD, Imm12ExtendedD;
	//----------------//
	logic LtFlagInput, xorNegFlag, xorNegForward, SInstrE;
	//----------------//
	logic zeroIn;
	logic [31:0] cbzNor, cbzAnd;
	//-----------------//
	logic [63:0] Imm12ExtendedE, DAddr9ExtendedE, DaE, DbE;
	logic [5:0] ShAmtE;
	logic [4:0] RdE;
	logic [2:0] ALUOpE;
	logic [1:0] ALUSelE, ALUSrcE; 
	logic UncondBrE, RegWriteE, MemToRegE, MemWriteE, RShiftE;
	//------------------//
	logic negative, zero, overflow, carry_out;
	logic [63:0] ALUOutE;
	//-----------------//
	logic negative_flag, zero_flag, overflow_flag, carry_out_flag;
	//------------------//
	logic UncondBrM, RegWriteM, MemToRegM, MemWriteM;
	logic [63:0] ALUOutM, DbM;
	logic [4:0] RdM;
	//--------------------//
	logic [63:0] MemToRegOutM;
	//--------------------//
	logic UncondBrW, RegWriteW;
	logic [4:0] RdW;
	logic [63:0] MemToRegOutW;
	
	logic [4:0] Aa, Ab;
	
	
	
//	InstructionPath fetchStage(.UncondBr(UncondBrWrite), .BrTaken(BrTakenE), .clk(clk), .reset(reset), .instruction(InstrF));
	InstructionFetch fetchStage(.currPC(pcIF), .BrAddr(pcBrD), .BranchTaken(BranchTaken), .instruction(InstrF), .clk(clk), .reset(reset));
	
	
	
	
	//-----------------------------------------------IF/DEC Pipeline Register-------------------------------------------------------//
	
	
	InstructionRegister instrReg (.InstrF(InstrF), .InstrD(InstrD), .pcIF(pcIF), .pcD(pcD), .clk(clk), .reset(reset)); 
	
	
	
	
	//----------------------------------------------------Control Signals-----------------------------------------------------------//
	
	
	controlLogic controlSignals(.instruction(InstrD), .Reg2Loc(Reg2LocD), .ALUSrc(ALUSrcD), .MemToReg(MemToRegD), .RegWrite(RegWriteD), 
											.MemWrite(MemWriteD), .BrSelect(BrSelectD), .UncondBr(UncondBrD), .ALUOp(ALUOpD), .SInstr(SInstrD), 
											.ALUSel(ALUSelD), .RShift(RShiftD));

	
	
	
	//-----------------------------------------------------Decode Stage-------------------------------------------------------------//
	
	// call InstructionDecode (I.D. module should have all logic pertaining to regfile and forwarding)
	
	

	
	InstructionDecode Reg_Dec(.clk(clk), .reset(reset), .InstrD(InstrD), .Reg2LocD(Reg2LocD), .RegWriteW(RegWriteW), .RdW(RdW), .MemToRegOutM(MemToRegOutM), .ALUOutE(ALUOutE), .MemToRegOutW(MemToRegOutW), .ForwardA(ForwardA), .ForwardB(ForwardB), .pcD(pcD), .UncondBrD(UncondBrD),
	.Aa(Aa), .Ab(Ab), .RdD(RdD), .DaD(DaD), .DbD(DbD), .ShAmtD(ShAmtD), .DAddr9ExtendedD(DAddr9ExtendedD), .Imm12ExtendedD(Imm12ExtendedD), .pcBrD(pcBrD));
	
	
	
	//***Forward Module***//
	//Only covers write read hazard not branching
	
	ForwardUnit Forwarding (.Aa(Aa), .Ab(Ab), .RdE(RdE), .RdM(RdM), .RegWriteE(RegWriteE), .RegWriteM(RegWriteM), .ForwardA(ForwardA), .ForwardB(ForwardB));
	
	
	
	
	//----------------***Accelerated Branching***--------//
	
	
	//***Flag Forwarding**//
	//If SinstrE is true, use the flag output of the ALU in exec instead of register value
	
	
	xor #(50ps) XORNEGFLAG (xorNegFlag, negative_flag, overflow_flag);
	xor #(50ps) XORNEGFWD (xorNegForward, negative, overflow);
	
		
	mux2_1 FLAGFWDMUX (.out(LtFlagInput), .i0(xorNegFlag), .i1(XORnegFwd), .sel(SInstrE));
	
	
	//For Cbz, Nor the bits of RdD
	
	
	genvar i, j;
	generate
		for (i = 0; i < 32; i++) begin: nor_calc
			nor NOR (cbzNor[i], DbD[2*i], DbD[2*i+1]);
		end
		nor ANDSetup (cbzAnd[0], cbzNor[0], cbzNor[1]);
		for (j = 1; j<32; j++) begin: nor_and
			and AND (cbzAnd[j], cbzNor[j], cbzAnd[j-1]);
		end
	endgenerate

	
	
	
	assign cbzIn = cbzAnd[31];
	
	//Branching Mux formerly in Exec
	mux4_1 BrTakenMux (.out(BranchTaken), .i0(0), .i1(1), .i2(zeroIn), .i3(LtFlagInput), .sel(BrSelectD));
	
	
	
	
	//------------------------------------------------DEC/EX Pipeline Register------------------------------------------------------//
	//	logic[63:0] Da, Db, DAddr9ExtendedD, Imm12ExtendedD, 
	// call DecodeRegister (pipeline between dec and ex that holds relevant data)

	
	
	DecodeRegister RegExec(.clk(clk), .reset(reset), .Imm12ExtendedD(Imm12ExtendedD), .DAddr9ExtendedD(DAddr9ExtendedD), .RdD(RdD), .DaD(DaD), .DbD(DbD), .ALUSelD(ALUSelD), .UncondBrD(UncondBrD), .RegWriteD(RegWriteD), .MemToRegD(MemToRegD), .MemWriteD(MemWriteD), .ALUOpD(ALUOpD), .ALUSrcD(ALUSrcD), .SInstrD(SInstrD), .ShAmtD(ShAmtD), .RShiftD(RShiftD),
														  .Imm12ExtendedE(Imm12ExtendedE), .DAddr9ExtendedE(DAddr9ExtendedE), .RdE(RdE), .DaE(DaE), .DbE(DbE), .ALUSelE(ALUSelE), .UncondBrE(UncondBrE), .RegWriteE(RegWriteE), .MemToRegE(MemToRegE), .MemWriteE(MemWriteE), .ALUOpE(ALUOpE), .ALUSrcE(ALUSrcE), .SInstrE(SInstrE), .ShAmtE(ShAmtE), .RShiftE(RShiftE));




	//----------------------------------------------------Execute Stage-------------------------------------------------------------//
	// create InstructionExecute module with all logic related to ALU, flag register, etc
	

	InstructionExecute Exec(.DaE(DaE), .DbE(DbE), .ShAmtE(ShAmtE), .ALUSrcE(ALUSrcE), .ALUOpE(ALUOpE), .ALUSelE(ALUSelE), .DAddr9ExtendedE(DAddr9ExtendedE), .Imm12ExtendedE(Imm12ExtendedE), .RShiftE(RShiftE),
							      .negative(negative), .zero(zero), .overflow(overflow), .carry_out(carry_out), .ALUOutE(ALUOutE));
									

	//***Flag Register***
	
	flagRegister Flags (.negative(negative), .zero(zero), .overflow(overflow), .carry_out(carry_out), .SInstr(SInstrE), .negative_flag(negative_flag), .zero_flag(zero_flag), .overflow_flag(overflow_flag), .carry_out_flag(carry_out_flag), .clk(clk));
	
	
	
	
	
	//------------------------------------------------EX/MEM Pipeline Register------------------------------------------------------//
	// create and call ExecuteRegister (pipeline between ex and mem that holds relevant data)
	
	ExecuteRegister ExecMem (.clk(clk), .reset(reset), .UncondBrE(UncondBrE), .RegWriteE(RegWriteE), .MemToRegE(MemToRegE), .MemWriteE(MemWriteE), .ALUOutE(ALUOutE), .DbE(DbE), .RdE(RdE),
																		.UncondBrM(UncondBrM), .RegWriteM(RegWriteM), .MemToRegM(MemToRegM), .MemWriteM(MemWriteM), .ALUOutM(ALUOutM), .DbM(DbM), .RdM(RdM));
	
	
	
	
	//----------------------------------------------------Memory Stage--------------------------------------------------------------//
	// create InstructionMemory module with all logic related to data mem access and wb mux
	
	
	InstructionMemory Mem(.ALUOutM(ALUOutM), .DbM(DbM), .RdM(RdM), .MemWriteM(MemWriteM), .MemToRegM(MemToRegM),
						       .MemToRegOutM(MemToRegOutM));
	
	
	
	
	
	//------------------------------------------------MEM/WB Pipeline Register------------------------------------------------------//
	// create and call MemoryRegister (pipeline between mem and wb that holds relevant data)
	
	MemoryRegister MemWr(.clk(clk), .reset(reset), .UncondBrM(UncondBrM), .RegWriteM(RegWriteM), .MemToRegOutM(MemToRegOutM), .RdM(RdM),
																  .UncondBrW(UncondBrW), .RegWriteW(RegWriteW), .MemToRegOutW(MemToRegOutW), .RdW(RdW));


		
endmodule





//module cpu_testbench();
//	logic clk;
//	cpu dut(.clk);
//	
//	parameter CLOCK_PERIOD=10000;
//		initial begin
//		clk <= 0;
//	forever #(CLOCK_PERIOD/2) clk <= ~clk;
//	end
//	
//	int i;
//	
//   initial begin
//	
//	@(posedge clk);
//	 @(posedge clk);
//		           @(posedge clk);
//		for (i=0; i<100; i++) begin
//			@(posedge clk);
//		end
//		$stop;
//	end
//
//endmodule