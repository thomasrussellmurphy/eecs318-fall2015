// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The test for the 5x5-bit signed multiplier in structural Verilog

module tb_multiplier_signed_5;

reg signed [ 4: 0 ] A, B;
wire signed [ 9: 0 ] P, P_expected;

// Indicates some delay
reg delay_clock;

multiplier_signed_5 multiplier
                    (
                      .A( A ),
                      .B( B ),
                      .P( P )
                    );

assign P_expected = A * B;

initial
begin
  // Save signal simulation data
  $dumpfile( "multiplier_signed_5.vcd" );
  $dumpvars( 1, delay_clock, A, B, P );
  $dumpflush;

  delay_clock = 1'b0;

  A = 5'sd0;
  B = 5'sd0;

  // Propagate initial state
  #20;

  // An additional tests
  A = 5'sd13;
  B = 5'sd7;

  #20;

  A = -5'sd13;
  B = 5'sd11;

  #20;

  // Test 1: -10*4
  A = -5'sd10;
  B = 5'sd4;

  #20;

  // Test 2: 11*-3
  A = 5'sd11;
  B = -5'sd3;

  #20;

  // Test 3: -10*-11
  A = -5'sd10;
  B = -5'sd11;

  #20;

  #20 $stop;
end

always forever
  begin
    #5 delay_clock = ~delay_clock;
  end

endmodule
