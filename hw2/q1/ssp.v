// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// Synchronous Serial Port implementation with the required interface

`timescale 1 ns / 10 ps

module ssp (
         input PCLK,
         input CLEAR_B, PSEL, PWRITE,
         input SSPCLKIN, SSPFSSIN, SSPRXD,
         input [ 7: 0 ] PWDATA,
         output [ 7: 0 ] PRDATA,
         output SSPCLKOUT, SSPFSSOUT, SSPTXD, SSPOE_B,
         output SSPTXINTR, SSPRXINTR
       );

// Interfaces to FIFOs
wire RxNextWord, TxValidWord, TxNextWord;
wire [ 7: 0 ] RxData, TxData;

// Instance rx_fifo
rx_fifo
  (
    .PCLK( PCLK ),
    .CLEAR_B( CLEAR_B ),
    .PSEL( PSEL ),
    .PWRITE( PWRITE ),
    .RxData( RxData ),
    .NextWord( RxNextWord ),
    .PRDATA( PRDATA ),
    .SSPRXINTR( SSPRXINTR )
  );

// Instance tx_fifo
tx_fifo
  (
    .PCLK( PCLK ),
    .CLEAR_B( CLEAR_B ),
    .PSEL( PSEL ),
    .PWRITE( PWRITE ),
    .PWDATA( PWDATA ),
    .NextWord( TxNextWord ),
    .ValidWord( TxValidWord ),
    .TxData( TxData ),
    .SSPTXINTR( SSPTXINTR )
  );

// Instance ssp_tx_rx
ssp_tx_rx (
    .PCLK( PCLK ),
    .CLEAR_B( CLEAR_B ),
    .SSPCLKIN( SSPCLKIN ),
    .SSPFSSIN( SSPFSSIN ),
    .SSPRXD( SSPRXD ),
    .TxData( TxData ),
    .TxValidWord( TxValidWord ),
    .TxNextWord( TxNextWord ),
    .RxData( RxData ),
    .RxNextWord( RxNextWord ),
    .SSPCLKOUT( SSPCLKOUT ),
    .SSPFSSOUT( SSPFSSOUT ),
    .SSPTXD( SSPTXD ),
    .SSPOE_B( SSPOE_B )
  );

endmodule
