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


// Instance rx_fifo
rx_fifo
  (
    .PCLK(),
    .CLEAR_B(),
    .PSEL(),
    .PWRITE(),
    .RxData(),
    .NextWord(),
    .PRDATA(),
    .SSPRXINTR()
  );

// Instance tx_fifo
rx_fifo
  (
    .PCLK(),
    .CLEAR_B(),
    .PSEL(),
    .PWRITE(),
    .PWDATA(),
    .NextWord(),
    .ValidWord(),
    .TxData(),
    .SSPTXINTR()
  );

// Instance ssp_tx_rx
ssp_tx_rx (
    .PCLK(),
    .CLEAR_B(),
    .SSPCLKIN(),
    .SSPFSSIN(),
    .SSPRXD(),
    .TxData(),
    .TxValidWord(),
    .TxNextWord(),
    .RxData(),
    .RxNextWord(),
    .SSPCLKOUT(),
    .SSPFSSOUT(),
    .SSPTXD(),
    .SSPOE_B()
  );

endmodule
