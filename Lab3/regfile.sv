`timescale 1ns/10ps
module regfile(ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
	input logic	[4:0] 	ReadRegister1, ReadRegister2, WriteRegister;
	input logic [63:0]	WriteData;
	input logic 			RegWrite, clk;
	output logic [63:0]	ReadData1, ReadData2;
	
	logic [31:0] [63:0] RegOut;
	logic [63:0][31:0] rotated;
	logic [31:0] out;
	
	
	genvar i,j, k, l;
	
	decoder5_32 decoder (.out(out), .in(WriteRegister), .RegWrite(RegWrite));
	//out is a 32 bit number, with the signle non zero bit representing the register to potentially be written to unless RegWrite is 0.
	
	//generates 31 instances of registers, writes to them if they are enabled by decoder out, and fills RegOut with the updated register values
	generate
		for(i=0; i<31; i++) begin: regmaker
			register reg_ (.q(RegOut[i]), .d(WriteData), .enable(out[i]), .clk(clk), .reset(0));
		end
	endgenerate
	//sets reg_31 to 0;
	register reg_31 (.q(RegOut[31]), .d(WriteData), .enable(0), .clk(clk), .reset(1));
//	assign RegOut[31] = 32'b0;

	//rotato
	generate
		for (j=0;j<64;j++) begin: rotate_X
		
			for(k=0;k<32;k++) begin: rotate_Y
			
				assign rotated[j][k] = RegOut[k][j];
				
			end
		end
	endgenerate
	
	
	
	// output registers to ReadData1 and ReadData2 based on the readregister selector
	generate
		for(l = 0; l<64;l++) begin: reader
			
			mux32_1 reader1(.out(ReadData1[l]), .i(rotated[l]), .sel(ReadRegister1));	
			
			mux32_1 reader2(.out(ReadData2[l]), .i(rotated[l]), .sel(ReadRegister2));
		end
	endgenerate
	
endmodule 

