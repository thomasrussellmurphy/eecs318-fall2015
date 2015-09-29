// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The implementation an 8-bit adder using the full-adder implementation
// Due to ripple-carry behavior, the full-adder delays will be long

`timescale 1 ns / 1 ns

module adder_rc_instant
       #(
         parameter IN_WIDTH = 8
       )
       (
         input [ IN_WIDTH - 1: 0 ] A,
         input [ IN_WIDTH - 1: 0 ] B,
         output [ IN_WIDTH: 0 ] S
       );

wire [ IN_WIDTH - 1: 0 ] Ci, Co, Spartial;

assign Ci = { Co[ IN_WIDTH - 2: 0 ], 1'b0 };

assign S = { Co[ IN_WIDTH - 1 ], Spartial };

adder_instant adders [ IN_WIDTH - 1: 0 ] (
                .A( A ),
                .B( B ),
                .Ci( Ci ),
                .S( Spartial ),
                .Co( Co )
              );

endmodule
