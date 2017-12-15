library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.constants.all;

entity registerfile is
	port(
		I_CLK : in  std_logic;
		I_WE  : in  std_logic;
		I_OE  : in  std_logic;
		I_REG : in  std_logic_vector(3 downto 0);
		I_IN  : in  std_logic_vector(XLEN - 1 downto 0);
		Q_OUT : out std_logic_vector(XLEN - 1 downto 0)
	);
end entity registerfile;

architecture RTL of registerfile is
	type regs_t is array (0 to 15) of std_logic_vector(XLEN - 1 downto 0);
	signal regs : regs_t := (others => (others => '0'));

	signal L_OUT : std_logic_vector(XLEN - 1 downto 0);
begin
	process(I_CLK)
	begin
		if (rising_edge(I_CLK)) then
			if (I_WE = '1') then
				regs(to_integer(unsigned(I_REG))) <= I_IN;
			end if;
		end if;
	end process;

	L_OUT <= regs(to_integer(unsigned(I_REG)));

	Q_OUT <= L_OUT when (I_OE = '1' and I_WE = '0')
		else I_IN when (I_OE = '1' and I_WE = '1')
		else (others => 'Z');
end architecture RTL;
