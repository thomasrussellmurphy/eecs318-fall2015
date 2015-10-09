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

assign SSPTXD = shift_out[ 7 ];
assign TxNextWord = TxNextWord_lcl;

wire tx_loading = ( tx_state == tx_load ) || ( tx_state == tx_shift0_load );

always @( posedge PCLK ) begin
  // State change
  tx_state <= tx_next_state;
end

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


// Receive operation
reg [ 7: 0 ] shift_in;



endmodule

