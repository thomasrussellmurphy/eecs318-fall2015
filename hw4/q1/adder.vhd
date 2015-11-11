-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Implementation of specified fancy adder

-- add   : 000     signed addition      (A+B -> C)
-- addu  : 001	   unsigned addition    (A+B -> C)
-- sub   : 010     signed subtraction   (A-B -> C)
-- subu  : 011     unsigned subtraction (A-B -> C)
-- inc   : 100     signed increment     (A+1 -> C)
-- dec   : 101     signed decrement     (A-1 -> C)

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;

entity adder is
  port (
    A : in std_logic_vector(15 downto 0);
    B : in std_logic_vector(15 downto 0);
    CODE : in std_logic_vector(2 downto 0);
    cin : in std_logic;
    coe : in std_logic;
    C : out std_logic_vector(15 downto 0);
    vout : out std_logic;
    cout : out std_logic );
end adder;

architecture RTL of adder is
  signal wide_cin : std_logic_vector(1 downto 0);
  signal result_s : signed(16 downto 0);
  signal result_u : unsigned(16 downto 0);
begin

  wide_cin <= '0' & cin;

  math: process(A, B, CODE, wide_cin) is
  begin
    case CODE is
      when "000" =>
        result_s <= resize(signed(A), result_s'length) +
          resize(signed(B), result_s'length) +
          resize(signed(wide_cin), result_s'length);
      when "001" =>
        result_u <= resize(unsigned(A), result_u'length) +
          resize(unsigned(B), result_u'length) +
          resize(unsigned(wide_cin), result_s'length);
      when "010" =>
        result_s <= resize(signed(A), result_s'length) -
          resize(signed(B), result_s'length);
      when "011" =>
        result_u <= resize(unsigned(A), result_u'length) -
          resize(unsigned(B), result_u'length);
      when "100" =>
        result_s <= resize(signed(A), result_s'length) + 1;
      when "101" =>
        result_s <= resize(signed(A), result_s'length) - 1;
      when others =>
        result_s <= to_signed(0, result_s'length);
        result_u <= to_unsigned(0, result_u'length);
    end case;
  end process math;

  outputs: process(CODE, result_s, result_u, coe) is
  begin
    case CODE is
      when "000" =>
        C <= std_logic_vector(result_s(15 downto 0));
        vout <= (A(15) and B(15) and not result_s(15)) or
          (not A(15) and not B(15) and result_s(15));
        cout <= (not coe) and result_s(16);
      when "001" =>
        C <= std_logic_vector(result_u(15 downto 0));
        -- Unsigned op: no overflow
        vout <= '0';
        cout <= (not coe) and result_u(16);
      when "010" =>
        C <= std_logic_vector(result_s(15 downto 0));
        vout <= (A(15) and B(15) and not result_s(15)) or
          (not A(15) and not B(15) and result_s(15));
        cout <= (not coe) and result_s(16);
      when "011" =>
        C <= std_logic_vector(result_u(15 downto 0));
        -- Unsigned op: no overflow
        vout <= '0';
        cout <= (not coe) and result_u(16);
      when "100" =>
        C <= std_logic_vector(result_s(15 downto 0));
        vout <= (A(15) and B(15) and not result_s(15)) or
          (not A(15) and not B(15) and result_s(15));
        cout <= (not coe) and result_s(16);
      when "101" =>
        C <= std_logic_vector(result_s(15 downto 0));
        vout <= (A(15) and B(15) and not result_s(15)) or
          (not A(15) and not B(15) and result_s(15));
        cout <= (not coe) and result_s(16);
      when others =>
    end case;
  end process outputs;

end RTL;
