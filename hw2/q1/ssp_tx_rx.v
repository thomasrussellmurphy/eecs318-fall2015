// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The core serialization/deserialization logic for the SSP

`timescale 1 ns / 10 ps

module ssp_tx_rx (
         input PCLK,
         input CLEAR_B,
         input SSPCLKIN, SSPFSSIN, SSPRXD,
         input [ 7: 0 ] TxData,
         // Interface to TX FIFO
         output [ 7: 0 ] RxData,
         // Interface to RX FIFO
         output SSPCLKOUT, SSPFSSOUT, SSPTXD, SSPOE_B,
         output SSPTXINTR, SSPRXINTR
       );

endmodule

