// Thomas Russell Murphy (trm70)
// EECS 319 Fall 2015
// The implementation a 9-bit adder using the full-adder implementation

module adder_rc_9_instant
       (
         input [ 8: 0 ] A,
         input [ 8: 0 ] B,
         output [ 9: 0 ] S
       );

wire [ 8: 0 ] Ci, Co, Spartial;

assign Ci = { Co[ 7: 0 ], 1'b0 };

assign S = { Co[ 8 ], Spartial };

adder_instant adders [ 8: 0 ] (
                .A( A ),
                .B( B ),
                .Ci( Ci ),
                .S( Spartial ),
                .Co( Co )
              );

endmodule
