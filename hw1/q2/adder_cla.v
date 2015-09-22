// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The core full-adder for a carry-lookahead adder implementation
// Gate delay of 10 in this gate-level model

`timescale 1 ns / 1 ns

module adder_cla
(
  input A, B, Ci
  output S, p, g
);

wire ABsum;

// Compute the sum
xor #10 u_sum1 ( ABsum, A, B );
xor #10 u_sum2 ( S, Ci, ABsum );

// Wire out the propagate
assign p = ABsum;

// Calculate the generate
and #10 u_generate (g, A, B);

endmodule
