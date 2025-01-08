`timescale 1ns/10ps

module alu1 (cout, out, a, b, cin, enabler);
	 input logic a, b, cin;
	 input logic [7:0] enabler;
	 output logic cout, out;
	 
	 /*Function Enable Values: ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	 enabler is an 8 bit value in which a single bit corresponding to a function is set to 1.
	 
	 enabler encoding schema
	 00000001 = pass b value
	 00000100 = a + b
	 00001000 = a - b
	 00010000 = a & b
	 00100000 = a | b
	 01000000 = a xor b
	 10000000 = no op
	 
	 Because each function has a dedicated bit in enabler, we can "and" the output of the function with its enable bit, resulting in a 0 unless it is the desired function.
	 */
	 
	 
	 //addder and subtractor logic
	 logic add_enable, adder_out, pass_out, and_out, or_out, or_temp, xor_out, xAMor_temp, out_temp;
	 
	 //use the adder/subtractor module when either function is enabled
    or OR1 (add_enable, enabler[2], enabler[3]);
    
	 //use subtract componenet of add/sub only if subtractor is enabled
	 adder ADD_SUB(.a(a), .b(b), .cin(cin), .cout(cout), .out(adder_out), .sub(enabler[3]), .enable(add_enable));
	 
	 //PASS logic:
	 //Passes b if the pass function is enabled
	 
	 and ENABLE_PASS (pass_out, enabler[0], b);
	 
	 
	 //AND logic:
	 //sets and_out to (a&b) if function is enabled
	 and TRUE_AND (and_out, enabler[4], a, b);
	 
	 //OR logic:
	 //sets or_out to (a or b) if function is enabled
	 or TRUE_OR (or_temp, a, b);
	 and ENABLE_OR (or_out, or_temp, enabler[5]);
	 
	 //XOR logic:
	 xor TRUE_XOR (xor_temp, a, b);
	 and ENABLE_XOR (xor_out, xor_temp, enabler[6]);
	 
	 
	 //All of the values in the following line are forced to be zero except that of the enabled fucntion.
	 //The "or" will merge all of these values, and because all other values are zero, will output the value of the desired function
	 or OUTPUT_MERGER (out_temp, xor_out, or_out, and_out, pass_out);
	 
	 //extra line in order to meet the max 4 inputs per gate rule
	 or TRUE_OUTPUT (out, out_temp, adder_out);
	 
endmodule 

module alu1_testbench();
	logic cout, out, a, b, cin;
	logic [7:0] enabler;
	
	alu1 dut(.cout, .out, .a, .b, .cin, .enabler);
	
	initial begin
		// case 1: pass b val
		a=0; b=0; cin=0; enabler=8'b00000000; #10;
		a=0; b=1; cin=0; enabler=8'b00000000; #10;
		a=0; b=1; cin=0; enabler=8'b00000001; #10;
		a=1; b=0; cin=0; enabler=8'b00000001; #10;
		
		
		// case 2: a + b
		a=0; b=0; cin=0; enabler=8'b00000100; #10;
		a=0; b=0; cin=1; enabler=8'b00000100; #10;
		a=0; b=1; cin=0; enabler=8'b00000100; #10;
		a=0; b=1; cin=1; enabler=8'b00000100; #10;
		a=1; b=0; cin=0; enabler=8'b00000100; #10;
		a=1; b=0; cin=1; enabler=8'b00000100; #10;
		a=1; b=1; cin=0; enabler=8'b00000100; #10;
		a=1; b=1; cin=1; enabler=8'b00000100; #10;
		
		
		// case 3: a - b
		a=0; b=0; cin=0; enabler=8'b00001000; #10;
		a=0; b=0; cin=1; enabler=8'b00001000; #10;
		a=0; b=1; cin=0; enabler=8'b00001000; #10;
		a=0; b=1; cin=1; enabler=8'b00001000; #10;
		a=1; b=0; cin=0; enabler=8'b00001000; #10;
		a=1; b=0; cin=1; enabler=8'b00001000; #10;
		a=1; b=1; cin=0; enabler=8'b00001000; #10;
		a=1; b=1; cin=1; enabler=8'b00001000; #10;
		
		
		// case 4: a & b
		cin = 0;
		a = 0; b = 0; enabler=8'b00010000; #10;
		a = 0; b = 1; enabler=8'b00010000; #10;
		a = 1; b = 0; enabler=8'b00010000; #10;
		a = 1; b = 1; enabler=8'b00010000; #10;
		
		
		// case 4: a | b
		cin = 0;
		a = 0; b = 0; enabler=8'b00100000; #10;
		a = 0; b = 1; enabler=8'b00100000; #10;
		a = 1; b = 0; enabler=8'b00100000; #10;
		a = 1; b = 1; enabler=8'b00100000; #10;
		
		
		// case 5: a xor b
		cin = 0;
		a = 0; b = 0; enabler=8'b01000000; #10;
		a = 0; b = 1; enabler=8'b01000000; #10;
		a = 1; b = 0; enabler=8'b01000000; #10;
		a = 1; b = 1; enabler=8'b01000000; #10;
		
		
		// case 4: no op
		cin = 0;
		a = 0; b = 0; enabler=8'b10000000; #10;
		a = 0; b = 1; enabler=8'b10000000; #10;
		cin = 1;
		a = 1; b = 0; enabler=8'b00000010; #10;
		a = 1; b = 1; enabler=8'b00000010; #10;

	end
endmodule
	
