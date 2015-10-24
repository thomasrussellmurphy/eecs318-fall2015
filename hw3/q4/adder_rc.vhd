-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Generic width ripple-carry adder

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder_rc is
  generic (
    width : natural := 8
   );
  port (
    a : in std_logic_vector(width-1 downto 0);
    b : in std_logic_vector(width-1 downto 0);
    s : out std_logic_vector(width downto 0) );

end adder_rc;

architecture RTL of adder_rc is
  signal ci : std_logic_vector(width-1 downto 0);
  signal co : std_logic_vector(width-1 downto 0);
  signal s_partial : std_logic_vector(width-1 downto 0);

  component adder is
    port (
      a : in std_logic;
      b : in std_logic;
      ci : in std_logic;
      co : out std_logic;
      s : out std_logic
    );
  end component;
begin

  -- Generate the 'width' adders with connections
  adders: for i in width-1 downto 0 generate
    adder_i : adder port map
    (
      a => a(i),
      b => b(i),
      ci => ci(i),
      co => co(i),
      s => s_partial(i)
    );
  end generate adders;

  -- Pass information between adders and produce result
  ci <= co(width-2 downto 0) & '0';
  s <= co(width-1) & s_partial;

end RTL;
