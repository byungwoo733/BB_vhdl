library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

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
	component reg is
		generic(
			WIDTH : natural
		);
		port(
			I_CLK : in  std_logic;
			I_D   : in  std_logic_vector(WIDTH - 1 downto 0);
			I_W   : in  std_logic;
			Q_D   : out std_logic_vector(WIDTH - 1 downto 0)
		);
	end component reg;

	signal L_WRITE  : std_logic_vector(15 downto 0)       := X"0000";
	signal L_WRITES : std_logic_vector(15 downto 0)       := X"0000";
	signal L_R0     : std_logic_vector(XLEN - 1 downto 0) := X"00";
	signal L_R1     : std_logic_vector(XLEN - 1 downto 0) := X"00";
	signal L_R2     : std_logic_vector(XLEN - 1 downto 0) := X"00";
	signal L_R3     : std_logic_vector(XLEN - 1 downto 0) := X"00";
	signal L_R4     : std_logic_vector(XLEN - 1 downto 0) := X"00";
	signal L_R5     : std_logic_vector(XLEN - 1 downto 0) := X"00";
	signal L_R6     : std_logic_vector(XLEN - 1 downto 0) := X"00";
	signal L_R7     : std_logic_vector(XLEN - 1 downto 0) := X"00";
	signal L_R8     : std_logic_vector(XLEN - 1 downto 0) := X"00";
	signal L_R9     : std_logic_vector(XLEN - 1 downto 0) := X"00";
	signal L_R10    : std_logic_vector(XLEN - 1 downto 0) := X"00";
	signal L_R11    : std_logic_vector(XLEN - 1 downto 0) := X"00";
	signal L_R12    : std_logic_vector(XLEN - 1 downto 0) := X"00";
	signal L_R13    : std_logic_vector(XLEN - 1 downto 0) := X"00";
	signal L_R14    : std_logic_vector(XLEN - 1 downto 0) := X"00";
	signal L_R15    : std_logic_vector(XLEN - 1 downto 0) := X"00";

	signal L_OUT : std_logic_vector(XLEN - 1 downto 0) := X"00";
begin
	r0 : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_IN,
			I_W   => L_WRITE(0),
			Q_D   => L_R0
		);

	r1 : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_IN,
			I_W   => L_WRITE(1),
			Q_D   => L_R1
		);

	r2 : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_IN,
			I_W   => L_WRITE(2),
			Q_D   => L_R2
		);

	r3 : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_IN,
			I_W   => L_WRITE(3),
			Q_D   => L_R3
		);

	r4 : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_IN,
			I_W   => L_WRITE(4),
			Q_D   => L_R4
		);

	r5 : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_IN,
			I_W   => L_WRITE(5),
			Q_D   => L_R5
		);

	r6 : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_IN,
			I_W   => L_WRITE(6),
			Q_D   => L_R6
		);

	r7 : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_IN,
			I_W   => L_WRITE(7),
			Q_D   => L_R7
		);

	r8 : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_IN,
			I_W   => L_WRITE(8),
			Q_D   => L_R8
		);

	r9 : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_IN,
			I_W   => L_WRITE(9),
			Q_D   => L_R9
		);

	r10 : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_IN,
			I_W   => L_WRITE(10),
			Q_D   => L_R10
		);

	r11 : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_IN,
			I_W   => L_WRITE(11),
			Q_D   => L_R11
		);

	r12 : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_IN,
			I_W   => L_WRITE(12),
			Q_D   => L_R12
		);

	r13 : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_IN,
			I_W   => L_WRITE(13),
			Q_D   => L_R13
		);

	r14 : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_IN,
			I_W   => L_WRITE(14),
			Q_D   => L_R14
		);

	r15 : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_IN,
			I_W   => L_WRITE(15),
			Q_D   => L_R15
		);

	with I_REG select L_WRITES <=
		"0000000000000001" when "0000",
		"0000000000000010" when "0001",
		"0000000000000100" when "0010",
		"0000000000001000" when "0011",
		"0000000000010000" when "0100",
		"0000000000100000" when "0101",
		"0000000001000000" when "0110",
		"0000000010000000" when "0111",
		"0000000100000000" when "1000",
		"0000001000000000" when "1001",
		"0000010000000000" when "1010",
		"0000100000000000" when "1011",
		"0001000000000000" when "1100",
		"0010000000000000" when "1101",
		"0100000000000000" when "1110",
		"1000000000000000" when "1111",
		"0000000000000000" when others;
	L_WRITE <= L_WRITES when I_WE = '1' else (others => '0');

	with I_REG select L_OUT <=
		L_R0 when "0000",
		L_R1 when "0001",
		L_R2 when "0010",
		L_R3 when "0011",
		L_R4 when "0100",
		L_R5 when "0101",
		L_R6 when "0110",
		L_R7 when "0111",
		L_R8 when "1000",
		L_R9 when "1001",
		L_R10 when "1010",
		L_R11 when "1011",
		L_R12 when "1100",
		L_R13 when "1101",
		L_R14 when "1110",
		L_R15 when "1111",
		(others => 'X') when others;

	Q_OUT <= L_OUT when I_OE = '1' else (others => 'Z');
end architecture RTL;
