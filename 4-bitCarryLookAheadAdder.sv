



module CarryLookAheadAdder4Bit (
	input  [3:0] a,
	input  [3:0] b,
	input        c_in,
	
	output [3:0] s,
	output       c_out);
	
	
	//parameter NUM_BITS = 4;
	
	wire  [/*NUM_BITS-1*/3:0] g, p;
	wire  [/*NUM_BITS-1*/3:0] carry;

	genvar ii;
	
	generate
		// lookahead logic
		assign carry[0] = c_in;
		assign carry[1] = g[0] | 
						  c_in & p[0];
		assign carry[2] = g[1] | 
						  g[0] & p[1] | 
						  c_in & p[0] & p[1];
		assign carry[3] = g[2] | 
						  g[1] & p[2] | 
						  g[0] & p[1] & p[2] | 
						  c_in & p[0] & p[1] & p[2];
		assign c_out    = g[3] | 
						  g[2] & p[3] | 
						  g[1] & p[2] & p[3] | 
						  g[0] & p[1] & p[2] & p[3] | 
						  c_in & p[0] & p[1] & p[2] & p[3];
		
		// adder logic
		for (ii = 0; ii < 4; ii = ii + 1) begin
			assign g[ii] = a[ii] & b[ii];
			assign p[ii] = a[ii] | b[ii];
			assign s[ii] = a[ii] ^ b[ii] ^ carry[ii];
		end
	endgenerate
	
endmodule
