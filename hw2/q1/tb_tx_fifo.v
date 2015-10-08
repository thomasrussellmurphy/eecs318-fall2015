// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// Testing the FIFO for the transmit side of the SSP implementation

`timescale 1 ns / 10 ps

module tb_tx_fifo;

reg clock, clear_b, psel, pwrite, next_word;
reg [ 7: 0 ] pw_data;

wire validword, isempty, ssptxintr;
wire [ 7: 0 ] tx_data;

tx_fifo DUT
        (
          .PCLK( clock ),
          .CLEAR_B( clear_b ),
          .PSEL( psel ),
          .PWRITE( pwrite ),
          .PWDATA( pw_data ),
          .NextWord( next_word ),
          .ValidWord( validword ),
          .IsEmpty( isempty ),
          .TxData( tx_data ),
          .SSPTXINTR( ssptxintr )
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
  psel = 1'b1;
  pwrite = 1'b1;
  pw_data = 8'hAE;
  #40;

  pw_data = 8'h39;
  #40;

  pw_data = 8'hC7;
  #40;

  psel = 1'b0;

  #80;

  // Now reading out some of the data
  next_word = 1'b1;
  #40;
  next_word = 1'b0;
  #800;

  next_word = 1'b1;
  #40;
  next_word = 1'b0;
  #800;

  next_word = 1'b1;
  #40;
  next_word = 1'b0;
  #800;

  $stop;

end

always
  #20 clock = ~clock;

endmodule
