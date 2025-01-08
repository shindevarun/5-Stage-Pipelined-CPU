`timescale 1ns/10ps

module signExtend #(parameter inputSize = 1) (in, isSigned, out);
	input logic [inputSize-1:0] in;
	input logic isSigned;
	output logic [63:0] out;
	logic extension;
	
	
	mux2_1 extender (.out(extension), .i0(0), .i1(in[inputSize-1]), .sel(isSigned));
	assign out[inputSize-1:0] = in;
	assign out[63:inputSize] = {(64-inputSize){extension}};
	
endmodule

module signExtend_testbench();
	
	parameter size = 12;
	logic isSigned;
	
	logic [size-1:0] in;
	logic [63:0] out;
	
	signExtend #(.inputSize(size)) dut (.in, .isSigned, .out);
	
	initial begin
		
		in = 0; isSigned = 0; #50;
		repeat (256) begin
			in++; #50;
		end
		in += 2 ** (size - 1); #200;
		
		in = 0; isSigned = 1; #50;
		repeat (256) begin
			in++; #50;
		end
		in += 2 ** (size - 1); #200;
		
		repeat (256) begin
			in++; #50;
		end 
	end
endmodule 