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



module nBitAdder_TB ();
	
	reg		[3:0]	a, b, s;
	reg			 	c_in, c_out;
	
	integer i, j, k;			// loop counters
	integer f;					// file handle
	integer errors = 0;			// errors counter

	// instantiate the DUT
/*
	CarryLookAheadAdder4Bit #( /*no parameters*/)
	adder (
		.a		(a),
		.b		(b),
		.c_in	(c_in),
		.s		(s),
		.c_out	(c_out)
	);
  */
  
  nBitCarryLookAheadAdder #(.NUMBITS(4))
	adder (
		.a		(a),
		.b		(b),
		.c_in	(c_in),
		.s		(s),
		.c_out	(c_out)
	);

	initial begin
		// open a logfile
		f = $fopen("addertest.log","w");
		$fwrite(f, "  Starting Simulation\n");
		$fwrite(f, "=========================\n");

		// build the input stimulus and compare to expectations
		// this small solution space allows for an exhaustive test
		for (i=0; i < 16; i=i+1) begin
			//$fwrite(f, "into i loop!\n");
			for (j=0; j < 16; j=j+1) begin
				//$fwrite(f, "into j loop\n");
				for (k=0; k < 2; k=k+1) begin
					//$fwrite(f, "into k loop");
					#100 a = i;
						 b = j;
						 c_in = k;
					#300 if ((a + b + c_in) != {c_out,s}) begin
							errors = errors + 1;
							$fwrite(f, "  ERROR: %2d + %2d + %1d != %2d\n",
									a, b, c_in, {c_out,s});
					end
					else begin
						$fwrite(f, "  %2d + %2d + %1d = %2d\n",
								a, b, c_in, {c_out, s});
					end
				end
			end
		end
		
		$fwrite(f, "=========================\n");
		$fwrite(f, "  Simulation Complete\n");
		if (0 == errors)
			$fwrite(f, "  Congratulations on an\n  error-free simulation!\n");
		else
			$fwrite(f, "  %4d errors detected\n", errors);
		$fwrite(f, "=========================\n");
		$fclose(f);
		$finish();
	end
endmodule
