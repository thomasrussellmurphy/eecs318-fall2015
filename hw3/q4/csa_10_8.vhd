-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Generic width ripple-carry adder

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity csa_10_8 is
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

end csa_10_8;

architecture RTL of csa_10_8 is
  -- Signals

  -- For Layer 1
  signal
    s_abc, c_abc,
    s_def, c_def,
    s_ghi, c_ghi : std_logic_vector(7 downto 0);

  -- For Layer 2
  signal
    s_abc_w, c_abc_w,
    s_def_w, c_def_w,
    s_ghi_w, c_ghi_w,
    s_csa2_a, c_csa2_a,
    s_csa2_b, c_csa2_b : std_logic_vector(8 downto 0);

  -- Components
  component csa is
    port (
      x : in std_logic;
      y : in std_logic;
      z : in std_logic;
      c : out std_logic;
      s : out std_logic );

  end component;

  component adder_rc is
    generic (
      width : natural := 8 );
    port (
      a : in std_logic_vector(width-1 downto 0);
      b : in std_logic_vector(width-1 downto 0);
      s : out std_logic_vector(width downto 0) );
  end component;
begin
  -- Layer 1: consumes a, b, c, d, e, f, g, h, i
  -- Widths are all 8

  layer_1: for index in 0 to 7 generate
    csa_abc: csa port map (
      x => a(index),
      y => b(index),
      z => a(index),
      c => c_abc(index),
      s => s_abc(index) );

    csa_def: csa port map (
      x => d(index),
      y => e(index),
      z => f(index),
      c => c_def(index),
      s => s_def(index) );

    csa_ghi: csa port map (
      x => g(index),
      y => h(index),
      z => i(index),
      c => c_ghi(index),
      s => s_ghi(index) );
  end generate layer_1;

  -- Layer 2: consumes s_abc, c_abc, s_def, c_def, s_ghi, c_ghi
  -- Widths are all 9 due to shifted carries

  s_abc_w <= '0' & s_abc;
  c_abc_w <= c_abc & '0';
  s_def_w <= '0' & s_def;
  c_def_w <= c_def & '0';
  s_ghi_w <= '0' & s_ghi;
  c_ghi_w <= c_ghi & '0';

  layer_2: for index in 0 to 8 generate
    csa2_a: csa port map (
      x => s_abc_w(index),
      y => c_abc_w(index),
      z => s_def_w(index),
      c => c_csa2_a(index),
      s => s_csa2_a(index) );

    csa2_b: csa port map (
      x => c_def_w(index),
      y => s_ghi_w(index),
      z => c_ghi_w(index),
      c => c_csa2_b(index),
      s => s_csa2_b(index) );
    end generate layer_2;

  -- Layer 3: consumes s_csa2_A, c_csa2_A, s_csa2_B, c_csa2_B, j
  -- Widths are now 10

  -- Layer 4: consumes s_csa3_A, c_csa3_A, s_csa3_B
  -- Widths are now 11

  -- Layer 5: consumes s_csa4, c_csa4, c_csa3_B
  -- Widths are now 12

  -- Final adder
  -- Widths are now 13
end RTL;
