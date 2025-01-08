`timescale 1ns/10ps
module cpu(clk, reset);
	input logic clk, reset;
	
	logic [31:0] instruction;
	
	logic zero, negative, overflow, carry_out, zero_flag, negative_flag, overflow_flag, carry_out_flag;
	logic Reg2Loc, MemToReg, RegWrite, MemWrite, UncondBr, BrTaken, SInstr, RShift;
	logic [1:0] ALUSrc, ALUSel, BrSelect;
	logic [2:0] ALUOp;
	
	instructionPath InstructionFetch (.UncondBr(UncondBr), .BrTaken(BrTaken), .clk(clk), .reset(reset), .instruction(instruction));
	
	controlLogic Controller (.instruction, .Reg2Loc, .ALUSrc, .MemToReg, .RegWrite, .MemWrite, .BrSelect, .UncondBr, .ALUOp, .SInstr, .ALUSel, .RShift);
								
	datapath MainDataPath (.instruction, .Reg2Loc, .ALUSrc, .ALUSel, .RegWrite, .MemToReg, .MemWrite, .ALUOp, .clk,
					  .negative, .zero, .overflow, .carry_out, .RShift);
				 
	flagRegister Flags (.negative, .zero, .overflow, .carry_out, .SInstr, .negative_flag, .zero_flag, .overflow_flag, .carry_out_flag, .clk);
	
	//sets Branch Taken variable for the control path (instuct path)
	//zero is for cbz, negative flag is for B.lt
	mux4_1 BrTakenMux (.out(BrTaken), .i0(0), .i1(1), .i2(zero), .i3(negative_flag), .sel(BrSelect));
	
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