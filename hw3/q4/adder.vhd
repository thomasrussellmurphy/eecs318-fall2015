-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Simple full-adder

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder is
  port (
    a : in std_logic;
    b : in std_logic;
    ci : in std_logic;
    co : out std_logic;
    s : out std_logic );

end adder;

architecture RTL of adder is
  signal partial_sum : std_logic := '0';
  signal sum : std_logic := '0';
  signal carry : std_logic := '0';
begin

  adder_output: process(a, b, ci)
  begin
    partial_sum <= a xor b;
    sum <= partial_sum xor ci;

    carry <= (partial_sum and ci) or (a and b);
  end process;

  s <= sum;
  co <= carry;
end RTL;
