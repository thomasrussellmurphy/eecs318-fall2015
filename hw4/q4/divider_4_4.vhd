-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Signed 4 into 4 bit divider: computes a / b

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;

entity divider_4_4 is
  port (
    a : in signed(3 downto 0);
    b : in signed(3 downto 0);
    z : out signed(3 downto 0) );
end entity divider_4_4;

architecture RTL of divider_4_4 is
  -- Signals
begin

  division: process(a, b) is
  begin
    z <= a / b;
  end process division;

end RTL;
