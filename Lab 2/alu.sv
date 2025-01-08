`timescale 1ns/10ps

module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic [63:0] A, B;
	input logic [2:0] cntrl;
	output logic [63:0] result;
	output logic negative, zero, overflow, carry_out;
	
	logic [64:0] cout_temp;
	logic [19:0] zero_temp;
	logic [7:0] enabler;
	genvar i,j, k;
	
	
	// ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	
	decoder3_8 decoded (.out(enabler), .C(cntrl[2]), .D(cntrl[1]), .E(cntrl[0]), .enable(1));
	
	
	generate
		//first ALU, uses the subtract enable value to decide whether to add 1, and saves the carry out to a temp register
		alu1 ALU0 (.cout(cout_temp[1]), .out(result[0]), .a(A[0]), .b(B[0]), .cin(enabler[3]), .enabler(enabler));
		
		for (i = 1; i <64; i++) begin : alu_generate_block
			alu1 ALU(.cout(cout_temp[i+1]), .out(result[i]), .a(A[i]), .b(B[i]), .cin(cout_temp[i]), .enabler(enabler));
		end
		
	endgenerate
	
		//CARRY_OUT: writes the carryout of the last 1-bit alu to the carry_out output without using assign
	and AND_cout (carry_out, 1, cout_temp[64]);
	
	
	//OVERFLOW: generates overflow value based on the cin and cout of the last 1-bit alu
	xor XOR_overflow (overflow, cout_temp[64],cout_temp[63]);

	
	//ZERO: make zero flag by nor of alu result while maintaiining the imposed max 4 inputs to gates
	//nor gates will all output 1 if all values are zeroes. And of all nor gate outputs is equvalent to a single nor gate of all values
	generate
		//break the result into 16 groups of 4 to be "nor"ed
		for (j = 0; j <16; j++) begin : zero_nor_generate
			nor NOR (zero_temp[j], result[4*j], result[4*j + 1], result[4*j + 2], result[4*j + 3]);
		end
		
		//zero_temp 0-15 = the output of the nor gates
		//need to take the "and" of those values
		for (k = 0; k <4; k++) begin : zero_and_generate
			and AND (zero_temp[16 + k], zero_temp[k*4], zero_temp[k*4+1], zero_temp[k*4+2], zero_temp[k*4+3]);
		end
		
		//combine the outputs of the four "and" gates
		and AND_ZERO_OUT (zero, zero_temp[16], zero_temp[17],zero_temp[18],zero_temp[19]);
		
	endgenerate
	 
	 
	//NEGATIVE: The value of the first (most significant) bit is written to negative without using assign.
	and AND_SIGN (negative, 1, result[63]);
	
endmodule 

module alu_testbench();

	logic [63:0] A, B;
	logic [2:0] cntrl;
	logic [63:0] result;
	logic negative, zero, overflow, carry_out;
	
	alu dut(.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);
	
	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	
	initial begin
	
		// check for B_pass with changing A values
		cntrl = ALU_PASS_B;
		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0001; #10;
		A = 64'h0000_0000_0000_0001; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h0000_0000_0000_0001; B = 64'hffff_ffff_ffff_ffff; #10;
		
		
		
		// check for addition operations with changing both A and B
		cntrl = ALU_ADD;
		A = 64'h0000_0000_0000_0001; B = 64'h0000_0000_0000_0000; #10;
		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0001; #10; // result should still be same
		
		A = 64'h1000_0000_0000_0001; B = 64'h0000_0000_0000_0010; #10; // 1 + 2
		A = 64'hffff_ffff_ffff_ffff; B = 64'hffff_ffff_ffff_fffe; #10; // -1 + -2
		A = 64'h0000_0000_0000_0100; B = 64'hffff_ffff_ffff_fffd; #10; // 4 + -3
		A = 64'hffff_ffff_ffff_ffff; B = 64'h0000_0000_0000_0001; #10; // 2^64 + 1 = carry_out is 1
		A = 64'h7fff_ffff_ffff_ffff; B = 64'h0000_0000_0000_0001; #10; // overflow should be 1 & carry out should be 0
		
		
		
		
		// check for subtraction operations with changing A and B
		cntrl = ALU_SUBTRACT;
		A = 64'h0000_0000_0000_000a; B = 64'h0000_0000_0000_0009; #10; // 10 - 9	
		A = 64'h0000_0000_0000_0009; B = 64'h0000_0000_0000_000a; #10; // 9 - 10. should set off negative flag
		A = 64'h0000_0000_0000_000a; B = 64'h0000_0000_0000_0009; #10; // 9 - 9 // should set off the zero flag
		A = 64'h8000_0000_0000_0000; B = 64'h0000_0000_0000_0001; #10; // -2^63 - 1 // overflow = true, neg = true, zero = false, carry out = false
		
		
		
		// check for ADD signals
		cntrl = ALU_AND;
		A = 64'hffff_ffff_ffff_ffff; B = 64'hffff_ffff_ffff_ffff; #10; // output = 1
		A = 64'hffff_ffff_ffff_ffff; B = 64'h0000_0000_0000_0000; #10; // output = 0
		
		
		// check for OR signals
		cntrl = ALU_OR;
		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0000; #10; // output = 0
		A = 64'hffff_ffff_ffff_ffff; B = 64'hffff_ffff_ffff_ffff; #10; // output = 2^63
		A = 64'hffff_ffff_ffff_ffff; B = 64'h0000_0000_0000_0000; #10; // output = 2^63
		A = 64'h0000_0000_0000_0001; B = 64'h1000_0000_0000_0000; #10; // output = 100... + 1
		
		
		
		cntrl = ALU_XOR;
		A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0000; #10; // output = 0
		A = 64'hffff_ffff_ffff_ffff; B = 64'hffff_ffff_ffff_ffff; #10; // output = 0
		A = 64'hffff_ffff_ffff_ffff; B = 64'h0000_0000_0000_0000; #10; // output = 2^63
		A = 64'h0000_0000_0000_0001; B = 64'h0000_0000_0000_0010; #10; // output = 100... + 1
		
		
		
		
	end

	
endmodule
