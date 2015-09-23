// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The implementation a full-adder without any delay
// Will be used for implementing a ripple-carry adder

module csa
       (
         input x, y, z,
         output s, c
       );

// Also just reusing logic from the full-adder
wire ABsum;
wire ABcarry, Ccarry;

// Compute the partial sum component
xor u_sum1 ( ABsum, x, y );
xor u_sum2 ( S, z, ABsum );

// Compute the shifted carry component
and u_carry1 ( Ccarry, ABsum, z );
and u_carry2 ( ABcarry, x, y );
or u_carry3 ( Co, Ccarry, ABcarry );

endmodule
