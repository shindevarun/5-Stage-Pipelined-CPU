`timescale 1ns/10ps
module InstructionFetch(currPC, BrAddr, BranchTaken, instruction, clk, reset);
	input logic BranchTaken, clk, reset;
	input logic [63:0] BrAddr;
	output [63:0]currPC; 
	output [31:0]instruction;
	
	logic [63:0] pcPlus4, nextPC;
	
	
	// getting the current instruction from the instruction memory
	instructmem getCurrInstruction (.address(currPC), .instruction(instruction), .clk(clk));
	
	
	// increment current program counter by 4
	fullAdder64 instructionPlus4 (.A(currPC), .B(64'd4), .out(pcPlus4));
	
	
	// choose between plus 4 or branch
	mux128_64 pcBranchMux (.A(pcPlus4), .B(BrAddr), .out(nextPC), .sel(BranchTaken));
	
	// move PC to correct next address
	pc nextDest (.in(nextPC), .out(currPC), .clk(clk), .reset(reset));

	
endmodule