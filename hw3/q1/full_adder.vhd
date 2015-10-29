-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Simple full-adder

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity full_adder is
  port (
    a : in std_logic;
    b : in std_logic;
    ci : in std_logic;
    co : out std_logic;
    s : out std_logic );

end full_adder;

architecture RTL of full_adder is
  signal sum : std_logic;
  signal carry : std_logic;
begin

  adder_output: process(a, b, ci) is
    variable partial_sum : std_logic;
  begin
    partial_sum := a xor b;
    sum <= partial_sum xor ci;

    carry <= (partial_sum and ci) or (a and b);
  end process;

  s <= sum;
  co <= carry;
end RTL;
