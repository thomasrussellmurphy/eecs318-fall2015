// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// Synchronous Serial Port implementation with the required interface

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
// Instance tx_fifo
// Instance ssp_tx_rx

endmodule
