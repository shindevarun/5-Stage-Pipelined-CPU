`timescale 1ns/10ps

module adder(a, b, cin, cout, out, sub, enable);
	input logic a, b, cin, sub, enable;
	output logic cout, out;
	
	logic temp0, temp1, temp2, temp3, temp4, temp_b;
	
	xor #(50ps) XOR0 (temp_b, b, sub);
	
	
	//out is 1 if abc = 111 or only one of a, b, and c is one
	xor #(50ps) XOR2 (temp0, a, temp_b, cin);
	and #(50ps) ENABLE1 (out, temp0, enable);
	//cout is one if at least 2 of abc = 1
	and #(50ps) AND1 (temp1, a, temp_b);
	and #(50ps) AND2 (temp2, temp_b,cin);
	and #(50ps) AND3 (temp3, cin, a);
	or #(50ps) OR1 (temp4, temp1, temp2, temp3);
	and #(50ps) ENABLE2 (cout, temp4, enable);
	
endmodule 

module adder_testbench();
	logic a, b, cin, sub, cout, out, enable;
	
	adder dut (.a, .b, .cin, .cout, .out, .sub, .enable);
	
	initial begin
		enable = 1;
		
		sub = 0; cin = 0; a = 0; b = 0; #10;
		sub = 0; cin = 0; a = 0; b = 1; #10;
		sub = 0; cin = 0; a = 1; b = 0; #10;
		sub = 0; cin = 0; a = 1; b = 1; #10;
		sub = 0; cin = 1; a = 0; b = 0; #10;
		sub = 0; cin = 1; a = 0; b = 1; #10;
		sub = 0; cin = 1; a = 1; b = 0; #10;
		sub = 0; cin = 1; a = 1; b = 1; #10;
		
		sub = 1; cin = 0; a = 0; b = 0; #10;
		sub = 1; cin = 0; a = 0; b = 1; #10;
		sub = 1; cin = 0; a = 1; b = 0; #10;
		sub = 1; cin = 0; a = 1; b = 1; #10;
		sub = 1; cin = 1; a = 0; b = 0; #10;
		sub = 1; cin = 1; a = 0; b = 1; #10;
		sub = 1; cin = 1; a = 1; b = 0; #10;
		sub = 1; cin = 1; a = 1; b = 1; #10;
		
		
		
		
		enable = 0;
		
		sub = 0; cin = 0; a = 0; b = 0; #10;
		sub = 0; cin = 0; a = 0; b = 1; #10;
		sub = 0; cin = 0; a = 1; b = 0; #10;
		sub = 0; cin = 0; a = 1; b = 1; #10;
		sub = 0; cin = 1; a = 0; b = 0; #10;
		sub = 0; cin = 1; a = 0; b = 1; #10;
		sub = 0; cin = 1; a = 1; b = 0; #10;
		sub = 0; cin = 1; a = 1; b = 1; #10;
		
		sub = 1; cin = 0; a = 0; b = 0; #10;
		sub = 1; cin = 0; a = 0; b = 1; #10;
		sub = 1; cin = 0; a = 1; b = 0; #10;
		sub = 1; cin = 0; a = 1; b = 1; #10;
		sub = 1; cin = 1; a = 0; b = 0; #10;
		sub = 1; cin = 1; a = 0; b = 1; #10;
		sub = 1; cin = 1; a = 1; b = 0; #10;
		sub = 1; cin = 1; a = 1; b = 1; #10;
		
	 
	
	end
	
endmodule 