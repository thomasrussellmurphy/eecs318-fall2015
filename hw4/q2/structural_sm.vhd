-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Structural implementation of this state machine

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;
  use IEEE.STD_LOGIC_MISC.ALL;

library work;
  use work.STD_LOGIC_COMPONENTS.ALL;

entity structural_sm is
  port (
    clk : in std_logic;
    x : in std_logic;
    z1 : out std_logic;
    z2 : out std_logic );
end entity structural_sm;

architecture RTL of structural_sm is
  -- Signals
  signal xn : std_logic;

  signal
    u1_in, u2_in, u3_in, u4_in, u5_in, u6_in, u7_in : std_logic_vector(1 to 2);

  signal
    u1_out, u2_out, u3_out, u4_out, u5_out, u6_out, u7_out : std_logic;

  signal
    y1, y1n, y2, y2n : std_logic;

  -- Components
  component jkff is
    port(
      clk : in std_logic;
      j, k : in std_logic;
      q, qn : out std_logic );
  end component;

      component ANDGATE				-- N input AND gate
	generic (N:   Positive := 2;		-- number of inputs
		 tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC_VECTOR (1 to N);	-- input
	      Output: out STD_LOGIC);		-- output
    end component;

    component NANDGATE				-- N input NAND gate
	generic (N:   Positive := 2;		-- number of inputs
		 tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC_VECTOR (1 to N);	-- input
	      Output: out STD_LOGIC);		-- output
    end component;

    component ORGATE				-- N input OR gate
	generic (N:   Positive := 2;		-- number of inputs
		 tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC_VECTOR (1 to N);	-- input
	      Output: out STD_LOGIC);		-- output
    end component;

    component NORGATE				-- N input NOR gate
	generic (N:   Positive := 2;		-- number of inputs
		 tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC_VECTOR (1 to N);	-- input
	      Output: out STD_LOGIC);		-- output
    end component;

    component INVGATE				-- inverter
	generic (tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC;			-- input
	      Output: out STD_LOGIC);		-- output
    end component;
begin

  x_inv : INVGATE port map (
    Input => x,
    Output => xn );

  u1_in <= xn & y2n;
  U1 : ANDGATE port map (
    Input => u1_in,
    Output => u1_out );

  u2_in <= x & y2;
  U2 : NORGATE port map (
    Input => u2_in,
    Output => u2_out );

  u3_in <= u1_out & u2_out;
  U3 : ORGATE port map (
    Input => u3_in,
    Output => u3_out );

  u4_in <= y1 & x;
  U4 : ANDGATE port map (
    Input => u4_in,
    Output => u4_out );

  ff1 : jkff port map (
    clk => clk,
    j => x,
    k => u3_out,
    q => y1,
    qn => y1n );

  ff2 : jkff port map (
    clk => clk,
    j => y1n,
    k => u4_out,
    q => y2,
    qn => y2n );

  u5_in <= y1n & y1;
  U5 : ANDGATE port map (
    Input => u5_in,
    Output => u5_out );

  u6_in <= y1 & y2;
  U6 : ANDGATE port map (
    Input => u6_in,
    Output => u6_out );

  u7_in <= xn & u5_out;
  U7 : ORGATE port map (
    Input => u7_in,
    Output => u7_out );

  z1 <= u6_out;
  z2 <= u7_out;

end RTL;
