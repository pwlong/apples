`timescale 1ns/1ps
/*!************************************************************************************************
*
*	@file		nBitAdder_TB.sv
*
*	@author		Paul Long <paul@thelongs.ws>
*	@date		31 March 2015
*	@copyright	Paul Long, 2015
*
*	@brief		Test bench 4-bit expandable carry lookahead adder
*
*
**************************************************************************************************/



module nBitAdderTestBench ();
	
	reg		[3:0]	a, b, s;
	reg			 	c_in, c_out;
	
	integer i, j, k;				// loop counters
	integer errors = 0;				// errors counter

	// instantiate the DUT
	CarryLookAheadAdder4Bit #( /* no parameters*/)
	adder (
		.a		(a),
		.b		(b),
		.c_in	(c_in),
		.s		(s),
		.c_out	(c_out)
	);

	initial begin
		for (i=0; i < 16; i=i+1) begin
			for (j=0; j < 16; j=j+1) begin
				for (k=0; k==1; k=k+1) begin
					#100 a = i;
						 b = j;
						 c_in = k;
						 
					#300 if ((a + b) != {c_out,s}) begin
							errors = errors + 1;
							$display("");
							$display("  ERROR: %4d + %4d != %5d", a, b, {c_out,s});
				end
			end
		end
		
		$display("");
		$display("  Simulation Complete");
		$display("===================================================");
		if (0 == errors) $display("  Congratulations on an error-free simulation.");
		else             $display("  %4d errors detected", errors);
    $display("");
		$finish();
	end
endmodule
