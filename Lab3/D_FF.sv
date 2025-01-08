`timescale 1ns/10ps
module D_FF (q, d, reset, clk);
    output reg q;
    input d, reset, clk;

    always_ff @(posedge clk)
        if (reset)
            q <= 0; // On reset, set to 0
        else
            q <= d; // Otherwise, q gets the value of d
endmodule

module D_FF_testbench();
	logic q, d, reset, clk;
	
	D_FF dut (.q, .d, .reset, .clk);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	// simulation testbench
	initial begin
	
		clk = 0; reset = 0; d = 0;
											@(posedge clk);
											@(posedge clk);
		d = 1;							@(posedge clk); // test for output q follow high data d
											@(posedge clk);
											@(posedge clk);
		d = 0;							@(posedge clk); // test for output q follow low data d
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		d = 1;							@(posedge clk);
											@(posedge clk);
		reset = 1;						@(posedge clk); // testing reset
											@(posedge clk);
		reset = 0;						@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		d = 1;							@(posedge clk);
											@(posedge clk); // test for output q following d after reset
											@(posedge clk);
		d = 0;							@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											
		
		
		$stop;
		
	end
	
endmodule
