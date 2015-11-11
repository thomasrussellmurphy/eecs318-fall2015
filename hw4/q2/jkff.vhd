-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- A J-K flip-flop for use in the structural state machine

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;

entity jkff is
  port(
    clk : in std_logic;
    j, k : in std_logic;
    q, qn : out std_logic );
end entity jkff;

architecture RTL of jkff is
  -- Signals
  signal state : std_logic := '0';
  signal inputs : std_logic_vector(1 downto 0);
begin

  q <= state;
  qn <= not state;

  inputs <= j & k;

  next_state: process(clk)
  begin
    if rising_edge(clk) then
      case inputs is
        when "00" =>
          -- Idle
          state <= state;
        when "01" =>
          -- Reset
          state <= '0';
        when "11" =>
          -- Flop
          state <= not state;
        when "10" =>
          -- Set
          state <= '1';
        when others =>
          state <= '0';
      end case;
    end if;
  end process next_state;

end RTL;
