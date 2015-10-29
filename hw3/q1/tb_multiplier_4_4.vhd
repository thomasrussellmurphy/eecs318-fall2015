-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Testbench for 4x4 multiplier implementation

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_multiplier_4_4 is
end entity tb_multiplier_4_4;

architecture test of tb_multiplier_4_4 is
  -- Signals
  signal end_simulation : boolean := false;

  signal test_clk : std_logic := '0';

  signal
    x, y : std_logic_vector(3 downto 0);

  signal p : std_logic_vector(7 downto 0);

  -- Components
  component multiplier_4_4 is
    port (
      x : in std_logic_vector(3 downto 0);
      y : in std_logic_vector(3 downto 0);
      p : out std_logic_vector(7 downto 0) );
  end component;

  -- Constants
  constant clock_period : time := 10 ns;
begin

  DUT: multiplier_4_4 port map (
    x => x,
    y => y,
    p => p );

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
    -- Setup input zeros
    x <= CONV_STD_LOGIC_VECTOR(0, 4);
    y <= CONV_STD_LOGIC_VECTOR(0, 4);

    wait until rising_edge(test_clk);

    -- Test sequence 1: 4*4
    x <= CONV_STD_LOGIC_VECTOR(4, 4);
    y <= CONV_STD_LOGIC_VECTOR(4, 4);

    wait until rising_edge(test_clk);

    -- Test sequence 2: 5*12
    x <= CONV_STD_LOGIC_VECTOR(5, 4);
    y <= CONV_STD_LOGIC_VECTOR(12, 4);

    wait until rising_edge(test_clk);

    end_simulation <= true;
    wait;
  end process test_sequence;

end architecture test;
