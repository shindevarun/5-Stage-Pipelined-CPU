`timescale 1ns/10ps
module DecodeRegister (clk, reset, Imm12ExtendedD, DAddr9ExtendedD, RdD, DaD, DbD, ALUSelD, UncondBrD, RegWriteD, MemToRegD, MemWriteD, ALUOpD, ALUSrcD, SInstrD, ShAmtD, RShiftD,
								           Imm12ExtendedE, DAddr9ExtendedE, RdE, DaE, DbE, ALUSelE, UncondBrE, RegWriteE, MemToRegE, MemWriteE, ALUOpE, ALUSrcE, SInstrE, ShAmtE, RShiftE);
	input logic clk, reset;
	input logic [63:0] Imm12ExtendedD, DAddr9ExtendedD, DaD, DbD;
	input logic [5:0] ShAmtD;
	input logic [4:0] RdD;
	input logic [2:0] ALUOpD;
	input logic [1:0] ALUSelD, ALUSrcD; 
	input logic UncondBrD, RegWriteD, MemToRegD, MemWriteD, SInstrD, RShiftD;
	
	output logic [63:0] Imm12ExtendedE, DAddr9ExtendedE, DaE, DbE;
	output logic [5:0] ShAmtE;
	output logic [4:0] RdE;
	output logic [2:0] ALUOpE; 
	output logic [1:0] ALUSelE, ALUSrcE; 
	output logic UncondBrE, RegWriteE, MemToRegE, MemWriteE, SInstrE, RShiftE;

	
	//Example Register
	//register_Nbit #(.N()) Reg(.q(E), .d(D), .clk(clk), .reset(reset));
	
	register_Nbit #(.N(64)) Reg1(.q(Imm12ExtendedE), .d(Imm12ExtendedD), .clk(clk), .reset(reset));
	register_Nbit #(.N(64)) Reg2(.q(DAddr9ExtendedE), .d(DAddr9ExtendedD), .clk(clk), .reset(reset));
	register_Nbit #(.N(64)) Reg3(.q(DaE), .d(DaD), .clk(clk), .reset(reset));
	register_Nbit #(.N(64)) Reg4(.q(DbE), .d(DbD), .clk(clk), .reset(reset));
	
	register_Nbit #(.N(6)) Reg5(.q(ShAmtE), .d(ShAmtD), .clk(clk), .reset(reset));
	
	register_Nbit #(.N(5)) Reg6(.q(RdE), .d(RdD), .clk(clk), .reset(reset));
	
	register_Nbit #(.N(3)) Reg7(.q(ALUOpE), .d(ALUOpD), .clk(clk), .reset(reset));
	
	register_Nbit #(.N(2)) Reg8(.q(ALUSelE), .d(ALUSelD), .clk(clk), .reset(reset));
	register_Nbit #(.N(2)) Reg9(.q(ALUSrcE), .d(ALUSrcD), .clk(clk), .reset(reset));
	
	register_Nbit #(.N(1)) Reg10(.q(UncondBrE), .d(UncondBrD), .clk(clk), .reset(reset));	
	register_Nbit #(.N(1)) Reg11(.q(RegWriteE), .d(RegWriteD), .clk(clk), .reset(reset));	
	register_Nbit #(.N(1)) Reg12(.q(MemToRegE), .d(MemToRegD), .clk(clk), .reset(reset));	
	register_Nbit #(.N(1)) Reg13(.q(MemWriteE), .d(MemWriteD), .clk(clk), .reset(reset));	
	register_Nbit #(.N(1)) Reg14(.q(SInstrE), .d(SInstrD), .clk(clk), .reset(reset));	
	register_Nbit #(.N(1)) Reg15(.q(RShiftE), .d(RShiftD), .clk(clk), .reset(reset));	
	
	
	
	
endmodule 
