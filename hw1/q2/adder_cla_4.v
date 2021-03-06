// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The implementation a 4-bit adder using the CLA blocks
// Foregoes the ripple-carry behavior, reducing the delay

`timescale 1 ns / 1 ns

module adder_cla_4
       (
         input [ 3: 0 ] A,
         input [ 3: 0 ] B,
         output [ 4: 0 ] S
       );

wire [ 3: 0 ] Ci, Spartial, p, g;

wire Cfinal;

assign Ci[ 0 ] = 1'b0;
assign S = { Cfinal, Spartial };

adder_cla adders [ 3: 0 ]
          (
            .A( A ),
            .B( B ),
            .Ci( Ci ),
            .S( Spartial ),
            .p( p ),
            .g( g )
          );

cla0 u_cla0
     (
       .Ci( 1'b0 ),
       .p( p[ 0: 0 ] ),
       .g( g[ 0: 0 ] ),
       .Co( Ci[ 1 ] )
     );

cla1 u_cla1
     (
       .Ci( 1'b0 ),
       .p( p[ 1: 0 ] ),
       .g( g[ 1: 0 ] ),
       .Co( Ci[ 2 ] )
     );

cla2 u_cla2
     (
       .Ci( 1'b0 ),
       .p( p[ 2: 0 ] ),
       .g( g[ 2: 0 ] ),
       .Co( Ci[ 3 ] )
     );

cla3 u_cla3
     (
       .Ci( 1'b0 ),
       .p( p[ 3: 0 ] ),
       .g( g[ 3: 0 ] ),
       .Co( Cfinal )
     );

endmodule
