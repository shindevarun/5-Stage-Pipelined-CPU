`timescale 1ns/10ps
module decoder2_4(outIntermediate, A, B);
	output logic [3:0] outIntermediate;
	input logic A, B; 
	logic Ainv, Binv;
	
	//A is Most Significant
	not #(50ps) Ainverter (Ainv, A);
	not #(50ps) Binverter (Binv, B);
	
	and #(50ps) AND00 (outIntermediate[0], Binv, Ainv);
	and #(50ps) AND01 (outIntermediate[1], B, Ainv);
	and #(50ps) AND10 (outIntermediate[2], Binv, A);
	and #(50ps) AND11 (outIntermediate[3], B, A);
	
endmodule 

module decoder2_4_testbench();
	logic [3:0] outIntermediate;
	logic A, B;

	decoder2_4 dut (.outIntermediate(outIntermediate), .A(A), .B(B));
	
	initial begin
		B=0; A=0; #100;
		B=0; A=0; #100;
		B=0; A=1; #100;
		B=0; A=1; #100;
		B=1; A=0; #100;
		B=1; A=0; #100;
		B=1; A=1; #100;
		B=1; A=1; #100;
	end
endmodule