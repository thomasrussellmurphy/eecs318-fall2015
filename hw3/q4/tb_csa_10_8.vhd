-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Carry-Save Adder for ten 8-bit inputs
-- Maximum output value is about 11.3 bits, requiring 12 bit output width

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_csa_10_8 is
end entity tb_csa_10_8;

architecture test of tb_csa_10_8 is
  -- Signals
  signal end_simulation : boolean := false;

  signal test_clk : std_logic := '0';

  signal
    a, b, c, d, e,
    f, g, h, i, j : std_logic_vector(7 downto 0);

  signal z : std_logic_vector(11 downto 0);

  -- Components
  component csa_10_8 is
    port (
    a : in std_logic_vector(7 downto 0);
    b : in std_logic_vector(7 downto 0);
    c : in std_logic_vector(7 downto 0);
    d : in std_logic_vector(7 downto 0);
    e : in std_logic_vector(7 downto 0);
    f : in std_logic_vector(7 downto 0);
    g : in std_logic_vector(7 downto 0);
    h : in std_logic_vector(7 downto 0);
    i : in std_logic_vector(7 downto 0);
    j : in std_logic_vector(7 downto 0);
    z : out std_logic_vector(11 downto 0) );
  end component;

  -- Constants
  constant clock_period : time := 10 ns;
begin

  DUT: csa_10_8 port map (
    a => a,
    b => b,
    c => c,
    d => d,
    e => e,
    f => f,
    g => g,
    h => h,
    i => i,
    j => j,
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
    -- Setup input zeros
    a <= CONV_STD_LOGIC_VECTOR(0, 8);
    b <= CONV_STD_LOGIC_VECTOR(0, 8);
    c <= CONV_STD_LOGIC_VECTOR(0, 8);
    d <= CONV_STD_LOGIC_VECTOR(0, 8);
    e <= CONV_STD_LOGIC_VECTOR(0, 8);
    f <= CONV_STD_LOGIC_VECTOR(0, 8);
    g <= CONV_STD_LOGIC_VECTOR(0, 8);
    h <= CONV_STD_LOGIC_VECTOR(0, 8);
    i <= CONV_STD_LOGIC_VECTOR(0, 8);
    j <= CONV_STD_LOGIC_VECTOR(0, 8);

    wait for 2 * clock_period;

    -- Test sequence 1: 11, 2, 13, 4, 5, 6, 7, 8, 9, 10
    a <= CONV_STD_LOGIC_VECTOR(11, 8);
    b <= CONV_STD_LOGIC_VECTOR(2, 8);
    c <= CONV_STD_LOGIC_VECTOR(13, 8);
    d <= CONV_STD_LOGIC_VECTOR(4, 8);
    e <= CONV_STD_LOGIC_VECTOR(5, 8);
    f <= CONV_STD_LOGIC_VECTOR(6, 8);
    g <= CONV_STD_LOGIC_VECTOR(7, 8);
    h <= CONV_STD_LOGIC_VECTOR(8, 8);
    i <= CONV_STD_LOGIC_VECTOR(9, 8);
    j <= CONV_STD_LOGIC_VECTOR(10, 8);

    wait for 2 * clock_period;

    -- Test sequence 2: 3, 14, 5, 6, 7, 8, 19, 10
    a <= CONV_STD_LOGIC_VECTOR(3, 8);
    b <= CONV_STD_LOGIC_VECTOR(14, 8);
    c <= CONV_STD_LOGIC_VECTOR(5, 8);
    d <= CONV_STD_LOGIC_VECTOR(6, 8);
    e <= CONV_STD_LOGIC_VECTOR(7, 8);
    f <= CONV_STD_LOGIC_VECTOR(8, 8);
    g <= CONV_STD_LOGIC_VECTOR(19, 8);
    h <= CONV_STD_LOGIC_VECTOR(10, 8);
    i <= CONV_STD_LOGIC_VECTOR(0, 8);
    j <= CONV_STD_LOGIC_VECTOR(0, 8);

    wait for 2 * clock_period;

    end_simulation <= true;
    wait;
  end process test_sequence;

end architecture test;
