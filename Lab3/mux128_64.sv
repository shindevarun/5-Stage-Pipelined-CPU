`timescale 1ns/10ps

module mux128_64(A, B, out, sel);
	input logic [63:0] A, B;
	output logic [63:0] out;
	input logic sel;
	
	genvar i;
	generate 
		for(i = 0; i <64; i++) begin: eachBit
			mux2_1 mux1 (.out(out[i]), .i0(A[i]), .i1(B[i]), .sel(sel));
		end
	endgenerate
endmodule

module mux128_64_testbench();
	logic [63:0] A, B, out;
	logic sel;
	
	mux128_64 dut (.A, .B, .out, .sel);
	
	initial begin
		A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000000; sel = 0; #100;
		A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000000; sel = 1; #100;
		A = 64'hFFFFFFFFFFFFFFFF; B = 64'h000000000000000A; sel = 1; #100;
		A = 64'hF000000000000000; B = 64'h0000000000000000; sel = 0; #100;
		
	end
endmodule
