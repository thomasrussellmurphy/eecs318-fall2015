// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The implementation a full-adder with a 10 unit gate delay
// Will be used for implementing a ripple-carry adder

`timescale 1 ns / 1 ns

module adder
       (
         input A, B, Ci,
         output S, Co
       );

wire ABsum;
wire ABcarry, Ccarry;

// Compute the sum
xor #10 u_sum1 ( ABsum, A, B );
xor #10 u_sum2 ( S, Ci, ABsum );

// Compute the ripple-carry
and #10 u_carry1 ( Ccarry, ABsum, Ci );
and #10 u_carry2 ( ABcarry, A, B );
or #10 u_carry3 ( Co, Ccarry, ABcarry );

endmodule
