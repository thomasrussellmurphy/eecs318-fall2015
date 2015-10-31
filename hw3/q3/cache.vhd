-- Thomas Russell Murphy (trm70)
-- EECS 318 Fall 2015
-- Implementation of an overly-simple processor cache

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cache is
  port (
    -- Processor interface
    p_strobe : in std_logic;
    p_address : in std_logic_vector(15 downto 0);
    p_ready : out std_logic;
    p_rw : in std_logic;
    p_data : inout std_logic_vector(31 downto 0);

    -- System bus interface
    sys_address : out std_logic_vector(15 downto 0);
    sys_data : inout std_logic_vector(7 downto 0);
    sys_strobe : out std_logic;
    sys_rw : out std_logic );

end cache;

architecture RTL of cache is
  type cache_ram_t is array(7 downto 0) of std_logic_vector(31 downto 0);
  type tag_ram_t is array(7 downto 0) of std_logic_vector(4 downto 0);

  signal cache_ram : cache_ram_t := (others => (others => '0'));
  signal tag_ram : tag_ram_t := (others => (others => '0'));
begin

end RTL;
