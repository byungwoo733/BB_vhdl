library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.constants.all;

entity cpu_top is
	port(
		I_CLK : in  std_logic;
		I_RST : in  std_logic;
		I_DAT : in  std_logic_vector(XLEN - 1 downto 0);
		Q_ADR : out std_logic_vector(XLEN - 1 downto 0);
		Q_DAT : out std_logic_vector(XLEN - 1 downto 0);
		Q_RW  : out std_logic
	);
end entity cpu_top;

architecture RTL of cpu_top is
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

	signal L_CREG : std_logic_vector(XLEN - 1 downto 0);

	component registerfile is
		port(
			I_CLK : in  std_logic;
			I_WE  : in  std_logic;
			I_OE  : in  std_logic;
			I_REG : in  std_logic_vector(3 downto 0);
			I_IN  : in  std_logic_vector(XLEN - 1 downto 0);
			Q_OUT : out std_logic_vector(XLEN - 1 downto 0)
		);
	end component registerfile;

	signal R_OUT : std_logic_vector(XLEN - 1 downto 0);

	component functional_unit is
		port(
			I_CLK : in  std_logic;
			I_A   : in  std_logic_vector(XLEN - 1 downto 0);
			I_B   : in  std_logic_vector(XLEN - 1 downto 0);
			I_FC  : in  std_logic;
			Q_OUT : out std_logic_vector(XLEN - 1 downto 0)
		);
	end component functional_unit;

	signal F_FC  : std_logic;
	signal F_A   : std_logic_vector(XLEN - 1 downto 0);
	signal F_B   : std_logic_vector(XLEN - 1 downto 0);
	signal F_OUT : std_logic_vector(XLEN - 1 downto 0);

	component control_unit is
		port(
			I_CLK  : in  std_logic;
			I_IRDY : in  std_logic;
			I_MRDY : in  std_logic;
			I_IR   : in  std_logic_vector(ILEN - 1 downto 0);
			Q_CS   : out std_logic_vector(CS_SIZE - 1 downto 0);
			Q_IMM  : out std_logic_vector(XLEN - 1 downto 0)
		);
	end component control_unit;

	signal C_IMM : std_logic_vector(XLEN - 1 downto 0);

	component bus_interface is
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
	end component bus_interface;

	signal B_IRDY : std_logic;
	signal B_MRDY : std_logic;
	signal B_WE   : std_logic;
	signal B_RE   : std_logic;
	signal B_MDR  : std_logic_vector(XLEN - 1 downto 0);

	signal L_IR : std_logic_vector(ILEN - 1 downto 0);

	signal L_BUSX : std_logic_vector(XLEN - 1 downto 0);
	signal L_BUSY : std_logic_vector(XLEN - 1 downto 0);

	signal L_CS   : std_logic_vector(CS_SIZE - 1 downto 0);
	signal L_LCKA : std_logic;
	signal L_LCKB : std_logic;
	signal L_LCKC : std_logic;
	signal L_RBUS : std_logic;
	signal L_BUSR : std_logic;
	signal L_PCIN : std_logic;
begin
	reg_a : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => L_BUSX,
			I_W   => L_LCKA,
			Q_D   => F_A
		);

	reg_b : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => L_BUSX,
			I_W   => L_LCKB,
			Q_D   => F_B
		);

	reg_c : reg
		generic map(
			WIDTH => XLEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => L_CREG,
			I_W   => L_LCKC,
			Q_D   => L_BUSY
		);

	rf : registerfile
		port map(
			I_CLK => I_CLK,
			I_WE  => L_BUSR,
			I_OE  => L_RBUS,
			I_REG => L_CS(CS_SREG'range),
			I_IN  => L_BUSY,
			Q_OUT => R_OUT
		);

	fu : functional_unit
		port map(
			I_CLK => I_CLK,
			I_A   => F_A,
			I_B   => F_B,
			I_FC  => F_FC,
			Q_OUT => F_OUT
		);

	cu : control_unit
		port map(
			I_CLK  => I_CLK,
			I_IRDY => B_IRDY,
			I_MRDY => B_MRDY,
			I_IR   => L_IR,
			Q_CS   => L_CS,
			Q_IMM  => C_IMM
		);

	bi : bus_interface
		port map(
			I_CLK   => I_CLK,
			I_RST   => I_RST,
			I_INCPC => L_PCIN,
			I_WE    => B_WE,
			I_RE    => B_RE,
			I_DAT   => I_DAT,
			I_MAR   => F_A,
			I_MDR   => F_B,
			Q_ADR   => Q_ADR,
			Q_DAT   => Q_DAT,
			Q_MDR   => B_MDR,
			Q_IR    => L_IR,
			Q_RW    => Q_RW,
			Q_IRDY  => B_IRDY,
			Q_MRDY  => B_MRDY
		);

	L_BUSX <= C_IMM when L_CS(CS_SBUS'range) = "1" else R_OUT;
	L_CREG <= B_MDR when L_CS(CS_SBUS'range) = "1" else F_OUT;

	L_LCKA <= '1' when L_CS(CS_LCKA'range) = "1" else '0';
	L_LCKB <= '1' when L_CS(CS_LCKB'range) = "1" else '0';
	L_LCKC <= '1' when L_CS(CS_LCKC'range) = "1" else '0';
	L_RBUS <= '1' when L_CS(CS_RBUS'range) = "1" else '0';
	L_BUSR <= '1' when L_CS(CS_BUSR'range) = "1" else '0';

	L_PCIN <= '1' when L_CS(CS_PCIN'range) = "1" else '0';

	F_FC <= '1' when L_CS(CS_ALUF'range) = "1" else '0';

	B_WE <= '1' when L_CS(CS_MEMW'range) = "1" else '0';
	B_RE <= '1' when L_CS(CS_MEMR'range) = "1" else '0';
end architecture RTL;
