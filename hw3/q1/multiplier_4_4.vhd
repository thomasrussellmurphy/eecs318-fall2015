-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- 4x4 unsigned multiplier with a big grid of blocks

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity multiplier_4_4 is
  port (
    x : in std_logic_vector(3 downto 0);
    y : in std_logic_vector(3 downto 0);
    p : out std_logic_vector(7 downto 0) );

end multiplier_4_4;

architecture RTL of multiplier_4_4 is
  signal
    sums_0, carries_0,
    sums_1, carries_1,
    sums_2, carries_2,
    sums_3, carries_3,
    final_carry, final_sum : std_logic_vector(3 downto 0);

  component unit_multiplier is
    port (
      a : in std_logic;
      b : in std_logic;
      si : in std_logic;
      ci : in std_logic;
      co : out std_logic;
      so : out std_logic );
  end component;

  component full_adder is
  port (
    a : in std_logic;
    b : in std_logic;
    ci : in std_logic;
    co : out std_logic;
    s : out std_logic );
  end component;
begin

  mult_row0: for y_index in 0 to 3 generate
    mult: unit_multiplier port map (
      a => x(0),
      b => y(y_index),
      si => '0',
      ci => '0',
      co => carries_0(y_index),
      so => sums_0(y_index) );
  end generate mult_row0;

  mult_row1: for y_index in 0 to 3 generate
    lsbs: if y_index < 3 generate
      mult: unit_multiplier port map (
        a => x(1),
        b => y(y_index),
        si => sums_0(y_index + 1),
        ci => carries_0(y_index),
        co => carries_1(y_index),
        so => sums_1(y_index) );
      end generate lsbs;

    msb: if y_index = 3 generate
      mult: unit_multiplier port map (
        a => x(1),
        b => y(y_index),
        si => '0',
        ci => carries_0(y_index),
        co => carries_1(y_index),
        so => sums_1(y_index) );
    end generate msb;
  end generate mult_row1;

  mult_row2: for y_index in 0 to 3 generate
    lsbs: if y_index < 3 generate
      mult: unit_multiplier port map (
        a => x(2),
        b => y(y_index),
        si => sums_1(y_index + 1),
        ci => carries_1(y_index),
        co => carries_2(y_index),
        so => sums_2(y_index) );
      end generate lsbs;

    msb: if y_index = 3 generate
      mult: unit_multiplier port map (
        a => x(2),
        b => y(y_index),
        si => '0',
        ci => carries_1(y_index),
        co => carries_2(y_index),
        so => sums_2(y_index) );
    end generate msb;
  end generate mult_row2;

  mult_row3: for y_index in 0 to 3 generate
    lsbs: if y_index < 3 generate
      mult: unit_multiplier port map (
        a => x(3),
        b => y(y_index),
        si => sums_2(y_index + 1),
        ci => carries_2(y_index),
        co => carries_3(y_index),
        so => sums_3(y_index) );
      end generate lsbs;

    msb: if y_index = 3 generate
      mult: unit_multiplier port map (
        a => x(3),
        b => y(y_index),
        si => '0',
        ci => carries_2(y_index),
        co => carries_3(y_index),
        so => sums_3(y_index) );
    end generate msb;
  end generate mult_row3;

  sum_row: for y_index in 0 to 3 generate
    lsb: if y_index < 3 generate
      add: full_adder port map (
        a => sums_3(y_index + 1),
        b => carries_3(y_index),
        ci => '0',
        co => final_carry(y_index),
        s => final_sum(y_index) );
      end generate lsb;

    mid: if y_index > 0 and y_index < 3 generate
      add: full_adder port map (
        a => sums_3(y_index + 1),
        b => carries_3(y_index),
        ci => final_carry(y_index - 1),
        co => final_carry(y_index),
        s => final_sum(y_index) );
    end generate mid;

    msb: if y_index = 3 generate
      add: full_adder port map (
        a => '0',
        b => carries_3(y_index),
        ci => final_carry(y_index - 1),
        co => final_carry(y_index),
        s => final_sum(y_index) );
    end generate msb;
  end generate sum_row;

  p <= final_sum & sums_3(0) & sums_2(0) & sums_1(0) & sums_0(0);

end RTL;
