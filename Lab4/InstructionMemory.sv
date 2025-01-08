`timescale 1ns/10ps
module InstructionMemory (ALUOutM, DbM, RdM, MemWriteM, MemToRegM,
								  MemToRegOutM);
	input logic	MemWriteM, MemToRegM;
	input logic [63:0] DbM, ALUOutM;
	input logic [4:0] RdM;
	
	output logic [63:0] MemToRegOutM;
	
	logic [63:0] MemOut;
	datamem DATAMEMORY (.address(ALUOutM), .write_enable(MemWriteM), .read_enable(1'b1), .write_data(DbM), .clk(clk), .xfer_size(4'b1000), .read_data(MemOut));
	
	mux128_64 dut (.A(ALUOutM), .B(MemOut), .out(MemToRegOutM), .sel(MemToRegM));
	
endmodule 