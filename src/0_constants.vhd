library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

package constants is
	constant CLOCK_PERIOD : time := 20 ns;

	constant XLEN : integer := 8;
	constant ILEN : integer := 16;

	constant RAM_BITS : integer                      := 7;
	constant ROM_BITS : integer                      := 6;
	constant TTY_ADDR : std_logic_vector(7 downto 0) := X"80";

	constant CS_RBUS : std_logic_vector(0 downto 0)   := (others => 'X');
	constant CS_BUSR : std_logic_vector(1 downto 1)   := (others => 'X');
	constant CS_LCKA : std_logic_vector(2 downto 2)   := (others => 'X');
	constant CS_LCKB : std_logic_vector(3 downto 3)   := (others => 'X');
	constant CS_LCKC : std_logic_vector(4 downto 4)   := (others => 'X');
	constant CS_ALUF : std_logic_vector(5 downto 5)   := (others => 'X');
	constant CS_SBUS : std_logic_vector(6 downto 6)   := (others => 'X');
	constant CS_MEMR : std_logic_vector(7 downto 7)   := (others => 'X');
	constant CS_MEMW : std_logic_vector(8 downto 8)   := (others => 'X');
	constant CS_PCIN : std_logic_vector(9 downto 9)   := (others => 'X');
	constant CS_SREG : std_logic_vector(13 downto 10) := (others => 'X');
	constant CS_SIZE : integer                        := 14;

	function CONV_CHAR(SLV8 : std_logic_vector (7 downto 0)) return CHARACTER;
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
