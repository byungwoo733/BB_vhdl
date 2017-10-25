library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.constants.all;

entity control_unit is
	port(
		I_CLK : in  std_logic;
		I_RST : in  std_logic;
		I_IR  : in  std_logic_vector(ILEN - 1 downto 0);
		Q_CS  : out std_logic_vector(CS_SIZE - 1 downto 0);
		Q_IMM : out std_logic_vector(XLEN - 1 downto 0)
	);
end entity control_unit;

architecture RTL of control_unit is
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

	component cycle_gen is
		port(
			I_CLK   : in  std_logic;
			I_INC   : in  std_logic;
			I_RST   : in  std_logic;
			Q_CYCLE : out std_logic_vector(7 downto 0)
		);
	end component cycle_gen;

	signal C_INC   : std_logic;
	signal C_RST   : std_logic;
	signal C_CYCLE : std_logic_vector(7 downto 0);

	component itype_decoder is
		port(
			I_OPC  : in  std_logic_vector(3 downto 0);
			Q_TYPE : out std_logic_vector(15 downto 0)
		);
	end component itype_decoder;

	signal D_TYPE : std_logic_vector(15 downto 0);

	signal L_LIR : std_logic;
	signal L_IR  : std_logic_vector(ILEN - 1 downto 0);
	signal L_CS  : std_logic_vector(CS_SIZE - 1 downto 0);
begin
	cg : cycle_gen
		port map(
			I_CLK   => I_CLK,
			I_INC   => C_INC,
			I_RST   => C_RST,
			Q_CYCLE => C_CYCLE
		);

	itd : itype_decoder
		port map(
			I_OPC  => L_IR(15 downto 12),
			Q_TYPE => D_TYPE
		);

	ir : reg
		generic map(
			WIDTH => ILEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_IR,
			I_W   => L_LIR,
			Q_D   => L_IR
		);

	C_INC <= '1';
	C_RST <= '1' when ((
		(C_CYCLE(0) = '1' and D_TYPE(1) = '1') -- HLT
		or (C_CYCLE(2) = '1' and (D_TYPE(0) = '1' or D_TYPE(3) = '1' or D_TYPE(4) = '1')) -- NOP, STA, LDI
		or (C_CYCLE(3) = '1' and (D_TYPE(2) = '1' or D_TYPE(5) = '1')) -- LDA, ADD
	) or I_RST = '1'
	) else '0';

	L_LIR <= C_RST and not I_RST and not D_TYPE(1);

	L_CS(CS_RBUS'range) <= "1" when ((C_CYCLE(0) = '1' and (D_TYPE(2) = '1' or D_TYPE(3) = '1' or D_TYPE(5) = '1')) or (C_CYCLE(1) = '1' and (D_TYPE(3) = '1' or D_TYPE(5) = '1'))) else "0";
	L_CS(CS_BUSR'range) <= "1" when ((C_CYCLE(2) = '1' and (D_TYPE(2) = '1' or D_TYPE(4) = '1')) or (C_CYCLE(3) = '1' and D_TYPE(5) = '1')) else "0";
	L_CS(CS_LCKA'range) <= "1" when (C_CYCLE(0) = '1' and (D_TYPE(2) = '1' or D_TYPE(3) = '1' or D_TYPE(4) = '1' or D_TYPE(5) = '1')) else "0";
	L_CS(CS_LCKB'range) <= "1" when (C_CYCLE(1) = '1' and (D_TYPE(3) = '1' or D_TYPE(5) = '1')) else "0";
	L_CS(CS_LCKC'range) <= "1" when ((C_CYCLE(1) = '1' and (D_TYPE(2) = '1' or D_TYPE(4) = '1')) or (C_CYCLE(2) = '1' and (D_TYPE(5) = '1'))) else "0";
	L_CS(CS_ALUF'range) <= "1" when (C_CYCLE(2) = '1' and D_TYPE(5) = '1') else "0";
	L_CS(CS_SBUS'range) <= "1" when ((C_CYCLE(0) = '1' and D_TYPE(4) = '1') or (C_CYCLE(1) = '1' and D_TYPE(2) = '1')) else "0";
	L_CS(CS_MEMR'range) <= "1" when (C_CYCLE(1) = '1' and D_TYPE(2) = '1') else "0";
	L_CS(CS_MEMW'range) <= "1" when (C_CYCLE(2) = '1' and D_TYPE(3) = '1') else "0";
	L_CS(CS_PCIN'range) <= "1" when (L_CS(CS_PCEN'range) = "1") else "0";
	L_CS(CS_PCEN'range) <= "1" when ((C_CYCLE(0) = '1') or (C_CYCLE(1) = '1' and (D_TYPE(0) = '1' or D_TYPE(3) = '1' or D_TYPE(4) = '1' or D_TYPE(5) = '1')) or (C_CYCLE(2) = '1' and D_TYPE(2) = '1')) else "0";
	L_CS(CS_OPLL'range) <= "1" when ((C_CYCLE(1) = '1' and (D_TYPE(0) = '1' or D_TYPE(3) = '1' or D_TYPE(4) = '1' or D_TYPE(5) = '1')) or (C_CYCLE(2) = '1' and D_TYPE(2) = '1')) else "0";
	L_CS(CS_OPHL'range) <= "1" when (C_CYCLE(0) = '1') else "0";
	L_CS(CS_SREG'range) <= L_IR(3 downto 0) when (C_CYCLE(1) = '1' and D_TYPE(5) = '1') -- SRC2
		else L_IR(7 downto 4) when ((C_CYCLE(0) = '1' and (D_TYPE(2) = '1' or D_TYPE(5) = '1')) or (C_CYCLE(1) = '1' and D_TYPE(3) = '1')) -- SRC/SRC1
		else L_IR(11 downto 8) when ((C_CYCLE(0) = '1' and D_TYPE(3) = '1') or (C_CYCLE(2) = '1' and (D_TYPE(2) = '1' or D_TYPE(4) = '1')) or (C_CYCLE(3) = '1' and D_TYPE(5) = '1')) -- DEST
		else "0000";

	Q_CS  <= L_CS when I_RST = '0' and D_TYPE(1) = '0' else (others => '0');
	Q_IMM <= L_IR(7 downto 0);
end architecture RTL;
