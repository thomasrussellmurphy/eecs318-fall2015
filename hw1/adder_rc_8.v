// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The implementation an 8-bit adder using the full-adder implementation
// Due to ripple-carry behavior, the full-adder delays will be long

`timescale 1 ns / 1 ns

module adder_rc_8
       (
         input [ 7: 0 ] A,
         input [ 7: 0 ] B,
         output [ 8: 0 ] S
       );

wire [ 7: 0 ] Ci, Co, Spartial;

assign Ci = { Co[ 6: 0 ], 1'b0 };

assign S = { Co[ 7 ], Spartial };

adder adders [ 7: 0 ] (
        .A( A ),
        .B( B ),
        .Ci( Ci ),
        .S( Spartial ),
        .Co( Co )
      );

endmodule
