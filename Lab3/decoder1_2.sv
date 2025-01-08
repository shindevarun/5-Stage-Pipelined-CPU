//module decoder1_2(out, in, enable);
//	output logic [1:0] out;
//	input logic in, enable;
//	
//	
//	and AND00 (outIntermediate[0], ~A, enable);
//	and AND01 (outIntermediate[1], A, enable);
//	
//endmodule 
//
//module decoder1_2_testbench();
//	logic [1:0] out;
//	logic in, enable;
//
//	decoder1_2 dut (.out(out), .in(in), .enable(enable));
//	
//	initial begin
//		enable=1; A=0; #100;
//		enable=0; A=0; #100;
//		enable=1; A=1; #100;
//		enable=0; A=1; #100;
//	
//	end
//endmodule
//
//
////	logic [3:0] enable;
////	
////	
////	decoder2_4 submodule2_4(enable, A, B);
////	