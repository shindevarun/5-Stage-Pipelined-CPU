`timescale 1ns/10ps
module mux2_1(out, i0, i1, sel);
	output logic out;
	input logic i0, i1, sel;
	logic out1, out2, selInv;
	
	and #(50ps) AND1 (out1, sel, i1); 
	not #(50ps) selInverter (selInv, sel);
	and #(50ps) AND2 (out2, selInv, i0);
	or #(50ps) OR (out, out1, out2);
	
endmodule

module mux2_1_testbench();
	logic i0, i1, sel;
	logic out;
	
	mux2_1 dut (.out, .i0, .i1, .sel);
	
	initial begin
		sel=0; i0=0; i1=0; #10;
		sel=0; i0=0; i1=1; #10;
		sel=0; i0=1; i1=0; #10;
		sel=0; i0=1; i1=1; #10;
		sel=1; i0=0; i1=0; #10;
		sel=1; i0=0; i1=1; #10;
		sel=1; i0=1; i1=0; #10;
		sel=1; i0=1; i1=1; #10;
	end
endmodule