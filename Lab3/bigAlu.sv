`timescale 1ns/10ps
module bigAlu (i0, i1, ALUOp, ALUSel, ShAmt, RShift, out, negative, zero, overflow, carry_out);
	input logic [63:0] i0, i1;
	
	input logic [5:0] ShAmt; //Shift amount
	
	// ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110
	input logic [2:0] ALUOp;
	
	//tiny_alu = 11, mult_low = 10, shift = 00, (DO NOT USE: mult_high = 01)
	input logic [1:0] ALUSel;
	
	//if 1 shift right, 0 shift left
	input logic RShift;
	
	output logic [63:0] out;
	output logic negative, zero, overflow, carry_out;
	
	logic [63:0] mult_low, mult_high, shifted, tiny_alu;
	
	//produces the multiplied high and low for signed binary numbers. For lab 3, we will only use ____
	mult MULT1(.A(i0), .B(i1), .doSigned(1'b1), .mult_low(mult_low), .mult_high(mult_high));
	
	//.direction is a 1 bit value (0 = left, 1 = right)
	shifter SHIFT1(.value(i0), .direction(RShift), .distance(ShAmt), .result(shifted));
	
	
	alu TINY_ALU(.A(i0), .B(i1), .cntrl(ALUOp), .result(tiny_alu), .negative(negative), .zero(zero), .overflow(overflow), .carry_out(carry_out));
	
	//following 10 or so lines of code replicate a multiplexer because this is how I did it in the previous labs and I don't feel like making a multiplexer.
	
	genvar i;
	generate
	
		for (i = 0; i < 64; i++) begin: mux_block
			mux4_1 ALUSELECT (.out(out[i]), .i0(shifted[i]), .i1(mult_high[i]), .i2(mult_low[i]), .i3(tiny_alu[i]), .sel(ALUSel));
		end
		
	endgenerate
	
endmodule 

module bigAlu_testbench();

	logic [63:0] A, B;
	logic [5:0] ShAmt;
	logic [2:0] cntrl;
	logic [1:0] ALUSel;
	logic [63:0] result;
	logic negative, zero, overflow, carry_out, RShift;
				// i0, i1, ALUOp, ALUSel, ShAmt, RShift, out, negative, zero, overflow, carry_out
	bigAlu dut(.i0(A), .i1(B), .ALUOp(cntrl), .ALUSel(ALUSel), .ShAmt(ShAmt), .RShift(RShift), .out(result), .negative(negative), .zero(zero), .overflow(overflow), .carry_out(carry_out));
	
	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	
	initial begin
	
		// check for B_pass with changing A values
		ShAmt = 6'b000000;
		RShift = 0;
		cntrl = ALU_PASS_B;
		ALUSel = 2'b11;
		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0001; #10;
		A = 64'h0000_0000_0000_0001; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h0000_0000_0000_0001; B = 64'hffff_ffff_ffff_ffff; #10;
		
		
		// check multiplier
		ALUSel = 2'b10;
		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0001; #10;
		A = 64'h0000_0000_0000_0001; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h0000_0000_0000_0001; B = 64'hffff_ffff_ffff_ffff; #10;
		A = 64'd2; B = 64'd4; #10;
		
		
		//check left shifter
		ALUSel = 2'b00;
		ShAmt = 6'b000001;
		//shift by 1 (will screw up hex)
		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h0000_0000_0000_1111; B = 64'h0000_0000_0000_0001; #10;
		A = 64'h0000_0011_0111_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h1111_0000_0000_0001; B = 64'hffff_ffff_ffff_ffff; #10;
		
		//shift 15
		ShAmt = 6'b010000;
		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h0000_0000_0000_1111; B = 64'h0000_0000_0000_0001; #10;
		A = 64'h0000_0011_0111_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h1111_0000_0000_0001; B = 64'hffff_ffff_ffff_ffff; #10;
		
		//shift 32
		ShAmt = 6'b100000;
		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h0000_0000_0000_1111; B = 64'h0000_0000_0000_0001; #10;
		A = 64'h0000_0011_0111_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h1111_0000_0000_0001; B = 64'hffff_ffff_ffff_ffff; #10;
		
		// shift 64
		ShAmt = 6'b111111;
		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h0000_0000_0000_0001; B = 64'h0000_0000_0000_0001; #10;
		A = 64'h0000_0011_0111_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h1111_0000_0000_0001; B = 64'hffff_ffff_ffff_ffff; #10;
		
		//check right shifter
		RShift = 1'b1;
		ALUSel = 2'b00;
		ShAmt = 6'b000001;
		//shift by 1 (will screw up hex)
		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h0000_0000_0000_1111; B = 64'h0000_0000_0000_0001; #10;
		A = 64'h0000_0011_0111_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h1111_0000_0000_0001; B = 64'hffff_ffff_ffff_ffff; #10;
		
		//shift 15
		ShAmt = 6'b010000;
		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h0000_0000_0000_1111; B = 64'h0000_0000_0000_0001; #10;
		A = 64'h0000_0011_0111_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h1111_0000_0000_0001; B = 64'hffff_ffff_ffff_ffff; #10;
		
		//shift 32
		ShAmt = 6'b100000;
		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h0000_0000_0000_1111; B = 64'h0000_0000_0000_0001; #10;
		A = 64'h0000_0011_0111_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h1111_0000_0000_0001; B = 64'hffff_ffff_ffff_ffff; #10;
		
		// shift 64
		ShAmt = 6'b111111;
		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h0000_0000_0000_0001; B = 64'h0000_0000_0000_0001; #10;
		A = 64'h0000_0011_0111_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h1111_0000_0000_0001; B = 64'hffff_ffff_ffff_ffff; #10;
		
		ALUSel = 2'b11;
		cntrl = 3'b010;
		A = 64'h0000_0000_0000_0001; B = 64'h0000_0000_0000_0001; #10;
		A = 64'h0000_0000_0000_0010; B = 64'h0000_0000_0000_0001; #10;
		
		
		

//		// check for addition operations with changing both A and B
//		ALUSel = 2'b11
//		cntrl = ALU_ADD;
//		A = 64'h0000_0000_0000_0001; B = 64'h0000_0000_0000_0000; #10;
//		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0001; #10; // result should still be same
//		
//		A = 64'h1000_0000_0000_0001; B = 64'h0000_0000_0000_0010; #10; // 1 + 2
//		A = 64'hffff_ffff_ffff_ffff; B = 64'hffff_ffff_ffff_fffe; #10; // -1 + -2
//		A = 64'h0000_0000_0000_0100; B = 64'hffff_ffff_ffff_fffd; #10; // 4 + -3
//		A = 64'hffff_ffff_ffff_ffff; B = 64'h0000_0000_0000_0001; #10; // 2^64 + 1 = carry_out is 1
//		A = 64'h7fff_ffff_ffff_ffff; B = 64'h0000_0000_0000_0001; #10; // overflow should be 1 & carry out should be 0
//		
//		
//		
//		
//		// check for subtraction operations with changing A and B
//		cntrl = ALU_SUBTRACT;
//		A = 64'h0000_0000_0000_000a; B = 64'h0000_0000_0000_0009; #10; // 10 - 9	
//		A = 64'h0000_0000_0000_0009; B = 64'h0000_0000_0000_000a; #10; // 9 - 10. should set off negative flag
//		A = 64'h0000_0000_0000_000a; B = 64'h0000_0000_0000_0009; #10; // 9 - 9 // should set off the zero flag
//		A = 64'h8000_0000_0000_0000; B = 64'h0000_0000_0000_0001; #10; // -2^63 - 1 // overflow = true, neg = true, zero = false, carry out = false
//		
//		
//		
//		// check for ADD signals
//		cntrl = ALU_AND;
//		A = 64'hffff_ffff_ffff_ffff; B = 64'hffff_ffff_ffff_ffff; #10; // output = 1
//		A = 64'hffff_ffff_ffff_ffff; B = 64'h0000_0000_0000_0000; #10; // output = 0
//		
//		
//		// check for OR signals
//		cntrl = ALU_OR;
//		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0000; #10; // output = 0
//		A = 64'hffff_ffff_ffff_ffff; B = 64'hffff_ffff_ffff_ffff; #10; // output = 2^63
//		A = 64'hffff_ffff_ffff_ffff; B = 64'h0000_0000_0000_0000; #10; // output = 2^63
//		A = 64'h0000_0000_0000_0001; B = 64'h1000_0000_0000_0000; #10; // output = 100... + 1
//		
//		
//		
//		cntrl = ALU_XOR;
//		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0000; #10; // output = 0
//		A = 64'hffff_ffff_ffff_ffff; B = 64'hffff_ffff_ffff_ffff; #10; // output = 0
//		A = 64'hffff_ffff_ffff_ffff; B = 64'h0000_0000_0000_0000; #10; // output = 2^63
//		A = 64'h0000_0000_0000_0001; B = 64'h0000_0000_0000_0010; #10; // output = 100... + 1
//		
		
		
		
	end

	
endmodule 