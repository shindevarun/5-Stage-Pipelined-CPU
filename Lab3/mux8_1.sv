`timescale 1ns/10ps
module mux8_1(out, i0, i1, i2, i3, i4, i5, i6, i7, sel);
	output logic out;
	input logic i0, i1, i2, i3, i4, i5, i6, i7;
	input logic [2:0] sel;
	
	logic out1, out2;
	
	mux4_1 mux1(.out(out1), .i0(i0), .i1(i1), .i2(i2), .i3(i3), .sel(sel[1:0]));
	mux4_1 mux2(.out(out2), .i0(i4), .i1(i5), .i2(i6), .i3(i7), .sel(sel[1:0]));
	mux2_1 muxFinal(.out(out), .i0(out1), .i1(out2), .sel(sel[2]));
	
endmodule

module mux8_1_testbench();

	logic i0, i1, i2, i3, i4, i5, i6, i7, i8, out;
	logic [2:0] sel;
	
	mux8_1 dut (.out, .i0, .i1, .i2, .i3, .i4, .i5, .i6, .i7, .sel);
	
//	integer i;
//	initial begin
//		for(i=0; i<128; i++) begin
//			
//		end
//	end

	integer i;
	initial begin
		// Loop through all combinations of inputs and sel values
		for (i = 0; i < 256; i = i + 1) begin
			// Assign values to the inputs and sel
			{i0, i1, i2, i3, i4, i5, i6, i7} = i[7:0]; // Assign i's least significant 8 bits to inputs
			sel = i[2:0];                            // Assign i's least significant 3 bits to sel
			
			#10;  // Wait for 10 time units before moving to the next iteration


		end
	end
endmodule
		
		
	
