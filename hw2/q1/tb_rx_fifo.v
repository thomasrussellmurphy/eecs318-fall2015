// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// Testing the FIFO for the transmit side of the SSP implementation

`timescale 1 ns / 10 ps

module tb_rx_fifo;

reg clock, clear_b, psel, pwrite, next_word;
reg [ 7: 0 ] rx_data;

wire ssprxintr;
wire [ 7: 0 ] pr_data;

rx_fifo DUT
        (
          .PCLK( clock ),
          .CLEAR_B( clear_b ),
          .PSEL( psel ),
          .PWRITE( pwrite ),
          .RxData( rx_data ),
          .NextWord( next_word ),
          .PRDATA( pr_data ),
          .SSPRXINTR( ssprxintr )
        );

initial
begin
  clock = 1'b0;
  clear_b = 1'b0;
  psel = 1'b0;
  pwrite = 1'b0;
  next_word = 1'b0;
  @( posedge clock );
  #1;
  @( posedge clock );

  // Stop clearing
  clear_b = 1'b1;

  #80;

  // Input some data
  next_word = 1'b1;
  rx_data = 8'hE7;
  #40;
  next_word = 1'b0;

  #400;

  next_word = 1'b1;
  rx_data = 8'h3A;
  #40;
  next_word = 1'b0;

  #400;

  next_word = 1'b1;
  rx_data = 8'h29;
  #40;
  next_word = 1'b0;

  #400;

end

always
  #20 clock = ~clock;

endmodule
