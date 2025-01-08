`timescale 1ns/10ps
module register_Nbit #(parameter N = 64) (q, d, clk, reset);
   input  logic 		  reset, clk;
	input  logic [N-1:0] d;
   output logic [N-1:0] q;
	
	genvar i;
	generate
		for (i=0; i < N; i++) begin : deff_gen_Nbit
			D_FF d_ff (.q(q[i]), .d(d[i]), .reset(reset), .clk(clk));
		end
	endgenerate

endmodule 


module register_Nbit_testbench();
    // Parameterized N values
    parameter N_1 = 1;
    parameter N_2 = 2;
    parameter N_3 = 3;
    parameter N_4 = 5;
	 

    // Signals for multiple instances
    logic [N_1-1:0] d_1, q_1;
    logic [N_2-1:0] d_2, q_2;
    logic [N_3-1:0] d_3, q_3;
    logic [N_4-1:0] d_4, q_4;
    logic clk, reset;

    // Instantiate the DUT for each N value
    register_Nbit #(N_1) dut_1 (.q(q_1), .d(d_1), .clk(clk), .reset(reset));
    register_Nbit #(N_2) dut_2 (.q(q_2), .d(d_2), .clk(clk), .reset(reset));
    register_Nbit #(N_3) dut_3 (.q(q_3), .d(d_3), .clk(clk), .reset(reset));
    register_Nbit #(N_4) dut_4 (.q(q_4), .d(d_4), .clk(clk), .reset(reset));

    // Clock generation
    parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD / 2) clk <= ~clk;
    end

    initial begin
        // Reset all modules
        reset = 1;
        @(posedge clk); 
        reset = 0;
        @(posedge clk); 

        // Test for N = 8
        d_1 = 1'b1;  // Set some value for 8-bit register
        @(posedge clk); // Wait for clock edge
        d_1 = 1'b1;  // Change value
        @(posedge clk); // Wait for clock edge

        // Test for N = 16
        d_2 = 2'd2; // Set some value for 16-bit register
        @(posedge clk);
        d_2 = 2'd0; // Change value
        @(posedge clk);

        // Test for N = 32
        d_3 = 3'd5; // Set some value for 32-bit register
        @(posedge clk);
        d_3 = 3'd3; // Change value
        @(posedge clk);

        // Test for N = 64
        d_4 = 5'd31; // Set some value for 64-bit register
        @(posedge clk);
        d_4 = 5'd15; // Change value
        @(posedge clk);

        $stop;
    end
endmodule

