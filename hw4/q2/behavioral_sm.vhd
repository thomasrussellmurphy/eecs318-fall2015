-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Behavioral implementation of this state machine

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;

library work;
  use work.STD_LOGIC_COMPONENTS.ALL;

entity behavioral_sm is
  port (
    clk : in std_logic;
    x : in std_logic;
    z1 : out std_logic;
    z2 : out std_logic );
end entity behavioral_sm;

architecture RTL of behavioral_sm is
  -- Signals
  signal
    j1, k1, j2, k2 : std_logic;

  signal
    y1, y1n, y2, y2n : std_logic;

  -- Components
  component jkff is
    port(
      clk : in std_logic;
      j, k : in std_logic;
      q, qn : out std_logic );
  end component;
begin

  j1 <= x;
  k1 <= (y2n and not x) nor (x and y2);

  j2 <= y1n;
  k2 <= y1 or x;

  ff1 : jkff port map (
    clk => clk,
    j => j1,
    k => k1,
    q => y1,
    qn => y1n );

  ff2 : jkff port map (
    clk => clk,
    j => j2,
    k => k2,
    q => y2,
    qn => y2n );

  z1 <= y2 and y1;
  z2 <= (y1 and y1n) or not x;

end RTL;
