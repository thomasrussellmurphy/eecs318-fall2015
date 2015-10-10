// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// Operating the simple processor for hw2 q3

module tb_processor_q2;

reg processor_clk = 1'b0;

processor
  #(
    .memory_file( 1 )
  )
  DUT
  (
    .clk( processor_clk )
  );

always forever
    #5 processor_clk = ~processor_clk;

endmodule
