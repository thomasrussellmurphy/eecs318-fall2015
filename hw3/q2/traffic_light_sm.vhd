-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Traffic light state machine

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity traffic_light_sm is
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

end traffic_light_sm;

architecture RTL of traffic_light_sm is
  -- State definition
  -- Active A direction
  constant s0 : natural := 0;
  constant s1 : natural := 1;
  constant s2 : natural := 2;
  constant s3 : natural := 3;
  constant s4 : natural := 4;
  constant s5 : natural := 5;
  -- Transition state to B
  constant s6 : natural := 6;
  -- Active B direction
  constant s7 : natural := 7;
  constant s8 : natural := 8;
  constant s9 : natural := 9;
  constant s10 : natural := 10;
  constant s11 : natural := 11;
  -- Transition state to B
  constant s12 : natural := 12;

  -- State variable
  signal state : natural := 0;
begin

  -- State transition management
  next_state: process(clk)
  begin
    if rising_edge(clk) then
      -- Process the state transitions here
      case state is
        when s0 =>
          state <= s1;
        when s1 =>
          state <= s2;
        when s2 =>
          state <= s3;
        when s3 =>
          state <= s4;
        when s4 =>
          state <= s5;
        when s5 =>
          if s_b = '0' then
            -- Maintain active A direction
            state <= s5;
          else
            state <= s6;
          end if;
        when s6 =>
          state <= s7;
        when s7 =>
          state <= s8;
        when s8 =>
          state <= s9;
        when s9 =>
          state <= s10;
        when s10 =>
          state <= s11;
        when s11 =>
          if s_a = '0' and s_b = '1' then
            -- Maintain active B direction
            state <= s11;
          else
            state <= s12;
          end if;
        when s12 =>
          state <= s0;
        when others =>
          state <= s0;
      end case;
    end if;
  end process next_state;

  -- Output value management
  output_g_a: process(state)
  begin
    case state is
      when s0 =>
        g_a <= '1';
      when s1 =>
        g_a <= '1';
      when s2 =>
        g_a <= '1';
      when s3 =>
        g_a <= '1';
      when s4 =>
        g_a <= '1';
      when s5 =>
        g_a <= '1';
      when others =>
        g_a <= '0';
    end case;
  end process output_g_a;

  output_y_a: process(state)
  begin
    case state is
      when s6 =>
        y_a <= '1';
      when others =>
        y_a <= '0';
    end case;
  end process output_y_a;

  output_r_a: process(state)
  begin
    case state is
      when s7 =>
        r_a <= '1';
      when s8 =>
        r_a <= '1';
      when s9 =>
        r_a <= '1';
      when s10 =>
        r_a <= '1';
      when s11 =>
        r_a <= '1';
      when s12 =>
        r_a <= '1';
      when others =>
        r_a <= '0';
    end case;
  end process output_r_a;

  output_g_b: process(state)
  begin
    case state is
      when s7 =>
        g_b <= '1';
      when s8 =>
        g_b <= '1';
      when s9 =>
        g_b <= '1';
      when s10 =>
        g_b <= '1';
      when s11 =>
        g_b <= '1';
      when others =>
        g_b <= '0';
    end case;
  end process output_g_b;

  output_y_b: process(state)
  begin
    case state is
      when s12 =>
        y_b <= '1';
      when others =>
        y_b <= '0';
    end case;
  end process output_y_b;

  output_r_b: process(state)
  begin
    case state is
      when s0 =>
        r_b <= '1';
      when s1 =>
        r_b <= '1';
      when s2 =>
        r_b <= '1';
      when s3 =>
        r_b <= '1';
      when s4 =>
        r_b <= '1';
      when s5 =>
        r_b <= '1';
      when s6 =>
        r_b <= '1';
      when others =>
        r_b <= '0';
    end case;
  end process output_r_b;

end RTL;
