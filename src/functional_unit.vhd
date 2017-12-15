library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.constants.all;

entity functional_unit is
	port(
		I_CLK : in  std_logic;
		I_A   : in  std_logic_vector(XLEN - 1 downto 0);
		I_B   : in  std_logic_vector(XLEN - 1 downto 0);
		I_FC  : in  std_logic;
		Q_OUT : out std_logic_vector(XLEN - 1 downto 0)
	);
end entity functional_unit;

architecture RTL of functional_unit is
	signal L_OUT : std_logic_vector(XLEN - 1 downto 0);
begin
	with I_FC select L_OUT <=
		I_A when '0',                   -- Pass A
		I_A + I_B when '1',             -- Add
		(others => 'Z') when others;
		
	Q_OUT <= L_OUT;
end architecture RTL;