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
         output ValidWord, IsEmpty,
         output [ 7: 0 ] TxData,
         output SSPTXINTR
       );

// Four-element byte memory for FIFO
reg [ 7: 0 ] memory [ 3: 0 ];
// For the reset logic
integer i;

// Pointers to head and tail of FIFO
reg [ 1: 0 ] FIFO_head, FIFO_tail;

// FIFO fullness tracker
reg FIFO_full, FIFO_empty;

// Export value of fullness
assign SSPTXINTR = FIFO_full;
assign IsEmpty = FIFO_empty;
assign ValidWord = ~FIFO_empty;

// Check state of the FIFO addresses
wire FIFO_almost_full = ( FIFO_head == FIFO_tail + 2'b1 );
wire FIFO_almost_empty = ( FIFO_head + 2'b1 == FIFO_tail );

// Checking if processor is writing
wire P_writing = PSEL && PWRITE;

// Assign output bus
assign TxData = memory[ FIFO_head ];

always @( posedge PCLK ) begin
  if ( ~CLEAR_B )
  begin
    // Reset logic from active-low signal
    FIFO_head <= 2'b0;
    FIFO_tail <= 2'b0;
    FIFO_full <= 1'b0;
    FIFO_empty <= 1'b1;

    for ( i = 0; i < 4; i = i + 1 )
    begin
      memory[ i ] <= 8'b0;
    end
  end else
  begin
    // Normal FIFO operation

    if ( NextWord && P_writing )
    begin
      // Simultaneous read and write (ignoring under-flow case)
      FIFO_head <= FIFO_head + 2'b1;
      FIFO_tail <= FIFO_tail + 2'b1;
      FIFO_full <= FIFO_full;
      FIFO_empty <= FIFO_empty;
      memory[ FIFO_tail ] <= PWDATA;
    end else if ( NextWord )
    begin
      // Just reading
      FIFO_head <= FIFO_head + 2'b1;
      FIFO_tail <= FIFO_tail;
      FIFO_full <= 1'b0;
      // Assuming that the reads won't underflow the FIFO
      FIFO_empty <= FIFO_almost_empty;
    end else if ( P_writing )
    begin
      // Just writing
      if ( FIFO_full )
      begin
        // No-op
        FIFO_head <= FIFO_head;
        FIFO_tail <= FIFO_tail;
        FIFO_full <= FIFO_full;
        FIFO_empty <= 1'b0;
      end else
      begin
        // Complete write
        FIFO_head <= FIFO_head;
        FIFO_tail <= FIFO_tail + 2'b1;
        FIFO_full <= FIFO_almost_full;
        FIFO_empty <= 1'b0;
        memory[ FIFO_tail ] <= PWDATA;
      end
    end else
    begin
      // No FIFO operation
      FIFO_head <= FIFO_head;
      FIFO_tail <= FIFO_tail;
      FIFO_full <= FIFO_full;
      FIFO_empty <= FIFO_empty;
    end
  end
end

endmodule
