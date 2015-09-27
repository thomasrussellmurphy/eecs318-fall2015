// Thomas Russell Murphy (trm70)
// EECS 319 Fall 2015
// A 2-to-1 mux, because we don't have one
// When sel is asserted (1), propagate B


module mux
       (
         input sel,
         input A, B,
         output Z
       );

wire sel_;
wire outA, outB;

not not_sel ( sel_, sel );

and and_A ( outA, sel_, A );
and and_B ( outB, sel, B );

or result ( Z, outA, outB );

endmodule
