-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Signed 4 into 4 bit divider testing

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;

entity tb_divider_4_4 is
end entity tb_divider_4_4;

architecture test of tb_divider_4_4 is
  -- Signals
  signal end_simulation : boolean := false;

  signal test_clk : std_logic := '0';

  signal
    a, b : signed(3 downto 0);

  signal z : signed(3 downto 0);

  -- Components
  component divider_4_4 is
    port (
      a : in signed(3 downto 0);
      b : in signed(3 downto 0);
      z : out signed(3 downto 0) );
  end component;

  -- Constants
  constant clock_period : time := 10 ns;
begin

  DUT: divider_4_4 port map (
    a => a,
    b => b,
    z => z );

  clk_gen: process
  begin
    if not end_simulation then
      test_clk <= '0';
      wait for clock_period / 2;
      test_clk <= '1';
      wait for clock_period / 2;
    else
      wait;
    end if;
  end process clk_gen;

  test_sequence: process
  begin

    a <= (others => '0');
    b <= to_signed(1, b'length);
    wait until rising_edge(test_clk);

    a <= to_signed(7, a'length);
    b <= to_signed(-2, b'length);
    wait until rising_edge(test_clk);

    a <= to_signed(6, a'length);
    b <= to_signed(-2, b'length);
    wait until rising_edge(test_clk);

    a <= (others => '0');
    b <= to_signed(1, b'length);
    wait until rising_edge(test_clk);
    end_simulation <= true;
    wait;
  end process test_sequence;
end test;
