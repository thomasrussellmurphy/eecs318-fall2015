// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The implementation of the state machine using 'structural' Verilog

`timescale 1 ns / 1 ns

module fsm_structural
       (
         input clk, x,
         output z1, z2
       );

// Invert x for use
wire x_;

not not_x( x_, x );

// Flip-flop 1 inputs
wire j1, k1;

// Flip-flop 1 outputs
wire y1, y1_;

// Flip-flop 2 inputs
wire j2, k2;

// Flip-flop 2 outputs
wire y2, y2_;

// Setup inputs for flip-flop 1
assign j1 = x;

wire pre_k1_and1, pre_k1_and2;

and k1_and1( pre_k1_and1, x_, y2_ );
and k1_and2( pre_k1_and2, x, y2 );
nor( k1, pre_k1_and1, pre_k1_and2 );

jkff jk_y1
     (
       .clk( clk ),
       .j( j1 ),
       .k( k1 ),
       .q( y1 ),
       .q_( y1_ )
     );

// Setup inputs for flip-flop 2
assign j2 = y1_;

or( k2, y1, x );

jkff jk_y2
     (
       .clk( clk ),
       .j( j2 ),
       .k( k2 ),
       .q( y2 ),
       .q_( y2_ )
     );

// Create z1 output
and and_z1( z1, y1, y2 );

// Create z2 output
wire pre_z2_and;

and z2_and( pre_z2_and, y1, y1_ );
// USELESS statement ^
or( z2, x_, pre_z2_and );

endmodule
