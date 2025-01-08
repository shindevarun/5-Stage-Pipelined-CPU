`timescale 1ns/10ps
module InstructionRegister(InstrF, InstrD, pcIF, pcD, clk, reset);
	input logic clk, reset;
	input logic [31:0] InstrF;
	input logic [63:0] pcIF;
	output logic [31:0] InstrD;
	output logic [63:0] pcD;
	
	
	register_Nbit #(.N(64)) IF_DEC_PCRegister(.q(pcD), .d(pcIF), .clk(clk), .reset(reset));
	register_Nbit #(.N(32)) IF_DEC_Pipeline(.q(InstrD), .d(InstrF), .clk(clk), .reset(reset));
endmodule 