// Thomas Russell Murphy (trm80)
// EECS 319 Fall 2015
// The implementation of the negation of a 5-bit number

module negate_5
       (
         input [ 4: 0 ] A,
         output [ 4: 0 ] N
       );

wire [ 4: 0 ] Ci, Co, Spartial, invA;

// Here's our trick for adding one
assign Ci = { Co[ 3: 0 ], 1'b1 };

not not_A [ 4: 0 ] ( invA, A );

adder_instant adders [ 4: 0 ] (
                .A( invA ),
                .B( 5'b0 ),
                .Ci( Ci ),
                .S( Spartial ),
                .Co( Co )
              );

assign N = Spartial;

endmodule
