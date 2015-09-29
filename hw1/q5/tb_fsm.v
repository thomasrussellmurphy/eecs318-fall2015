// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// Testbenches for the two finite state machine implementations

`timescale 1 ns / 1 ns

module tb_fsm;

reg clk;
reg x;
wire z1_b, z2_b;
wire z1_s, z2_s;

fsm_behavioral DUT1
               (
                 .clk( clk ),
                 .x( x ),
                 .z1( z1_b ),
                 .z2( z2_b )
               );

fsm_structural DUT2
               (
                 .clk( clk ),
                 .x( x ),
                 .z1( z1_s ),
                 .z2( z2_s )
               );


initial
begin
  // Save signal simulation data
  $dumpfile( "adder_cla_4_propagation.vcd" );
  $dumpvars( 1, clk, x, z1_b, z2_b, z1_s, z2_s );
  $dumpflush;

  clk = 1'b0;

  x = 1'b0;

  // Let it flop around for a while
  #200;

  x = 1'b1;
  #10;
  x = 1'b0;
  #20;
  x = 1'b1;

  #200 $stop;
end

always forever
  begin
    // Period 10 clock
    #5 clk = ~clk;
  end

endmodule
