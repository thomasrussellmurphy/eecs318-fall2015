-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Signed 4 into 4 bit divider: computes a / b

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;

entity divider_4_4 is
  port (
    a : in signed(3 downto 0);
    b : in signed(3 downto 0);
    z : out signed(3 downto 0) );
end entity divider_4_4;

architecture RTL of divider_4_4 is
begin

  division: process(a, b) is
    variable
      p, p_p, d : signed(7 downto 0) := (others => '0');
    variable q : signed(3 downto 0) := (others => '0');
  begin
    -- p ~ A; d ~ Q; b ~ M;

    p := resize(a, p'length);
    d := resize(b, d'length);

    for i in 3 downto 0 loop
      p := shift_left(p, 1);
      d := shift_left(d, 1);

      -- Retain previous
      p_p := p;

      if p(7) = b(3) then
        -- Same sign
        p := p - b;
      else
        -- Different sign
        p := p + b;
      end if;

      if (p(7) = p_p(7)) or (p = 0) then
        -- Success
        d(0) := '1';
      else
        -- Failure, with restore
        d(0) := '0';
        p := p_p;
      end if;
    end loop;

    q := d(7) & d(2 downto 0);
    -- Check sign for final output
    if a(3) = b(3) then
      z <= q;
    else
      z <= - q;
    end if;
  end process division;

end RTL;
