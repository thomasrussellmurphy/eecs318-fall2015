-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Testbench for multifunction adder

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;

entity tb_adder is
end entity tb_adder;

architecture test of tb_adder is
  -- Signals
  signal end_simulation : boolean := false;

  signal test_clk : std_logic := '0';

  signal
    A, B, C : std_logic_vector(15 downto 0);

  signal CODE : std_logic_vector(2 downto 0);

  signal
    cin, coe, vout, cout : std_logic;

  -- Components
  component adder is
    port (
      A : in std_logic_vector(15 downto 0);
      B : in std_logic_vector(15 downto 0);
      CODE : in std_logic_vector(2 downto 0);
      cin : in std_logic;
      coe : in std_logic;
      C : out std_logic_vector(15 downto 0);
      vout : out std_logic;
      cout : out std_logic );
  end component;

  -- Constants
  constant clock_period : time := 10 ns;
begin

  DUT: adder port map(
    A => A,
    B => B,
    CODE => CODE,
    cin => cin,
    coe => coe,
    C => C,
    vout => vout,
    cout => cout );

  clk_gen: process
  begin
    if not end_simulation then
      test_clk <= '0';
      wait for clock_period / 2;
      test_clk <= '1';
      wait for clock_period / 2;
    else
      wait;
    end if;
  end process clk_gen;

  test_sequence: process
    -- A simple procedure to have one-line changes of DUT inputs
    procedure set_inputs (
      A_value, B_value : in std_logic_vector(15 downto 0);
      CODE_value : in std_logic_vector(2 downto 0);
      cin_value, coe_value : in std_logic ) is
    begin
      A <= A_value;
      B <= B_value;
      CODE <= code_value;
      cin <= cin_value;
      coe <= coe_value;
      wait for 0 ns;
    end set_inputs;
  begin

    -- Initial state, all zeros
    set_inputs(x"0000", x"0000", "000", '0', '0');
    wait until rising_edge(test_clk);

    -- Operations with signed addition, code "000"
    set_inputs(x"0000", x"0001", "000", '0', '0');
    wait until rising_edge(test_clk);

    set_inputs(x"000F", x"000F", "000", '1', '0');
    wait until rising_edge(test_clk);

    set_inputs(x"7F00", x"0300", "000", '0', '0');
    wait until rising_edge(test_clk);

    set_inputs(x"FF00", x"0100", "000", '1', '0');
    wait until rising_edge(test_clk);

    set_inputs(x"8100", x"8000", "000", '1', '1');
    wait until rising_edge(test_clk);

    -- Operations with unsigned addition, code "001"
    -- Operations with signed subtraction
    -- Operations with unsigned subtraction
    -- Operations with signed increment
    -- Operations with signed decrement

    wait until rising_edge(test_clk);

    end_simulation <= true;
    wait;
  end process test_sequence;

end architecture test;
