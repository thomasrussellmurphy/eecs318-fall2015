// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// The FIFO for the receive side of the SSP implementation

// Processor interface uses:
// CLEAR_B, PSEL, PWRITE, PRDATA, SSPRXINTR

// SSP interface logic uses:
// RxData, NextWord

`timescale 1 ns / 10 ps

module rx_fifo
       (
         input PCLK,
         input CLEAR_B, PSEL, PWRITE,
         input [ 7: 0 ] RxData,
         input NextWord,
         output [ 7: 0 ] PRDATA,
         output SSPRXINTR
       );

// Four-element byte memory for FIFO
reg [ 7: 0 ] memory [ 1: 0 ];
// For the reset logic
integer i;

// Pointers to head and tail of FIFO
reg [ 1: 0 ] FIFO_head, FIFO_tail;

// FIFO fullness tracker
reg FIFO_full;

// Export value of fullness
assign SSPRXINTER = FIFO_full;

// Check state of the FIFO addresses
wire FIFO_almost_full = ( FIFO_head == FIFO_tail + 2'b1 );
wire FIFO_almost_empty = ( FIFO_head + 2'b1 == FIFO_tail );

// Checking if processor is reading
wire P_reading = PSEL && ~PWRITE;

// Assign output bus
assign PRDATA = memory[ FIFO_head ];

always @( posedge PCLK ) begin
  if ( CLEAR_B )
  begin
    // Reset logic
    FIFO_head <= 2'b0;
    FIFO_tail <= 2'b0;
    FIFO_full = 1'b0;

    for ( i = 0; i < 4; i = i + 1 )
    begin
      memory[ i ] <= 8'b0;
    end
  end else
  begin
    // Normal FIFO operation

    if ( P_reading && NextWord )
    begin
      // Simultaneous read and write (ignoring under-flow case)
      FIFO_head <= FIFO_head + 2'b1;
      FIFO_tail <= FIFO_tail + 2'b1;
      FIFO_full <= FIFO_full;
      memory[ FIFO_tail ] <= RxData;
    end else if ( P_reading )
    begin
      // Just reading (ignoring under-flow case)
      FIFO_head <= FIFO_head + 2'b1;
      FIFO_tail <= FIFO_tail;
      FIFO_full <= 1'b0;
    end else if ( NextWord )
    begin
      // Just writing
      if ( FIFO_full )
      begin
        // No-op
        FIFO_head <= FIFO_head;
        FIFO_tail <= FIFO_tail;
        FIFO_full <= FIFO_full;
      end else
      begin
        // Complete write
        FIFO_head <= FIFO_head;
        FIFO_tail <= FIFO_tail + 2'b1;
        FIFO_full <= FIFO_almost_full;
        memory[ FIFO_tail ] <= NextWord;
      end
    end else
    begin
      // No FIFO operation
      FIFO_head <= FIFO_head;
      FIFO_tail <= FIFO_tail;
      FIFO_full <= FIFO_full;
    end
  end
end


endmodule
