`timescale 1ns/1ps
/*!************************************************************************************************
*
*	@file		    4-bitCarryLookAheadAdder.sv
*
*	@author		  Paul Long <paul@thelongs.ws>
*	@date		    31 March 2015
*	@copyright  Paul Long, 2015
*
*	@brief		  4-bit expandable carry lookahead adder
*				
*		  This module implements a 4-bit carry lookahead adder as described in  ECE571
*		  at Portland State University, Spring 2015. It uses XOR for the addition and 
*		  constructs generate and propagate signals for the lookahead logic. The lookahead
*		  algorithm can be summarized thusly: a carry out (CO) is produced if the current
*		  stage generates a CO (i.e. a=b=1) or if any previous stage generates a CO which
*		  propagates through all intervening stages including the current stage.
*		  
*		  Inputs:	 a,b   4-bit numbers to be added
*		  		 c_in  carry in from any previous stages (module is expandable)
*		  	
*		  Outputs: s     4-bit result of the addition
*		  		 c_out carry out to the next stage
*     
*		  Propagation delay is modelled at 5ns
*		  
**************************************************************************************************/

	
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
		assign #5 carry[0] =  c_in;
		assign #5 carry[1] =  g[0] | 
                          c_in & p[0];
		assign #5 carry[2] =  g[1] | 
                          g[0] & p[1] | 
                          c_in & p[0] & p[1];
		assign #5 carry[3] =  g[2] | 
                          g[1] & p[2] | 
                          g[0] & p[1] & p[2] | 
                          c_in & p[0] & p[1] & p[2];
		assign #5 c_out    =  g[3] | 
                          g[2] & p[3] | 
                          g[1] & p[2] & p[3] | 
                          g[0] & p[1] & p[2] & p[3] | 
                          c_in & p[0] & p[1] & p[2] & p[3];
		
		// adder logic
		for (ii = 0; ii < 4; ii = ii + 1) begin
			assign #5 g[ii] = a[ii] & b[ii];
			assign #5 p[ii] = a[ii] | b[ii];
			assign #5 s[ii] = a[ii] ^ b[ii] ^ carry[ii];
		end
	endgenerate
	
endmodule
