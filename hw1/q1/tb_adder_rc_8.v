// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The testbench for the 8-bit ripple carry with a 10 unit gate delay

`timescale 1 ns / 1 ns

module tb_adder_rc_8;

reg [ 7: 0 ] A, B;
wire [ 8: 0 ] S;

// Indicates a gate delay cycle on every rising edge
reg delay_clock;

adder_rc_8 DUT (
             .A( A ),
             .B( B ),
             .S( S )
           );

initial
begin
  // Save signal simulation data
  $dumpfile( "adder_rc_8_propagation.vcd" );
  $dumpvars( 1, delay_clock, A, B, S );
  $dumpflush;

  delay_clock = 1'b0;

  A = 8'b0;
  B = 8'b0;

  // Propagate initial state
  #200;

  A = 8'b1111_1111;

  // Need to wait for the propagation of data through the A path
  #200;

  B = 8'b1;

  #500 $stop;
end

always forever
  begin
    #5 delay_clock = ~delay_clock;
  end

endmodule
