`timescale 1ns/10ps

module flagRegister(negative, zero, overflow, carry_out, SInstr, negative_flag, zero_flag, overflow_flag, carry_out_flag, clk);

	output logic negative_flag, zero_flag, overflow_flag, carry_out_flag;

	input logic negative, zero, overflow, carry_out, SInstr, clk;

	logic [3:0] store;
	//keeps old data unless enabled by an S instruction, in which case takes writedata from input
	//I know I could have done this with a generate loop, but I'm lazy
	mux2_1 mux1 (.out(store[0]), .i0(negative_flag), .i1(negative), .sel(SInstr));
	D_FF d_ff1 (.q(negative_flag), .d(store[0]), .reset(0), .clk(clk));
	
	mux2_1 mux2 (.out(store[1]), .i0(zero_flag), .i1(zero), .sel(SInstr));
	D_FF d_ff2 (.q(zero_flag), .d(store[1]), .reset(0), .clk(clk));
	
	mux2_1 mux3 (.out(store[2]), .i0(overflow_flag), .i1(overflow), .sel(SInstr));
	D_FF d_ff3 (.q(overflow_flag), .d(store[2]), .reset(0), .clk(clk));
	
	mux2_1 mux4 (.out(store[3]), .i0(carry_out_flag), .i1(carry_out), .sel(SInstr));
	D_FF d_ff4 (.q(carry_out_flag), .d(store[3]), .reset(0), .clk(clk));

 
	 
endmodule 

module flagRegister_testbench();
	logic negative, zero, overflow, carry_out, negative_flag, zero_flag, overflow_flag, carry_out_flag, clk, SInstr;
	
	flagRegister dut (.negative, .zero, .overflow, .carry_out, .SInstr, .negative_flag, .zero_flag, .overflow_flag, .carry_out_flag, .clk);
	
	initial begin
		clk = 0; negative = 0; zero = 0; overflow = 0; carry_out = 0; SInstr = 0; #100;
		clk = 1; negative = 0; zero = 0; overflow = 0; carry_out = 0; SInstr = 0; #100;
		
		clk = 0; negative = 1; zero = 1; overflow = 1; carry_out = 1; SInstr = 1; #100;
		clk = 1; negative = 1; zero = 1; overflow = 1; carry_out = 1; SInstr = 1; #100;
		
		clk = 0; negative = 0; zero = 0; overflow = 0; carry_out = 0; SInstr = 0; #100;
		clk = 1; negative = 0; zero = 0; overflow = 0; carry_out = 0; SInstr = 0; #100;
		
		clk = 0; negative = 1; zero = 0; overflow = 1; carry_out = 0; SInstr = 1; #100;
		clk = 1; negative = 1; zero = 0; overflow = 1; carry_out = 0; SInstr = 1; #100;
		
		clk = 0; negative = 0; zero = 0; overflow = 0; carry_out = 0; SInstr = 1; #100;
		clk = 1; negative = 0; zero = 0; overflow = 0; carry_out = 0; SInstr = 1; #100;
		
		clk = 0; negative = 1; zero = 1; overflow = 1; carry_out = 1; SInstr = 0; #100;
		clk = 1; negative = 1; zero = 1; overflow = 1; carry_out = 1; SInstr = 0; #100;
	end
	
endmodule

