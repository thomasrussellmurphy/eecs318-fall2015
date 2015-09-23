// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The implementation a full-adder without any delay
// Will be used for implementing a ripple-carry adder

`timescale 1 ns / 1 ns

module adder_instant
       (
         input A, B, Ci,
         output S, Co
       );

wire ABsum;
wire ABcarry, Ccarry;

// Compute the sum
xor u_sum1 ( ABsum, A, B );
xor u_sum2 ( S, Ci, ABsum );

// Compute the ripple-carry
and u_carry1 ( Ccarry, ABsum, Ci );
and u_carry2 ( ABcarry, A, B );
or u_carry3 ( Co, Ccarry, ABcarry );

endmodule
