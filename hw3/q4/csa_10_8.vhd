-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Carry-Save Adder for ten 8-bit inputs
-- Maximum output value is about 11.3 bits, requiring 12 bit output width

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

  -- For Layer 3
  signal
    s_csa2_a_w, c_csa2_a_w,
    s_csa2_b_w, c_csa2_b_w,
    j_w,
    s_csa3_a, c_csa3_a,
    s_csa3_b, c_csa3_b : std_logic_vector(9 downto 0);

  -- For Layer 4
  signal
    s_csa3_a_w, c_csa3_a_w,
    s_csa3_b_w,
    s_csa4, c_csa4 : std_logic_vector(10 downto 0);

  -- For Layer 5
  signal
    c_csa3_b_w,
    s_csa4_w, c_csa4_w,
    s_csa5, c_csa5 : std_logic_vector(11 downto 0);

  -- For Final Adder
  signal s_csa5_w, c_csa5_w : std_logic_vector(12 downto 0);
  signal wide_result : std_logic_vector(13 downto 0);

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

  s_csa2_a_w <= '0' & s_csa2_a;
  c_csa2_a_w <= c_csa2_a & '0';
  s_csa2_b_w <= '0' & s_csa2_b;
  c_csa2_b_w <= c_csa2_b & '0';
  j_w <= B"00" & j;

  layer_3: for index in 0 to 9 generate
    csa3_a: csa port map (
      x => s_csa2_a_w(index),
      y => c_csa2_a_w(index),
      z => s_csa2_b_w(index),
      c => c_csa3_a(index),
      s => s_csa3_a(index) );

    csa3_b: csa port map (
      x => c_csa2_b_w(index),
      y => j_w(index),
      z => '0',
      c => c_csa3_b(index),
      s => s_csa3_b(index) );
  end generate layer_3;

  -- Layer 4: consumes s_csa3_A, c_csa3_A, s_csa3_B
  -- Widths are now 11

  s_csa3_a_w <= '0' & s_csa3_a;
  c_csa3_a_w <= c_csa3_a & '0';
  s_csa3_b_w <= '0' & s_csa3_b;

  layer_4: for index in 0 to 10 generate
    csa4: csa port map (
      x => s_csa3_a_w(index),
      y => c_csa3_a_w(index),
      z => s_csa3_b_w(index),
      c => c_csa4(index),
      s => s_csa4(index) );
  end generate layer_4;

  -- Layer 5: consumes s_csa4, c_csa4, c_csa3_B
  -- Widths are now 12

  c_csa3_b_w <= '0' & c_csa3_b & '0';
  s_csa4_w <= '0' & s_csa4;
  c_csa4_w <= c_csa4 & '0';

  layer_5: for index in 0 to 11 generate
    csa5: csa port map (
      x => c_csa3_b_w(index),
      y => s_csa4_w(index),
      z => c_csa4_w(index),
      c => c_csa5(index),
      s => s_csa5(index) );
  end generate layer_5;

  -- Final adder
  -- Widths are now 13

  s_csa5_w <= '0' & s_csa5;
  c_csa5_w <= c_csa5 & '0';

  final_adder: adder_rc generic map (
      width => 13 )
    port map (
      a => s_csa5_w,
      b => c_csa5_w,
      s => wide_result );

  z <= wide_result(11 downto 0);
end RTL;
