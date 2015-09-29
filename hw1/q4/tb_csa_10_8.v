// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The test for the 5x5-bit signed multiplier in structural Verilog

`timescale 1 ns / 1 ns

module tb_csa_10_8;

// Input values
reg [ 7: 0 ] a, b, c, d, e, f, g, h, i, j;

// Output value
wire [ 11: 0 ] sum;
wire [ 11: 0 ] expected;

// Indicates some delay
reg delay_clock;

csa_10_8 DUT
         (
           .a( a ),
           .b( b ),
           .c( c ),
           .d( d ),
           .e( e ),
           .f( f ),
           .g( g ),
           .h( h ),
           .i( i ),
           .j( j ),
           .z( sum )
         );

assign expected = a + b + c + d + e + f + g + h + i + j;

initial
begin
  // Save signal simulation data
  $dumpfile( "csa_10_8.vcd" );
  $dumpvars( 1, delay_clock, a, b, c, d, e, f, g, h, i, j, sum, expected );
  $dumpflush;

  delay_clock = 1'b0;

  // Initial state
  a = 8'b0;
  b = 8'b0;
  c = 8'b0;
  d = 8'b0;
  e = 8'b0;
  f = 8'b0;
  g = 8'b0;
  h = 8'b0;
  i = 8'b0;
  j = 8'b0;

  #20;

  // Test 1: (11, 2, 13, 4, 5, 6, 7, 8, 9, 10)
  a = 8'd11;
  b = 8'd2;
  c = 8'd13;
  d = 8'd4;
  e = 8'd5;
  f = 8'd6;
  g = 8'd7;
  h = 8'd8;
  i = 8'd9;
  j = 8'd10;

  #20;

  // Test 2: (3, 14, 5, 6, 7, 8, 19, 10)
  a = 8'd3;
  b = 8'd14;
  c = 8'd5;
  d = 8'd6;
  e = 8'd7;
  f = 8'd8;
  g = 8'd19;
  h = 8'd10;
  i = 8'd0;
  j = 8'd0;

  #20;

  #20 $stop;
end

always forever
  begin
    #5 delay_clock = ~delay_clock;
  end

endmodule
