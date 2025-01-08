`timescale 1ns/10ps
module ForwardUnit(Aa, Ab, RdE, RdM, RegWriteE, RegWriteM, ForwardA, ForwardB);
	input logic [4:0] Aa, Ab, RdE, RdM;
	input logic RegWriteE, RegWriteM;
	output logic [1:0] ForwardA, ForwardB;
	
	
	logic RDMA, RDEA, RDMB, RDEB, RDMA_Write, RDEA_Write, RDMB_Write, RDEB_Write, Exception_31A, Exception_31B, ANot31, BNot31;
	logic [1:0] ATemp, BTemp;
	
	//checks if the Rd of the previous 2 instructions match the either of the inputs to the current instruction
	equals5x2_1 EQUAL1 (.I0(Aa), .I1(RdM), .matchOut(RDMA));
	equals5x2_1 EQUAL2 (.I0(Aa), .I1(RdE), .matchOut(RDEA));
	equals5x2_1 EQUAL3 (.I0(Ab), .I1(RdM), .matchOut(RDMB));
	equals5x2_1 EQUAL4 (.I0(Ab), .I1(RdE), .matchOut(RDEB));
	
	equals5x2_1 EQUAL31A (.I0(Aa), .I1(5'b11111), .matchOut(Exception_31A));
	equals5x2_1 EQUAL31B (.I0(Ab), .I1(5'b11111), .matchOut(Exception_31B));
	
	assign ANot31 = ~Exception_31A;
	assign BNot31 = ~Exception_31B;
	
	
	//Checks if matching rd is going to be written to (Does not write
	and AND1 (RDMA_Write, RDMA, RegWriteM, ANot31);
	and AND2 (RDEA_Write, RDEA, RegWriteE, ANot31);
	and AND3 (RDMB_Write, RDMB, RegWriteM, BNot31);
	and AND4 (RDEB_Write, RDEB, RegWriteE, BNot31);
	
	
	
	//assigns output signal based on whether forwarding is necessary
	mux2x2_1 MUXA1(ATemp, 2'b00, 2'b10, RDMA_Write);
	mux2x2_1 MUXAOUT(ForwardA, ATemp, 2'b01, RDEA_Write);	
	mux2x2_1 MUXB1(BTemp, 2'b00, 2'b10, RDMB_Write);
	mux2x2_1 MUXBOUT(ForwardB, BTemp, 2'b01, RDEB_Write);
	
	
endmodule 
	
module mux2x2_1(out, i0, i1, sel);
	output logic [1:0] out;
	input logic [1:0] i0, i1;
	input logic sel;
	
	

	mux2_1 MUX0 (out[0], i0[0], i1[0], sel);
	mux2_1 MUX1 (out[1], i0[1], i1[1], sel);
	
endmodule 


module ForwardUnit_testbench();
	logic [4:0] Aa, Ab, RdE, RdM;
	logic RegWriteE, RegWriteM;
	logic [1:0] ForwardA, ForwardB;
	
	
	ForwardUnit dut (.Aa, .Ab, .RdE, .RdM, .RegWriteE, .RegWriteM, .ForwardA, .ForwardB);
	
	initial begin
		RegWriteE = 0; RegWriteM = 0;
		#100;
		Aa = 5'b11111; Ab = 5'b11111; RdE = 5'b11111; RdM = 5'b11111; 
		#100;
		RdE = 5'b10000;
		RdM = 5'b10000;
		for (int i = 0; i < 32; i++) begin
			RegWriteE = ~RegWriteE;
			
			if(i % 2 == 0) begin
				RegWriteM = ~RegWriteM;
			end
			
			Aa = i;
			Ab = i;
			RdE= i;
			RdM = i;
			#100;
		end
		
		
	end
	
endmodule