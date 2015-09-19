// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The testbench for the full-adder with a 10 unit gate delay

`timescale 1 ns / 1 ps

module tb_adder();

reg A, B, Ci;
wire S, Co;

integer counter;

adder DUT(
        .A( A ),
        .B( B ),
        .Ci( Ci ),
        .S( S ),
        .Co( Co )
      );

initial
begin
  A = 1'b0;
  B = 1'b0;
  Ci = 1'b0;

  counter = 0;

  // Save signal simulation data
  $dumpfile( "adder.vcd" );
  $dumpvars( 1, A, B, Ci, S, Co );
  $dumpflush;


  // Given the gate delay of #10, need to wait for a while
  #500 $finish;
end

always forever
  begin
    #50 counter = counter + 1;
    { A, B, Ci } = counter[ 2: 0 ];
  end

endmodule
