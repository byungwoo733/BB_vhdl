library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity itype_decoder is
	port(
		I_OPC  : in  std_logic_vector(3 downto 0);
		Q_TYPE : out std_logic_vector(15 downto 0)
	);
end entity itype_decoder;

architecture RTL of itype_decoder is

begin
	Q_TYPE(0)  <= '1' when I_OPC = "0000" else '0'; -- NOP
	Q_TYPE(1)  <= '1' when I_OPC = "0001" else '0'; -- HLT
	Q_TYPE(2)  <= '1' when I_OPC = "0010" else '0'; -- LDA
	Q_TYPE(3)  <= '1' when I_OPC = "0011" else '0'; -- STA
	Q_TYPE(4)  <= '1' when I_OPC = "0100" else '0'; -- ADD
	Q_TYPE(5)  <= '1' when I_OPC = "0101" else '0';
	Q_TYPE(6)  <= '1' when I_OPC = "0110" else '0';
	Q_TYPE(7)  <= '1' when I_OPC = "0111" else '0';
	Q_TYPE(8)  <= '1' when I_OPC = "1000" else '0';
	Q_TYPE(9)  <= '1' when I_OPC = "1001" else '0';
	Q_TYPE(10) <= '1' when I_OPC = "1010" else '0';
	Q_TYPE(11) <= '1' when I_OPC = "1011" else '0';
	Q_TYPE(12) <= '1' when I_OPC = "1100" else '0';
	Q_TYPE(13) <= '1' when I_OPC = "1101" else '0';
	Q_TYPE(14) <= '1' when I_OPC = "1110" else '0';
	Q_TYPE(15) <= '1' when I_OPC = "1111" else '0';
end architecture RTL;