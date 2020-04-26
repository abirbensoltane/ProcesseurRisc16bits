library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity alu is
	port (
		op : in std_logic_vector(3 downto 0);
		i1 : in std_logic_vector(15 downto 0);
		i2 : in std_logic_vector(15 downto 0);
		o  : out std_logic_vector(15 downto 0);
		st : out std_logic_vector(3 downto 0)
	);
end entity;
architecture arch of alu is
	signal result : std_logic_vector(16 downto 0);
	signal add, sub, lsl, lsr : std_logic;
begin
	process (op, i1, i2)
	begin
		sub <= '0';
		add <= '0';
		lsl <= '0';
		lsr <= '0';
		result(16) <= '0';
		case (op) is
			when "0000" => result <= '0' & (i1 and i2);
			when "0001" => result <= '0' & (i1 or i2);
			when "0010" => result <= '0' & (i1 xor i2);
			when "0011" => result <= '0' & (not i2);
			when "0100" => result <= std_logic_vector(signed('0' & i1) + signed('0' & i2)); add <= '1';
			when "0101" => result <= std_logic_vector(signed('0' & i1) - signed('0' & i2)); sub <= '1';
			when "0110" => result <= std_logic_vector(signed('0' & i1) sll to_integer(signed(i2))); lsl <= '1';
			when "0111" => result <= std_logic_vector(signed('0' & i1) srl to_integer(signed(i2))); lsr <= '1';
			when "1000" => result <= '0' & i2;
			when "1001" => result <= '0' & i1;
			when "1010" => result <= '0' & i2;
			when "1011" => result <= '0' & i1;
			when "1100" => result <= std_logic_vector(signed('0' & i1) + signed('0' & i2)); --add <= '1';
			when "1101" => result <= std_logic_vector(signed('0' & i1) - signed('0' & i2)); --sub <= '1';
			when "1110" => result <= '0' & i2;
			when "1111" => result <= '0' & i2;
			when others => null;
		end case;
	end process;
	o <= result(15 downto 0);
	st(3) <= '1' when result(15 downto 0) = x"0000" else '0';
	st(2) <= '1' when (signed(result(15 downto 0)) < 0) else '0';
	st(1) <= not result(16) when sub = '1' else result(16);
	st(0) <= '1' when ((((lsl = '1' or lsr = '1') and ((signed(i1) < 0 and signed(result(15 downto 0)) > 0) or (signed(i1) > 0 and signed(result(15 downto 0)) < 0)))) or ((add = '1' and ((signed(result(15 downto 0)) > 0 and signed(i1) < 0 and signed(i2) < 0) or (signed(result(15 downto 0)) < 0 and signed(i1) > 0 and signed(i2) > 0)))) or ((sub = '1' and ((signed(result(15 downto 0)) > 0 and signed(i1) < 0 and signed(i2) > 0) or (signed(result(15 downto 0)) < 0 and signed(i1) > 0 and signed(i2) < 0)))))else '0';
end architecture;