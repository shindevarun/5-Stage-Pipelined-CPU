`timescale 1ns/10ps
module decoder5_32(out, in, RegWrite);
	output logic [31:0] out;
	input logic [4:0] in;
	logic [3:0] outIntermediate;
	logic [7:0] out31_24, out23_16, out15_8, out7_0;
	input logic RegWrite;
	
	// 2:4 decoder for in[4:3]
	decoder2_4 dec2_4init (.outIntermediate(outIntermediate), .A(in[4]), .B(in[3]));
	
	// initialize 4 3:8 decoders
	decoder3_8 dec3_8init31_24 (.out(out31_24), .C(in[2]), .D(in[1]), .E(in[0]), .enable(outIntermediate[3]));
	decoder3_8 dec3_8init23_16 (.out(out23_16), .C(in[2]), .D(in[1]), .E(in[0]), .enable(outIntermediate[2]));
	decoder3_8 dec3_8init15_8 (.out(out15_8), .C(in[2]), .D(in[1]), .E(in[0]), .enable(outIntermediate[1]));
	decoder3_8 dec3_8init7_0 (.out(out7_0), .C(in[2]), .D(in[1]), .E(in[0]), .enable(outIntermediate[0]));
	
	

	genvar i;
	generate
		for(i = 0; i < 8; i++) begin : gudshit
			and AND1 (out[i+24], out31_24[i], out31_24[i], RegWrite);
			and AND2 (out[i+16], out23_16[i], out23_16[i], RegWrite);
			and AND3 (out[i+8], out15_8[i], out15_8[i], RegWrite);
			and AND4 (out[i+0], out7_0[i], out7_0[i], RegWrite);
		end
	endgenerate

	
		
	
endmodule
//
module decoder5_32_testbench();
	logic [31:0] out;
	logic [4:0] in;
	logic [3:0] outIntermediate;
	logic [7:0] out31_24, out23_16, out15_8, out7_0;
	logic RegWrite;

	decoder5_32 dut (.out(out), .in(in), .RegWrite(RegWrite));
	
	integer i;
	initial begin
		RegWrite = 0;
		for(i = 0; i < 32; i++) begin
			in = i; #100;
		end
		
		RegWrite = 1;
//		integer j;
		for(i = 0; i < 32; i++) begin
			in = i; #100;
		end
	end
//endmodule
	
//	initial begin
//		RegWrite = 0;
//		integer j;
//		for(j = 0; j < 32; j++) begin
//			in = j; #100;
//		end
//	end
endmodule

						
	
	
	