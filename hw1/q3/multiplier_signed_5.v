// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The implementation of a 5x5-bit signed multiplier in structural Verilog

module multiplier_signed_5
       (
         input signed [ 4: 0 ] A, B,
         output signed [ 9: 0 ] P
       );

// Create our signals


// Generate the partial products


// Sum the partial products

assign P = A * B;

endmodule
