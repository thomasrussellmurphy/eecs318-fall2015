// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The FIFO for the transmit side of the SSP implementation

module rx_fifo
(
  input PCLK,
  input CLEAR_B, PSEL, PWRITE
  input [7:0] PWDATA,
  // plus interface to Tx/Rx logic
  input NextWord,
  output ValidWord,
  output [7:0] TxData,
  output SSPTXINTR
);

endmodule
