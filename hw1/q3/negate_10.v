// Thomas Russell Murphy (trm70)
// EECS 319 Fall 2015
// The implementation of the negation of a 10-bit number

module negate_5
       (
         input [ 9: 0 ] A,
         output [ 9: 0 ] N
       );

wire [ 9: 0 ] Ci, Co, Spartial, invA;

// Here's our trick for adding one
assign Ci = { Co[ 8: 0 ], 1'b1 };

not not_A [ 9: 0 ] ( invA, A );

adder_instant adders [ 4: 0 ] (
                .A( invA ),
                .B( 10'b0 ),
                .Ci( Ci ),
                .S( Spartial ),
                .Co( Co )
              );

assign N = Spartial;

endmodule
