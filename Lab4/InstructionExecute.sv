`timescale 1ns/10ps
module InstructionExecute (DaE, DbE, ShAmtE, ALUSrcE, ALUOpE, ALUSelE, DAddr9ExtendedE, Imm12ExtendedE, ALUOpE, RShiftE,
									 negative, zero, overflow, carry_out, ALUOutE);
									 
	input logic [63:0] DaE, DbE, DAddr9ExtendedE, Imm12ExtendedE;
	input logic [5:0] ShAmtE;
	input logic [1:0] ALUSrcE, ALUSelE;
	input logic [2:0] ALUOpE;
	input logic [5:0] RShiftE;
	
	
	
	output logic negative, zero, overflow, carry_out;
	output logic [63:0] ALUOutE;
	
	logic [63:0] Ib;
	
	//Reference:
	// Ib is input to the ALU from the ALUSrc mux
	//	logic [63:0] Ib, ALUOut;
	//	
	//	mux4_1 ALUSRC (.out(Ib), .i0(Db), .i1(DAddr9), .i2(Imm19Extended), .i3(Imm12Extended), .sel(ALUSrc));
	//	
	//	
	//	logic negative, zero, overflow, carry_out; //temp variables from current operation (uses tinyALU so not accurate for shift or mult)
	//	
	//	bigAlu dut(.i0(Da), .i1(Ib), .ALUOp(ALUOp), .ShAmt(ShAmt), .RShift(RShift), .out(ALUOut), .negative(negative), .zero(zero), .overflow(overflow), .carry_out(carry_out));
	
//	mux4_1 ALUSRC (.out(Ib), .i0(DbE), .i1(DAddr9ExtendedE), .i2(64'b1), .i3(Imm12ExtendedE), .sel(ALUSrcE));

	genvar j;
	generate
		for(j = 0; j < 64; j++) begin: ALUSRCMUX
			mux4_1 ALUSRC (.out(Ib[j]), .i0(DbE[j]), .i1(DAddr9ExtendedE[j]), .i2(1'b1), .i3(Imm12ExtendedE[j]), .sel(ALUSrcE));
		end
	endgenerate 
	
	bigAlu not_dut(.i0(DaE), .i1(Ib), .ALUOp(ALUOpE), .ALUSel(ALUSelE), .ShAmt(ShAmtE), .RShift(RShiftE), .out(ALUOutE), .negative(negative), .zero(zero), .overflow(overflow), .carry_out(carry_out));
	
endmodule 