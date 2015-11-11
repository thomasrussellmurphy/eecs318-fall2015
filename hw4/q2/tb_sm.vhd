-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Testbench for both state machine implementations

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;

entity tb_sm is
end entity tb_sm;

architecture test of tb_sm is
  -- Signals
  signal end_simulation : boolean := false;

  signal test_clk : std_logic := '0';

  signal x : std_logic;

  signal
    z1_A, z2_A, z1_B, z2_B : std_logic;

  -- Components
  component behavioral_sm is
    port (
      clk : in std_logic;
      x : in std_logic;
      z1 : out std_logic;
      z2 : out std_logic );
  end component;

  component structural_sm is
    port (
      clk : in std_logic;
      x : in std_logic;
      z1 : out std_logic;
      z2 : out std_logic );
  end component;

  -- Constants
  constant clock_period : time := 10 ns;
begin

  DUT_A : behavioral_sm port map (
    clk => test_clk,
    x => x,
    z1 => z1_A,
    z2 => z2_A );

  DUT_B : behavioral_sm port map (
    clk => test_clk,
    x => x,
    z1 => z1_B,
    z2 => z2_B );

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

    x <= '0';

    wait until rising_edge(test_clk);

    wait for 5 * clock_period;

    x <= '1';
    wait for 3 * clock_period;

    x <= '0';
    wait for 2 * clock_period;

    wait until rising_edge(test_clk);

    end_simulation <= true;
    wait;
  end process test_sequence;

end test;
