// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The implementation of a 5x5-bit signed multiplier in structural Verilog

module multiplier_signed_5
       (
         input signed [ 4: 0 ] A, B,
         output signed [ 9: 0 ] P
       );

// Since multB must not be negative, need to sort things out
wire [ 4: 0 ] multA, multB;

// Temporaries for changing signs of A and B
wire [ 4: 0 ] negA, negB;

negate_5 negate_A (
           .A( A ),
           .N( negA )
         );

negate_5 negate_B (
           .A( B ),
           .N( negB )
         );

// Choosing what gets used
wire swapA, swapB;
wire neg_result;

assign swapA = A[ 4 ];
assign swapB = B[ 4 ];
xor result_sign ( neg_result, swapA, swapB);

mux swap_in_negA [ 4: 0 ] (
      .sel( swapA ),
      .A( A ),
      .B( negA ),
      .Z( multA )
    );

mux swap_in_negB [ 4: 0 ] (
      .sel( swapB ),
      .A( B ),
      .B( negB ),
      .Z( multB )
    );

// Create our partial products
wire [ 8: 0 ] partialP_0, partialP_1, partialP_2, partialP_3, partialP_4;
wire [ 9: 0 ] adderS_0, adderS_1, adderS_2, adderS_3;

// Generate the partial products
and and_partialP_0 [ 4: 0 ] ( partialP_0[ 4: 0 ], { 5{ multB[ 0 ] } }, multA );
assign { partialP_0[ 8: 5 ] } = { 4{ partialP_0[ 4 ] } };

and and_partialP_1 [ 4: 0 ] ( partialP_1[ 5: 1 ], { 5{ multB[ 1 ] } }, multA );
assign partialP_1[ 8: 6 ] = { 3{ partialP_1[ 5 ] } };
assign partialP_1[ 0 ] = 1'b0;

and and_partialP_2 [ 4: 0 ] ( partialP_2[ 6: 2 ], { 5{ multB[ 2 ] } }, multA );
assign partialP_2[ 8: 7 ] = { 2{ partialP_2[ 6 ] } };
assign partialP_2[ 1: 0 ] = 2'b0;

and and_partialP_3 [ 4: 0 ] ( partialP_3[ 7: 3 ], { 5{ multB[ 3 ] } }, multA );
assign partialP_3[ 8 ] = partialP_3[ 7 ];
assign partialP_3[ 2: 0 ] = 3'b0;

and and_partialP_4 [ 4: 0 ] ( partialP_4[ 8: 4 ], { 5{ multB[ 4 ] } }, multA );
assign partialP_4[ 3: 0 ] = 4'b0 ;

// Sum the partial products

adder_rc_9_instant adder_9_0 (
                     .A( partialP_0 ),
                     .B( partialP_1 ),
                     .S( adderS_0 )
                   );

adder_rc_9_instant adder_9_1 (
                     .A( partialP_2 ),
                     .B( adderS_0 [ 8: 0 ] ),
                     .S( adderS_1 )
                   );

adder_rc_9_instant adder_9_2 (
                     .A( partialP_3 ),
                     .B( adderS_1[ 8: 0 ] ),
                     .S( adderS_2 )
                   );

adder_rc_9_instant adder_9_3 (
                     .A( partialP_4 ),
                     .B( adderS_2[ 8: 0 ] ),
                     .S( adderS_3 )
                   );

wire [9:0] pos_result, neg_result;

assign pos_result = adderS_3;

negate_10 negate_result (
           .A( pos_result ),
           .N( neg_result )
         );

mux swap_neg_result [9:0] (
  .sel(neg_result),
  .A(pos_result),
  .B(neg_result),
  .Z(P)
);

endmodule
