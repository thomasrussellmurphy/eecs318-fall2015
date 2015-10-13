// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// Operating the simple processor for hw2 q4

`timescale 1 ns / 10 ps

module tb_processor_q4;

reg processor_clk = 1'b0;

processor
  #(
    .memory_file( 3 )
  )
  DUT
  (
    .clk( processor_clk )
  );

always forever
    #5 processor_clk = ~processor_clk;

endmodule
