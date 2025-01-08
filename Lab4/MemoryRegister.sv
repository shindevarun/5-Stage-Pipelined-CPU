`timescale 1ns/10ps
module MemoryRegister(clk, reset, UncondBrM, RegWriteM, MemToRegOutM, RdM,
											 UncondBrW, RegWriteW, MemToRegOutW, RdW);
	input logic clk, reset;
	input logic UncondBrM, RegWriteM;
	input logic [4:0] RdM;
	input logic [63:0] MemToRegOutM;
	
	output logic UncondBrW, RegWriteW;
	output logic [4:0] RdW;
	output logic [63:0] MemToRegOutW;
	
	
	//register_Nbit #(.N()) Reg(.q(W), .d(M), .clk(clk), .reset(reset));
	
	register_Nbit #(.N(1)) Reg1(.q(UncondBrW), .d(UncondBrM), .clk(clk), .reset(reset));
	register_Nbit #(.N(1)) Reg2(.q(RegWriteW), .d(RegWriteM), .clk(clk), .reset(reset));
	
	register_Nbit #(.N(5)) Reg3(.q(RdW), .d(RdM), .clk(clk), .reset(reset));
	
	register_Nbit #(.N(64)) Reg4(.q(MemToRegOutW), .d(MemToRegOutM), .clk(clk), .reset(reset));
endmodule 