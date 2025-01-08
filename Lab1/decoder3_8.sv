`timescale 1ns/10ps
module decoder3_8(out, C, D, E, enable);
	output logic [7:0] out;
	input logic enable;
	input logic C, D, E;
	
	logic Cinv, Dinv, Einv;
	
	//Most significant descending -> C, D, E
	not #(50ps) Cinverter (Cinv, C);
	not #(50ps) Dinverter (Dinv, D);
	not #(50ps) Einverter (Einv, E);
	
	and #(50ps) AND000 (out[0],Cinv, Einv, Dinv, enable);
	and #(50ps) AND001 (out[1],Cinv, E, Dinv, enable);
	and #(50ps) AND010 (out[2],Cinv, Einv, D, enable);
	and #(50ps) AND011 (out[3],Cinv, E, D, enable);
	and #(50ps) AND100 (out[4],C, Einv, Dinv, enable);
	and #(50ps) AND101 (out[5],C, E, Dinv, enable);
	and #(50ps) AND110 (out[6],C, Einv, D, enable);
	and #(50ps) AND111 (out[7],C, E, D, enable);
	
endmodule 



module decoder3_8_testbench();
	logic [7:0] out;
	logic enable;
	logic C, D, E;
	
	decoder3_8 dut (.out(out), .C(C), .D(D), .E(E), .enable(enable));
	
	initial begin
		C=0; D=0; E=0; enable = 1; #100; // enanble true
		C=0; D=0; E=1; enable = 1; #100;
		C=0; D=1; E=0; enable = 1; #100;
		C=0; D=1; E=1; enable = 1; #100;
		C=1; D=0; E=0; enable = 1; #100;
		C=1; D=0; E=1; enable = 1; #100;
		C=1; D=1; E=0; enable = 1; #100;
		C=1; D=1; E=1; enable = 1; #100;
		
		C=0; D=0; E=0; enable = 0; #100; // enable false
		C=0; D=0; E=1; enable = 0; #100;
		C=0; D=1; E=0; enable = 0; #100;
		C=0; D=1; E=1; enable = 0; #100;
		C=1; D=0; E=0; enable = 0; #100;
		C=1; D=0; E=1; enable = 0; #100;
		C=1; D=1; E=0; enable = 0; #100;
		C=1; D=1; E=1; enable = 0; #100;
		
	end
endmodule
