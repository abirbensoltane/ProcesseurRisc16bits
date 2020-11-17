library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity bascule is
	port (
		rst, clk : in std_logic;
		din: in std_logic_vector(15 downto 0);
		q : out std_logic_vector(15 downto 0)
	);
end bascule;
architecture arch of bascule is
	signal sq : std_logic_vector(15 downto 0);
begin
	process (clk, rst)
	begin
		if(rst = '1')then
			sq <= x"0000";
		elsif (rising_edge(clk)) then
			sq <= din;
		end if;
	end process;
	q <= sq;
end arch;