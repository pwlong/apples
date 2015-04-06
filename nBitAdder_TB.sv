`timescale 1ns/1ps
/*!************************************************************************************************
*
*	@file		    nBitAdder_TB.sv
*
*	@author		  Paul Long <paul@thelongs.ws>
*	@date		    31 March 2015
*	@copyright	Paul Long, 2015
*
*	@brief		  Test bench 4-bit expandable carry lookahead adder
*
*
**************************************************************************************************/



module nBitAdder_TB ();
	
	reg		[3:0]	a, b, s;
	reg			 	  c_in, c_out;
	
	integer i, j, k;		    // loop counters
	integer f;					    // file handle
	integer errors = 0;			// errors counter
  string  testName;       // which test to run
  integer numBits;        // input width

  
  
  generate
    if (numBits > 4) begin
      nBitCarryLookAheadAdder #(.NUMBITS(numBits))
      adder_nBit (
        .a_in   (a),
        .b_in   (b),
        .c_in   (c_in),
        .s_out  (s),
        .c_out  (c_out)
      );
    end
    else begin
      CarryLookAheadAdder4Bit #()
      adder_4Bit (
        .a		  (a),
        .b		  (b),
        .c_in	  (c_in),
        .s		  (s),
        .c_out  (c_out)
      );
    end
  endgenerate
/*
	CarryLookAheadAdder4Bit #()
	adder_4Bit (
		.a		(a),
		.b		(b),
		.c_in	(c_in),
		.s		(s),
		.c_out	(c_out)
	);
  */
  /*
  nBitCarryLookAheadAdder #(.NUMBITS(numBits))
  adder_nBit (
    .a_in   (a),
    .b_in   (b),
    .c_in   (c_in),
    .s_out  (s),
    .c_out  (c_out)
  );
  */
  

  initial begin
    // open the logfile
    f = $fopen("addertest.log","w");
    $fwrite(f, "  Starting Simulation\n");
  
    
    // get name of test if given as +arg
    if ($value$plusargs("TESTNAME=%s", testName)) begin
      $fwrite(f,"  Running test %s\n", testName);
    end
    else begin
      $fwrite(f,"  No test specified on commandline\n  Running 4-bit test\n");
    end
    $fwrite(f, "=========================\n");
      
     // get numBits from command line 
    if (!$value$plusargs("NUMBITS=%d", numBits)) begin
      //default to 4-bits if not specified via +arg
      numBits = 4;
      $fwrite(f, "numBits not specified, using 4\n");
    end
      
    // build the input stimulus and compare to expectations
    // this small solution space allows for an exhaustive test
    for (i=0; i < 16; i=i+1) begin
      for (j=0; j < 16; j=j+1) begin
        for (k=0; k < 2; k=k+1) begin
          #100 a = i;
            b = j;
            c_in = k;
          #300 if ((a + b + c_in) !== {c_out,s}) begin
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
    if (0 == errors) begin
      $fwrite(f, "  Congratulations on an\n  error-free simulation!\n");
    end
    else begin
      $fwrite(f, "  %4d errors detected\n", errors);
    end
    $fwrite(f, "=========================\n");
    
    $fclose(f);
    $finish();
  
	end // Initial
endmodule
