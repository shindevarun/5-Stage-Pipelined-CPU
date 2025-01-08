`timescale 1ns/10ps
module ExecuteRegister(clk, reset, UncondBrE, RegWriteE, MemToRegE, MemWriteE, ALUOutE, DbE, RdE,
											  UncondBrM, RegWriteM, MemToRegM, MemWriteM, ALUOutM, DbM, RdM);
	input logic clk, reset, UncondBrE, RegWriteE, MemToRegE, MemWriteE;
	input logic [63:0] ALUOutE, DbE;
	input logic [4:0] RdE;
	
	output logic UncondBrM, RegWriteM, MemToRegM, MemWriteM;
	output logic [63:0] ALUOutM, DbM;
	output logic [4:0] RdM;
	
	
	//Example Register
	//register_Nbit #(.N()) Reg(.q(M), .d(E), .clk(clk), .reset(reset));
	
	register_Nbit #(.N(64)) Reg1(.q(ALUOutM), .d(ALUOutE), .clk(clk), .reset(reset));
	register_Nbit #(.N(64)) Reg2(.q(DbM), .d(DbE), .clk(clk), .reset(reset));
	
	
	register_Nbit #(.N(5)) Reg3(.q(RdM), .d(RdE), .clk(clk), .reset(reset));
	
	
	register_Nbit #(.N(1)) Reg4(.q(UncondBrM), .d(UncondBrE), .clk(clk), .reset(reset));
	register_Nbit #(.N(1)) Reg5(.q(RegWriteM), .d(RegWriteE), .clk(clk), .reset(reset));
	register_Nbit #(.N(1)) Reg6(.q(MemToRegM), .d(MemToRegE), .clk(clk), .reset(reset));
	register_Nbit #(.N(1)) Reg7(.q(MemWriteM), .d(MemWriteE), .clk(clk), .reset(reset));
	
	
	
	
endmodule 