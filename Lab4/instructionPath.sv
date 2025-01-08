`timescale 1ns/10ps

module instructionPath (UncondBr, BrTaken, clk, reset, instruction);
	input logic clk, reset, UncondBr, BrTaken;
	output logic [31:0] instruction;
	
	logic [63:0] currPC, normalPC, condAddr, brAddr, condAddrMuxOut, shiftedOut, pcPlusBranchDest, brTakenOut, newPC;
	
	// getting the current instruction from the instruction memory
	instructmem getCurrInstruction (.address(currPC), .instruction(instruction), .clk(clk));
	
	// increment current program counter by 4
	fullAdder64 instructionPlus4 (.A(currPC), .B(64'd4), .out(normalPC));
	
	// sign extend conditional Address 19 and Branch Address 26
	signExtend #(.inputSize(19)) condAddrExtender (.in(instruction[23:5]), .isSigned(1'b1), .out(condAddr));
	signExtend #(.inputSize(26)) brAddrExtender (.in(instruction[25:0]), .isSigned(1'b1), .out(brAddr));
	
	// choose between condtional Address 19 or Branch Address 26
	mux128_64 conditionalBranchMux (.A(condAddr), .B(brAddr), .out(condAddrMuxOut), .sel(UncondBr));
	
	// left shift output from condional mux by 2is ther
	leftShift2 leftShifter (.value(condAddrMuxOut), .out(shiftedOut));
	
	// pc plus output from left shifter (pc plus the address to branch to)
	fullAdder64 instructionPlusBranchDest (.A(currPC), .B(shiftedOut), .out(pcPlusBranchDest));
	
	// choose between sending through branched value or not
	mux128_64 pcBranchMux (.A(normalPC), .B(pcPlusBranchDest), .out(brTakenOut), .sel(BrTaken));
	
	// move PC to correct next address
	pc nextDest (.in(brTakenOut), .out(currPC), .clk(clk), .reset(reset));
	
endmodule


module instructionPath_testbench;
	logic clk, reset, BrTaken, UncondBr;
	logic [31:0] instruction;

	instructionPath dut(.UncondBr, .BrTaken, .clk, .reset, .instruction);

	parameter CLOCK_PERIOD= 1000;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	integer i;
	always_comb begin
		if(instruction[31:26] == 6'b000101) begin
			UncondBr = 1'b1;
			BrTaken = 1'b1;
		end
		
		else if(instruction[31:24] == 8'b10110100) begin
			UncondBr = 1'b0;
			BrTaken = 1'b1;
		end
		
		else begin
			UncondBr = 1'b0;
			BrTaken = 1'b0;
		end
	end
	
	initial begin
		reset <= 1'b1;
		@(posedge clk);
		reset <= 1'b0;
		for(i = 0; i < 20 ; i++) begin
			@(posedge clk);
		end
		$stop;
	end
			
		

endmodule	