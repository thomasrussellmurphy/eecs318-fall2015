-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Signed 5x5 bit multiplier

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;

entity tb_multiplier_5_5 is
end entity tb_multiplier_5_5;

architecture test of tb_multiplier_5_5 is
  -- Signals
  signal end_simulation : boolean := false;

  signal test_clk : std_logic := '0';

  signal
    a, b : signed(4 downto 0);

  signal z : signed(9 downto 0);

  -- Components
  component multiplier_5_5 is
    port (
      a : in signed(4 downto 0);
      b : in signed(4 downto 0);
      z : out signed(9 downto 0) );
  end component;

  -- Constants
  constant clock_period : time := 10 ns;
begin

  DUT: multiplier_5_5 port map (
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
    b <= (others => '0');
    wait until rising_edge(test_clk);

    a <= to_signed(-11, a'length);
    b <= to_signed(4, b'length);
    wait until rising_edge(test_clk);

    a <= to_signed(14, a'length);
    b <= to_signed(-3, b'length);
    wait until rising_edge(test_clk);

    a <= to_signed(-11, a'length);
    b <= to_signed(-12, b'length);
    wait until rising_edge(test_clk);

    a <= (others => '0');
    b <= (others => '0');
    wait until rising_edge(test_clk);
    end_simulation <= true;
    wait;
  end process test_sequence;
end test;
