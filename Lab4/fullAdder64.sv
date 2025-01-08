`timescale 1ns/10ps

module fullAdder64(A, B, out);
	input logic [63:0] A, B;
	output logic [63:0] out;
	logic [63:0] carryConnect;
	
	// adder for least signigicant bit with carry in of 0
	// enable = 1 (we want to activiate adder); sub = 0 (we dont want to subtract)
	adder LSB (.a(A[0]), .b(B[0]), .cin(1'b0), .cout(carryConnect[0]), .out(out[0]), .sub(1'b0), .enable(1'b1)); 
	
	genvar i;
	generate
		for(i = 1; i < 64; i++) begin: adderCreator
			adder otherAdders (.a(A[i]), .b(B[i]), .cin(carryConnect[i-1]), .cout(carryConnect[i]), .out(out[i]), .sub(1'b0), .enable(1'b1));
		end
	endgenerate
	
endmodule


module fullAdder64_testbench();
	logic [63:0] A, B;
	logic [63:0] out;
	
	fullAdder64 dut(.A, .B, .out);
	
	initial begin
		A = 64'd10; B = 64'd20; #100;
		A = 64'd10000; B=64'd99999; #100;
		A = 64'd1; B=64'd2; #100;
		A = 64'd12345; B=64'd12345; #100;
	end
endmodule