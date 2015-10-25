-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Basic block for a Carry-Save Adder

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity csa is
  port (
    x : in std_logic;
    y : in std_logic;
    z : in std_logic;
    c : out std_logic;
    s : out std_logic );

end csa;

architecture RTL of csa is
  signal sum : std_logic;
  signal carry : std_logic;
begin

  csa_output: process(x, y, z) is
    variable partial_sum : std_logic;
  begin
    partial_sum := x xor y;
    sum <= partial_sum xor z;

    carry <= (partial_sum and z) or (x and y);
  end process;

  s <= sum;
  c <= carry;
end RTL;
