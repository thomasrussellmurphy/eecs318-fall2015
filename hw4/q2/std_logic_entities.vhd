--synopsys synthesis_off


--------------------------------   -----------------------------------------
--
-- Copyright (c) 1990, 1991, 1992 by Synopsys, Inc.  All rights reserved.
--
-- This source file may be used and distributed without restriction
-- provided that this copyright statement is not removed from the file
-- and that any derivative work contains this copyright notice.
--
--	File name: std_logic_entities.vhd
--
--	Purpose: A set of models (entity/architecture pairs) for the
--	         primitives of IEEE Standard Logic library.
--
--	Author: JT, PH, GWH
--
--	NOTE:
--	      The component declarations for the entities in this
--	      package appear in the package IEEE.STD_LOGIC_COMPONENTS
--
----------------------------------------------------------------------------

----------------------------------------------------------------------------
--
--	Primitive name: ANDGATE
--
--	Purpose: An AND gate for multiple value logic STD_LOGIC,
--		 N inputs, 1 output.
--
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;


entity ANDGATE is
	generic (N:   Positive := 2;		-- number of inputs
		 tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC_VECTOR (1 to N);	-- inputs
	      Output: out STD_LOGIC);		-- output
end ANDGATE;

architecture A of ANDGATE is
	signal currentstate: STD_LOGIC := 'U';

	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);
begin
	P: process
		variable nextstate: STD_LOGIC;
		variable delta: Time;
		variable next_assign_val: STD_LOGIC;
	begin
	    -- evaluate logical function
	    nextstate := '1';
	    for i in Input'RANGE loop
	    	    nextstate := Input(i) and nextstate;
	    	    exit when nextstate = '0';
	    end loop;

	    nextstate := STRENGTH_MAP(nextstate, strn);

	    if (nextstate /= next_assign_val) then

		-- compute delay
                case TWOBIT'(currentstate & nextstate) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := 0 ns;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
                    when others =>
                             delta := tHL;
                end case;

		-- assign new value after internal delay
		currentstate <= nextstate after delta;
		Output <= nextstate after delta;
		next_assign_val := nextstate;
	    end if;

	    -- wait for signal changes
	    wait on Input;

	end process P;
end A;


library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of ANDGATE is
	attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_ANDGATE_BI of ANDGATE is
	for BI
	end for;
end;

configuration CFG_ANDGATE_A of ANDGATE is
	for A
	end for;
end;



----------------------------------------------------------------------------
--
--	Primitive name: NANDGATE
--
--	Purpose: A NAND gate for multiple value logic STD_LOGIC,
--		 N inputs, 1 output.
--		 (see package IEEE.STD_LOGIC_1164 for truth table)
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity NANDGATE is
	generic (N:   Positive := 2;		-- number of inputs
		 tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC_VECTOR (1 to N);	-- inputs
	      Output: out STD_LOGIC);		-- output
end NANDGATE;


architecture A of NANDGATE is
	signal currentstate: STD_LOGIC := 'U';

	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);
begin
	P: process
		variable nextstate: STD_LOGIC;
		variable delta: Time;
		variable next_assign_val: STD_LOGIC;
	begin
	    -- evaluate logical function
	    nextstate := '1';
	    for i in Input'RANGE loop
	    	    nextstate := Input(i) and nextstate;
	    	    exit when nextstate = '0';
	    end loop;

	    nextstate := STRENGTH_MAP(not(nextstate), strn);

	    if (nextstate /= next_assign_val) then

		-- compute delay
                case TWOBIT'(currentstate & nextstate) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := 0 ns;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
                    when others =>
                             delta := tHL;
                end case;

		-- assign new value after internal delay
		currentstate <= nextstate after delta;
		Output <= nextstate after delta;
		next_assign_val := nextstate;
	    end if;

	    -- wait for signal changes
	    wait on Input;

	end process P;
end A;

library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of NANDGATE is
	attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_NANDGATE_BI of NANDGATE is
	for BI
	end for;
end;

configuration CFG_NANDGATE_A of NANDGATE is
	for A
	end for;
end;


----------------------------------------------------------------------------
--
--	Primitive name: ORGATE
--
--	Purpose: An OR gate for multiple value logic STD_LOGIC,
--		 N inputs, 1 output.
--		 (see package IEEE.STD_LOGIC_1164 for truth table)
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity ORGATE is
	generic (N:   Positive := 2;		-- number of inputs
		 tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC_VECTOR (1 to N);	-- inputs
	      Output: out STD_LOGIC);		-- output
end ORGATE;


architecture A of ORGATE is
	signal currentstate: STD_LOGIC := 'U';

	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);
begin
	P: process
		variable nextstate: STD_LOGIC;
		variable delta: Time;
		variable next_assign_val: STD_LOGIC;
	begin
	    -- evaluate logical function
	    nextstate := '0';
	    for i in Input'RANGE loop
	    	    nextstate := Input(i) or nextstate;
	    	    exit when nextstate = '1';
	    end loop;

	    nextstate := STRENGTH_MAP(nextstate, strn);

	    if (nextstate /= next_assign_val) then

		-- compute delay
                case TWOBIT'(currentstate & nextstate) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := 0 ns;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
                    when others =>
                             delta := tHL;
                end case;

		-- assign new value after internal delay
		currentstate <= nextstate after delta;
		Output <= nextstate after delta;
		next_assign_val := nextstate;
	    end if;

	    -- wait for signal changes
	    wait on Input;

	end process P;
end A;


library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of ORGATE is
	attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_ORGATE_BI of ORGATE is
	for BI
	end for;
end;

configuration CFG_ORGATE_A of ORGATE is
	for A
	end for;
end;

----------------------------------------------------------------------------
--
--	Primitive name: NORGATE
--
--	Purpose: A NOR gate for multiple value logic STD_LOGIC,
--		 N inputs, 1 output.
--		 (see package IEEE.STD_LOGIC_1164 for truth table)
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity NORGATE is
	generic (N:   Positive := 2;		-- number of inputs
		 tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC_VECTOR (1 to N);	-- inputs
	      Output: out STD_LOGIC);		-- output
end NORGATE;


architecture A of NORGATE is
	signal currentstate: STD_LOGIC := 'U';

	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);
begin
	P: process
		variable nextstate: STD_LOGIC;
		variable delta: Time;
		variable next_assign_val: STD_LOGIC;
	begin
	    -- evaluate logical function
	    nextstate := '0';
	    for i in Input'RANGE loop
	    	    nextstate := Input(i) or nextstate;
	    	    exit when nextstate = '1';
	    end loop;

	    nextstate := STRENGTH_MAP(not(nextstate), strn);

	    if (nextstate /= next_assign_val) then

		-- compute delay
                case TWOBIT'(currentstate & nextstate) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := 0 ns;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
                    when others =>
                             delta := tHL;
                end case;

		-- assign new value after internal delay
		currentstate <= nextstate after delta;
		Output <= nextstate after delta;
		next_assign_val := nextstate;
	    end if;

	    -- wait for signal changes
	    wait on Input;

	end process P;
end A;


library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of NORGATE is
	attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_NORGATE_BI of NORGATE is
	for BI
	end for;
end;

configuration CFG_NORGATE_A of NORGATE is
	for A
	end for;
end;

----------------------------------------------------------------------------
--
--	Primitive name: XORGATE
--
--	Purpose: A XOR gate for multiple value logic STD_LOGIC,
--		 N inputs, 1 output.
--		 (see package IEEE.STD_LOGIC_1164 for truth table)
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity XORGATE is
	generic (N:   Positive := 2;		-- number of inputs
		 tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC_VECTOR (1 to N);	-- inputs
	      Output: out STD_LOGIC);		-- output
end XORGATE;


architecture A of XORGATE is
	signal currentstate: STD_LOGIC := 'U';

	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);
begin
	P: process
		variable nextstate: STD_LOGIC;
		variable delta: Time;
		variable next_assign_val: STD_LOGIC;
	begin
	    -- evaluate logical function
	    nextstate := '0';
	    for i in Input'RANGE loop
	    	    nextstate := Input(i) xor nextstate;
		    exit when nextstate = 'U';
	    end loop;

	    nextstate := STRENGTH_MAP(nextstate, strn);

	    if (nextstate /= next_assign_val) then

		-- compute delay
                case TWOBIT'(currentstate & nextstate) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := 0 ns;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
                    when others =>
                             delta := tHL;
                end case;

		-- assign new value after internal delay
		currentstate <= nextstate after delta;
		Output <= nextstate after delta;
		next_assign_val := nextstate;
	    end if;

	    -- wait for signal changes
	    wait on Input;

	end process P;
end A;


library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of XORGATE is
	attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_XORGATE_BI of XORGATE is
	for BI
	end for;
end;

configuration CFG_XORGATE_A of XORGATE is
	for A
	end for;
end;

----------------------------------------------------------------------------
--
--	Primitive name: NXORGATE
--
--	Purpose: A NXOR gate for multiple value logic STD_LOGIC,
--		 N inputs, 1 output.
--		 (see package IEEE.STD_LOGIC_1164 for truth table)
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity NXORGATE is
	generic (N:   Positive := 2;		-- number of inputs
		 tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC_VECTOR (1 to N);	-- inputs
	      Output: out STD_LOGIC);		-- output
end NXORGATE;


architecture A of NXORGATE is
	signal currentstate: STD_LOGIC := 'U';

	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);
begin
	P: process
		variable nextstate: STD_LOGIC;
		variable delta: Time;
		variable next_assign_val: STD_LOGIC;
	begin
	    -- evaluate logical function
	    nextstate := '0';
	    for i in Input'RANGE loop
	    	    nextstate := Input(i) xor nextstate;
		    exit when nextstate = 'U';
	    end loop;

	    nextstate := STRENGTH_MAP(not(nextstate), strn);

	    if (nextstate /= next_assign_val) then

		-- compute delay
                case TWOBIT'(currentstate & nextstate) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := 0 ns;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
                    when others =>
                             delta := tHL;
                end case;

		-- assign new value after internal delay
		currentstate <= nextstate after delta;
		Output <= nextstate after delta;
		next_assign_val := nextstate;
	    end if;

	    -- wait for signal changes
	    wait on Input;

	end process P;
end A;


library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of NXORGATE is
	attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_NXORGATE_BI of NXORGATE is
	for BI
	end for;
end;

configuration CFG_NXORGATE_A of NXORGATE is
	for A
	end for;
end;
----------------------------------------------------------------------------
--
--	Primitive name: XNORGATE
--
--	Purpose: A XNOR gate for multiple value logic STD_LOGIC,
--		 N inputs, 1 output.
--		 (see package IEEE.STD_LOGIC_1164 for truth table)
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity XNORGATE is
	generic (N:   Positive := 2;		-- number of inputs
		 tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC_VECTOR (1 to N);	-- inputs
	      Output: out STD_LOGIC);		-- output
end XNORGATE;


architecture A of XNORGATE is
	signal currentstate: STD_LOGIC := 'U';

	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);
begin
	P: process
		variable nextstate: STD_LOGIC;
		variable delta: Time;
		variable next_assign_val: STD_LOGIC;
	begin
	    -- evaluate logical function
	    nextstate := '0';
	    for i in Input'RANGE loop
	    	    nextstate := Input(i) xor nextstate;
		    exit when nextstate = 'U';
	    end loop;

	    nextstate := STRENGTH_MAP(not(nextstate), strn);

	    if (nextstate /= next_assign_val) then

		-- compute delay
                case TWOBIT'(currentstate & nextstate) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := 0 ns;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
                    when others =>
                             delta := tHL;
                end case;

		-- assign new value after internal delay
		currentstate <= nextstate after delta;
		Output <= nextstate after delta;
		next_assign_val := nextstate;
	    end if;

	    -- wait for signal changes
	    wait on Input;

	end process P;
end A;


library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of XNORGATE is
	attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_XNORGATE_BI of XNORGATE is
	for BI
	end for;
end;

configuration CFG_XNORGATE_A of XNORGATE is
	for A
	end for;
end;

----------------------------------------------------------------------------
--
--	Primitive name: BUFGATE
--
--	Purpose: A BUFFER gate for multiple value logic STD_LOGIC,
--		 1 input, 1 output.
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity BUFGATE is
	generic (tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC;			-- input
	      Output: out STD_LOGIC);		-- output
end BUFGATE;


architecture A of BUFGATE is
	signal currentstate: STD_LOGIC := 'U';

	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);
begin
	P: process
		variable nextstate: STD_LOGIC;
		variable delta: Time;
		variable next_assign_val: STD_LOGIC;
	begin
	    -- evaluate logical function
	    nextstate := STRENGTH_MAP(Input, strn);

	    if (nextstate /= next_assign_val) then

		-- compute delay
                case TWOBIT'(currentstate & nextstate) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := 0 ns;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
                    when others =>
                             delta := tHL;
                end case;

		-- assign new value after internal delay
		currentstate <= nextstate after delta;
		Output <= nextstate after delta;
		next_assign_val := nextstate;
	    end if;

	    -- wait for signal changes
	    wait on Input;

	end process P;
end A;


library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of BUFGATE is
	attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_BUFGATE_BI of BUFGATE is
	for BI
	end for;
end;

configuration CFG_BUFGATE_A of BUFGATE is
	for A
	end for;
end;

----------------------------------------------------------------------------
--
--	Primitive name: WBUFGATE
--
--	Purpose: A BUFFER gate with TRANSPORT delay mode
--	for multiple value logic STD_LOGIC, 1 input, 1 output.
--
--	Note: in order to model a wire with delay,
--	      must set tLH and tHL to a same value.
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity WBUFGATE is
	generic (tLH: Time := 0 ns;		-- rise transport delay
		 tHL: Time := 0 ns;		-- fall transport delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC;		-- input
	      Output: out STD_LOGIC);		-- output
end WBUFGATE;


architecture A of WBUFGATE is
	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);
begin
	P: process
		variable nextstate, next_assign_val: STD_LOGIC;
		variable delta, last_delta: Time := 0 ns;
	begin
	    -- evaluate logical function
	    nextstate := STRENGTH_MAP(Input, strn);

	    if (nextstate /= next_assign_val) then

		-- compute delay
                case TWOBIT'(next_assign_val & nextstate) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := last_delta;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
			     last_delta := tLH;
                    when others =>
                             delta := tHL;
                             last_delta := tHL;
                end case;
		-- assign new value after internal delay
		Output <= transport nextstate after delta;
		next_assign_val := nextstate;
	    end if;

	    -- wait for signal changes
	    wait on Input;
	end process;
end A;

-- The built-in architecture BI is a copy of the non built-in code
-- This was done for star 31679 since the built-in code did not guarantee
-- correct results.

architecture BI of WBUFGATE is
	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);
begin
	P: process
		variable nextstate, next_assign_val: STD_LOGIC;
		variable delta, last_delta: Time := 0 ns;
	begin
	    -- evaluate logical function
	    nextstate := STRENGTH_MAP(Input, strn);

	    if (nextstate /= next_assign_val) then

		-- compute delay
                case TWOBIT'(next_assign_val & nextstate) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := last_delta;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
			     last_delta := tLH;
                    when others =>
                             delta := tHL;
                             last_delta := tHL;
                end case;
		-- assign new value after internal delay
		Output <= transport nextstate after delta;
		next_assign_val := nextstate;
	    end if;

	    -- wait for signal changes
	    wait on Input;
	end process;
end BI;


configuration CFG_WBUFGATE_BI of WBUFGATE is
	for BI
	end for;
end;

configuration CFG_WBUFGATE_A of WBUFGATE is
	for A
	end for;
end;

----------------------------------------------------------------------------
--
--	Primitive name: INVGATE
--
--	Purpose: An INVERTER (not) gate for multiple value logic STD_LOGIC,
--		 1 input, 1 output.
--		 (see package IEEE.STD_LOGIC_1164 for truth table)
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity INVGATE is
	generic (tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC;			-- input
	      Output: out STD_LOGIC);		-- output
end INVGATE;

architecture A of INVGATE is
	signal currentstate: STD_LOGIC := 'U';

	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);
begin
	P: process
		variable nextstate: STD_LOGIC;
		variable delta: Time;
		variable next_assign_val: STD_LOGIC;
	begin
	    -- evaluate logical function
	    nextstate := STRENGTH_MAP(not(Input), strn);

	    if (nextstate /= next_assign_val) then

		-- compute delay
                case TWOBIT'(currentstate & nextstate) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := 0 ns;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
                    when others =>
                             delta := tHL;
                end case;

		-- assign new value after internal delay
		currentstate <= nextstate after delta;
		Output <= nextstate after delta;
		next_assign_val := nextstate;
	    end if;

	    -- wait for signal changes
	    wait on Input;

	end process P;
end A;

library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of INVGATE is
	attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_INVGATE_BI of INVGATE is
	for BI
	end for;
end;

configuration CFG_INVGATE_A of INVGATE is
	for A
	end for;
end;


----------------------------------------------------------------------------
--
--	Primitive name: BUF3S
--
--	Purpose: A TRISTATE BUFFER gate for multiple value logic STD_LOGIC,
--		 1 input, 1 enable(active high), 1 output.
--		 (see package IEEE.STD_LOGIC_1164 for truth table)
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity BUF3S is
	generic (tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC;			-- input
	      Enable: in STD_LOGIC;			-- enable
	      Output: out STD_LOGIC);		-- output
end BUF3S;


architecture A of BUF3S is
	signal currentstate: STD_LOGIC := 'U';

	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

begin
	P: process
		variable nextstate: STD_LOGIC;
		variable delta: Time;
		variable next_assign_val: STD_LOGIC;
	begin
	    -- evaluate logical function
	    nextstate := fun_BUF3S(To_UX01(Input), To_UX01(Enable), strn);

	    if (nextstate /= next_assign_val) then

		-- compute delay
                case TWOBIT'(currentstate & nextstate) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := 0 ns;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
                    when others =>
                             delta := tHL;
                end case;

		-- assign new value after internal delay
		currentstate <= nextstate after delta;
		Output <= nextstate after delta;
		next_assign_val := nextstate;
	    end if;

	    -- wait for signal changes
	    wait on Enable, Input;

	end process P;

end A;

library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of BUF3S is
	attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_BUF3S_BI of BUF3S is
	for BI
	end for;
end;

configuration CFG_BUF3S_A of BUF3S is
	for A
	end for;
end;


----------------------------------------------------------------------------
--
--	Primitive name: BUF3SL
--
--	Purpose: A TRISTATE BUFFER gate for multiple value logic STD_LOGIC,
--		 1 input, 1 enable(active low), 1 output.
--		 (see package IEEE.STD_LOGIC_1164 for truth table)
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity BUF3SL is
	generic (tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC;			-- input
	      Enable: in STD_LOGIC;			-- enable
	      Output: out STD_LOGIC);		-- output
end BUF3SL;


architecture A of BUF3SL is
	signal currentstate: STD_LOGIC := 'U';

	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

begin
	P: process
		variable nextstate: STD_LOGIC;
		variable delta: Time;
		variable next_assign_val: STD_LOGIC;
	begin
	    -- evaluate logical function
	    nextstate := fun_BUF3SL(To_UX01(Input), To_UX01(Enable), strn);

	    if (nextstate /= next_assign_val) then

		-- compute delay
                case TWOBIT'(currentstate & nextstate) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := 0 ns;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
                    when others =>
                             delta := tHL;
                end case;

		-- assign new value after internal delay
		currentstate <= nextstate after delta;
		Output <= nextstate after delta;
		next_assign_val := nextstate;
	    end if;

	    -- wait for signal changes
	    wait on Enable, Input;

	end process P;

end A;

library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of BUF3SL is
	attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_BUF3SL_BI of BUF3SL is
	for BI
	end for;
end;

configuration CFG_BUF3SL_A of BUF3SL is
	for A
	end for;
end;


----------------------------------------------------------------------------
--
--	Primitive name: INV3S
--
--	Purpose: A TRISTATE INVERTER (not) gate for multiple value logic STD_LOGIC,
--		 1 input, 1 enable(active high), 1 output.
--		 (see package IEEE.STD_LOGIC_1164 for truth table)
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity INV3S is
	generic (tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC;			-- input
	      Enable: in STD_LOGIC;			-- enable
	      Output: out STD_LOGIC);		-- output
end INV3S;


architecture A of INV3S is
	signal currentstate: STD_LOGIC := 'U';

	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

begin
	P: process
		variable nextstate: STD_LOGIC;
		variable delta: Time;
		variable next_assign_val: STD_LOGIC;
	begin
	    -- evaluate logical function
	    nextstate := fun_BUF3S(not(Input), To_UX01(Enable), strn);

	    if (nextstate /= next_assign_val) then

		-- compute delay
                case TWOBIT'(currentstate & nextstate) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := 0 ns;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
                    when others =>
                             delta := tHL;
                end case;

		-- assign new value after internal delay
		currentstate <= nextstate after delta;
		Output <= nextstate after delta;
		next_assign_val := nextstate;
	    end if;

	    -- wait for signal changes
	    wait on Enable, Input;

	end process P;
end A;

library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of INV3S is
	attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_INV3S_BI of INV3S is
	for BI
	end for;
end;

configuration CFG_INV3S_A of INV3S is
	for A
	end for;
end;


----------------------------------------------------------------------------
--
--	Primitive name: INV3SL
--
--	Purpose: A TRISTATE INVERTER (not) gate for multiple value logic STD_LOGIC,
--		 1 input, 1 enable(active low), 1 output.
--		 (see package IEEE.STD_LOGIC_1164 for truth table)
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity INV3SL is
	generic (tLH: Time := 0 ns;		-- rise inertial delay
		 tHL: Time := 0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (Input: in STD_LOGIC;			-- input
	      Enable: in STD_LOGIC;			-- enable
	      Output: out STD_LOGIC);		-- output
end INV3SL;


architecture A of INV3SL is
	signal currentstate: STD_LOGIC := 'U';

	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

begin
	P: process
		variable nextstate: STD_LOGIC;
		variable delta: Time;
		variable next_assign_val: STD_LOGIC;
	begin
	    -- evaluate logical function
	    nextstate := fun_BUF3S(not(Input), not(Enable), strn);

	    if (nextstate /= next_assign_val) then

		-- compute delay
                case TWOBIT'(currentstate & nextstate) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := 0 ns;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
                    when others =>
                             delta := tHL;
                end case;

		-- assign new value after internal delay
		currentstate <= nextstate after delta;
		Output <= nextstate after delta;
		next_assign_val := nextstate;
	    end if;

	    -- wait for signal changes
	    wait on Enable, Input;

	end process P;
end A;


library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of INV3SL is
	attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_INV3SL_BI of INV3SL is
	for BI
	end for;
end;

configuration CFG_INV3SL_A of INV3SL is
	for A
	end for;
end;

----------------------------------------------------------------------------
--
--	Primitive name: MUX2x1
--

--	Purpose: A two inputs MULTIPLEXER for multiple value logic STD_LOGIC,
--		 2 data inputs, 1 select input, 1 output.
--		 (see package IEEE.STD_LOGIC_1164 for the truth table)
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity MUX2x1 is
	generic (tLH: Time :=  0 ns;		-- rise inertial delay
		 tHL: Time :=  0 ns;		-- fall inertial delay
		 strn: STRENGTH := strn_X01);	-- output strength
	port (In0,				-- data input 0
	      In1,				-- data input 1
	      Sel: in STD_LOGIC;			-- select input
	      Output: out STD_LOGIC);		-- output
end MUX2x1;

architecture A of MUX2x1 is
	signal currentstate: STD_LOGIC := 'U';

	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

begin
	P: process
		variable nextstate: STD_LOGIC;
		variable delta: Time;
		variable next_assign_val: STD_LOGIC;
	begin
	    -- evaluate logical function
	    nextstate := fun_MUX2x1(To_UX01(In0), To_UX01(In1), To_UX01(Sel));

	    nextstate := STRENGTH_MAP(nextstate, strn);

	    if (nextstate /= next_assign_val) then

		-- compute delay
                case TWOBIT'(currentstate & nextstate) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := 0 ns;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
                    when others =>
                             delta := tHL;
                end case;

		-- assign new value after internal delay
		currentstate <= nextstate after delta;
		Output <= nextstate after delta;
		next_assign_val := nextstate;
	    end if;

	    -- wait for signal changes
	    wait on In0, In1, Sel;

	end process P;
end A;


library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of MUX2X1 is
	attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_MUX2X1_BI of MUX2X1 is
	for BI
	end for;
end;

configuration CFG_MUX2X1_A of MUX2X1 is
	for A
	end for;
end;



----------------------------------------------------------------------------
--
--	Primitive name: DFFREG
--
--	Purpose: An N-bit edge triggered register. (Reset active high)
--
--	Truth table:  -----------------------------------------------
--		      |  Data   Clock    Reset  |  Output           |
--		      |---------------------------------------------|
--		      |   *       *        U    |    U              |
--		      |   *       *        1    |    0              |
--		      |   *       *        X    | X or U or 0 or NC |(Note 1)
--		      |   *      X-Trns    0    | X or U or NC      |(Note 2)
--		      |   *      1-Trns    0    |   Data            |
--		      |   *      0-Trns    0    |    NC             |
--		      -----------------------------------------------
--		      ~ = not equal;    * = don't care;   NC = no change
--		      0 = '0' or 'L';   1 = '1' or 'H';   U = 'U';
--		      X = 'X', 'W', 'Z', or '-';
--		      (The truth table rows are in order of decreasing precedence)
--
--		      Clock transition definitions:
--			1-Trns: 0->1;
--			0-Trns: *->0, or 1->*, or X->X|U, or U->X|U;
--			X-Trns: 0->X|U, or X|U->1;
--
--		      Note 1: if ((Output already == 0) and
--				  not((Data != 0) and (X-Trns or 1-Trns)))
--				      (no change);
--			      else if ((Data == 0) and 1-Trns)
--			              Output := 0;
--			      else if (((Output already == U) and ~1-Trns) or
--				       ((Data == U) and ~0-Trns))
--			              Output := U;
--			      else
--				      Output := X;
--
--		      Note 2: if ((Output already == Data) or
--				  (Output already == U))
--				      (no change);
--			      else if (Data == U)
--			              Output := U;
--			      else
--				      Output := X;
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity DFFREG is
    generic (N: Positive :=1;              -- N bit register
             tLH: Time :=  0 ns;           -- rise inertial delay
             tHL: Time :=  0 ns;           -- fall inertial delay
             strn: STRENGTH := strn_X01;   -- output strength
         	 tHOLD : Time := 0 ns;         -- Hold time
             tSetUp : Time := 0 ns;        -- Setup time
             tPwHighMin : Time := 0 ns;    -- min pulse width when clock is high
             tPwLowMin : Time := 0 ns);    -- min pulse width when clock is low

    port    (Data: in STD_LOGIC_VECTOR (N-1 downto 0);-- data input
             Clock,                                    -- clock input
             Reset: in STD_LOGIC;                     -- reset input
             Output: out STD_LOGIC_VECTOR (N-1 downto 0));  -- output
end DFFREG;


architecture A of DFFREG is
    signal currentstate: STD_LOGIC_VECTOR (Data'RANGE);
    subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

begin
    P: process
        variable nextstate: STD_LOGIC_VECTOR (Data'RANGE);
        variable next_assign_val: STD_LOGIC_VECTOR (Data'RANGE);
        variable delta: Time := 0 ns;
   	variable clock_flag : integer := 0; 	-- initial to 0-Trns

    begin
    -- evaluate logical function
    if (Clock'EVENT) then
        case TWOBIT'(Clock'LAST_VALUE & Clock) is
            when "01"|"L1"|"0H"|"LH" =>
                clock_flag := 1;	-- 1-Trns
            when "0U"|"0X"|"0Z"|"0W"|"0-"| "LU"|"LX"|"LZ"|"LW"|"L-"|
		 "U1"|"X1"|"Z1"|"W1"|"-1"| "UH"|"XH"|"ZH"|"WH"|"-H"   =>
                clock_flag := 2;	-- X-Trns
            when others =>
                clock_flag := 0;	-- 0-Trns
        end case;
    else
                clock_flag := 0;	-- 0-Trns
    end if;

    for i in Data'RANGE loop
        case Reset is
            when 'U' =>
                nextstate(i) :=  'U';
            when '1' | 'H' =>
                nextstate(i) :=  STRENGTH_MAP('0', strn);
            when '0' | 'L' =>
                case clock_flag is
                    when 0 =>
                        exit;
              	    when 1 =>
                        nextstate(i) := STRENGTH_MAP(Data(i), strn);
                    when others =>	-- X-Trans
			if (next_assign_val(i) = STRENGTH_MAP(Data(i),strn)
					     or next_assign_val(i) = 'U') then
                     	    next;
			elsif (Data(i) = 'U') then
			    nextstate(i) :=  'U';
            		else
                            nextstate(i) := STRENGTH_MAP('X', strn);
            		end if;
                end case;
            when 'X' | 'W' | 'Z' | '-' =>
                if (next_assign_val(i) = STRENGTH_MAP('0', strn)
                    and (Data(i)='0' or Data(i)='L' or clock_flag=0)) then
                       next;
                elsif ((Data(i)='0' or Data(i)='L') and clock_flag=1) then
                       nextstate(i) :=  STRENGTH_MAP('0', strn);
                elsif ((next_assign_val(i) ='U' and not(clock_flag=1))
		              or (Data(i)='U' and not(clock_flag=0))) then
                       nextstate(i) :=  'U';
                else
                       nextstate(i) := STRENGTH_MAP('X', strn);
                end if;
	end case;

        if (next_assign_val(i) = nextstate(i)) then
            next;
        end if;

	-- compute delay
        case TWOBIT'(currentstate(i) & nextstate(i)) is
            when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		 "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
		 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
					  "11"|"1H"|"HH"|"H1"      =>
                     delta := 0 ns;
            when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				"0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
				"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                     delta := tLH;
            when others =>
                     delta := tHL;
        end case;

        currentstate(i) <= nextstate(i) after delta;
        Output(i) <= nextstate(i) after delta;
        next_assign_val(i) := nextstate(i);

    end loop;

    wait on Clock, Reset;
    end process P;
end A;



library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of DFFREG is
    attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_DFFREG_BI of DFFREG is
    for BI
    end for;
end;

configuration CFG_DFFREG_A of DFFREG is
    for A
    end for;
end;



----------------------------------------------------------------------------
--
--	Primitive name: DFFREGL
--
--	Purpose: An N-bit edge triggered register. (Reset active low)
--
--	Truth table:  -----------------------------------------------
--		      |  Data   Clock    Reset  |  Output           |
--		      |---------------------------------------------|
--		      |   *       *        U    |    U              |
--		      |   *       *        0    |    0              |
--		      |   *       *        X    | X or U or 0 or NC |(Note 1)
--		      |   *      X-Trns    1    | X or U or NC      |(Note 2)
--		      |   *      1-Trns    1    |   Data            |
--		      |   *      0-Trns    1    |    NC             |
--		      -----------------------------------------------
--		      ~ = not equal;    * = don't care;   NC = no change
--		      0 = '0' or 'L';   1 = '1' or 'H';   U = 'U';
--		      X = 'X', 'W', 'Z', or '-';
--		      (The truth table rows are in order of decreasing precedence)
--
--		      Clock transition definitions:
--			1-Trns: 0->1;
--			0-Trns: *->0, or 1->*, or X->X|U, or U->X|U;
--			X-Trns: 0->X|U, or X|U->1;
--
--		      Note 1: if ((Output already == 0) and
--				  not((Data != 0) and (X-Trns or 1-Trns)))
--				      (no change);
--			      else if ((Data == 0) and 1-Trns)
--			              Output := 0;
--			      else if (((Output already == U) and ~1-Trns) or
--				       ((Data == U) and ~0-Trns))
--			              Output := U;
--			      else
--				      Output := X;
--
--		      Note 2: if ((Output already == Data) or
--				  (Output already == U))
--				      (no change);
--			      else if (Data == U)
--			              Output := U;
--			      else
--				      Output := X;
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity DFFREGL is
    generic (N: Positive :=1;              -- N bit register
             tLH: Time :=  0 ns;           -- rise inertial delay
             tHL: Time :=  0 ns;           -- fall inertial delay
             strn: STRENGTH := strn_X01;   -- output strength
         	 tHOLD : Time := 0 ns;         -- Hold time
             tSetUp : Time := 0 ns;        -- Setup time
             tPwHighMin : Time := 0 ns;    -- min pulse width when clock is high
             tPwLowMin : Time := 0 ns);    -- min pulse width when clock is low
    port    (Data: in STD_LOGIC_VECTOR (N-1 downto 0);-- data input
             Clock,                                    -- clock input
             Reset: in STD_LOGIC;                     -- reset input
             Output: out STD_LOGIC_VECTOR (N-1 downto 0));  -- output
end DFFREGL;


architecture A of DFFREGL is
    signal currentstate: STD_LOGIC_VECTOR (Data'RANGE);
    subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

begin
    P: process
        variable nextstate: STD_LOGIC_VECTOR (Data'RANGE);
        variable next_assign_val: STD_LOGIC_VECTOR (Data'RANGE);
        variable delta: Time := 0 ns;
   	variable clock_flag : integer := 0; 	-- initial to 0-Trns

    begin
    -- evaluate logical function
    if (Clock'EVENT) then
        case TWOBIT'(Clock'LAST_VALUE & Clock) is
            when "01"|"L1"|"0H"|"LH" =>
                clock_flag := 1;	-- 1-Trns
            when "0U"|"0X"|"0Z"|"0W"|"0-"| "LU"|"LX"|"LZ"|"LW"|"L-"|
		 "U1"|"X1"|"Z1"|"W1"|"-1"| "UH"|"XH"|"ZH"|"WH"|"-H"   =>
                clock_flag := 2;	-- X-Trns
            when others =>
                clock_flag := 0;	-- 0-Trns
        end case;
    else
                clock_flag := 0;	-- 0-Trns
    end if;

    for i in Data'RANGE loop
        case Reset is
            when 'U' =>
                nextstate(i) :=  'U';
            when '0' | 'L' =>
                nextstate(i) :=  STRENGTH_MAP('0', strn);
            when '1' | 'H' =>
                case clock_flag is
                    when 0 =>
                        exit;
              	    when 1 =>
                        nextstate(i) := STRENGTH_MAP(Data(i), strn);
                    when others =>	-- X-Trans
			if (next_assign_val(i) = STRENGTH_MAP(Data(i),strn)
					     or next_assign_val(i) = 'U') then
                     	    next;
			elsif (Data(i) = 'U') then
			    nextstate(i) :=  'U';
            		else
                            nextstate(i) := STRENGTH_MAP('X', strn);
            		end if;
                end case;
            when 'X' | 'W' | 'Z' | '-' =>
                if (next_assign_val(i) = STRENGTH_MAP('0', strn)
                    and (Data(i)='0' or Data(i)='L' or clock_flag=0)) then
                       next;
                elsif ((Data(i)='0' or Data(i)='L') and clock_flag=1) then
                       nextstate(i) :=  STRENGTH_MAP('0', strn);
                elsif ((next_assign_val(i) ='U' and not(clock_flag=1))
		              or (Data(i)='U' and not(clock_flag=0))) then
                       nextstate(i) :=  'U';
                else
                       nextstate(i) := STRENGTH_MAP('X', strn);
                end if;
	end case;

        if (next_assign_val(i) = nextstate(i)) then
            next;
        end if;

	-- compute delay
        case TWOBIT'(currentstate(i) & nextstate(i)) is
            when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		 "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
		 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
					  "11"|"1H"|"HH"|"H1"      =>
                     delta := 0 ns;
            when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				"0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
				"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                     delta := tLH;
            when others =>
                     delta := tHL;
        end case;

        currentstate(i) <= nextstate(i) after delta;
        Output(i) <= nextstate(i) after delta;
        next_assign_val(i) := nextstate(i);

    end loop;

    wait on Clock, Reset;
    end process P;
end A;



library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of DFFREGL is
    attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_DFFREGL_BI of DFFREGL is
    for BI
    end for;
end;

configuration CFG_DFFREGL_A of DFFREGL is
    for A
    end for;
end;



----------------------------------------------------------------------------
--
--  Primitive name: DFFREGSRH
--
--  Purpose: An N-bit edge triggered register. (Reset & Set active high)
--
--  Truth table:  --------------------------------------------------
--  	          | Data   Clock   Reset   Set |  Output           |
--		  |------------------------------------------------|
--		  |   *      *       *      U  |    U              |
--		  |   *      *       U      *  |    U              |
--		  |   *      *       *      1  |    1              |
--		  |   *      *       1      0  |    0              |
--		  |   *      *       1      X  |    X              |
--		  |   *      *       X      X  | X or U            |(Note 1)
--		  |   *      *       0      X  | X or U or 1 or NC |(Note 2)
--		  |   *      *       X      0  | X or U or 0 or NC |(Note 3)
--		  |   *   X-Trns     0      0  | X or U or NC      |(Note 4)
--		  |   *   1-Trns     0      0  |   Data            |
--		  |   *   0-Trns     0      0  |    NC             |
--		  --------------------------------------------------
--		   ~ = not equal;    * = don't care;   NC = no change
--		   0 = '0' or 'L';   1 = '1' or 'H';   U = 'U';
--		   X = 'X', 'W', 'Z', or '-';
--		  (The truth table rows are in order of decreasing precedence)
--
--		   Clock transition definitions:
--			1-Trns: 0->1;
--			0-Trns: *->0, or 1->*, or X->X|U, or U->X|U;
--			X-Trns: 0->X|U, or X|U->1;
--
--		   Note 1: if (((Output already == U) and ~1-Trns) or
--			       ((Data == U) and ~0-Trns))
--			              Output := U;
--			   else
--				      Output := X;
--
--		   Note 2: if ((Output already == 1) and
--				not((Data != 1) and (X-Trns or 1-Trns)))
--				      (no change);
--			   else if ((Data == 1) and 1-Trns)
--			              Output := 1;
--			   else if (((Output already == U) and ~1-Trns) or
--			            ((Data == U) and ~0-Trns))
--			              Output := U;
--			   else
--				      Output := X;
--
--		   Note 3: if ((Output already == 0) and
--				not((Data != 0) and (X-Trns or 1-Trns)))
--				      (no change);
--			   else if ((Data == 0) and 1-Trns)
--			              Output := 0;
--			   else if (((Output already == U) and ~1-Trns) or
--			            ((Data == U) and ~0-Trns))
--			              Output := U;
--			   else
--				      Output := X;
--
--		   Note 4: if ((Output already == Data) or
--			       (Output already == U))
--				      (no change);
--			   else if (Data == U)
--				      Output := U;
--			   else
--				      Output := X;
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity DFFREGSRH is
    generic (N: Positive :=1;              -- N bit register
             tLH: Time :=  0 ns;           -- rise inertial delay
             tHL: Time :=  0 ns;           -- fall inertial delay
             strn: STRENGTH := strn_X01;   -- output strength
         	 tHOLD : Time := 0 ns;         -- Hold time
             tSetUp : Time := 0 ns;        -- Setup time
             tPwHighMin : Time := 0 ns;    -- min pulse width when clock is high
             tPwLowMin : Time := 0 ns);    -- min pulse width when clock is low
    port    (Data: in STD_LOGIC_VECTOR (N-1 downto 0);	-- data input
             Clock,                                    	-- clock input
             Reset,   		                       		-- reset input
             Set: in STD_LOGIC;                       	-- set input
             Output: out STD_LOGIC_VECTOR (N-1 downto 0));  -- output
end DFFREGSRH;


architecture A of DFFREGSRH is
    signal currentstate: STD_LOGIC_VECTOR (Data'RANGE);
    subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

begin
    P: process
        variable nextstate: STD_LOGIC_VECTOR (Data'RANGE);
        variable next_assign_val: STD_LOGIC_VECTOR (Data'RANGE);
        variable delta: Time := 0 ns;
   	variable clock_flag : integer := 0; 	-- initial to 0-Trns

    begin
    -- evaluate logical function
    if (Clock'EVENT) then
        case TWOBIT'(Clock'LAST_VALUE & Clock) is
            when "01"|"L1"|"0H"|"LH" =>
                clock_flag := 1;	-- 1-Trns
            when "0U"|"0X"|"0Z"|"0W"|"0-"| "LU"|"LX"|"LZ"|"LW"|"L-"|
		 "U1"|"X1"|"Z1"|"W1"|"-1"| "UH"|"XH"|"ZH"|"WH"|"-H"   =>
                clock_flag := 2;	-- X-Trns
            when others =>
                clock_flag := 0;	-- 0-Trns
        end case;
    else
                clock_flag := 0;	-- 0-Trns
    end if;

    for i in Data'RANGE loop
	case TWOBIT'(Reset & Set) is
	    when "UU"|"UX"|"U0"|"U1"|"UZ"|"UW"|"UL"|"UH"|"U-"|
		      "XU"|"0U"|"1U"|"ZU"|"WU"|"LU"|"HU"|"-U"  =>
		nextstate(i) :=  'U';
	    when "X1"|"01"|"11"|"Z1"|"W1"|"L1"|"H1"|"-1"|
		 "XH"|"0H"|"1H"|"ZH"|"WH"|"LH"|"HH"|"-H"       =>
		nextstate(i) :=  STRENGTH_MAP('1', strn);
	    when "10"|"1L"|"H0"|"HL"			       =>
		nextstate(i) :=  STRENGTH_MAP('0', strn);
	    when "XX"|"XZ"|"XW"|"X-"|"ZX"|"ZZ"|"ZW"|"Z-"|
		 "WX"|"WZ"|"WW"|"W-"|"-X"|"-Z"|"-W"|"--"       =>
                if ((next_assign_val(i) ='U' and not(clock_flag=1))
		             or (Data(i)='U' and not(clock_flag=0))) then
                       nextstate(i) := 'U';
                else
                       nextstate(i) := STRENGTH_MAP('X', strn);
                end if;
	    when "0X"|"0Z"|"0W"|"0-"|"LX"|"LZ"|"LW"|"L-"       =>
                if (next_assign_val(i) = STRENGTH_MAP('1', strn)
                    and (Data(i)='1' or Data(i)='H' or clock_flag=0)) then
                       next;
                elsif ((Data(i)='1' or Data(i)='H') and clock_flag=1) then
                       nextstate(i) :=  STRENGTH_MAP('1', strn);
                elsif ((next_assign_val(i) ='U' and not(clock_flag=1))
		              or (Data(i)='U' and not(clock_flag=0))) then
                       nextstate(i) :=  'U';
                else
                       nextstate(i) := STRENGTH_MAP('X', strn);
                end if;
	    when "1X"|"1Z"|"1W"|"1-"|"HX"|"HZ"|"HW"|"H-"       =>
                nextstate(i) := STRENGTH_MAP('X', strn);
	    when "X0"|"Z0"|"W0"|"-0"|"XL"|"ZL"|"WL"|"-L"       =>
                if (next_assign_val(i) = STRENGTH_MAP('0', strn)
                    and (Data(i)='0' or Data(i)='L' or clock_flag=0)) then
                       next;
                elsif ((Data(i)='0' or Data(i)='L') and clock_flag=1) then
                       nextstate(i) :=  STRENGTH_MAP('0', strn);
                elsif ((next_assign_val(i) ='U' and not(clock_flag=1))
		              or (Data(i)='U' and not(clock_flag=0))) then
                       nextstate(i) :=  'U';
                else
                       nextstate(i) := STRENGTH_MAP('X', strn);
                end if;
	    when "00"|"0L"|"L0"|"LL"			       =>
                case clock_flag is
                    when 0 =>
                        exit;
              	    when 1 =>
                        nextstate(i) := STRENGTH_MAP(Data(i), strn);
                    when others =>	-- X-Trans
			if (next_assign_val(i) = STRENGTH_MAP(Data(i),strn)
					    or next_assign_val(i) = 'U') then
                     	    next;
			elsif (Data(i) = 'U') then
			    nextstate(i) :=  'U';
            		else
                            nextstate(i) := STRENGTH_MAP('X', strn);
            		end if;
                end case;
        end case;

        if (next_assign_val(i) = nextstate(i)) then
            next;
        end if;

	-- compute delay
        case TWOBIT'(currentstate(i) & nextstate(i)) is
            when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		 "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
		 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
					  "11"|"1H"|"HH"|"H1"      =>
                     delta := 0 ns;
            when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				"0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
				"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                     delta := tLH;
            when others =>
                     delta := tHL;
        end case;

        currentstate(i) <= nextstate(i) after delta;
        Output(i) <= nextstate(i) after delta;
        next_assign_val(i) := nextstate(i);

    end loop;

    wait on Clock, Reset, Set;
    end process P;
end A;



library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of DFFREGSRH is
    attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_DFFREGSRH_BI of DFFREGSRH is
    for BI
    end for;
end;

configuration CFG_DFFREGSRH_A of DFFREGSRH is
    for A
    end for;
end;



----------------------------------------------------------------------------
--
--  Primitive name: DFFREGSRL
--
--  Purpose: An N-bit edge triggered register. (Reset & Set active low)
--
--  Truth table:  --------------------------------------------------
--  	          | Data   Clock   Reset   Set |  Output           |
--		  |------------------------------------------------|
--		  |   *      *       *      U  |    U              |
--		  |   *      *       U      *  |    U              |
--		  |   *      *       *      0  |    1              |
--		  |   *      *       0      1  |    0              |
--		  |   *      *       0      X  |    X              |
--		  |   *      *       X      X  | X or U            |(Note 1)
--		  |   *      *       1      X  | X or U or 1 or NC |(Note 2)
--		  |   *      *       X      1  | X or U or 0 or NC |(Note 3)
--		  |   *   X-Trns     1      1  | X or U or NC      |(Note 4)
--		  |   *   1-Trns     1      1  |   Data            |
--		  |   *   0-Trns     1      1  |    NC             |
--		  --------------------------------------------------
--		   ~ = not equal;    * = don't care;   NC = no change
--		   0 = '0' or 'L';   1 = '1' or 'H';   U = 'U';
--		   X = 'X', 'W', 'Z', or '-';
--		  (The truth table rows are in order of decreasing precedence)
--
--		   Clock transition definitions:
--			1-Trns: 0->1;
--			0-Trns: *->0, or 1->*, or X->X|U, or U->X|U;
--			X-Trns: 0->X|U, or X|U->1;
--
--		   Note 1: if (((Output already == U) and ~1-Trns) or
--			       ((Data == U) and ~0-Trns))
--			              Output := U;
--			   else
--				      Output := X;
--
--		   Note 2: if ((Output already == 1) and
--				not((Data != 1) and (X-Trns or 1-Trns)))
--				      (no change);
--			   else if ((Data == 1) and 1-Trns)
--			              Output := 1;
--			   else if (((Output already == U) and ~1-Trns) or
--			            ((Data == U) and ~0-Trns))
--			              Output := U;
--			   else
--				      Output := X;
--
--		   Note 3: if ((Output already == 0) and
--				not((Data != 0) and (X-Trns or 1-Trns)))
--				      (no change);
--			   else if ((Data == 0) and 1-Trns)
--			              Output := 0;
--			   else if (((Output already == U) and ~1-Trns) or
--			            ((Data == U) and ~0-Trns))
--			              Output := U;
--			   else
--				      Output := X;
--
--		   Note 4: if ((Output already == Data) or
--			       (Output already == U))
--				      (no change);
--			   else if (Data == U)
--				      Output := U;
--			   else
--				      Output := X;
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity DFFREGSRL is
    generic (N: Positive :=1;              -- N bit register
             tLH: Time :=  0 ns;           -- rise inertial delay
             tHL: Time :=  0 ns;           -- fall inertial delay
             strn: STRENGTH := strn_X01;   -- output strength
         	 tHOLD : Time := 0 ns;         -- Hold time
             tSetUp : Time := 0 ns;        -- Setup time
             tPwHighMin : Time := 0 ns;    -- min pulse width when clock is high
             tPwLowMin : Time := 0 ns);    -- min pulse width when clock is low
    port    (Data: in STD_LOGIC_VECTOR (N-1 downto 0);	-- data input
             Clock,                                    	-- clock input
             Reset,   		                       		-- reset input
             Set: in STD_LOGIC;                    		-- set input
             Output: out STD_LOGIC_VECTOR (N-1 downto 0));  -- output
end DFFREGSRL;


architecture A of DFFREGSRL is
    signal currentstate: STD_LOGIC_VECTOR (Data'RANGE);
    subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

begin
    P: process
        variable nextstate: STD_LOGIC_VECTOR (Data'RANGE);
        variable next_assign_val: STD_LOGIC_VECTOR (Data'RANGE);
        variable delta: Time := 0 ns;
   	variable clock_flag : integer := 0; 	-- initial to 0-Trns

    begin
    -- evaluate logical function
    if (Clock'EVENT) then
        case TWOBIT'(Clock'LAST_VALUE & Clock) is
            when "01"|"L1"|"0H"|"LH" =>
                clock_flag := 1;	-- 1-Trns
            when "0U"|"0X"|"0Z"|"0W"|"0-"| "LU"|"LX"|"LZ"|"LW"|"L-"|
		 "U1"|"X1"|"Z1"|"W1"|"-1"| "UH"|"XH"|"ZH"|"WH"|"-H"   =>
                clock_flag := 2;	-- X-Trns
            when others =>
                clock_flag := 0;	-- 0-Trns
        end case;
    else
                clock_flag := 0;	-- 0-Trns
    end if;

    for i in Data'RANGE loop
	case TWOBIT'(Reset & Set) is
	    when "UU"|"UX"|"U0"|"U1"|"UZ"|"UW"|"UL"|"UH"|"U-"|
		      "XU"|"0U"|"1U"|"ZU"|"WU"|"LU"|"HU"|"-U"  =>
		nextstate(i) :=  'U';
	    when "X0"|"00"|"10"|"Z0"|"W0"|"L0"|"H0"|"-0"|
		 "XL"|"0L"|"1L"|"ZL"|"WL"|"LL"|"HL"|"-L"       =>
		nextstate(i) :=  STRENGTH_MAP('1', strn);
	    when "01"|"L1"|"0H"|"LH"			       =>
		nextstate(i) :=  STRENGTH_MAP('0', strn);
	    when "XX"|"XZ"|"XW"|"X-"|"ZX"|"ZZ"|"ZW"|"Z-"|
		 "WX"|"WZ"|"WW"|"W-"|"-X"|"-Z"|"-W"|"--"       =>
                if ((next_assign_val(i) ='U' and not(clock_flag=1))
		             or (Data(i)='U' and not(clock_flag=0))) then
                       nextstate(i) := 'U';
                else
                       nextstate(i) := STRENGTH_MAP('X', strn);
                end if;
	    when "1X"|"1Z"|"1W"|"1-"|"HX"|"HZ"|"HW"|"H-"       =>
                if (next_assign_val(i) = STRENGTH_MAP('1', strn)
                    and (Data(i)='1' or Data(i)='H' or clock_flag=0)) then
                       next;
                elsif ((Data(i)='1' or Data(i)='H') and clock_flag=1) then
                       nextstate(i) :=  STRENGTH_MAP('1', strn);
                elsif ((next_assign_val(i) ='U' and not(clock_flag=1))
		              or (Data(i)='U' and not(clock_flag=0))) then
                       nextstate(i) :=  'U';
                else
                       nextstate(i) := STRENGTH_MAP('X', strn);
                end if;
	    when "0X"|"0Z"|"0W"|"0-"|"LX"|"LZ"|"LW"|"L-"       =>
                nextstate(i) := STRENGTH_MAP('X', strn);
	    when "X1"|"Z1"|"W1"|"-1"|"XH"|"ZH"|"WH"|"-H"       =>
                if (next_assign_val(i) = STRENGTH_MAP('0', strn)
                    and (Data(i)='0' or Data(i)='L' or clock_flag=0)) then
                       next;
                elsif ((Data(i)='0' or Data(i)='L') and clock_flag=1) then
                       nextstate(i) :=  STRENGTH_MAP('0', strn);
                elsif ((next_assign_val(i) ='U' and not(clock_flag=1))
		              or (Data(i)='U' and not(clock_flag=0))) then
                       nextstate(i) :=  'U';
                else
                       nextstate(i) := STRENGTH_MAP('X', strn);
                end if;
	    when "11"|"1H"|"H1"|"HH"			       =>
                case clock_flag is
                    when 0 =>
                        exit;
              	    when 1 =>
                        nextstate(i) := STRENGTH_MAP(Data(i), strn);
                    when others =>	-- X-Trans
			if (next_assign_val(i) = STRENGTH_MAP(Data(i),strn)
					    or next_assign_val(i) = 'U') then
                     	    next;
			elsif (Data(i) = 'U') then
			    nextstate(i) :=  'U';
            		else
                            nextstate(i) := STRENGTH_MAP('X', strn);
            		end if;
                end case;
        end case;

        if (next_assign_val(i) = nextstate(i)) then
            next;
        end if;

	-- compute delay
        case TWOBIT'(currentstate(i) & nextstate(i)) is
            when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		 "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
		 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
					  "11"|"1H"|"HH"|"H1"      =>
                     delta := 0 ns;
            when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				"0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
				"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                     delta := tLH;
            when others =>
                     delta := tHL;
        end case;

        currentstate(i) <= nextstate(i) after delta;
        Output(i) <= nextstate(i) after delta;
        next_assign_val(i) := nextstate(i);

    end loop;

    wait on Clock, Reset, Set;
    end process P;
end A;



library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of DFFREGSRL is
    attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_DFFREGSRL_BI of DFFREGSRL is
    for BI
    end for;
end;

configuration CFG_DFFREGSRL_A of DFFREGSRL is
    for A
    end for;
end;



----------------------------------------------------------------------------
--
--	Primitive name: DLATREG
--
--	Purpose: An N-bit level sensitive register. (Reset active high)
--
--	Truth table:  ----------------------------------------------
--		      |  Data   Enable  Reset  |  Output           |
--		      |--------------------------------------------|
--		      |   *       *       U    |    U              |
--		      |   *       *       1    |    0              |
--		      |   *       U      ~1    |    U              |
--		      |   *      ~U       X    | X or U or 0 or NC |(Note 1)
--		      |   *       X       0    | X or U or NC      |(Note 2)
--		      |   *       1       0    |   Data            |
--		      |   *       0       0    |    NC             |
--		      ----------------------------------------------
--		      ~ = not equal;    * = don't care;   NC = no change
--		      0 = '0' or 'L';   1 = '1' or 'H';   U = 'U';
--		      X = 'X', 'W', 'Z', or '-';
--		      (The truth table rows are in order of decreasing precedence)
--
--		      Note 1: if ((Output already == 0) and not((Data != 0)
--				   and ((Enable == X) or (Enable == 1))))
--				      (no change);
--			      else if ((Data == 0) and (Enable == 1))
--			              Output := 0;
--			      else if (((Output already == U) and (Enable != 1))
--				       or ((Data == U) and Enable != 0))
--			              Output := U;
--			      else
--				      Output := X;
--
--		      Note 2: if ((Output already == Data) or
--				  (Output already == U))
--				      (no change);
--			      else if (Data == U)
--				      Output := U;
--			      else
--				      Output := X;
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity DLATREG is
    generic (N: Positive :=1;             -- N bit register
             tLH: Time :=  0 ns;          -- rise inertial delay
             tHL: Time :=  0 ns;          -- fall inertial delay
             strn: STRENGTH := strn_X01;  -- output strength
         	 tHOLD : Time := 0 ns;        -- Hold time
             tSetUp : Time := 0 ns;       -- Setup time
             tPwHighMin : Time := 0 ns;   -- min pulse width when enable is high
             tPwLowMin : Time := 0 ns);   -- min pulse width when enable is low
    port    (Data: in STD_LOGIC_VECTOR (N-1 downto 0);-- data input
             Enable,                                   -- enable input
             Reset: in STD_LOGIC;                     -- reset input
             Output: out STD_LOGIC_VECTOR (N-1 downto 0));  -- output
end DLATREG;


architecture A of DLATREG is
    signal currentstate: STD_LOGIC_VECTOR (Data'RANGE);
    subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

begin
    P: process
        variable nextstate: STD_LOGIC_VECTOR (Data'RANGE);
        variable next_assign_val: STD_LOGIC_VECTOR (Data'RANGE);
        variable delta: Time := 0 ns;
   	variable enable_flag : integer := 0;

    begin
    -- evaluate logical function
    case Enable is
        when '1' | 'H' =>
            enable_flag := 1;
        when '0' | 'L' =>
            enable_flag := 0;
        when 'U' =>
            enable_flag := 3;
        when others =>
            enable_flag := 2;
    end case;

    for i in Data'RANGE loop
        case Reset is
            when 'U' =>
                nextstate(i) :=  'U';
            when '1' | 'H' =>
                nextstate(i) :=  STRENGTH_MAP('0', strn);
            when '0' | 'L' =>
                case enable_flag is
                    when 0 =>
                        exit;
              	    when 3 =>
                        nextstate(i) := 'U';
              	    when 1 =>
                        nextstate(i) := STRENGTH_MAP(Data(i), strn);
                    when others =>
			if (next_assign_val(i) = STRENGTH_MAP(Data(i),strn)
					     or next_assign_val(i) = 'U') then
                     	    next;
			elsif (Data(i) = 'U') then
			    nextstate(i) :=  'U';
            		else
                            nextstate(i) := STRENGTH_MAP('X', strn);
            		end if;
                end case;
            when 'X' | 'W' | 'Z' | '-' =>
                if ((enable_flag = 3) or
		    (next_assign_val(i) = 'U' and not(enable_flag = 1)) or
		    (Data(i) = 'U' and not(enable_flag = 0))) then
                       nextstate(i) :=  'U';
                elsif (next_assign_val(i) = STRENGTH_MAP('0', strn)
                    and (Data(i)='0' or Data(i)='L' or enable_flag=0)) then
                       next;
                elsif ((Data(i)='0' or Data(i)='L') and enable_flag=1) then
                       nextstate(i) :=  STRENGTH_MAP('0', strn);
                else
                       nextstate(i) := STRENGTH_MAP('X', strn);
                end if;
	end case;

        if (next_assign_val(i) = nextstate(i)) then
            next;
        end if;

	-- compute delay
        case TWOBIT'(currentstate(i) & nextstate(i)) is
            when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		 "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
		 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
					  "11"|"1H"|"HH"|"H1"      =>
                     delta := 0 ns;
            when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				"0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
				"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                     delta := tLH;
            when others =>
                     delta := tHL;
        end case;

        currentstate(i) <= nextstate(i) after delta;
        Output(i) <= nextstate(i) after delta;
        next_assign_val(i) := nextstate(i);

    end loop;

    wait on Data, Enable, Reset;
    end process P;
end A;



library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of DLATREG is
    attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_DLATREG_BI of DLATREG is
    for BI
    end for;
end;

configuration CFG_DLATREG_A of DLATREG is
    for A
    end for;
end;



----------------------------------------------------------------------------
--
--	Primitive name: DLATREGL
--
--	Purpose: An N-bit level sensitive register. (Reset active low)
--
--	Truth table:  ----------------------------------------------
--		      |  Data   Enable  Reset  |  Output           |
--		      |--------------------------------------------|
--		      |   *       *       U    |    U              |
--		      |   *       *       0    |    0              |
--		      |   *       U      ~0    |    U              |
--		      |   *      ~U       X    | X or U or 0 or NC |(Note 1)
--		      |   *       X       1    | X or U or NC      |(Note 2)
--		      |   *       1       1    |   Data            |
--		      |   *       0       1    |    NC             |
--		      ----------------------------------------------
--		      ~ = not equal;    * = don't care;   NC = no change
--		      0 = '0' or 'L';   1 = '1' or 'H';   U = 'U';
--		      X = 'X', 'W', 'Z', or '-';
--		      (The truth table rows are in order of decreasing precedence)
--
--		      Note 1: if ((Output already == 0) and not((Data != 0)
--				   and ((Enable == X) or (Enable == 1))))
--				      (no change);
--			      else if ((Data == 0) and (Enable == 1))
--			              Output := 0;
--			      else if (((Output already == U) and (Enable != 1))
--				       or ((Data == U) and Enable != 0))
--			              Output := U;
--			      else
--				      Output := X;
--
--		      Note 2: if ((Output already == Data) or
--				  (Output already == U))
--				      (no change);
--			      else if (Data == U)
--				      Output := U;
--			      else
--				      Output := X;
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity DLATREGL is
    generic (N: Positive :=1;             -- N bit register
             tLH: Time :=  0 ns;          -- rise inertial delay
             tHL: Time :=  0 ns;          -- fall inertial delay
             strn: STRENGTH := strn_X01;  -- output strength
         	 tHOLD : Time := 0 ns;        -- Hold time
             tSetUp : Time := 0 ns;       -- Setup time
             tPwHighMin : Time := 0 ns;   -- min pulse width when enable is high
             tPwLowMin : Time := 0 ns);   -- min pulse width when enable is low
    port    (Data: in STD_LOGIC_VECTOR (N-1 downto 0);-- data input
             Enable,                                   -- enable input
             Reset: in STD_LOGIC;                     -- reset input
             Output: out STD_LOGIC_VECTOR (N-1 downto 0));  -- output
end DLATREGL;


architecture A of DLATREGL is
    signal currentstate: STD_LOGIC_VECTOR (Data'RANGE);
    subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

begin
    P: process
        variable nextstate: STD_LOGIC_VECTOR (Data'RANGE);
        variable next_assign_val: STD_LOGIC_VECTOR (Data'RANGE);
        variable delta: Time := 0 ns;
   	variable enable_flag : integer := 0;

    begin
    -- evaluate logical function
    case Enable is
        when '1' | 'H' =>
            enable_flag := 1;
        when '0' | 'L' =>
            enable_flag := 0;
        when 'U' =>
            enable_flag := 3;
        when others =>
            enable_flag := 2;
    end case;

    for i in Data'RANGE loop
        case Reset is
            when 'U' =>
                nextstate(i) :=  'U';
            when '0' | 'L' =>
                nextstate(i) :=  STRENGTH_MAP('0', strn);
            when '1' | 'H' =>
                case enable_flag is
                    when 0 =>
                        exit;
              	    when 3 =>
                        nextstate(i) := 'U';
              	    when 1 =>
                        nextstate(i) := STRENGTH_MAP(Data(i), strn);
                    when others =>
			if (next_assign_val(i) = STRENGTH_MAP(Data(i),strn)
					     or next_assign_val(i) = 'U') then
                     	    next;
			elsif (Data(i) = 'U') then
			    nextstate(i) :=  'U';
            		else
                            nextstate(i) := STRENGTH_MAP('X', strn);
            		end if;
                end case;
            when 'X' | 'W' | 'Z' | '-' =>
                if ((enable_flag = 3) or
		    (next_assign_val(i) = 'U' and not(enable_flag = 1)) or
		    (Data(i) = 'U' and not(enable_flag = 0))) then
                       nextstate(i) :=  'U';
                elsif (next_assign_val(i) = STRENGTH_MAP('0', strn)
                    and (Data(i)='0' or Data(i)='L' or enable_flag=0)) then
                       next;
                elsif ((Data(i)='0' or Data(i)='L') and enable_flag=1) then
                       nextstate(i) :=  STRENGTH_MAP('0', strn);
                else
                       nextstate(i) := STRENGTH_MAP('X', strn);
                end if;
	end case;

        if (next_assign_val(i) = nextstate(i)) then
            next;
        end if;

	-- compute delay
        case TWOBIT'(currentstate(i) & nextstate(i)) is
            when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		 "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
		 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
					  "11"|"1H"|"HH"|"H1"      =>
                     delta := 0 ns;
            when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				"0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
				"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                     delta := tLH;
            when others =>
                     delta := tHL;
        end case;

        currentstate(i) <= nextstate(i) after delta;
        Output(i) <= nextstate(i) after delta;
        next_assign_val(i) := nextstate(i);

    end loop;

    wait on Data, Enable, Reset;
    end process P;
end A;



library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of DLATREGL is
    attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_DLATREGL_BI of DLATREGL is
    for BI
    end for;
end;

configuration CFG_DLATREGL_A of DLATREGL is
    for A
    end for;
end;



----------------------------------------------------------------------------
--
--  Primitive name: DLATREGSRH
--
--  Purpose: An N-bit level sensitive register. (Reset & Set active high)
--
--  Truth table:  --------------------------------------------------
--  	          | Data   Enable  Reset   Set |  Output           |
--		  |------------------------------------------------|
--		  |   *      *       *      U  |    U              |
--		  |   *      *       U     ~1  |    U              |
--		  |   *      *       *      1  |    1              |
--		  |   *      *       1      0  |    0              |
--		  |   *      *       1      X  |    X              |
--		  |   *      U      ~1     ~1  |    U              |
--		  |   *     ~U       X      X  | X or U            |(Note 1)
--		  |   *     ~U       0      X  | X or U or 1 or NC |(Note 2)
--		  |   *     ~U       X      0  | X or U or 0 or NC |(Note 3)
--		  |   *      X       0      0  | X or U or NC      |(Note 4)
--		  |   *      1       0      0  |   Data            |
--		  |   *      0       0      0  |    NC             |
--		  --------------------------------------------------
--		  ~ = not equal;    * = don't care;   NC = no change
--		  0 = '0' or 'L';   1 = '1' or 'H';   U = 'U';
--		  X = 'X', 'W', 'Z', or '-';
--		  (The truth table rows are in order of decreasing precedence)
--
--		  Note 1: if (((Output already == U) and (Enable != 1)) or
--			      ((Data == U) and (Enable != 0)))
--				      Output := U;
--			  else
--				      Output := X;
--
--		  Note 2: if ((Output already == 1) and not((Data != 1)
--			       and ((Enable == X) or (Enable == 1))))
--				      Output := 1;
--			  else if ((Data == 1) and (Enable == 1))
--			              Output := 1;
--			  else if ((Output already == U) and (Enable != 1))
--			              Output := U;
--			  else
--				      Output := X;
--
--		  Note 3: if ((Output already == 0) and not((Data != 0)
--			       and ((Enable == X) or (Enable == 1))))
--				      Output := 0;
--			  else if ((Data == 0) and (Enable == 1))
--			              Output := 0;
--			  else if ((Output already == U) and (Enable != 1))
--			              Output := U;
--			  else
--				      Output := X;
--
--		  Note 4: if ((Output already == Data) or
--			      (Output already == U))
--				      (no change);
--			  else if (Data == U)
--				      Output := U;
--			  else
--				      Output := X;
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity DLATREGSRH is
    generic (N: Positive :=1;             -- N bit register
             tLH: Time :=  0 ns;          -- rise inertial delay
             tHL: Time :=  0 ns;          -- fall inertial delay
             strn: STRENGTH := strn_X01;  -- output strength
         	 tHOLD : Time := 0 ns;        -- Hold time
             tSetUp : Time := 0 ns;       -- Setup time
             tPwHighMin : Time := 0 ns;   -- min pulse width when enable is high
             tPwLowMin : Time := 0 ns);   -- min pulse width when enable is low
    port    (Data: in STD_LOGIC_VECTOR (N-1 downto 0);-- data input
             Enable,                                    -- enable input
             Reset,   		                       -- reset input
             Set: in STD_LOGIC;                       -- set input
             Output: out STD_LOGIC_VECTOR (N-1 downto 0));  -- output
end DLATREGSRH;


architecture A of DLATREGSRH is
    signal currentstate: STD_LOGIC_VECTOR (Data'RANGE);
    subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

begin
    P: process
        variable nextstate: STD_LOGIC_VECTOR (Data'RANGE);
        variable next_assign_val: STD_LOGIC_VECTOR (Data'RANGE);
        variable delta: Time := 0 ns;
   	variable enable_flag : integer := 0;

    begin
    -- evaluate logical function
    case Enable is
        when '1' | 'H' =>
            enable_flag := 1;
        when '0' | 'L' =>
            enable_flag := 0;
        when 'U' =>
            enable_flag := 3;
        when others =>
            enable_flag := 2;
    end case;

    for i in Data'RANGE loop
	case TWOBIT'(Reset & Set) is
	    when "UU"|"UX"|"U0"|"U1"|"UZ"|"UW"|"UL"|"UH"|"U-"|
		      "XU"|"0U"|"1U"|"ZU"|"WU"|"LU"|"HU"|"-U"  =>
		nextstate(i) :=  'U';
	    when "X1"|"01"|"11"|"Z1"|"W1"|"L1"|"H1"|"-1"|
		 "XH"|"0H"|"1H"|"ZH"|"WH"|"LH"|"HH"|"-H"       =>
		nextstate(i) :=  STRENGTH_MAP('1', strn);
	    when "10"|"1L"|"H0"|"HL"			       =>
		nextstate(i) :=  STRENGTH_MAP('0', strn);
	    when "XX"|"XZ"|"XW"|"X-"|"ZX"|"ZZ"|"ZW"|"Z-"|
		 "WX"|"WZ"|"WW"|"W-"|"-X"|"-Z"|"-W"|"--"       =>
                if ((enable_flag = 3) or
		    (next_assign_val(i) = 'U' and not(enable_flag = 1)) or
		    (Data(i) = 'U' and not(enable_flag = 0))) then
                       nextstate(i) := 'U';
                else
                       nextstate(i) := STRENGTH_MAP('X', strn);
                end if;
	    when "0X"|"0Z"|"0W"|"0-"|"LX"|"LZ"|"LW"|"L-"       =>
                if ((enable_flag = 3) or
		    (next_assign_val(i) = 'U' and not(enable_flag = 1)) or
		    (Data(i) = 'U' and not(enable_flag = 0))) then
                       nextstate(i) := 'U';
                elsif (next_assign_val(i) = STRENGTH_MAP('1', strn)
                    and (Data(i)='1' or Data(i)='H' or enable_flag=0)) then
                       next;
                elsif ((Data(i)='1' or Data(i)='H') and enable_flag=1) then
                       nextstate(i) :=  STRENGTH_MAP('1', strn);
                else
                       nextstate(i) := STRENGTH_MAP('X', strn);
                end if;
	    when "1X"|"1Z"|"1W"|"1-"|"HX"|"HZ"|"HW"|"H-"       =>
                nextstate(i) := STRENGTH_MAP('X', strn);
	    when "X0"|"Z0"|"W0"|"-0"|"XL"|"ZL"|"WL"|"-L"       =>
                if ((enable_flag = 3) or
		    (next_assign_val(i) = 'U' and not(enable_flag = 1)) or
		    (Data(i) = 'U' and not(enable_flag = 0))) then
                       nextstate(i) := 'U';
                elsif (next_assign_val(i) = STRENGTH_MAP('0', strn)
                    and (Data(i)='0' or Data(i)='L' or enable_flag=0)) then
                       next;
                elsif ((Data(i)='0' or Data(i)='L') and enable_flag=1) then
                       nextstate(i) :=  STRENGTH_MAP('0', strn);
                else
                       nextstate(i) := STRENGTH_MAP('X', strn);
                end if;
	    when "00"|"0L"|"L0"|"LL"			       =>
                case enable_flag is
                    when 0 =>
                        exit;
              	    when 3 =>
                        nextstate(i) := 'U';
              	    when 1 =>
                        nextstate(i) := STRENGTH_MAP(Data(i), strn);
                    when others =>	-- X-Trans
			if (next_assign_val(i) = STRENGTH_MAP(Data(i),strn)
					    or next_assign_val(i) = 'U') then
                     	    next;
			elsif (Data(i) = 'U') then
			    nextstate(i) :=  'U';
            		else
                            nextstate(i) := STRENGTH_MAP('X', strn);
            		end if;
                end case;
        end case;

        if (next_assign_val(i) = nextstate(i)) then
            next;
        end if;

	-- compute delay
        case TWOBIT'(currentstate(i) & nextstate(i)) is
            when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		 "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
		 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
					  "11"|"1H"|"HH"|"H1"      =>
                     delta := 0 ns;
            when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				"0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
				"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                     delta := tLH;
            when others =>
                     delta := tHL;
        end case;

        currentstate(i) <= nextstate(i) after delta;
        Output(i) <= nextstate(i) after delta;
        next_assign_val(i) := nextstate(i);

    end loop;

    wait on Data, Enable, Reset, Set;
    end process P;
end A;



library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of DLATREGSRH is
    attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_DLATREGSRH_BI of DLATREGSRH is
    for BI
    end for;
end;

configuration CFG_DLATREGSRH_A of DLATREGSRH is
    for A
    end for;
end;



----------------------------------------------------------------------------
--
--  Primitive name: DLATREGSRHL
--
--  Purpose: An N-bit level sensitive register. (Reset & Set active low)
--
--  Truth table:  --------------------------------------------------
--  	          | Data   Enable  Reset   Set |  Output           |
--		  |------------------------------------------------|
--		  |   *      *       *      U  |    U              |
--		  |   *      *       U     ~0  |    U              |
--		  |   *      *       *      0  |    1              |
--		  |   *      *       0      1  |    0              |
--		  |   *      *       0      X  |    X              |
--		  |   *      U      ~0     ~0  |    U              |
--		  |   *     ~U       X      X  | X or U            |(Note 1)
--		  |   *     ~U       1      X  | X or U or 1 or NC |(Note 2)
--		  |   *     ~U       X      1  | X or U or 0 or NC |(Note 3)
--		  |   *      X       1      1  | X or U or NC      |(Note 4)
--		  |   *      1       1      1  |   Data            |
--		  |   *      0       1      1  |    NC             |
--		  --------------------------------------------------
--		  ~ = not equal;    * = don't care;   NC = no change
--		  0 = '0' or 'L';   1 = '1' or 'H';   U = 'U';
--		  X = 'X', 'W', 'Z', or '-';
--		  (The truth table rows are in order of decreasing precedence)
--
--		  Note 1: if (((Output already == U) and (Enable != 1)) or
--			      ((Data == U) and (Enable != 0)))
--				      Output := U;
--			  else
--				      Output := X;
--
--		  Note 2: if ((Output already == 1) and not((Data != 1)
--			       and ((Enable == X) or (Enable == 1))))
--				      Output := 1;
--			  else if ((Data == 1) and (Enable == 1))
--			              Output := 1;
--			  else if ((Output already == U) and (Enable != 1))
--			              Output := U;
--			  else
--				      Output := X;
--
--		  Note 3: if ((Output already == 0) and not((Data != 0)
--			       and ((Enable == X) or (Enable == 1))))
--				      Output := 0;
--			  else if ((Data == 0) and (Enable == 1))
--			              Output := 0;
--			  else if ((Output already == U) and (Enable != 1))
--			              Output := U;
--			  else
--				      Output := X;
--
--		  Note 4: if ((Output already == Data) or
--			      (Output already == U))
--				      (no change);
--			  else if (Data == U)
--				      Output := U;
--			  else
--				      Output := X;
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity DLATREGSRL is
    generic (N: Positive :=1;             -- N bit register
             tLH: Time :=  0 ns;          -- rise inertial delay
             tHL: Time :=  0 ns;          -- fall inertial delay
             strn: STRENGTH := strn_X01;  -- output strength
         	 tHOLD : Time := 0 ns;        -- Hold time
             tSetUp : Time := 0 ns;       -- Setup time
             tPwHighMin : Time := 0 ns;   -- min pulse width when enable is high
             tPwLowMin : Time := 0 ns);   -- min pulse width when enable is low
    port    (Data: in STD_LOGIC_VECTOR (N-1 downto 0);-- data input
             Enable,                                    -- enable input
             Reset,   		                       -- reset input
             Set: in STD_LOGIC;                       -- set input
             Output: out STD_LOGIC_VECTOR (N-1 downto 0));  -- output
end DLATREGSRL;


architecture A of DLATREGSRL is
    signal currentstate: STD_LOGIC_VECTOR (Data'RANGE);
    subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

begin
    P: process
        variable nextstate: STD_LOGIC_VECTOR (Data'RANGE);
        variable next_assign_val: STD_LOGIC_VECTOR (Data'RANGE);
        variable delta: Time := 0 ns;
   	variable enable_flag : integer := 0;

    begin
    -- evaluate logical function
    case Enable is
        when '1' | 'H' =>
            enable_flag := 1;
        when '0' | 'L' =>
            enable_flag := 0;
        when 'U' =>
            enable_flag := 3;
        when others =>
            enable_flag := 2;
    end case;

    for i in Data'RANGE loop
	case TWOBIT'(Reset & Set) is
	    when "UU"|"UX"|"U0"|"U1"|"UZ"|"UW"|"UL"|"UH"|"U-"|
		      "XU"|"0U"|"1U"|"ZU"|"WU"|"LU"|"HU"|"-U"  =>
		nextstate(i) :=  'U';
	    when "X0"|"00"|"10"|"Z0"|"W0"|"L0"|"H0"|"-0"|
		 "XL"|"0L"|"1L"|"ZL"|"WL"|"LL"|"HL"|"-L"       =>
		nextstate(i) :=  STRENGTH_MAP('1', strn);
	    when "01"|"L1"|"0H"|"LH"			       =>
		nextstate(i) :=  STRENGTH_MAP('0', strn);
	    when "XX"|"XZ"|"XW"|"X-"|"ZX"|"ZZ"|"ZW"|"Z-"|
		 "WX"|"WZ"|"WW"|"W-"|"-X"|"-Z"|"-W"|"--"       =>
                if ((enable_flag = 3) or
		    (next_assign_val(i) = 'U' and not(enable_flag = 1)) or
		    (Data(i) = 'U' and not(enable_flag = 0))) then
                       nextstate(i) := 'U';
                else
                       nextstate(i) := STRENGTH_MAP('X', strn);
                end if;
	    when "1X"|"1Z"|"1W"|"1-"|"HX"|"HZ"|"HW"|"H-"       =>
                if ((enable_flag = 3) or
		    (next_assign_val(i) = 'U' and not(enable_flag = 1)) or
		    (Data(i) = 'U' and not(enable_flag = 0))) then
                       nextstate(i) := 'U';
                elsif (next_assign_val(i) = STRENGTH_MAP('1', strn)
                    and (Data(i)='1' or Data(i)='H' or enable_flag=0)) then
                       next;
                elsif ((Data(i)='1' or Data(i)='H') and enable_flag=1) then
                       nextstate(i) :=  STRENGTH_MAP('1', strn);
                else
                       nextstate(i) := STRENGTH_MAP('X', strn);
                end if;
	    when "0X"|"0Z"|"0W"|"0-"|"LX"|"LZ"|"LW"|"L-"       =>
                nextstate(i) := STRENGTH_MAP('X', strn);
	    when "X1"|"Z1"|"W1"|"-1"|"XH"|"ZH"|"WH"|"-H"       =>
                if ((enable_flag = 3) or
		    (next_assign_val(i) = 'U' and not(enable_flag = 1)) or
		    (Data(i) = 'U' and not(enable_flag = 0))) then
                       nextstate(i) := 'U';
                elsif (next_assign_val(i) = STRENGTH_MAP('0', strn)
                    and (Data(i)='0' or Data(i)='L' or enable_flag=0)) then
                       next;
                elsif ((Data(i)='0' or Data(i)='L') and enable_flag=1) then
                       nextstate(i) :=  STRENGTH_MAP('0', strn);
                else
                       nextstate(i) := STRENGTH_MAP('X', strn);
                end if;
	    when "11"|"1H"|"H1"|"HH"			       =>
                case enable_flag is
                    when 0 =>
                        exit;
              	    when 3 =>
                        nextstate(i) := 'U';
              	    when 1 =>
                        nextstate(i) := STRENGTH_MAP(Data(i), strn);
                    when others =>
			if (next_assign_val(i) = STRENGTH_MAP(Data(i),strn)
					    or next_assign_val(i) = 'U') then
                     	    next;
			elsif (Data(i) = 'U') then
			    nextstate(i) :=  'U';
            		else
                            nextstate(i) := STRENGTH_MAP('X', strn);
            		end if;
                end case;
        end case;

        if (next_assign_val(i) = nextstate(i)) then
            next;
        end if;

	-- compute delay
        case TWOBIT'(currentstate(i) & nextstate(i)) is
            when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		 "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
		 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
					  "11"|"1H"|"HH"|"H1"      =>
                     delta := 0 ns;
            when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				"0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
				"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                     delta := tLH;
            when others =>
                     delta := tHL;
        end case;

        currentstate(i) <= nextstate(i) after delta;
        Output(i) <= nextstate(i) after delta;
        next_assign_val(i) := nextstate(i);

    end loop;

    wait on Data, Enable, Reset, Set;
    end process P;
end A;



library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of DLATREGSRL is
    attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_DLATREGSRL_BI of DLATREGSRL is
    for BI
    end for;
end;

configuration CFG_DLATREGSRL_A of DLATREGSRL is
    for A
    end for;
end;




----------------------------------------------------------------------------
--
--	Primitive name: DLATRAM
--
--	Purpose: A level sensitive random access memory model.
--
--	Function:
--        (note: 0 = '0'|'L'; 1 = '1'|'H'; X = 'U'|'X'|'W'|'Z'|'-')
--
--        1. Read operation:
--		a. RE = 0 --> DATAout = 'Z's
--		b. RE = 1, and no X in ADDR --> DATAout = m(ADDR)
--		c. RE = 1, and X in ADDR --> DATAout = 'X'es.
--		d. RE = X --> DATAout = 'X'es
--
--	  2. Write operation:
--		a. WE = 0 --> no write
--		b. WE = 1, and no X in ADDR --> m(ADDR) = DATAin
--		c. WE = X, and no X in ADDR --> m(ADDR) = 'X'es
--		d. WE = 1 | X, and X in ADDR --> WARNING issued
--		e. WE = 1, and ADDR changes --> WARNING issued, do b. or d..
--
--	  3. simultaneous read/write operations: allowed.
--
--	  4. Initialization: m() = 'U's.
--
--	  5. Output strength: mapping according to parameter strn
--			      (default strn = strn_X01).
--
--	  6. Timing: output rising and falling delays are set to DATAout
--		     (deault tLH = tHL = 0 ns).
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_MISC.all;

entity DLATRAM is
    generic (Ndata: Positive := 1;	          -- # of data I/O lines
	     Naddr: Positive := 1;		  -- # of address lines
	     tLH: time := 0 ns;			  -- output rising delay
	     tHL: time := 0 ns;			  -- output fulling delay
	     strn: STRENGTH := strn_X01);	  -- output strength
    port    (DATAin: in STD_LOGIC_VECTOR(Ndata-1 downto 0);    -- data in
	     DATAout: out STD_LOGIC_VECTOR(Ndata-1 downto 0);  -- data out
	     ADDR: in STD_LOGIC_VECTOR(Naddr-1 downto 0);      -- address
	     WE: in STD_LOGIC;		          -- write enable(active high)
	     RE: in STD_LOGIC);		  -- read enable(active high)

end DLATRAM;

architecture A of DLATRAM is
	signal currentstate: STD_LOGIC_VECTOR (DATAout'RANGE);
begin
    --
    -- assertion for changes in address lines
    --
    Assertion: process (ADDR)
        begin
	    assert not(WE = '1' or WE = 'H')
	        report "Address lines changed while RAM is Write Enabled"
	        severity WARNING;
	end process;

    --
    -- the memory model
    --
    P: process
	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);
	subtype ETYPE is STD_LOGIC_VECTOR(DATAin'RANGE);
	type MEMTYPE is array (NATURAL range <>) of ETYPE;
	variable m: MEMTYPE(0 to 2**ADDR'length-1) := (others => (others=>'U'));
	variable nextstate: STD_LOGIC_VECTOR (DATAout'RANGE);
	variable next_assign_val: STD_LOGIC_VECTOR (DATAout'RANGE);
	variable delta: Time := 0 ns;

	procedure do_read is
	    variable mem_word: ETYPE;
	begin
	    for i in ADDR'RANGE loop
		if (ADDR(i) = 'X' or ADDR(i) = 'W' or ADDR(i) = 'Z' or
		                     ADDR(i) = 'U' or ADDR(i) = '-') then
		    nextstate := (others => STRENGTH_MAP('X', strn));
		    return;
		end if;
	    end loop;
	    mem_word := m(CONV_INTEGER(UNSIGNED(ADDR)));
	    for i in nextstate'RANGE loop
		nextstate(i) := STRENGTH_MAP( mem_word(i), strn);
	    end loop;
	end do_read;

	procedure do_write(data: ETYPE) is
	    variable xdata: ETYPE := data;
	begin
	    for i in ADDR'RANGE loop
		if (ADDR(i) = 'X' or ADDR(i) = 'W' or ADDR(i) = 'Z' or
		                     ADDR(i) = 'U' or ADDR(i) = '-') then
		    assert false
			report "Attempted write to bad RAM address"
			severity WARNING;
		    return;
		end if;
	    end loop;
	    for i in xdata'RANGE loop
		case xdata(i) is
		when 'L' => xdata(i) := '0';
		when 'H' => xdata(i) := '1';
		when 'Z' | 'W' | '-' => xdata(i) := 'X';
		when others => null;
		end case;
	    end loop;
	    m(CONV_INTEGER(UNSIGNED(ADDR))) := xdata;
	end do_write;

    begin
    	-- The variable m and the port DATAout are initialized correctly
    	-- at elaboration time.  This makes it best to wait at the top
    	-- of the process.
    	wait on WE, RE, DATAin, ADDR;

	if (WE'event or DATAin'event or ADDR'event) then
	    if (WE = '1' or WE = 'H') then
		do_write(DATAin);
	    elsif (WE = 'X' or WE = 'W' or WE = 'Z' or WE = 'U' or WE = '-') then
		do_write((DATAin'RANGE => 'X'));
	    end if;
	end if;

	if (RE = '0' or RE = 'L') then
	    nextstate := (others => 'Z');
	elsif (RE = '1' or RE = 'H') then
	    do_read;
	else -- (RE = 'X' or RE = 'W' or RE = 'Z' or RE = 'U' or RE = '-')
	    nextstate := (others => STRENGTH_MAP('X',strn));
	end if;

	if (nextstate /= next_assign_val) then

	    for i in DATAout'RANGE loop
	        if (nextstate(i) = next_assign_val(i)) then
	            next;
		end if;

		-- compute delay
                case TWOBIT'(currentstate(i) & nextstate(i)) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := 0 ns;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
                    when others =>
                             delta := tHL;
                end case;

		-- assign new value after internal delay
		currentstate(i) <= nextstate(i) after delta;
		DATAout(i) <= nextstate(i) after delta;
		next_assign_val(i) := nextstate(i);
	    end loop;
	end if;

    end process;

end A;

configuration CFG_DLATRAM_A of DLATRAM is
	for A
	end for;
end;



----------------------------------------------------------------------------
--
--	Primitive name: DLATROM
--
--	Purpose: A level sensitive read only memory model.
--
--	Function:
--        (note: 0 = '0'|'L'; 1 = '1'|'H'; X = 'U'|'X'|'W'|'Z'|'-')
--
--        1. Read operation:
--		a. RE = 0 --> DATA = 'Z's
--		b. RE = 1, and no X in ADDR --> DATA = m(ADDR)
--		c. RE = 1, and X in ADDR --> DATA = 'X'es.
--		d. RE = X --> DATA = 'X'es
--
--	  2. Initialization: m() = 'U's.
--
--	  3. Output strength: mapping according to parameter strn
--			      (default strn = strn_X01).
--
--	  4. Timing: output rising and falling delays are set to DATA
--		     (deault tLH = tHL = 0 ns).
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_MISC.all;

entity DLATROM is
    generic (Ndata: Positive := 1;	          -- # of data lines
	     Naddr: Positive := 1;		  -- # of address lines
	     tLH: time := 0 ns;			  -- output rising delay
	     tHL: time := 0 ns;			  -- output fulling delay
	     strn: STRENGTH := strn_X01);	  -- output strength
    port    (DATA: out STD_LOGIC_VECTOR(Ndata-1 downto 0);     -- data out
	     ADDR: in STD_LOGIC_VECTOR(Naddr-1 downto 0);      -- address
	     RE: in STD_LOGIC);		  -- read enable(active high)

end DLATROM;

architecture A of DLATROM is
	signal currentstate: STD_LOGIC_VECTOR (DATA'RANGE);
begin
    --
    -- the memory model
    --
    P: process
	subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);
	subtype ETYPE is STD_LOGIC_VECTOR(DATA'RANGE);
	type MEMTYPE is array (NATURAL range <>) of ETYPE;
	variable m: MEMTYPE(0 to 2**ADDR'length-1) := (others => (others=>'U'));
	variable nextstate: STD_LOGIC_VECTOR (DATA'RANGE);
	variable next_assign_val: STD_LOGIC_VECTOR (DATA'RANGE);
	variable delta: Time := 0 ns;

	procedure do_read is
	    variable mem_word: ETYPE;
	begin
	    for i in ADDR'RANGE loop
		if (ADDR(i) = 'X' or ADDR(i) = 'W' or ADDR(i) = 'Z' or
		                     ADDR(i) = 'U' or ADDR(i) = '-') then
		    nextstate := (others => STRENGTH_MAP('X', strn));
		    return;
		end if;
	    end loop;
	    mem_word := m(CONV_INTEGER(UNSIGNED(ADDR)));
	    for i in nextstate'RANGE loop
		nextstate(i) := STRENGTH_MAP( mem_word(i), strn);
	    end loop;
	end do_read;

    begin
    	-- The variable m and the port DATA are initialized correctly
    	-- at elaboration time.  This makes it best to wait at the top
    	-- of the process.
    	wait on RE, ADDR;

	if (RE = '0' or RE = 'L') then
	    nextstate := (others => 'Z');
	elsif (RE = '1' or RE = 'H') then
	    do_read;
	else -- (RE = 'X' or RE = 'W' or RE = 'Z' or RE = 'U' or RE = '-')
	    nextstate := (others => STRENGTH_MAP('X',strn));
	end if;

	if (nextstate /= next_assign_val) then

	    for i in DATA'RANGE loop
	        if (nextstate(i) = next_assign_val(i)) then
	            next;
		end if;

		-- compute delay
                case TWOBIT'(currentstate(i) & nextstate(i)) is
                    when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
		         "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
			 "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
						  "11"|"1H"|"HH"|"H1"      =>
                             delta := 0 ns;
                    when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
				        "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
					"LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                             delta := tLH;
                    when others =>
                             delta := tHL;
                end case;

		-- assign new value after internal delay
		currentstate(i) <= nextstate(i) after delta;
		DATA(i) <= nextstate(i) after delta;
		next_assign_val(i) := nextstate(i);
	    end loop;
	end if;

    end process;

end A;

configuration CFG_DLATROM_A of DLATROM is
	for A
	end for;
end;



----------------------------------------------------------------------------
--
--	Primitive name: SUHDCK
--
--	Purpose: A setup/hold time checker.
--
--	Assertion condition:
--		when Clock changes from (0 | L) to (1 | H)
--			assert Data'last_event >= tSetup
--		        report "Setup time violation on data input lines."
--
--		when Data changes
--		     	assert Clock did not rise for tHold time
--		        report "Hold time violation on data input lines."
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity SUHDCK is
	generic (N: Positive := 1;		-- number of data lines
		 tSetup,			-- setup time
		 tHold: Time := 0 ns);			-- hold time
	port (Data:  in STD_LOGIC_VECTOR (1 to N);	-- data lines
	      Clock: in STD_LOGIC);			-- clock line
end SUHDCK;

architecture A of SUHDCK is
	signal clock_edge: Boolean := FALSE;
begin
    err_chk: process(Clock, Data)
        variable normal: Boolean;
	variable setup_time, hold_time: Time;
    begin
	setup_time := tSetup;
	hold_time  := tHold;
        normal := (setup_time >= 0 ns and hold_time >= 0 ns);
        assert normal
	report "Negative setup/hold time passed to setup/hold checker";
    end process;

    clk_edge: process(Clock)
    begin
        if (Clock = '1' or Clock = 'H') and
	   (Clock'last_value = '0' or Clock'last_value = 'L') then
	        -- record the clock trigger edge event
	        clock_edge <= not clock_edge;
	end if;
    end process;

    setup_chk: process(Clock)
	variable violation: Boolean;
	variable setup_time: Time;
    begin
	setup_time := tSetup;
	violation := (((Clock = '1') or (Clock = 'H')) and
		      ((Clock'last_value = '0') or (Clock'last_value = 'L'))
		      and (Data'last_event < setup_time));

	assert not violation
	report "Setup time violation on data input lines."
	severity WARNING;
    end process;

    hold_chk: process(Data)
	variable normal: Boolean;
	variable hold_time: Time;
    begin
	hold_time := tHold;
	normal := (clock_edge'last_event >= hold_time);
	assert normal
	report "Hold time violation on data input lines."
	severity WARNING;
    end process;

end A;

configuration CFG_SUHDCK_A of SUHDCK is
	for A
	end for;
end;




----------------------------------------------------------------------------
--
--	Primitive name: MPWCK
--
--	Purpose: A minimum pulse width checker.
--
--	Assertion condition:
--		when Clock changes from high
--			assert Clock'last_event >= tHigh
--			report "Minimum pulse width violation on clock high."
--
--		when Clock changes from low
--			assert Clock'last_event >= tLow
--			report "Minimum pulse width violation on clock low."
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity MPWCK is
	generic (tHigh,			-- pulse's high time
		 tLow: Time := 0 ns);	-- pulse's low time
	port (Clock: in STD_LOGIC);		-- clock line
end MPWCK;

architecture A of MPWCK is
begin

        err_chk: process(Clock)
	    variable normal: Boolean;
	    variable high_time, low_time: Time;
        begin
	    high_time := tHigh;
	    low_time  := tLow;
	    normal := (high_time >= 0 ns and low_time >= 0 ns);
  	    assert normal
	    report "Negative High/Low time passed to pulse width checker";
        end process;

	process(Clock)
	    variable normal_high, normal_low: Boolean;
	    variable high_time, low_time: Time;
	begin
	    high_time := tHigh;
	    low_time  := tLow;

	    if (Clock'last_value = '0') or (Clock'last_value = 'L') then
		    normal_low  := Clock'delayed(0 ns)'last_event >= low_time;
	            assert normal_low
		    report "Minimum pulse width violation on clock low."
		    severity WARNING;
	    elsif (Clock'last_value = '1') or (Clock'last_value = 'H') then
		    normal_high  := Clock'delayed(0 ns)'last_event >= high_time;
		    assert normal_high
		    report "Minimum pulse width violation on clock high."
		    severity WARNING;
	    end if;
	end process;

end A;

configuration CFG_MPWCK_A of MPWCK is
	for A
	end for;
end;




----------------------------------------------------------------------------
--
--	Primitive name: RECOVCK
--
--	Purpose: A recovery time checker.  Check for reset (active low)
--		 releasing too close to clock triggering edge.
--
--	Assertion condition:
--		when Clock changes from (0 | L) to (1 | H)
--		     	assert Reset did not rise for tSetup time
--		        report "Recovery setup time violation on reset/clock lines."
--		when Reset changes from (0 | L) to (1 | H)
--		     	assert Clock did not rise for tHold time
--		        report "Recovery hold time violation on reset/clock lines."
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity RECOVCK is
	generic (tSetup,		-- setup time
		 tHold: Time := 0 ns);	-- hold time
	port (Reset,			-- Reset line
	      Clock: in STD_LOGIC);		-- clock line
end RECOVCK;

architecture A of RECOVCK is
	signal reset_rise: Boolean := FALSE;
	signal clock_edge: Boolean := FALSE;
begin
    err_chk: process(Clock)
        variable normal: Boolean;
	variable setup_time, hold_time: Time;
    begin
	setup_time := tSetup;
	hold_time  := tHold;
        normal := (setup_time >= 0 ns and hold_time >= 0 ns);
        assert normal
        report "Negative Setup/Hold time passed to Recovery checker";
    end process;

    reset_event: process(Reset)
    begin
	if (Reset = '1' or Reset = 'H') and
	   (Reset'last_value = '0' or Reset'last_value = 'L') then
		-- record the reset release event
		reset_rise <= not reset_rise;
	end if;
    end process;

    setup_chk: process(Clock)
	variable violation: Boolean;
	variable setup_time: Time;
    begin
	setup_time := tSetup;
	violation := ((Clock'last_value = '0' or Clock'last_value = 'L') and
	      (Clock = '1' or Clock = 'H') and
	      (reset_rise'last_event < setup_time));

	assert not violation
	report "Recovery setup time violation on reset/clock lines."
	severity WARNING;
    end process;

    clk_edge: process(Clock)
    begin
        if (Clock = '1' or Clock = 'H') and
	   (Clock'last_value = '0' or Clock'last_value = 'L') then
	        -- record the clock trigger edge event
	        clock_edge <= not clock_edge;
	end if;
    end process;

    hold_chk: process(Reset'delayed(0 ns))
	variable violation: Boolean;
	variable hold_time: Time;
    begin
	hold_time := tHold;
	violation := ((Reset'delayed(0 ns)'last_value = '0' or
		       Reset'delayed(0 ns)'last_value = 'L') and
		      (Reset'delayed(0 ns) = '1' or Reset'delayed(0 ns) = 'H')
		      and (clock_edge'last_event < hold_time));
	assert not violation
	report "Recovery hold time violation on reset/clock lines."
	severity WARNING;
    end process;

end A;

configuration CFG_RECOVCK_A of RECOVCK is
	for A
	end for;
end;




----------------------------------------------------------------------------
--
--	Primitive name: NXFERGATE
--
--	Purpose: A unidirectional transistor.
--
--	Truth table:	(see tbl_NXFER in the architecture)
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity NXFERGATE is
    generic (tLH, tHL: time := 0 ns);
    port (Input, Enable: in STD_LOGIC; output: Out STD_LOGIC);
end NXFERGATE;

architecture A of NXFERGATE is
    signal currentstate: STD_LOGIC := 'U';
    subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

    -- two dimensional array type
    type STD_LOGIC_TABLE is array (STD_LOGIC, STD_LOGIC) of STD_LOGIC;

        constant tbl_NXFER: STD_LOGIC_TABLE :=
    --------------------------------------------------------------------
    -- | Input  'U'  'X'  '0'  '1'  'Z'  'W'  'L'  'H'  '-'   |   Enable
    --------------------------------------------------------------------
              (('U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U'),   -- 'U'
               ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),   -- 'X'
               ('Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z'),   -- '0'
               ('U', 'X', '0', '1', 'Z', 'W', 'L', 'H', 'X'),   -- '1'
               ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),   -- 'Z'
               ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),   -- 'W'
               ('Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z'),   -- 'L'
               ('U', 'X', '0', '1', 'Z', 'W', 'L', 'H', 'X'),   -- 'H'
               ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'));  -- '-'
begin
    P: Process
	variable nextstate: STD_LOGIC;
	variable delta: time;
	variable next_assign_val: STD_LOGIC;
    begin
	nextstate := tbl_NXFER(Enable, Input);
	if (nextstate /= next_assign_val) then

	    -- compute delay
            case TWOBIT'(currentstate & nextstate) is
                when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
	             "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
		     "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
					      "11"|"1H"|"HH"|"H1"      =>
                         delta := 0 ns;
                when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
		                    "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
				    "LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                         delta := tLH;
                when others =>
                         delta := tHL;
            end case;

	    -- assign new value after internal delay
	    currentstate <= nextstate after delta;
	    Output <= nextstate after delta;
	    next_assign_val := nextstate;
	end if;

	wait on Input, Enable;
    end process P;
end A;

configuration CFG_NXFERGATE_A of NXFERGATE is
	for A
	end for;
end;




----------------------------------------------------------------------------
--
--	Primitive name: NRXFERGATE
--
--	Purpose: A unidirectional transistor. Output strength reduced.
--
--	Truth table:	(see tbl_NRXFER in the architecture)
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity NRXFERGATE is
    generic (tLH, tHL: time := 0 ns);
    port (Input, Enable: in STD_LOGIC; output: Out STD_LOGIC);
end NRXFERGATE;

architecture A of NRXFERGATE is
    signal currentstate: STD_LOGIC := 'U';
    subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

    -- two dimensional array type
    type STD_LOGIC_TABLE is array (STD_LOGIC, STD_LOGIC) of STD_LOGIC;

        constant tbl_NRXFER: STD_LOGIC_TABLE :=
    --------------------------------------------------------------------
    -- | Input  'U'  'X'  '0'  '1'  'Z'  'W'  'L'  'H'  '-'   |   Enable
    --------------------------------------------------------------------
              (('U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U'),   -- 'U'
               ('U', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'),   -- 'X'
               ('Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z'),   -- '0'
               ('U', 'W', 'L', 'H', 'Z', 'W', 'L', 'H', 'W'),   -- '1'
               ('U', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'),   -- 'Z'
               ('U', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'),   -- 'W'
               ('Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z'),   -- 'L'
               ('U', 'W', 'L', 'H', 'Z', 'W', 'L', 'H', 'W'),   -- 'H'
               ('U', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'));  -- '-'
begin
    P: Process
	variable nextstate: STD_LOGIC;
	variable delta: time;
	variable next_assign_val: STD_LOGIC;
    begin
	nextstate := tbl_NRXFER(Enable, Input);
	if (nextstate /= next_assign_val) then

	    -- compute delay
            case TWOBIT'(currentstate & nextstate) is
                when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
	             "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
		     "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
					      "11"|"1H"|"HH"|"H1"      =>
                         delta := 0 ns;
                when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
		                    "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
				    "LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                         delta := tLH;
                when others =>
                         delta := tHL;
            end case;

	    -- assign new value after internal delay
	    currentstate <= nextstate after delta;
	    Output <= nextstate after delta;
	    next_assign_val := nextstate;
	end if;

	wait on Input, Enable;
    end process P;
end A;

configuration CFG_NRXFERGATE_A of NRXFERGATE is
	for A
	end for;
end;




----------------------------------------------------------------------------
--
--	Primitive name: PXFERGATE
--
--	Purpose: A unidirectional transistor.
--
--	Truth table:	(see tbl_PXFER in the architecture)
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity PXFERGATE is
    generic (tLH, tHL: time := 0 ns);
    port (Input, Enable: in STD_LOGIC; output: Out STD_LOGIC);
end PXFERGATE;

architecture A of PXFERGATE is
    signal currentstate: STD_LOGIC := 'U';
    subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

    -- two dimensional array type
    type STD_LOGIC_TABLE is array (STD_LOGIC, STD_LOGIC) of STD_LOGIC;

        constant tbl_PXFER: STD_LOGIC_TABLE :=
    --------------------------------------------------------------------
    -- | Input  'U'  'X'  '0'  '1'  'Z'  'W'  'L'  'H'  '-'   |   Enable
    --------------------------------------------------------------------
              (('U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U'),   -- 'U'
               ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),   -- 'X'
               ('U', 'X', '0', '1', 'Z', 'W', 'L', 'H', 'X'),   -- '0'
               ('Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z'),   -- '1'
               ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),   -- 'Z'
               ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),   -- 'W'
               ('U', 'X', '0', '1', 'Z', 'W', 'L', 'H', 'X'),   -- 'L'
               ('Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z'),   -- 'H'
               ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'));  -- '-'
begin
    P: Process
	variable nextstate: STD_LOGIC;
	variable delta: time;
	variable next_assign_val: STD_LOGIC;
    begin
	nextstate := tbl_PXFER(Enable, Input);
	if (nextstate /= next_assign_val) then

	    -- compute delay
            case TWOBIT'(currentstate & nextstate) is
                when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
	             "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
		     "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
					      "11"|"1H"|"HH"|"H1"      =>
                         delta := 0 ns;
                when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
		                    "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
				    "LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                         delta := tLH;
                when others =>
                         delta := tHL;
            end case;

	    -- assign new value after internal delay
	    currentstate <= nextstate after delta;
	    Output <= nextstate after delta;
	    next_assign_val := nextstate;
	end if;

	wait on Input, Enable;
    end process P;
end A;

configuration CFG_PXFERGATE_A of PXFERGATE is
	for A
	end for;
end;




----------------------------------------------------------------------------
--
--	Primitive name: PRXFERGATE
--
--	Purpose: A unidirectional transistor. Output strength reduced.
--
--	Truth table:	(see tbl_PRXFER in the architecture)
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity PRXFERGATE is
    generic (tLH, tHL: time := 0 ns);
    port (Input, Enable: in STD_LOGIC; output: Out STD_LOGIC);
end PRXFERGATE;

architecture A of PRXFERGATE is
    signal currentstate: STD_LOGIC := 'U';
    subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

    -- two dimensional array type
    type STD_LOGIC_TABLE is array (STD_LOGIC, STD_LOGIC) of STD_LOGIC;

        constant tbl_PRXFER: STD_LOGIC_TABLE :=
    --------------------------------------------------------------------
    -- | Input  'U'  'X'  '0'  '1'  'Z'  'W'  'L'  'H'  '-'   |   Enable
    --------------------------------------------------------------------
              (('U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U'),   -- 'U'
               ('U', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'),   -- 'X'
               ('U', 'W', 'L', 'H', 'Z', 'W', 'L', 'H', 'W'),   -- '0'
               ('Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z'),   -- '1'
               ('U', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'),   -- 'Z'
               ('U', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'),   -- 'W'
               ('U', 'W', 'L', 'H', 'Z', 'W', 'L', 'H', 'W'),   -- 'L'
               ('Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z'),   -- 'H'
               ('U', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'));  -- '-'
begin
    P: Process
	variable nextstate: STD_LOGIC;
	variable delta: time;
	variable next_assign_val: STD_LOGIC;
    begin
	nextstate := tbl_PRXFER(Enable, Input);
	if (nextstate /= next_assign_val) then

	    -- compute delay
            case TWOBIT'(currentstate & nextstate) is
                when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
	             "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
		     "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
					      "11"|"1H"|"HH"|"H1"      =>
                         delta := 0 ns;
                when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
		                    "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
				    "LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                         delta := tLH;
                when others =>
                         delta := tHL;
            end case;

	    -- assign new value after internal delay
	    currentstate <= nextstate after delta;
	    Output <= nextstate after delta;
	    next_assign_val := nextstate;
	end if;

	wait on Input, Enable;
    end process P;
end A;

configuration CFG_PRXFERGATE_A of PRXFERGATE is
	for A
	end for;
end;



----------------------------------------------------------------------------
--
--	Primitive name: RESISTOR
--
--	Purpose: A device that generates resistive strength outputs.
--
--	Truth table:	(see tbl_REDUCE in the architecture)
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;

entity RESISTOR is
    generic (tLH, tHL: time := 0 ns);
    port (Input: in STD_LOGIC; output: Out STD_LOGIC);
end RESISTOR;

architecture A of RESISTOR is
    signal currentstate: STD_LOGIC := 'W';
    subtype TWOBIT is STD_LOGIC_VECTOR (0 to 1);

    -- one dimensional array type
    type STD_LOGIC_TAB1D is array (STD_LOGIC) of STD_LOGIC;

    -- truth table for reduce function
    constant tbl_REDUCE: STD_LOGIC_TAB1D :=
    -----------------------------------------------------------
    -- | Input  'U'  'X'  '0'  '1'  'Z'  'W'  'L'  'H'  '-'   |
    -----------------------------------------------------------
               ('U', 'W', 'L', 'H', 'Z', 'W', 'L', 'H', 'W' );
begin
    P: Process
	variable nextstate: STD_LOGIC;
	variable delta: time;
	variable next_assign_val: STD_LOGIC;
    begin
	nextstate := tbl_REDUCE(Input);
	if (nextstate /= next_assign_val) then

	    -- compute delay
            case TWOBIT'(currentstate & nextstate) is
                when "UU"|"UX"|"UZ"|"UW"|"U-"|"XU"|"XX"|"XZ"|"XW"|"X-"|
	             "ZU"|"ZX"|"ZZ"|"ZW"|"Z-"|"WU"|"WX"|"WZ"|"WW"|"W-"|
		     "-U"|"-X"|"-Z"|"-W"|"--"|"00"|"0L"|"LL"|"L0"|
					      "11"|"1H"|"HH"|"H1"      =>
                         delta := 0 ns;
                when "U1"|"UH"|"X1"|"XH"|"Z1"|"ZH"|"W1"|"WH"|"-1"|"-H"|
		                    "0U"|"0X"|"01"|"0Z"|"0W"|"0H"|"0-"|
				    "LU"|"LX"|"L1"|"LZ"|"LW"|"LH"|"L-" =>
                         delta := tLH;
                when others =>
                         delta := tHL;
            end case;

	    -- assign new value after internal delay
	    currentstate <= nextstate after delta;
	    Output <= nextstate after delta;
	    next_assign_val := nextstate;
	end if;

	wait on Input;
    end process P;
end A;


library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.ALL;
architecture BI of RESISTOR is
	attribute BUILTIN of BI: architecture is VHDL_SYSTEM_PRIMITIVE_STD_LOGIC;
begin
end;

configuration CFG_RESISTOR_BI of RESISTOR is
	for BI
	end for;
end;

configuration CFG_RESISTOR_A of RESISTOR is
	for A
	end for;
end;

--synopsys synthesis_on
