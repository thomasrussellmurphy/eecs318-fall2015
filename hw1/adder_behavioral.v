// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The implementation a full-adder with a 10 unit gate delay
// Will be used for implementing a ripple-carry adder

`timescale 1 ns / 1 ns

module adder_behavioral(
         input A, B, Ci,
         output S, Co
       );

reg ABsum;
reg ABcarry, Ccarry;

reg S_lcl, Co_lcl;

assign S = S_lcl;
assign Co = Co_lcl;

// Compute the sum
always @( * ) begin
  ABsum <= #10 A ^ B;
  S_lcl <= #10 Ci ^ ABsum;
end

// Compute the ripple-carry
always @( * ) begin
  Ccarry <= #10 ABsum & Ci;
  ABcarry <= #10 A & B;
  Co_lcl <= #10 Ccarry | ABcarry;
end

endmodule

