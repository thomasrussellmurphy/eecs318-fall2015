// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The FIFO for the receive side of the SSP implementation

`timescale 1 ns / 10 ps

module rx_fifo
(
  input PCLK,
  input CLEAR_B, PSEL, PWRITE
  input [7:0] RxData,
  // plus interface to Tx/Rx logic
  input NextWord,
  output [7:0] PRDATA,
  output SSPRXINTR
);

endmodule
