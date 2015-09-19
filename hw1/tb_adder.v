// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The testbench for the full-adder with a 10 unit gate delay

`timescale 1 ns / 1 ns

module tb_adder();

reg A, B, Ci;
wire S, Co;
wire S_b, Co_b;

integer counter;

adder DUT1 (
        .A( A ),
        .B( B ),
        .Ci( Ci ),
        .S( S ),
        .Co( Co )
      );

adder_behavioral DUT2 (
                   .A( A ),
                   .B( B ),
                   .Ci( Ci ),
                   .S( S_b ),
                   .Co( Co_b )
                 );

initial
begin
  A = 1'b0;
  B = 1'b0;
  Ci = 1'b0;

  counter = 0;

  // Save signal simulation data
  $dumpfile( "adder.vcd" );
  $dumpvars( 1, A, B, Ci, S, Co, S_b, Co_b );
  $dumpflush;


  // Given the gate delay of #10, need to wait for a while
  #1000 $finish;
end

always forever
  begin
    #100 counter = counter + 1;
    { A, B, Ci } = counter[ 2: 0 ];
  end

endmodule
