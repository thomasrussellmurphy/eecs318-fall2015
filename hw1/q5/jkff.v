// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The implementation of a J-K flip flop

`timescale 1 ns / 1 ns

module jkff
       (
         input clk,
         input j, k,
         output q, q_
       );

reg state;

initial
  state = 1'b0;

assign q = state;
assign q_ = ~state;

always @( posedge clk ) begin
  case ( { j, k } )
    2'b00:
      state <= state; // idle
    2'b01:
      state <= 1'b0; // reset
    2'b11:
      state <= ~state; // flop
    2'b10:
      state <= 1'b1; // set
    default:
      state <= 1'b0; // go to default state
  endcase
end

endmodule
