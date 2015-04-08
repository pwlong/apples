Instructions for simulating ECE571 Homework 1

Paul Long <paul@thelongs.ws>
7 April 2015

NOTE: The 8-bit adder specified in the assignment is implemented as an n-bit adder
      with defaults set to produce 8-bits. This satisfies the requirements of the 
      assignment while providing more flexibility. For significantly larger bit counts,
      the exhaustive verification employed here may become untenable.

  1. Unzip the package (you probably did that already if you are reading this).
  2. To compile and run the simulation and provided tests from the command line (recommended).
      a. Type "make run" (without quotes).
         QuestSima should start up and give you the QuestaSim> prompt.
      b. At QuestaSim> prompt type "do 4bit.do".
         This will run the exhaustive 4-bit base adder test with the correct parameters
         already specified for you. Screen will show results summary and give
         logfile name for more detailed output.
      c. At QuestaSim> prompt type "do 8bit.do".
         This will run exhaustive 8-bit test which uses the base adder tested above.
         As before, the correct parameters will be specified for you and the screen should show
         a results summary and logfile name.
      d. To end simulation and peruse the log files or write some glowing feedback for Paul or 
         just go on about your life at the command line, type "q".
  3. To compile the simulation without starting it up, type "make".
      a. You can then manually start the simulation with any desired parameters.
      b. Once started you can manually run the simulation with any desired parameters.
 
 
 Directory Structure (before running make):
.
|-- 4bit.do
|-- 8bit.do
|-- Makefile
|-- README.md
`-- hdl
    |-- CarryLookAheadAdder4Bit.sv
    |-- fourBitAdder_TB.sv.IGNORE
    |-- nBitAdder_TB.sv
    `-- nBitCarryLookAheadAdder.sv

After running the tests, ./ will also have QuestaSim produced files & work directory
as well as the detailed logs produced by the test bench.