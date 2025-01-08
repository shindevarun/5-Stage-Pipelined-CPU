`timescale 1ns/10ps
module mux16_1(out, i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14, i15, sel);
	output logic out;
	input logic i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14, i15;
	input logic [3:0] sel;
	
	logic out1, out2;
	
	
	mux8_1 mux1 (.out(out1), .i0(i0), .i1(i1), .i2(i2), .i3(i3), .i4(i4), .i5(i5), .i6(i6), .i7(i7), .sel(sel[2:0]));
	mux8_1 mux2 (.out(out2), .i0(i8), .i1(i9), .i2(i10), .i3(i11), .i4(i12), .i5(i13), .i6(i14), .i7(i15), .sel(sel[2:0]));
	mux2_1 muxFinal (.out(out), .i0(out1), .i1(out2), .sel(sel[3]));
	
endmodule

module mux16_1_testbench();
    logic i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14, i15;
    logic [3:0] sel;
    logic out;
    
    // Instantiate the 16:1 MUX
    mux16_1 dut (
        .out(out),
        .i0(i0), .i1(i1), .i2(i2), .i3(i3), .i4(i4), .i5(i5), .i6(i6), .i7(i7),
        .i8(i8), .i9(i9), .i10(i10), .i11(i11), .i12(i12), .i13(i13), .i14(i14), .i15(i15),
        .sel(sel)
    );

    integer i;
    
    initial begin
        // Initialize all inputs
//        {i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14, i15} = 16'b1010101010101010;
        
        // Loop through all possible select values
		  integer i;
        for (i = 0; i < 512; i = i + 1) begin
//            sel = i; // Set the select lines
//            #10;     // Wait 10 time units
//            $display("sel = %b, out = %b", sel, out); // Display the selected input and output
				{i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14, i15} = i[15:0]; // Assign i's least significant 8 bits to inputs
				sel = i[3:0];                            // Assign i's least significant 3 bits to sel
				
				#10;  // Wait for 10 time units before moving to the next iteration

        end
        
//        $finish; // End simulation
    end
endmodule

