`timescale 1ns/10ps
module mux32_1(out, i, sel);
	output logic out;
	input logic [31:0] i;
	input logic [4:0] sel;
	
	logic out1, out2;
	
	mux16_1 mux1 (.out(out1), 
                   .i0(i[0]), .i1(i[1]), .i2(i[2]), .i3(i[3]), 
                   .i4(i[4]), .i5(i[5]), .i6(i[6]), .i7(i[7]), 
                   .i8(i[8]), .i9(i[9]), .i10(i[10]), .i11(i[11]), 
                   .i12(i[12]), .i13(i[13]), .i14(i[14]), .i15(i[15]), 
                   .sel(sel[3:0]));
    
  
    mux16_1 mux2 (.out(out2), 
                   .i0(i[16]), .i1(i[17]), .i2(i[18]), .i3(i[19]), 
                   .i4(i[20]), .i5(i[21]), .i6(i[22]), .i7(i[23]), 
                   .i8(i[24]), .i9(i[25]), .i10(i[26]), .i11(i[27]), 
                   .i12(i[28]), .i13(i[29]), .i14(i[30]), .i15(i[31]), 
                   .sel(sel[3:0]));
					  
	mux2_1 muxFinal (.out(out), .i0(out1), .i1(out2), .sel(sel[4]));
	
endmodule 


module mux32_1_testbench();
    logic [31:0] i;       // 32-bit input vector
    logic [4:0] sel;      // 5-bit select signal
    logic out;            // Output of the 32:1 multiplexer

    // Instantiate the 32:1 multiplexer under test
    mux32_1 dut (.out(out), .i(i), .sel(sel));

    integer j;
    initial begin
        // Loop through all combinations of inputs and select values
        for (j = 0; j < 1024; j++) begin
            i = j[31:0];             // Assign 32 inputs (least significant 32 bits of j)
            sel = j[4:0];            // Assign the least significant 5 bits of j to sel
            #10;                     // Wait for 10 time units before moving to the next iteration
        end
    end
endmodule
