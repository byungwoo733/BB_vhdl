library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

package constants is
	constant CLOCK_PERIOD : time := 20 ns;

	constant XLEN : integer := 8;       -- Data length
	constant ILEN : integer := 16;      -- Instruction length

	constant RAM_BITS : integer                      := 7;
	constant ROM_BITS : integer                      := 6;
	constant TTY_ADDR : std_logic_vector(7 downto 0) := X"80";

	constant CS_RBUS : std_logic_vector(0 downto 0)   := (others => 'X'); -- Place register (CS_SREG) on bus
	constant CS_BUSR : std_logic_vector(1 downto 1)   := (others => 'X'); -- Store bus in register (CS_SREG)
	constant CS_LCKA : std_logic_vector(2 downto 2)   := (others => 'X'); -- Load value in register A
	constant CS_LCKB : std_logic_vector(3 downto 3)   := (others => 'X'); -- Load value in register B
	constant CS_LCKC : std_logic_vector(4 downto 4)   := (others => 'X'); -- Load value in register C
	constant CS_ALUF : std_logic_vector(5 downto 5)   := (others => 'X'); -- ALU function (pass/add)
	constant CS_SBUS : std_logic_vector(6 downto 6)   := (others => 'X'); -- Select which value gets placed on the bus
	constant CS_MEMR : std_logic_vector(7 downto 7)   := (others => 'X'); -- Read from memory
	constant CS_MEMW : std_logic_vector(8 downto 8)   := (others => 'X'); -- Write to memory
	constant CS_PCIN : std_logic_vector(9 downto 9)   := (others => 'X'); -- Increment PC
	constant CS_PCEN : std_logic_vector(10 downto 10) := (others => 'X'); -- Use PC as MAR
	constant CS_OPLL : std_logic_vector(11 downto 11) := (others => 'X'); -- Load lower instruction byte
	constant CS_OPHL : std_logic_vector(12 downto 12) := (others => 'X'); -- Load upper instruction byte
	constant CS_SREG : std_logic_vector(16 downto 13) := (others => 'X'); -- Register select
	constant CS_SIZE : integer                        := 17;

	function CONV_CHAR(SLV8 : std_logic_vector (7 downto 0)) return CHARACTER; -- Utility function for TTY
end package constants;

package body constants is
	function CONV_CHAR(SLV8 : std_logic_vector (7 downto 0)) return CHARACTER is
		constant XMAP : INTEGER := 0;
		variable TEMP : INTEGER := 0;
	begin
		for i in SLV8'range loop
			TEMP := TEMP*2;
			case SLV8(i) is
				when '0' | 'L' => null;
				when '1' | 'H' => TEMP := TEMP + 1;
				when others    => TEMP := TEMP + XMAP;
			end case;
		end loop;
		return CHARACTER'VAL(TEMP);
	end CONV_CHAR;

end package body constants;
