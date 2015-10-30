-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Carry-Save Adder for ten 8-bit inputs
-- Maximum output value is about 11.3 bits, requiring 12 bit output width

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_traffic_light_sm is
end entity tb_traffic_light_sm;

architecture test of tb_traffic_light_sm is
  -- Signals
  signal end_simulation : boolean := false;

  signal test_clk : std_logic := '0';

  signal s_a, s_b : std_logic;

  signal
    g_a, y_a, r_a,
    g_b, y_b, r_b : std_logic;

  -- Components
  component traffic_light_sm is
  port (
    clk : in std_logic;
    s_a : in std_logic;
    s_b : in std_logic;
    g_a : out std_logic;
    y_a : out std_logic;
    r_a : out std_logic;
    g_b : out std_logic;
    y_b : out std_logic;
    r_b : out std_logic );
  end component;

  -- Constants
  constant clock_period : time := 10 sec;
begin

  DUT: traffic_light_sm port map (
    clk => test_clk,
    s_a => s_a,
    s_b => s_b,
    g_a => g_a,
    y_a => y_a,
    r_a => r_a,
    g_b => g_b,
    y_b => y_b,
    r_b => r_b );

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
    s_a <= '0';
    s_b <= '0';

    wait for 20 * clock_period;

    s_b <= '1';

    wait for 7 * clock_period;

    s_a <= '1';

    wait for clock_period;

    s_b <= '0';

    wait for 8 * clock_period;

    end_simulation <= true;
    wait;
  end process test_sequence;

end architecture test;
