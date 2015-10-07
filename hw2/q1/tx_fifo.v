// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The FIFO for the transmit side of the SSP implementation

// Processor interface uses:
// CLEAR_B, PSEL, PWRITE, PWDATA, SSPTXINTR

// SSP interface logic uses:
// NextWord, VaildWord, IsEmpty, RxData

`timescale 1 ns / 10 ps

module tx_fifo
       (
         input PCLK,
         input CLEAR_B, PSEL, PWRITE,
         input [ 7: 0 ] PWDATA,
         input NextWord,
         output ValidWord, IsEmpty
         output [ 7: 0 ] TxData,
         output SSPTXINTR
       );

endmodule
