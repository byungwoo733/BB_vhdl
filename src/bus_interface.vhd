library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.constants.all;

entity bus_interface is
	port(
		I_CLK   : in  std_logic;
		I_RST   : in  std_logic;
		I_INCPC : in  std_logic;
		I_RE    : in  std_logic;
		I_WE    : in  std_logic;
		I_DAT   : in  std_logic_vector(XLEN - 1 downto 0);
		I_MAR   : in  std_logic_vector(XLEN - 1 downto 0);
		I_MDR   : in  std_logic_vector(XLEN - 1 downto 0);
		Q_ADR   : out std_logic_vector(XLEN - 1 downto 0);
		Q_DAT   : out std_logic_vector(XLEN - 1 downto 0);
		Q_MDR   : out std_logic_vector(XLEN - 1 downto 0);
		Q_IR    : out std_logic_vector(ILEN - 1 downto 0);
		Q_RW    : out std_logic;
		Q_IRDY  : out std_logic;
		Q_MRDY  : out std_logic
	);
end entity bus_interface;

architecture RTL of bus_interface is
	signal L_PC    : std_logic_vector(XLEN - 1 downto 0);
	signal L_IR    : std_logic_vector(ILEN - 1 downto 0);
	signal L_STATE : std_logic_vector(2 downto 0);

	signal L_IRDY : std_logic;
	signal L_MRDY : std_logic;

	signal L_RW   : std_logic;
	signal L_ADR  : std_logic_vector(XLEN - 1 downto 0);
	signal L_DATO : std_logic_vector(XLEN - 1 downto 0);
	signal L_DATI : std_logic_vector(XLEN - 1 downto 0);
begin
	process(I_CLK)
	begin
		if (rising_edge(I_CLK)) then
			if (I_RST = '1') then
				L_PC    <= X"C0";
				L_IRDY  <= '0';
				L_STATE <= "000";
			elsif (I_INCPC = '1') then
				L_PC   <= L_PC + X"02";
				L_IRDY <= '0';
			end if;

			if (L_STATE = "000") then   -- Idle state
				L_ADR  <= (others => 'Z');
				L_DATO <= (others => 'Z');
				L_DATI <= (others => 'Z');
				L_RW   <= 'Z';
				L_MRDY <= '0';

				if (I_WE = '1') then
					L_ADR  <= I_MAR;
					L_DATO <= I_MDR;
					L_RW   <= '1';
					L_MRDY <= '1';

					L_STATE <= "000";   -- Writes are finished in a single cycle
				elsif (I_RE = '1' and L_MRDY = '0') then
					L_ADR <= I_MAR;
					L_RW  <= '0';

					L_STATE <= "011";   -- Read
				elsif (L_IRDY = '0') then
					L_ADR <= L_PC;
					L_RW  <= '0';

					L_STATE <= "001";   -- Instruction fetch
				end if;
			elsif (L_STATE = "001") then
				--if (I_MEMRDY = '1') then	-- Reads have data ready the next cycle, normally you would add a stall here
				L_IR(15 downto 8) <= I_DAT; -- Store upper half of instruction
				L_ADR             <= L_PC + X"01";
				L_RW              <= '0';

				L_STATE <= "010";
				--end if;
			elsif (L_STATE = "010") then
				--if (I_MEMRDY = '1') then
				L_IR(7 downto 0) <= I_DAT; -- Store lower half of instruction
				L_IRDY           <= '1';

				L_STATE <= "000";
				--end if;
			elsif (L_STATE = "011") then
				--if (I_MEMRDY = '1') then
				L_DATI <= I_DAT;        -- Store read data
				L_MRDY <= '1';

				L_STATE <= "000";
				--end if;
			end if;
		end if;
	end process;

	Q_IR   <= L_IR;
	Q_IRDY <= L_IRDY;
	Q_MRDY <= L_MRDY;

	Q_RW  <= L_RW;
	Q_ADR <= L_ADR;
	Q_DAT <= L_DATO;
	Q_MDR <= L_DATI;
end architecture RTL;