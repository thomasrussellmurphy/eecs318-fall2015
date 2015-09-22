// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The 2nd carry-lookahead stage for a CLA adder
// Gate delay of 10 in this gate-level model

`timescale 1 ns / 1 ns

module cla2
       (
         input Ci,
         input [ 2: 0 ] p, g,
         output Co
       );
// Implementing Co = g[2] + p[2] * g[1] + p[2] * p[1] * g[0] + p[2] * p[1] * p[0] * Ci

wire [ 2: 0 ] p_result;

// Generate-or term
or #10 u_or0 ( Co, g[ 2 ], p_result[ 2 ], p_result[ 1 ], p_result[ 0 ] );

// Generate the propagation results
and #10 u_and2 ( p_result[ 2 ], p[ 2 ], g[ 1 ] );
and #10 u_and1 ( p_result[ 1 ], p[ 2 ], p[ 1 ], g[ 0 ] );
and #10 u_and0 ( p_result[ 0 ], p[ 2 ], p[ 1 ], p[ 0 ], Ci );

endmodule
