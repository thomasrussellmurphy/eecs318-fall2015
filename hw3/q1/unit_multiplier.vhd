-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Single-element multiplier

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity unit_multiplier is
  port (
    a : in std_logic;
    b : in std_logic;
    si : in std_logic;
    ci : in std_logic;
    co : out std_logic;
    so : out std_logic );

end unit_multiplier;

architecture RTL of unit_multiplier is
  signal product : std_logic;

  component full_adder is
  port (
    a : in std_logic;
    b : in std_logic;
    ci : in std_logic;
    co : out std_logic;
    s : out std_logic );
  end component;
begin
  product <= a and b;

  adder: full_adder port map (
    a => product,
    b => si,
    ci => ci,
    co => co,
    s => so );

end RTL;
