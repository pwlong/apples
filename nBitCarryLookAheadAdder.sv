// use a loop and parameters to connect up the right number of 4 bits







module nBitCarryLookAheadAdder #(parameter NUMBITS=8)(

	input   [NUMBITS-1:0] a_in, b_in,
	input				          c_in,
	output  [NUMBITS-1:0] s_out,
	output				        c_out
);
	
	localparam BASEADDERSIZE   = 4;						            // width of constituent adders
	localparam BASEADDEROFFSET = BASEADDERSIZE-1;		      // upper index given base adder size
	localparam BASEADDERNUM    = NUMBITS / BASEADDERSIZE; // number of base adders we need
                                                        // to hit the desired input width
	
	if (NUMBITS % BASEADDERSIZE != 0) begin
		// stop and scream, this won't work, bucko!
	end
	

	// internal connections
	wire  [NUMBITS-1:0]		  a, b, s;			  		          //
	wire  [BASEADDERNUM:0]  carry;  				  	          //
	
  assign a     = a_in;
  assign b     = b_in;
  assign s_out = s;
  assign carry[0] = c_in;
	assign c_out    = carry[BASEADDERNUM];
  
	genvar i;											                        // loop counter
  generate		
		for (i=0; i < BASEADDERNUM; i = i + 1) begin : adders
			CarryLookAheadAdder4Bit #()
			adder (
				.a		 (a[(i*BASEADDERSIZE)+BASEADDEROFFSET:i*BASEADDERSIZE]),
				.b		 (b[(i*BASEADDERSIZE)+BASEADDEROFFSET:i*BASEADDERSIZE]),
				.c_in	 (carry[i]),
				.s		 (s[(i*BASEADDERSIZE)+BASEADDEROFFSET:i*BASEADDERSIZE]),
				.c_out (carry[i+1])
			);
		end
	endgenerate
 
endmodule
