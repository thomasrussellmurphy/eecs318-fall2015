// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The implementation of a 10-input, 8-bit carry-save adder
// Maximum output value is about 11.3 bits, requiring 12 bit output width

module csa_10_8
       (
         input [ 7: 0 ] a, b, c, d, e, f, g, h, i, j,
         output [ 11: 0 ] z
       );

// Layer 1: consumes a, b, c, d, e, f, g, h, i
// Widths are all 8

wire [ 7: 0 ] s_abc, c_abc;
wire [ 7: 0 ] s_def, c_def;
wire [ 7: 0 ] s_ghi, c_ghi;

csa csa1_abc [ 7: 0 ]
    (
      .x( a ),
      .y( b ),
      .z( c ),
      .s( s_abc ),
      .c( c_ghi )
    );

csa csa1_def [ 7: 0 ]
    (
      .x( d ),
      .y( e ),
      .z( f ),
      .s( s_def ),
      .c( c_def )
    );

csa csa1_ghi [ 7: 0 ]
    (
      .x( g ),
      .y( h ),
      .z( i ),
      .s( s_ghi ),
      .c( c_def )
    );

// Layer 2: consumes s_abc, c_abc, s_def, c_def, s_ghi, c_ghi
// Widths are all 9 due to shifted carries

wire [ 8: 0 ] s_csa2_A, c_csa_A;
wire [ 8: 0 ] s_csa2_B, c_csa_B;

csa csa2_A [ 8: 0 ]
    (
      .x( { 1'b0, s_abc } ),
      .y( { c_abc, 1'b0 } ),
      .z( { 1'b0, s_def } ),
      .s( s_csa2_A ),
      .c( c_csa_A )
    );

csa csa2_B [ 8: 0 ]
    (
      .x( { c_def, 1'b0 } ),
      .y( { 1'b0, s_ghi } ),
      .z( { c_ghi, 1'b0 } ),
      .s( s_csa2_B ),
      .c( c_csa2_B )
    );

// Layer 3: consumes s_csa2_A, c_csa_A, s_csa2_B, c_csa_B, j
// Widths are now 10

wire [ 9: 0 ] s_csa3_A, c_csa3_A;
wire [ 9: 0 ] s_csa3_B, c_csa3_B;

csa csa3_A [ 9: 0 ]
    (
      .x( { 1'b0, s_csa2_A } ),
      .y( { c_csa_A, 1'b0 } ),
      .z( { 1'b0, s_csa2_B } ),
      .s( s_csa3_A ),
      .c( c_csa3_A )
    );

csa csa3_B [ 9: 0 ]
    (
      .x( { c_csa_B, 1'b0 } ),
      .y( { 2'b0, j } ),
      .z( 10'b0 ),
      .s( s_csa3_B ),
      .c( c_csa3_B )
    );

// Layer 4: consumes s_csa3_A, c_csa3_A, s_csa3_B

wire [ 10: 0 ] s_csa4, c_csa4;

csa csa4 [ 10: 0 ]
    (
      .x( { 1'b0, s_csa3_A } ),
      .y( { c_csa3_A, 1'b0 } ),
      .z( { 1'b0, s_csa3_B } ),
      .s( s_csa4 ),
      .c( c_csa4 )
    );

// Layer 5: consumes s_csa4, c_csa4, c_csa3_B,

wire [ 11: 0 ] s_csa5, c_csa5;

csa csa5 [ 11: 0 ]
    (
      .x( { 1'b0, s_csa4 } ),
      .y( { c_csa4, 1'b0 } ),
      .z( { 1'b0, c_csa3_B, 1'b0 } ),
      .s( s_csa5 ),
      .c( c_csa5 )
    );

// Final Adder

wire [ 12: 0 ] wide_result;

adder_rc
  #(
    .IN_WIDTH( 13 )
  )
  (
    .A( { 1'b0, s_csa5 } ),
    .B( { c_csa5, 1'b0 } ),
    .S( wide_result )
  );

assign z = wide_result[ 11: 0 ];

endmodule
