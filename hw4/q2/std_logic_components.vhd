----------------------------------------------------------------------------
--
-- Copyright (c) 1990, 1991, 1992 by Synopsys, Inc.  All rights reserved.
--
-- This source file may be used and distributed without restriction
-- provided that this copyright statement is not removed from the file
-- and that any derivative work contains this copyright notice.
--
--	Package name: STD_LOGIC_STD_LOGIC_COMPONENTS
--
--	Purpose: A set of components for IEEE Standard Logic library.
--
--	Author: JT, PH, GWH
--
--	NOTE:
--	      The models (entity/architecture pairs) for these components
--	      are defined in the package IEEE.STD_LOGIC_ENTITIES
--
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;


package STD_LOGIC_COMPONENTS is
--synopsys translate_off

    ------------------------------------------------------------------------
    --
    -- Logic gates for n inputs
    --
    ------------------------------------------------------------------------

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

    component XORGATE				-- N input XOR gate
	generic (N:   Positive := 2;		-- number of inputs
		 tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC_VECTOR (1 to N);	-- input
	      Output: out STD_LOGIC);		-- output
    end component;

    component XNORGATE				-- N input XNOR gate
	generic (N:   Positive := 2;		-- number of inputs
		 tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC_VECTOR (1 to N);	-- input
	      Output: out STD_LOGIC);		-- output
    end component;

    component NXORGATE				-- N input NXOR gate
	generic (N:   Positive := 2;		-- number of inputs
		 tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC_VECTOR (1 to N);	-- input
	      Output: out STD_LOGIC);		-- output
    end component;

    --------------------------------------------------------------------------
    --
    -- Transfer gates
    --
    -------------------------------------------------------------------------
    component BUFGATE				-- buffer with INERTIAL delay
	generic (tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC;			-- input
	      Output: out STD_LOGIC);		-- output
    end component;

    component WBUFGATE				-- buffer with TRANSPORT delay
	generic (tLH: Time := 0 ns;		-- rise transport delay
		 tHL: Time := 0 ns;		-- fall transport delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC;			-- input
	      Output: out STD_LOGIC);		-- output
    end component;

    component INVGATE				-- inverter
	generic (tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC;			-- input
	      Output: out STD_LOGIC);		-- output
    end component;


    --------------------------------------------------------------------------
    --
    -- Tristate transfer gates
    --
    -------------------------------------------------------------------------
    component BUF3S				-- tristate buffer
	generic (tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC;			-- input
	      Enable: in STD_LOGIC;			-- enable
	      Output: out STD_LOGIC);		-- output
    end component;

    component BUF3SL				-- tristate buffer
	generic (tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC;			-- input
	      Enable: in STD_LOGIC;			-- enable
	      Output: out STD_LOGIC);		-- output
    end component;

    component INV3S				-- tristate inverter
	generic (tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC;			-- input
	      Enable: in STD_LOGIC;			-- enable
	      Output: out STD_LOGIC);		-- output
    end component;

    component INV3SL				-- tristate inverter
	generic (tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC;			-- input
	      Enable: in STD_LOGIC;			-- enable
	      Output: out STD_LOGIC);		-- output
    end component;

    --------------------------------------------------------------------------
    --
    -- Other logic components
    --
    --------------------------------------------------------------------------

    component MUX2x1				-- 2 by 1 multiplexer
	generic (tLH: Time :=  0 ns;		-- rise inertial delay
		 tHL: Time :=  0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (In0,				-- data input 0
	      In1,				-- data input 1
	      Sel: in STD_LOGIC;			-- select input (0=>In0)
	      Output: out STD_LOGIC);		-- output
    end component;


    -------------------------------------------------------------------------
    --
    -- State components
    --
    -------------------------------------------------------------------------

    component DFFREG		 -- edge triggered register, reset active high
	generic (N: Positive :=1;			-- N bit I/O
		 tLH: Time :=  0 ns;			-- rise inertial delay
		 tHL: Time :=  0 ns;			-- fall inertial delay
		 strn: STRENGTH := strn_X01;	-- output strength;
         tHOLD : Time := 0 ns; 			-- Hold time
         tSetUp : Time := 0 ns;			-- Setup time
         tPwHighMin : Time := 0 ns;     -- min pulse width when clock is high
         tPwLowMin : Time := 0 ns);     -- min pulse width when clock is low
	port (Data: in STD_LOGIC_VECTOR (N-1 downto 0);	-- data input
	      Clock,							-- clock input
	      Reset: in STD_LOGIC;				-- reset input(act.high)
	      Output: out STD_LOGIC_VECTOR (N-1 downto 0));	-- output
    end component;

    component DFFREGL		  -- edge triggered register, reset active low
	generic (N: Positive :=1;			-- N bit I/O
		 tLH: Time :=  0 ns;			-- rise inertial delay
		 tHL: Time :=  0 ns;			-- fall inertial delay
		 strn: STRENGTH := strn_X01;	-- output strength
         tHOLD : Time := 0 ns; 			-- Hold time
         tSetUp : Time := 0 ns;			-- Setup time
         tPwHighMin : Time := 0 ns;     -- min pulse width when clock is high
         tPwLowMin : Time := 0 ns);     -- min pulse width when clock is low
	port (Data: in STD_LOGIC_VECTOR (N-1 downto 0);	-- data input
	      Clock,					-- clock input
	      Reset: in STD_LOGIC;				-- reset input(act. low)
	      Output: out STD_LOGIC_VECTOR (N-1 downto 0));	-- output
    end component;

    component DLATREG		-- level sensitive register, reset active high
	generic (N: Positive :=1;			-- N bit I/O
		 tLH: Time :=  0 ns;			-- rise inertial delay
		 tHL: Time :=  0 ns;			-- fall inertial delay
		 strn: STRENGTH := strn_X01;	-- output strength
         tHOLD : Time := 0 ns; 			-- Hold time
         tSetUp : Time := 0 ns;			-- Setup time
         tPwHighMin : Time := 0 ns;     -- min pulse width when enable is high
         tPwLowMin : Time := 0 ns);     -- min pulse width when enable is low
	port (Data: in STD_LOGIC_VECTOR (N-1 downto 0);	-- data input
	      Enable,					-- enable input
	      Reset: in STD_LOGIC;				-- reset input(act.high)
	      Output: out STD_LOGIC_VECTOR (N-1 downto 0));	-- output
    end component;

    component DLATREGL	  -- level sensitive register, reset active low
	generic (N: Positive :=1;			-- N bit I/O
		 tLH: Time :=  0 ns;			-- rise inertial delay
		 tHL: Time :=  0 ns;			-- fall inertial delay
		 strn: STRENGTH := strn_X01;	-- output strength
         tHOLD : Time := 0 ns; 			-- Hold time
         tSetUp : Time := 0 ns;			-- Setup time
         tPwHighMin : Time := 0 ns;     -- min pulse width when enable is high
         tPwLowMin : Time := 0 ns);     -- min pulse width when enable is low
	port (Data: in STD_LOGIC_VECTOR (N-1 downto 0);	-- data input
	      Enable,					-- enable input
	      Reset: in STD_LOGIC;				-- reset input(act. low)
	      Output: out STD_LOGIC_VECTOR (N-1 downto 0));	-- output
    end component;

    component DFFREGSRH    -- edge triggered register, reset & set active high
	generic (N: Positive :=1;			-- N bit register
		 tLH: Time :=  0 ns;			-- rise inertial delay
		 tHL: Time :=  0 ns;			-- fall inertial delay
		 strn: STRENGTH := strn_X01;	-- output strength
         tHOLD : Time := 0 ns; 			-- Hold time
         tSetUp : Time := 0 ns;			-- Setup time
         tPwHighMin : Time := 0 ns;     -- min pulse width when clock is high
         tPwLowMin : Time := 0 ns);     -- min pulse width when clock is low
	port (Data: in STD_LOGIC_VECTOR (N-1 downto 0);	-- data input
	      Clock: in STD_LOGIC;				-- clock input
	      Reset, Set: in STD_LOGIC := '0';		-- reset, set input
	      Output: out STD_LOGIC_VECTOR (N-1 downto 0));	-- output
    end component;

    component  DFFREGSRL   -- edge triggered register, reset & set active low
	generic (N: Positive :=1;			-- N bit register
		 tLH: Time :=  0 ns;			-- rise inertial delay
		 tHL: Time :=  0 ns;			-- fall inertial delay
		 strn: STRENGTH := strn_X01;	-- output strength
         tHOLD : Time := 0 ns; 			-- Hold time
         tSetUp : Time := 0 ns;			-- Setup time
         tPwHighMin : Time := 0 ns;     -- min pulse width when clock is high
         tPwLowMin : Time := 0 ns);     -- min pulse width when clock is low
	port (Data: in STD_LOGIC_VECTOR (N-1 downto 0);	-- data input
	      Clock: in STD_LOGIC;				-- clock input
	      Reset, Set: in STD_LOGIC := '1';		-- reset, set input
	      Output: out STD_LOGIC_VECTOR (N-1 downto 0));	-- output
    end component;

    component  DLATREGSRH   -- level sensitive register, reset & set active high
	generic (N: Positive :=1;			-- N bit register
		 tLH: Time :=  0 ns;			-- rise inertial delay
		 tHL: Time :=  0 ns;			-- fall inertial delay
		 strn: STRENGTH := strn_X01;	-- output strength
         tHOLD : Time := 0 ns; 			-- Hold time
         tSetUp : Time := 0 ns;			-- Setup time
         tPwHighMin : Time := 0 ns;     -- min pulse width when enable is high
         tPwLowMin : Time := 0 ns);     -- min pulse width when enable is low
	port (Data: in STD_LOGIC_VECTOR (N-1 downto 0);	-- data input
	      Enable: in STD_LOGIC;				-- clock input
	      Reset, Set: in STD_LOGIC := '0';		-- reset, set input
	      Output: out STD_LOGIC_VECTOR (N-1 downto 0));	-- output
    end component;

    component  DLATREGSRL   -- level sensitive register, reset & set active low
	generic (N: Positive :=1;			-- N bit register
		 tLH: Time :=  0 ns;			-- rise inertial delay
		 tHL: Time :=  0 ns;			-- fall inertial delay
		 strn: STRENGTH := strn_X01;	-- output strength
         tHOLD : Time := 0 ns; 			-- Hold time
         tSetUp : Time := 0 ns;			-- Setup time
         tPwHighMin : Time := 0 ns;     -- min pulse width when enable is high
         tPwLowMin : Time := 0 ns);     -- min pulse width when enable is low
	port (Data: in STD_LOGIC_VECTOR (N-1 downto 0);	-- data input
	      Enable: in STD_LOGIC;				-- clock input
	      Reset, Set: in STD_LOGIC := '1';		-- reset, set input
	      Output: out STD_LOGIC_VECTOR (N-1 downto 0));	-- output
    end component;

    -------------------------------------------------------------------------
    --
    -- Memory component
    --
    -------------------------------------------------------------------------

    component DLATRAM 	  -- level sensitive ram
	generic (Ndata: Positive := 1;			  -- # of data I/O lines
		 Naddr: Positive := 1;			  -- # of address lines
		 tLH: time := 0 ns;			  -- output rising delay
		 tHL: time := 0 ns;			  -- output fulling delay
		 strn: STRENGTH := strn_X01);		  -- output strength
	port (DATAin: in STD_LOGIC_VECTOR(Ndata-1 downto 0);	  -- data in lines
	      DATAout: out STD_LOGIC_VECTOR(Ndata-1 downto 0); -- data out lines
	      ADDR: in STD_LOGIC_VECTOR(Naddr-1 downto 0);	  -- address lines
	      WE: in STD_LOGIC;				  -- write enable(active high)
	      RE: in STD_LOGIC);				  -- read enable(active high)

    end component;

    component DLATROM 	  -- level sensitive rom
	generic (Ndata: Positive := 1;			  -- # of data I/O lines
		 Naddr: Positive := 1;			  -- # of address lines
		 tLH: time := 0 ns;			  -- output rising delay
		 tHL: time := 0 ns;			  -- output fulling delay
		 strn: STRENGTH := strn_X01);		  -- output strength
	port (DATA: out STD_LOGIC_VECTOR(Ndata-1 downto 0); 	  -- data out lines
	      ADDR: in STD_LOGIC_VECTOR(Naddr-1 downto 0);	  -- address lines
	      RE: in STD_LOGIC);				  -- read enable(active high)

    end component;

    -------------------------------------------------------------------------
    --
    -- Timing Checker components
    --
    -------------------------------------------------------------------------

    component SUHDCK 				-- setup/hold timing checker
	generic (N: Positive := 1;		-- number of data lines
		 tSetup,			-- setup time
		 tHold: Time := 0 ns);		-- hold time
	port (Data:  in STD_LOGIC_VECTOR (1 to N);	-- data lines
	      Clock: in STD_LOGIC);			-- clock line
    end component;

    component MPWCK 				-- minimum pulse width checker
	generic (tHigh,				-- pulse's high time
		 tLow: Time := 0 ns);		-- pulse's low time
	port (Clock: in STD_LOGIC);			-- clock line
    end component;

    component RECOVCK 				-- recovery timing checker
	generic (tSetup,			-- setup time
		 tHold: Time := 0 ns);		-- hold time
	port (Reset,				-- Reset line
	      Clock: in STD_LOGIC);			-- clock line
    end component;


    -------------------------------------------------------------------------
    --
    -- Unidirectional Transistors.
    --
    -------------------------------------------------------------------------

    component NXFERGATE
        generic (tLH, tHL: time := 0 ns);
        port (Input, Enable: in STD_LOGIC; output: Out STD_LOGIC);
    end component;

    component NRXFERGATE
        generic (tLH, tHL: time := 0 ns);
        port (Input, Enable: in STD_LOGIC; output: Out STD_LOGIC);
    end component;

    component PXFERGATE
        generic (tLH, tHL: time := 0 ns);
        port (Input, Enable: in STD_LOGIC; output: Out STD_LOGIC);
    end component;

    component PRXFERGATE
        generic (tLH, tHL: time := 0 ns);
        port (Input, Enable: in STD_LOGIC; output: Out STD_LOGIC);
    end component;

    -------------------------------------------------------------------------
    --
    -- Resistor Primitive.
    --
    -------------------------------------------------------------------------
    component RESISTOR
        generic (tLH, tHL: time := 0 ns);
        port (Input: in STD_LOGIC; output: Out STD_LOGIC);
    end component;

--synopsys translate_on
end STD_LOGIC_COMPONENTS;
