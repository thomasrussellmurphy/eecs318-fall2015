// Thomas Russell Murphy (trm70)
// EECS 318 Fall 2015
// Implementing a simple processor

/*
  Processor instruction_register format
  32-bit instruction word

  [31:28] 4-bit Opcode
  [27:24] 4-bit Condition Code (BRANCH only)
  [27] 1-bit source type flag
  [26] 1-bit destination type flag
    0 means register or memory, 1 means immediate value
  [23:12] 12-bit Source Address (LD, STR, XOR, ADD, CMP)
  [23:12] 12-bit Shift/Rotate Count (ROT, SHF)
  [11:0] 12-bit Destination Address (LD, STR, BRA, XOR, ADD, ROT, SHF, CMP)
*/

/*
  Processor status_register format
  [0] carry
  [1] parity
  [2] even
  [3] negative
  [4] zero
*/

module processor
       #(
         parameter memory_file = 1
       )
       (
         input clk
       );

// Processor operation codes
parameter
  op_NOP = 4'h0,
  op_LD = 4'h1,
  op_STR = 4'h2,
  op_BRA = 4'h3,
  op_XOR = 4'h4,
  op_ADD = 4'h5,
  op_ROT = 4'h6,
  op_SHF = 4'h7,
  op_HLT = 4'h8,
  op_CMP = 4'h9;

// Processor condition codes
parameter
  cc_A = 4'h0,
  cc_P = 4'h1,
  cc_E = 4'h2,
  cc_C = 4'h3,
  cc_N = 4'h4,
  cc_Z = 4'h5,
  cc_NC = 4'h6,
  cc_PO = 4'h7;

// 12-bit addressable memory of 32-bit words
reg [ 31: 0 ] mem [ 4095: 0 ];

// 4-bit addressable register file of 32-bit words
reg [ 31: 0 ] processor_registers [ 15: 0 ];

// Our program counter, the address of the instruction being used
reg [ 11: 0 ] program_counter;

reg [ 31: 0 ] instruction_register;

integer i_clearing;

initial
begin
  // Arbitrary start of the program counter in memory
  program_counter = 12'h100;

  // Zeroize the memory
  for( i_clearing = 0; i_clearing < 4096; i_clearing = i_clearing + 1) begin
    mem[i_clearing] = 32'b0;
  end

  // Then load in the data
  if ( memory_file == 1 )
  begin
    $readmemb( "memory1.list", mem );
  end else
  begin
    $readmemb( "memory0.list", mem );
  end
end


always @( posedge clk ) begin
  // Time to do an impossibly long set of blocking things in the processor
  $stop;
end

endmodule
