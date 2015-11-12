-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Signed 5x5 bit multiplier

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;

entity multiplier_5_5 is
  port (
    a : in signed(4 downto 0);
    b : in signed(4 downto 0);
    z : out signed(9 downto 0) );
end entity multiplier_5_5;

architecture RTL of multiplier_5_5 is
  -- Signals
  signal
    a_norm, b_norm : signed(4 downto 0);

  signal
    product0, product1, product2, product3, product4 : signed(4 downto 0);

  signal
    partial0, partial1, partial2, partial3, partial4 : signed(9 downto 0);
begin

  normalize_inputs: process(a, b) is
  begin
    if a(4) = '1' and b(4) = '1' then
      a_norm <= - a;
      b_norm <= - b;
    elsif b(4) = '1' then
      a_norm <= b;
      b_norm <= a;
    else
      a_norm <= a;
      b_norm <= b;
    end if;
  end process normalize_inputs;

  products: process(a_norm, b_norm) is
  begin
    if b_norm(0) = '1' then
      product0 <= a_norm;
    else
      product0 <= (others => '0');
    end if;

    if b_norm(1) = '1' then
      product1 <= a_norm;
    else
      product1 <= (others => '0');
    end if;

    if b_norm(2) = '1' then
      product2 <= a_norm;
    else
      product2 <= (others => '0');
    end if;

    if b_norm(3) = '1' then
      product3 <= a_norm;
    else
      product3 <= (others => '0');
    end if;

    if b_norm(4) = '1' then
      product4 <= a_norm;
    else
      product4 <= (others => '0');
    end if;
  end process products;

  prepare_partials: process(product0, product1, product2, product3, product4) is
    variable
      wide0, wide1, wide2, wide3, wide4 : signed(9 downto 0);
  begin
    wide0 := resize(product0, wide0'length);
    wide1 := resize(product1, wide1'length);
    wide2 := resize(product2, wide2'length);
    wide3 := resize(product3, wide3'length);
    wide4 := resize(product4, wide4'length);

    partial0 <= shift_left(wide0, 0);
    partial1 <= shift_left(wide1, 1);
    partial2 <= shift_left(wide2, 2);
    partial3 <= shift_left(wide3, 3);
    partial4 <= shift_left(wide4, 4);
  end process prepare_partials;

  sum: process(partial0, partial1, partial2, partial3, partial4) is
  begin
    z <= partial0 + partial1 + partial2 + partial3 + partial4;
  end process sum;

end RTL;
