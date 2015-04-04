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
	
  integer numBits;
  
  if (!$value$plusargs("NUMBITS=%0d", numBits))
    numBits = 4;
 
  reg		[numBits-1:0]	a, b, s;
	reg			 	c_in, c_out;
	
	integer i, j, k;  			// loop counters
	integer f;    					// file handle
	integer errors  = 0;		// errors counter
 
	// instantiate appropriate the DUT
	//	CarryLookAheadAdder4Bit #()
	//	adder (
	//		.a		(a),
	//		.b		(b),
	//		.c_in	(c_in),
	//		.s		(s),
	//		.c_out	(c_out)
	//	);
	
		nBitCarryLookAheadAdder #(.NUMBITS(4))
		adder (
			.a_in		(a),
			.b_in		(b),
			.c_in		(c_in),
			.s_out	(s),
			.c_out	(c_out)
		);
	
	initial begin
		// open a logfile
		f = $fopen("addertest.log","w");
		$fwrite(f, "  Starting Simulation\n");
		//if ($value$plusargs("TESTNAME=%s", testName)) begin
		//	$fwrite(f, "  %s\n", testName);
		//end
		$fwrite(f, "=========================\n");

		// build the input stimulus and compare to expectations
		// this small solution space allows for an exhaustive test
		for (i=0; i < 2^numBits; i=i+1) begin
			for (j=0; j < 2^numBits; j=j+1) begin
				for (k=0; k < 2; k=k+1) begin
					#100 a = i;
						 b = j;
						 c_in = k;
					#300 if ((a + b + c_in) !== {c_out,s}) begin //includes X and Z
							errors = errors + 1;
							$fwrite(f, "  ERROR: %3d + %3d + %1d != %3d\n",
									a, b, c_in, {c_out,s});
					end
					else begin
						$fwrite(f, "  %3d + %3d + %1d = %3d\n",
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
