`timescale 1ns/10ps

module cpustim(); 		

	parameter ClockDelay = 100;

	logic clk, reset;


	integer i;

	// Your register file MUST be named "regfile".
	// Also you must make sure that the port declarations
	// match up with the module instance in this stimulus file.
	cpu dut (.clk, .reset);

	// Force %t's to print in a nice format.
//	initial $timeformat(-9, 2, " ns", 10);

	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	initial begin
	reset=1;
		@(posedge clk);
	reset=0;
	   @(posedge clk);
		           @(posedge clk);
		for (i=0; i<600; i++) begin
			@(posedge clk);
		end
		$stop;
	end

endmodule