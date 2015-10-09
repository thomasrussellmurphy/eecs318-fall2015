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

reg ssp_out_clk_div = 1'b0;
assign SSPCLKOUT = ssp_out_clk_div;

// Clock happens
always @( posedge PCLK ) ssp_out_clk_div <= ssp_out_clk_div + 1'b1;

// Control state machine transitions to happen after the low cycle of the
// divided-by-two system clock (could be updated for slower SSP clock)
wire update_state = ( ssp_out_clk_div == 1'b0 );
// And control SSPOE_B, in part, with the cycle before falling edge
wire pre_update_state = ( ssp_out_clk_div == 1'b1 );

// Transmit operation
reg [ 7: 0 ] shift_out = 8'b0;
reg TxNextWord_lcl, SSPOE_B_lcl;
reg [ 3: 0 ] tx_state, tx_next_state;
parameter
  tx_idle = 4'd0,
  tx_load = 4'd1,
  tx_shift7 = 4'd2,
  tx_shift6 = 4'd3,
  tx_shift5 = 4'd4,
  tx_shift4 = 4'd5,
  tx_shift3 = 4'd6,
  tx_shift2 = 4'd7,
  tx_shift1 = 4'd8,
  tx_shift0 = 4'd9,
  tx_shift0_load = 4'd10;

wire tx_loading = ( tx_state == tx_load ) || ( tx_state == tx_shift0_load );

assign SSPTXD = shift_out[ 7 ];
assign TxNextWord = TxNextWord_lcl;
assign SSPOE_B = SSPOE_B_lcl;
assign SSPFSSOUT = tx_loading;

// State change
always @( posedge PCLK ) tx_state <= tx_next_state;

always @( * ) begin
  // Manage transmit state machine
  if ( update_state )
  begin
    case ( tx_state )
      tx_idle:
        // Start the process by going to the loading state
        if ( ~TxIsEmpty )
        begin
          tx_next_state <= tx_load;
        end
        else
        begin
          tx_next_state <= tx_idle;
        end
      tx_load:
        tx_next_state <= tx_shift7;
      tx_shift7:
        tx_next_state <= tx_shift6;
      tx_shift6:
        tx_next_state <= tx_shift5;
      tx_shift5:
        tx_next_state <= tx_shift4;
      tx_shift4:
        tx_next_state <= tx_shift3;
      tx_shift3:
        tx_next_state <= tx_shift2;
      tx_shift2:
        tx_next_state <= tx_shift1;
      tx_shift1:
        // Check for continuous output frames
        if ( ~TxIsEmpty )
        begin
          tx_next_state <= tx_shift0_load;
        end
        else
        begin
          tx_next_state <= tx_shift0;
        end
      tx_shift0:
        tx_next_state <= tx_idle;
      tx_shift0_load:
        tx_next_state <= tx_shift7;
      default:
        tx_next_state <= tx_idle;
    endcase
  end else
  begin
    tx_next_state <= tx_state;
  end
end

always @( posedge PCLK ) begin
  // Manage the transmit shift register
  if ( update_state )
  begin
    case ( tx_state )
      tx_load:
        shift_out <= TxData;
      tx_shift0_load:
        shift_out <= TxData;
      default:
        shift_out <= { shift_out[ 6: 0 ], 1'b0 };
    endcase
  end
end

always @( * ) begin
  TxNextWord_lcl <= update_state && tx_loading ;
end

always @( posedge PCLK ) begin
  if ( tx_loading && pre_update_state )
  begin
    SSPOE_B_lcl <= 1'b0;
  end else if ( ( tx_state == tx_idle ) && pre_update_state )
  begin
    SSPOE_B_lcl <= 1'b1;
  end else
  begin
    SSPOE_B_lcl <= SSPOE_B_lcl;
  end
end

// Receive operation
reg [ 7: 0 ] shift_in = 8'b0;
reg RxNextWord_lcl;
reg SSPCLKIN_prev;
reg [ 3: 0 ] rx_state, rx_next_state;
parameter
  rx_idle = 4'd0,
  rx_shift7 = 4'd1,
  rx_shift6 = 4'd2,
  rx_shift5 = 4'd3,
  rx_shift4 = 4'd4,
  rx_shift3 = 4'd5,
  rx_shift2 = 4'd6,
  rx_shift1 = 4'd7,
  rx_shift0 = 4'd8;

assign RxData = shift_in;
assign RxNextWord = RxNextWord_lcl;

// Recording history of the SSPCLKIN
always @( posedge PCLK ) SSPCLKIN_prev <= SSPCLKIN;

wire SSPCLKIN_fall = SSPCLKIN_prev && ~SSPCLKIN;
wire SSPCLKIN_rise = ~SSPCLKIN_prev && SSPCLKIN;

// State change
always @( posedge PCLK ) rx_state <= rx_next_state;

always @( * ) begin
  // Manage the receive state machine
  if ( SSPCLKIN_fall )
  begin
    case ( rx_state )
      rx_idle:
        // Start receive process by starting to receive data
        if ( SSPFSSIN )
        begin
          rx_next_state <= rx_shift7;
        end else
        begin
          rx_next_state <= rx_idle;
        end
      rx_shift7:
        rx_next_state <= rx_shift6;
      rx_shift6:
        rx_next_state <= rx_shift5;
      rx_shift5:
        rx_next_state <= rx_shift4;
      rx_shift4:
        rx_next_state <= rx_shift3;
      rx_shift3:
        rx_next_state <= rx_shift2;
      rx_shift2:
        rx_next_state <= rx_shift1;
      rx_shift1:
        rx_next_state <= rx_shift0;
      rx_shift0:
        // Time to continue the transaction?
        if ( SSPFSSIN )
        begin
          rx_next_state <= rx_shift7;
        end else
        begin
          rx_next_state <= rx_idle;
        end
      default:
        rx_next_state <= rx_idle;
    endcase
  end else
  begin
    rx_next_state <= rx_state;
  end
end

always @( posedge PCLK ) begin
  // Pretty simple shift register management
  if ( SSPCLKIN_fall )
  begin
    shift_in <= { shift_in[ 6: 0 ], SSPRXD };
  end else
  begin
    shift_in <= shift_in;
  end
end

always @( posedge PCLK ) begin
  // Control the receive FIFO
  if ( ( rx_state == rx_shift0 ) && SSPCLKIN_rise )
  begin
    RxNextWord_lcl <= 1'b1;
  end else
  begin
    RxNextWord_lcl <= 1'b0;
  end
end

endmodule

