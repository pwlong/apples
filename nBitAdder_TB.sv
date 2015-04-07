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
	parameter TEST     = 0;
  parameter NUMBITS  = 4;
  
	wire	[NUMBITS-1:0]	a, b;
  wire		 	          c_in;
  wire                s_out
  wire                c_out;
  
  // internal signals
  wire  [NUMBITS-1:0] temp_s[1:0];
  wire                temp_c[1:0];
  
	integer i, j, k;		    // loop counters
	integer f;					    // file handle
	integer errors   = 0;		// errors counter
  integer testsRun = 0;   // results counter
  
  // instantiate modules
  CarryLookAheadAdder4Bit #()
    adder_4Bit (
      .a		  (a),
      .b		  (b),
      .c_in	  (c_in),
      .s		  (temp_s[0]),
      .c_out  (temp_c[0])
    );  
    
  nBitCarryLookAheadAdder #(.NUMBITS(NUMBITS))
    adder_nBit (
      .a_in   (a),
      .b_in   (b),
      .c_in   (c_in),
      .s_out  (temp_s[1]),
      .c_out  (temp_c[1])
    );
  
  // mux the results; select with which test we care about
  assign s_out = temp_s[test];
  assign c_out = temp_c[test];
  
    
  initial begin
    // open the logfile
    f = $fopen("addertest.log","w");
    $fwrite(f, "  Starting Simulation\n");
  
    /*
    // get name of test if given as +arg
    if ($value$plusargs("TESTNAME=%s", testName)) begin
      $fwrite(f,"  Running test %s\n", testName);
    end
    else begin
      $fwrite(f,"  No test specified on command line\n  Running 4-bit test\n");
    end
    $fwrite(f, "=========================\n");
      
     // get numBits from command line 
    if (!$value$plusargs("NUMBITS=%d", numBits)) begin
      //default to 4-bits if not specified via +args
      numBits = 4;
      $fwrite(f, "numBits not specified, using 4\n");
    end
    */
    
    // build the input stimulus and compare to expectations
    // this small solution space allows for an exhaustive test
    for (i=0; i < NUMBITS*4; i=i+1) begin
      for (j=0; j < NUMBITS*4; j=j+1) begin
        for (k=0; k < 2; k=k+1) begin
          testsRun = testsRun + 1;
          #100 a = i;
            b = j;
            c_in = k;
          #300 if ((a + b + c_in) !== {c_out,s_out}) begin
              errors = errors + 1;
              $fwrite(f, "  ERROR: %2d + %2d + %1d != %2d\n",
                  a, b, c_in, {c_out,s_out});
          end
          else begin
            $fwrite(f, "  %2d + %2d + %1d = %2d\n",
                a, b, c_in, {c_out, s_out});
          end
        end
      end
    end
    
    $fwrite(f, "=========================\n");
    $fwrite(f, "  Simulation Complete\n");
    $display(  "  Simulation Complete");
    $fwrite(f, "  Ran %d tests\n", tetsRun);
    $display(  "  Ran %d tests", tetsRun);
    $fwrite(f, "  %4d errors detected\n", errors);
    $display(  "  %4d errors detected", errors);
    $fwrite(f, "=========================\n");
    
    $fclose(f);
    $finish();
  
	end // Initial
endmodule
