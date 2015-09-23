// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The implementation of a 5x5-bit signed multiplier in structural Verilog

module multiplier_signed_5
       (
         input signed [ 4: 0 ] A, B,
         output signed [ 9: 0 ] P
       );

// Create our signals
wire [ 8: 0 ] partialP_0, partialP_1, partialP_2, partialP_3, partialP_4;
wire [ 9: 0 ] adderS_2_0, adderS_2_1;
wire [ 9: 0 ] adderS_1, adderS_0;

// Generate the partial products
and and_partialP_0 [ 4: 0 ] ( partialP_0[ 4: 0 ], { 5{ B[ 0 ] } }, A );
assign { partialP_0[ 8: 5 ] } = { 4{ partialP_0[ 4 ] } };

and and_partialP_1 [ 4: 0 ] ( partialP_1[ 5: 1 ], { 5{ B[ 1 ] } }, A );
assign partialP_1[ 8: 6 ] = { 3{ partialP_1[ 5 ] } };
assign partialP_1[ 0 ] = 1'b0;

and and_partialP_2 [ 4: 0 ] ( partialP_2[ 6: 2 ], { 5{ B[ 2 ] } }, A );
assign partialP_2[ 8: 7 ] = { 2{ partialP_2[ 6 ] } };
assign partialP_2[ 1: 0 ] = 2'b0;

and and_partialP_3 [ 4: 0 ] ( partialP_3[ 7: 3 ], { 5{ B[ 3 ] } }, A );
assign partialP_3[ 8 ] = partialP_3[ 7 ];
assign partialP_3[ 2: 0 ] = 3'b0;

and and_partialP_4 [ 4: 0 ] ( partialP_4[ 8: 4 ], { 5{ B[ 4 ] } }, A );
assign partialP_4[ 3: 0 ] = 4'b0 ;

// Sum the partial products

adder_rc_9_instant adder_9_2_0 (
                     .A( partialP_0 ),
                     .B( partialP_1 ),
                     .S( adderS_2_0 )
                   );

adder_rc_9_instant adder_9_2_1 (
                     .A( partialP_2 ),
                     .B( partialP_3 ),
                     .S( adderS_2_1 )
                   );

adder_rc_9_instant adder_9_1 (
                     .A( adderS_2_0[ 8: 0 ] ),
                     .B( adderS_2_1[ 8: 0 ] ),
                     .S( adderS_1 )
                   );

adder_rc_9_instant adder_9_0 (
                     .A( adderS_1[ 8: 0 ] ),
                     .B( partialP_4 ),
                     .S( adderS_0 )
                   );

assign P = //adderS_0;

endmodule
