`timescale 1ns/10ps
module controlLogic(instruction, Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, BrSelect, UncondBr, ALUOp, SInstr, ALUSel, RShift);
	input logic [31:0] instruction;
	output logic [2:0] ALUOp;
	output logic [1:0] ALUSrc, BrSelect, ALUSel;
	output logic Reg2Loc, MemToReg, RegWrite, MemWrite, UncondBr, SInstr, RShift;
	
	logic [4:0] conditionCode;
	logic [10:0] opCode;
	
	
	assign opCode = instruction [31:21];
	
	parameter 	ADD = 11'b10001011000,
					SUB = 11'b11001011000,
					LDUR = 11'b11111000010,
					STUR = 11'b11111000000,
					B = 11'b000101xxxxx,
					CBZ = 11'b10110100xxx,
					LSL = 11'b11010011011,
					LSR = 11'b11010011010,
					MUL = 11'b10011011000,
					ADDI = 11'b1001000100x,
					ADDS = 11'b10101011000,
					SUBS = 11'b11101011000,
					BLT = 11'b01010100XXX; // find a way to implement condition code into this so it is specifically B.LT and not B.EQ or any other B
					
					
					
	always_comb
		begin
			casex(opCode)
			
				ADD: begin
					Reg2Loc = 1'b1;
					ALUSrc = 2'b00;
					MemToReg = 1'b0;
					RegWrite = 1'b1;
					MemWrite = 1'b0;
					BrSelect = 2'b00;
					UncondBr = 1'bx;
					ALUOp = 3'b010;
					SInstr = 1'b0;
					ALUSel = 2'b11;
					RShift = 1'bx;
					
					end
					
					
					
				SUB: begin
					Reg2Loc = 1'b1;
					ALUSrc = 2'b00;
					MemToReg = 1'b0;
					RegWrite = 1'b1;
					MemWrite = 1'b0;
					BrSelect = 2'b00;
					UncondBr = 1'bx;
					ALUOp = 3'b011;
					SInstr = 1'b0;
					ALUSel = 2'b11;
					RShift = 1'bx;
					
					end
					
					
					
				LDUR: begin
					Reg2Loc = 1'bx;
					ALUSrc = 2'b01;
					MemToReg = 1'b1;
					RegWrite = 1'b1;
					MemWrite = 1'b0;
					BrSelect = 2'b00;
					UncondBr = 1'bx;
					ALUOp = 3'b010;
					SInstr = 1'b0;
					ALUSel = 2'b11;
					RShift = 1'bx;
					
					end
				
				
				
				STUR: begin
					Reg2Loc = 1'b0;
					ALUSrc = 2'b01;
					MemToReg = 1'bx;
					RegWrite = 1'b0;
					MemWrite = 1'b1;
					BrSelect = 2'b00;
					UncondBr = 1'bx;
					ALUOp = 3'b010;
					SInstr = 1'b0;
					ALUSel = 2'b11;
					RShift = 1'bx;
					
					end
					
					
					
				B: begin
					Reg2Loc = 1'bx;
					ALUSrc = 2'bxx;
					MemToReg = 1'bx;
					RegWrite = 1'b0;
					MemWrite = 1'b0;
					BrSelect = 2'b01;
					UncondBr = 1'b1;
					ALUOp = 3'bxxx;
					SInstr = 1'b0;
					ALUSel = 2'bxx;
					RShift = 1'bx;
					
					end
				
				
				
				CBZ: begin
					Reg2Loc = 1'b0;
					ALUSrc = 2'b00;
					MemToReg = 1'bx;
					RegWrite = 1'b0;
					MemWrite = 1'b0;
					BrSelect = 2'b10;
					UncondBr = 1'b0;
					ALUOp = 3'b000;
					SInstr = 1'b0;
					ALUSel = 2'bxx;
					RShift = 1'bx;
					
					end
					
					
				
				LSL: begin
					Reg2Loc = 1'bx;
					ALUSrc = 2'b00;
					MemToReg = 1'b0;
					RegWrite = 1'b1;
					MemWrite = 1'b0;
					BrSelect = 2'b00;
					UncondBr = 1'bx;
					ALUOp = 3'bxxx;
					SInstr = 1'b0;
					ALUSel = 2'b00;
					RShift = 1'b0;
					
					end
					
				
				
				LSR: begin
					Reg2Loc = 1'bx;
					ALUSrc = 2'b00;
					MemToReg = 1'b0;
					RegWrite = 1'b1;
					MemWrite = 1'b0;
					BrSelect = 2'b00;
					UncondBr = 1'bx;
					ALUOp = 3'bxxx;
					SInstr = 1'b0;
					ALUSel = 2'b00;
					RShift = 1'b1;
				
					end
					
					
					
				MUL: begin
					Reg2Loc = 1'b1;
					ALUSrc = 2'b00;
					MemToReg = 1'b0;
					RegWrite = 1'b1;
					MemWrite = 1'b0;
					BrSelect = 2'b00;
					UncondBr = 1'bx;
					ALUOp = 3'bxxx;
					SInstr = 1'b0;
					ALUSel = 2'b10;
					RShift = 1'bx;
					
					end
				
				
				
				ADDI: begin
					Reg2Loc = 1'b1;
					ALUSrc = 2'b11;
					MemToReg = 1'b0;
					RegWrite = 1'b1;
					MemWrite = 1'b0;
					BrSelect = 2'b00;
					UncondBr = 1'bx;
					ALUOp = 3'b010;
					SInstr = 1'b0;
					ALUSel = 2'b11;
					RShift = 1'bx;
	
					end
					
					
					
				ADDS: begin
					Reg2Loc = 1'b1;
					ALUSrc = 2'b00;
					MemToReg = 1'b0;
					RegWrite = 1'b1;
					MemWrite = 1'b0;
					BrSelect = 2'b00;
					UncondBr = 1'bx;
					ALUOp = 3'b010;
					SInstr = 1'b1;
					ALUSel = 2'b11;
					RShift = 1'bx;
					
					end
					
					
					
				
				SUBS: begin
					Reg2Loc = 1'b1;
					ALUSrc = 2'b00;
					MemToReg = 1'b0;
					RegWrite = 1'b1;
					MemWrite = 1'b0;
					BrSelect = 2'b00;
					UncondBr = 1'bx;
					ALUOp = 3'b011;
					SInstr = 1'b1;
					ALUSel = 2'b11;
					RShift = 1'bx;
					
					end
					
				
				
				BLT: begin
					Reg2Loc = 1'b0;
					ALUSrc = 2'b00;
					MemToReg = 1'bx;
					RegWrite = 1'b0;
					MemWrite = 1'b0;
					BrSelect = 2'b11;
					UncondBr = 1'b0;
					ALUOp = 3'b000;
					SInstr = 1'b0;
					ALUSel = 2'bxx;
					RShift = 1'bx;
					
					end
				
				
				default begin
					Reg2Loc = 1'bx;
					ALUSrc = 2'bxx;
					MemToReg = 1'bx;
					RegWrite = 1'bx;
					MemWrite = 1'bx;
					BrSelect = 2'bxx;
					UncondBr = 1'bx;
					ALUOp = 3'bxxx;
					SInstr = 1'bx;
					ALUSel = 2'bxx;
					RShift = 1'bx;
					
					end
					
			endcase
		end
endmodule



module controlLogic_testbench();
	logic [31:0] instruction;
	logic [2:0] ALUOp;
	logic [1:0] ALUSrc, BrSelect, ALUSel;
	logic Reg2Loc, MemToReg, RegWrite, MemWrite, UncondBr, SInstr, RShift;
	
	logic [4:0] conditionCode;
	logic [10:0] opCode;
	
	
	assign opCode = instruction [31:21];
	
	
	controlLogic dut (.instruction, .Reg2Loc, .ALUSrc, .MemToReg, .RegWrite, .MemWrite, .BrSelect, .UncondBr, .ALUOp, .SInstr, .ALUSel, .RShift);
	
	initial begin
		instruction = 32'b10001011000xxxxxxxxxxxxxxxxxxxxx; #100; // ADD test
		instruction = 32'b11001011000xxxxxxxxxxxxxxxxxxxxx; #100; // SUB test
		instruction = 32'b11111000010xxxxxxxxxxxxxxxxxxxxx; #100; // LDUR test
		instruction = 32'b11111000000xxxxxxxxxxxxxxxxxxxxx; #100; // STUR test
		instruction = 32'b000101xxxxxxxxxxxxxxxxxxxxxxxxxx; #100; // B test
		instruction = 32'b10110100xxxxxxxxxxxxxxxxxxxxxxxx; #100; // CBZ test
		instruction = 32'b11010011011xxxxxxxxxxxxxxxxxxxxx; #100; // LSL test
		instruction = 32'b11010011010xxxxxxxxxxxxxxxxxxxxx; #100; // LSR test
		instruction = 32'b10011011000xxxxxxxxxxxxxxxxxxxxx; #100; // MUL test
		instruction = 32'b1001000100xxxxxxxxxxxxxxxxxxxxxx; #100; // ADDI test
		instruction = 32'b10101011000xxxxxxxxxxxxxxxxxxxxx; #100; // ADDS test
		instruction = 32'b11101011000xxxxxxxxxxxxxxxxxxxxx; #100; // SUBS test
		instruction = 32'b01010100XXXxxxxxxxxxxxxxxxxxxxxx; #100; // BLT test

	end
	
endmodule