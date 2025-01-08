`timescale 1ns/10ps
module register(q, d, enable, clk, reset);
    output logic [63:0] q;
    input logic [63:0] d;
    input logic clk, enable, reset;

    logic [63:0] store;

    genvar i;
    generate 
        for (i = 0; i<64; i++) begin: dff_gen
        //takes old data unless enabled, in which case takes writedata from d
            mux2_1 dff_mux (.out(store[i]), .i0(q[i]), .i1(d[i]), .sel(enable));
            D_FF d_ff (.q(q[i]), .d(store[i]), .reset(reset), .clk(clk));
        end
    endgenerate
endmodule

module register_testbench();
    logic [63:0] d;
    logic clk;
    logic enable;
    logic [63:0] q;

    register uut (.q(q), .d(d), .enable(enable), .clk(clk));

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        //test all 0
        enable = 0;
        d = 64'h0000000000000000;
        @(posedge clk) // #10; 

        //write big number to register
        d = 64'h123456789ABCDEF0;
        enable = 1;
        @(posedge clk) // #10; //doesn't work without this ???
        enable = 0;
        @(posedge clk) // #10;

        //rewrite the register
        d = 64'hFEDCBA9876543210;
        enable = 1;
        @(posedge clk) // #10;
        enable = 0;
        @(posedge clk) // #10;

        //check enable requirement
        d = 64'hAAAAAAAAAAAAAAAA;
        enable = 0;
        @(posedge clk) // #10;

        //Rewrite the register
        d = 64'hFFFFFFFFFFFFFFFF;
        enable = 1;
        @(posedge clk) // #10;
        enable = 0;
        @(posedge clk) // #10;

        $stop;
    end
//
//    initial begin
//        $monitor("Time: %0t | d: %h | q: %h | enable: %b", $time, d, q, enable);
//    end
endmodule




//module D_FF (q, d, reset, clk);
//    output reg q;
//    input d, reset, clk;
//
//    always_ff @(posedge clk)
//
//    if (reset)
//        q <= 0; // On reset, set to 0
//
//    else
//        q <= d; // Otherwise out = d
//endmodule