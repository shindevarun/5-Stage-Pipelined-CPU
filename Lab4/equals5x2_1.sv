`timescale 1ns/10ps
module equals5x2_1(I0, I1, matchOut);
	input logic [4:0] I0, I1;
	output logic matchOut;
	logic match0, match1, match2, match3, match4, matchTemp;

	xnor #(50ps) XNOR0 (match0, I0[0], I1[0]);
	xnor #(50ps) XNOR1 (match1, I0[1], I1[1]);
	xnor #(50ps) XNOR2 (match2, I0[2], I1[2]);
	xnor #(50ps) XNOR3 (match3, I0[3], I1[3]);
	xnor #(50ps) XNOR4 (match4, I0[4], I1[4]);
	
	and #(50ps) AND1 (matchTemp, match0, match1, match2);
	and #(50ps) ANDOUT (matchOut, matchTemp, match3, match4);
endmodule 