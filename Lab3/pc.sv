`timescale 1ns/10ps

module pc (in, out, clk, reset);
	input logic clk, reset;
	input logic [63:0] in;
	output logic [63:0] out;
	
	genvar i;
	generate
		for(i=0; i<64; i++) begin: individualDFFs
			D_FF myDFF (.q(out[i]), .d(in[i]), .reset(reset), .clk(clk));
		end
	endgenerate
	
endmodule


module pc_testbench();
	logic[63:0] in, out;
	logic clk, reset;
	
	pc dut (.in, .out, .clk, .reset);
	
	initial begin
		clk = 0; reset = 0; in = 64'hFFFFFFFFFFFFFFFF; #100;
		clk = 1; reset = 0; in = 64'hFFFFFFFFFFFFFFFF; #100;
		clk = 0; reset = 0; in = 64'hFFFFFFFFFFFFFFFF; #100;
		clk = 0; reset = 0; in = 64'hF000000000000000; #100;
		clk = 0; reset = 1; in = 64'hF000000000000000; #100;
		clk = 1; reset = 0; in = 64'hF000000000000000; #100;
		clk = 0; reset = 0; in = 64'hF000000000000000; #100;
		clk = 0; reset = 0; in = 64'hF000000000000000; #100;
		clk = 0; reset = 0; in = 64'hF000000000000000; #100;
		clk = 1; reset = 1; in = 64'hF000000000000000; #100;
		clk = 0; reset = 0; in = 64'hF000000000000000; #100;
		clk = 0; reset = 0; in = 64'hF000000000000000; #100;
		clk = 1; reset = 0; in = 64'hF000000000000000; #100;
		clk = 0; reset = 0; in = 64'hF000000000000000; #100;
		clk = 0; reset = 0; in = 64'hF000000000000000; #100;
	end
endmodule