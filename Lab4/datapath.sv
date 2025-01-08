`timescale 1ns/10ps
module datapath (instruction, Reg2Loc, ALUSrc, ALUSel, RegWrite, MemToReg, MemWrite, ALUOp, clk,
					  negative, zero, overflow, carry_out, RShift);
	input logic [31:0] instruction;
	input logic Reg2Loc, MemToReg, RegWrite, MemWrite, clk, RShift;
	
	input logic [2:0] ALUOp;
	input logic [1:0] ALUSrc, ALUSel;
	
//	output logic [63:0] Rd;
	output logic negative, zero, overflow, carry_out; //outputs of the flag register
	
	
	
	logic [4:0] Aa, Ab, Aw;
	
	genvar i;
	//Rd to Aw wire
	assign Aw = instruction[4:0];
	//Rn to Aa wire
	assign Aa = instruction[9:5];
	
	//Reg2Loc 5 bit 2 to 1 mux to get Ab (Either Rd or Rm =instruction[20:16])
	generate 
		for (i = 0; i < 5; i++) begin: Muxer
			mux2_1 Reg2LocMux (.out(Ab[i]), .i0(instruction[i]), .i1(instruction[i+16]), .sel(Reg2Loc));
		end
	endgenerate
	
	
	
	//Da, Db are outputs of Regfile, Dw is variable to be written to regfile (at Rd). 
	logic [63:0] Da, Db, Dw;
	
	regfile REGFILE (.ReadData1(Da), .ReadData2(Db), .WriteData(Dw), .ReadRegister1(Aa), .ReadRegister2(Ab), .WriteRegister(Aw), .RegWrite(RegWrite), .clk(clk));
	
	//extend the potential operators for the ALU
	logic [63:0] DAddr9Extended, Imm19Extended, Imm12Extended;
	
	signExtend #(.inputSize(9)) DADDR9EXTEND (.in(instruction[20:12]), .isSigned(1), .out(DAddr9Extended));
	
	signExtend #(.inputSize(12)) IMM12EXTEND (.in(instruction[21:10]), .isSigned(0), .out(Imm12Extended));
	
	//not necessary for lab 3
	signExtend #(.inputSize(19)) IMM19EXTEND (.in(instruction[23:5]), .isSigned(0), .out(Imm19Extended));
		
	//_________ALU:__________
	logic [5:0] ShAmt;
	assign ShAmt = instruction[15:10];
	
	//Ib is input to the ALU from the ALUSrc mux
	logic [63:0] Ib, ALUOut;
	
	
	genvar j;
	generate
		for(j = 0; j < 64; j++) begin: ALUSRCMUX
			mux4_1 ALUSRC (.out(Ib[j]), .i0(Db[j]), .i1(DAddr9Extended[j]), .i2(Imm19Extended[j]), .i3(Imm12Extended[j]), .sel(ALUSrc));
		end
	endgenerate 
	
	
//	logic negative, zero, overflow, carry_out; //temp variables from current operation (uses tinyALU so not accurate for shift or mult)
	
	bigAlu BIEGBOIALU(.i0(Da), .i1(Ib), .ALUSel(ALUSel), .ALUOp(ALUOp), .ShAmt(ShAmt), .RShift(RShift), .out(ALUOut), .negative(negative), .zero(zero), .overflow(overflow), .carry_out(carry_out));

	//___________DATA MEMORY:___________
	logic [63:0] MemOut;

	datamem DATAMEMORY (.address(ALUOut), .write_enable(MemWrite), .read_enable(1'b1), .write_data(Db), .clk(clk), .xfer_size(4'b1000), .read_data(MemOut));
	
	mux128_64 MEMTOREGMUX (.A(ALUOut), .B(MemOut), .out(Dw), .sel(MemToReg));

	
	
	
endmodule 


//module datapath_testbench();
//	logic [31:0] instruction;
//	logic Reg2Loc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, negative_flag, zero_flag, overflow_flag, carry_out_flag;
//	
//	logic [2:0] ALUOp;
//	logic [1:0] ALUSrc;
//	
//	logic [63:0] Rd;
//	
//	datapath dut (.instruction, .Reg2Loc, .ALUSrc, .ALUSel, .RegWrite, .MemToReg, .MemWrite, .ALUOp, .clk,
//					  .negative, .zero, .overflow, .carry_out);
//					  
//endmodule 