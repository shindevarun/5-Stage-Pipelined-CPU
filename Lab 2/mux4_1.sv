`timescale 1ns/10ps
module mux4_1(out, i0, i1, i2, i3, sel);
	output logic out;
	input logic i0, i1 ,i2, i3;
	input logic [1:0] sel;
	
	logic out1, out2;
	
	
	mux2_1 mux1 (out1, i0, i1, sel[0]);
	mux2_1 mux2 (out2, i2, i3, sel[0]);
	mux2_1 muxFinal (out, out1, out2, sel[1]);
endmodule 

module mux4_1_testbench();
	logic i0, i1, i2, i3, out;
	logic [1:0] sel;
	
	mux4_1 dut (.out, .i0, .i1, .i2, .i3, .sel);
	
	initial begin
		sel[1]=0; i0=0; i1=0; i2=0; i3=0; sel[0]=0;#10;
		sel[1]=0; i0=0; i1=0; i2=0; i3=1; sel[0]=0;#10;
		sel[1]=0; i0=0; i1=0; i2=1; i3=0; sel[0]=0;#10;
		sel[1]=0; i0=0; i1=0; i2=1; i3=1; sel[0]=0;#10;
		sel[1]=0; i0=0; i1=1; i2=0; i3=0; sel[0]=1;#10;
		sel[1]=0; i0=0; i1=1; i2=0; i3=1; sel[0]=1;#10;
		sel[1]=0; i0=0; i1=1; i2=1; i3=0; sel[0]=1;#10;
		sel[1]=0; i0=0; i1=1; i2=1; i3=1; sel[0]=1;#10;
		sel[1]=1; i0=1; i1=0; i2=0; i3=0; sel[0]=0;#10;
		sel[1]=1; i0=1; i1=0; i2=0; i3=1; sel[0]=0;#10;
		sel[1]=1; i0=1; i1=0; i2=1; i3=0; sel[0]=0;#10;
		sel[1]=1; i0=1; i1=0; i2=1; i3=1; sel[0]=0;#10;
		sel[1]=1; i0=1; i1=1; i2=0; i3=0; sel[0]=1;#10;
		sel[1]=1; i0=1; i1=1; i2=0; i3=1; sel[0]=1;#10;
		sel[1]=1; i0=1; i1=1; i2=1; i3=0; sel[0]=1;#10;
		sel[1]=1; i0=1; i1=1; i2=1; i3=1; sel[0]=1;#10;
	end
endmodule
	