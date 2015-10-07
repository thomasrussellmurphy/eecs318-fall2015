// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The core serialization/deserialization logic for the SSP

// Processor interface uses:
// CLEAR_B

// Receive FIFO interface logic uses:
// RxData, RxNextWord

// Transmit FIFO interface logic uses:
// TxData, TxValidWord, TxNextWord

// World-facing serial port interface uses:
// SSPCLKIN, SSPFSSIN, SSPRXD, SSPCLKOUT, SSPFSSOUT, SSPTXD, SSPOE_B

`timescale 1 ns / 10 ps

module ssp_tx_rx (
         input PCLK,
         input CLEAR_B,
         input SSPCLKIN, SSPFSSIN, SSPRXD,
         input [ 7: 0 ] TxData,
         input TxValidWord, TxIsEmpty,
         output TxNextWord,
         output [ 7: 0 ] RxData,
         output RxNextWord,
         output SSPCLKOUT, SSPFSSOUT, SSPTXD, SSPOE_B
       );

endmodule

