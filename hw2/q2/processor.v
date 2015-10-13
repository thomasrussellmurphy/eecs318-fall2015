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

`timescale 1 ns / 10 ps

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

// Copy of current instruction is loaded here
reg [ 31: 0 ] instruction_register;

// Breaking down the IR into names
reg [ 3: 0 ] instruction_opcode, instruction_conditioncode;
reg instruction_source, instruction_destination;
reg [ 11: 0 ] source_count, destination;

// Processor Status Register
reg [ 4: 0 ] processor_sr;

// Producing results
reg [ 31: 0 ] free_operand, result;
reg carry;

integer i_clearing;

initial
begin
  // Arbitrary start of the program counter in memory
  program_counter = 12'h100;

  // Zeroize the memory
  for ( i_clearing = 0; i_clearing < 4096; i_clearing = i_clearing + 1 )
  begin
    mem[ i_clearing ] = 32'b0;
  end

  // Then load in the data
  case ( memory_file )
    1:
      $readmemb( "memory1.list", mem );
    default:
      $readmemb( "memory0.list", mem );
  endcase

  // Clear all of our other registers
  for ( i_clearing = 0; i_clearing < 16; i_clearing = i_clearing + 1 )
  begin
    processor_registers[ i_clearing ] = 32'b0;
  end

  instruction_register = 32'b0;
  processor_sr = 5'b0;
  free_operand = 32'b0;
  result = 32'b0;
  carry = 1'b0;

  // Finally, set the program counter to the top of the program memory
  program_counter = 12'h100;
end


always @( posedge clk ) begin
  // Time to do an impossibly long set of blocking things in the processor

  // Fetch
  fetch_instruction;

  // Decode and execute all simulation-like
  case ( instruction_register[ 31: 28 ] )
    op_NOP:
      ; // Yup, nothing
    op_LD:
    begin
      result = mem[ source_count ];
      carry = 1'b0;
      store_result;
      set_PSR;
    end
    op_STR:
    begin
      result = processor_registers[ source_count[ 3: 0 ] ];
      clear_PSR;
      mem[ destination ] = result;
    end
    op_BRA:
    case ( instruction_conditioncode )
      cc_A:
        // Always [load jump target]
        ;
      cc_P:
        // If parity bit
        ;
      cc_E:
        // If even bit
        ;
      cc_C:
        // If carry bit
        ;
      cc_N:
        // If negative bit
        ;
      cc_Z:
        // If zero bit
        ;
      cc_NC:
        // If not carry
        ;
      cc_PO:
        // If positive
        ;
      default:
        ;
    endcase
    op_XOR:
    begin
      get_operand;
      result = free_operand ^ processor_registers[ destination[ 3: 0 ] ];
      carry = 1'b0;
      set_PSR;
      store_result;
    end
    op_ADD:
    begin
      get_operand;
      { carry, result } = free_operand + processor_registers[ destination[ 3: 0 ] ];
      set_PSR;
      store_result;
    end
    op_ROT:
      ;
    op_SHF:
      ;
    op_HLT:
    begin
      // Stall a cycle and then halt to show what happens this cycle
      @( posedge clk );
      $stop;
    end
    op_CMP:
    begin
      get_operand;
      carry = 1'b0;
      result = ~free_operand;
      set_PSR;
      store_result;
    end
    default:
      ;
  endcase

  // Continue
  program_counter = program_counter + 12'b1;
end

task fetch_instruction;
  begin
    instruction_register = mem[ program_counter ];

    // Redundancy because these need to be registers
    // THANKS FOR THE COMPLEXITY, VERILOG >.>
    instruction_opcode = instruction_register[ 31: 28 ];
    instruction_conditioncode = instruction_register[ 27: 24 ];
    instruction_source = instruction_register[ 27 ];
    instruction_destination = instruction_register[ 26 ];
    source_count = instruction_register[ 23: 12 ];
    destination = instruction_register[ 11: 0 ];
  end
endtask

task get_operand;
  begin
    // Used by XOR, ADD, ROTATE, SHIFT, COMPLEMENT
    if ( instruction_source )
    begin
      // Loading immediate value, sign extended
      free_operand = { { 20{ source_count[ 11 ] } }, source_count };
    end else
    begin
      // Loading from a register
      free_operand = processor_registers[ source_count[ 3: 0 ] ];
    end
  end
endtask

task get_shift_amount;
  begin
    free_operand = source_count[ 4: 0 ];
  end
endtask

task store_result;
  begin
    processor_registers[ destination[ 3: 0 ] ] = result;
  end
endtask

task set_PSR;
  begin
    // Carry flag
    processor_sr[ 0 ] = carry;
    // Parity flag (reduction XOR)
    processor_sr[ 1 ] = ^ result;
    // Even flag (get LSB)
    processor_sr[ 2 ] = ~result[ 0 ];
    // Negative flag (get MSB)
    processor_sr[ 3 ] = result[ 31 ];
    // Zero flag (reduction AND)
    processor_sr[ 4 ] = & result;
  end
endtask

task clear_PSR;
  begin
    processor_sr = 5'b0;
  end
endtask

endmodule
