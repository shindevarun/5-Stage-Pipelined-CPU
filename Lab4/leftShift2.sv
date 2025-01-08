`timescale 1ns/10ps

module leftShift2(value, out);
	input logic [63:0] value;
	output logic [63:0] out;
	
	genvar i;
	generate
		for(i=63; i>1; i--) begin: leftShifter
			assign out[i] = value[i-2];
		end
	endgenerate
	
	assign out[1:0] = 2'b0;

endmodule


module leftShift2_testbench();
	logic [63:0] value, out;
	
	leftShift2 dut (.value, .out);
	
	initial begin
		value = 64'h0000000000000011; #100;
		value = 64'h0000001100000000; #100;
		value = 64'h0000000000000000; #100;
		value = 64'hF000000000000000; #100;
		value = 64'hFFFFFFFFFFFFFFFF; #100;
		
	end
	
	
endmodule