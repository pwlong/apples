// use a loop and parameters to connect up the right number of 4 bits







module nBitCarryLookAheadAdder #(parameter NUMBITS=8)(
	input   [NUMBITS-1:0] a_in, b_in,
	input					        c_in,
	output  [NUMBITS-1:0]	s_out,
	output					      c_out);
	
	localparam BASEADDERSIZE   = 4;						            // width of constituent adders
	localparam BASEADDEROFFSET = BASEADDERSIZE-1;		      // upper index given base adder size
	localparam BASEADDERNUM    = NUMBITS / BASEADDERSIZE; // number of base adders we need
                                                        // to hit the desired input width
	
	if (NUMBITS % BASEADDERSIZE != 0) begin
		// stop and scream, this won't work, bucko!
	end
	

	// internal connections
	//wire	[BASEADDEROFFSET:0] a, b, s;      				// these need to be the right width
	wire  [BASEADDERNUM:0]    carry;								// to connect the constituent adders
	
	genvar i;		// loop counter
	
	generate
		assign carry[0] = c_in;
		assign c_out    = carry[BASEADDERNUM];
		
		for (i=0; i < BASEADDERNUM; i = i + 1) begin : adders
      CarryLookAheadAdder4Bit #(/*no parameters*/)
      adder (
				.a		  (a_in[(i*BASEADDERSIZE)+BASEADDEROFFSET:i*BASEADDERSIZE]),
				.b		  (b_in[(i*BASEADDERSIZE)+BASEADDEROFFSET:i*BASEADDERSIZE]),
				.c_in	  (carry[i]),
				.s		  (s_out[(i*BASEADDERSIZE)+BASEADDEROFFSET:i*BASEADDERSIZE]),
				.c_out  (carry[i+1])			
			);
		end
	endgenerate
endmodule
