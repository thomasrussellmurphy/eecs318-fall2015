// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The implementation of the state machine using 'behavioral' Verilog

`timescale 1 ns / 1 ns

module fsm_behavioral
       (
         input clk, x,
         output z1, z2
       );

parameter sA = 2'b00, sB = 2'b01, sC = 2'b11, sD = 2'b10;

reg y2, y1;
reg [ 1: 0 ] next_state;

initial
  { y2, y1 } = 2'b0;

// Output expression with simplifications
assign z2 = ~x;
assign z1 = y1 && y2;

always @( posedge clk ) begin
  { y2, y1 } <= next_state;
end

always @( * ) begin
  case ( { y2, y1 } )
    sA:
      if ( x )
      begin
        next_state <= sC;
      end else
      begin
        next_state <= sD;
      end
    sB:
      if ( x )
      begin
        next_state <= sA;
      end else
      begin
        next_state <= sA;
      end
    sC:
      if ( x )
      begin
        next_state <= sB;
      end else
      begin
        next_state <= sA;
      end
    sD:
      if ( x )
      begin
        next_state <= sC;
      end else
      begin
        next_state <= sD;
      end
    default:
      next_state <= sA;
  endcase
end

endmodule

