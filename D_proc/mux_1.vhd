library ieee;
use ieee.std_logic_1164.all;
entity mux_1 is
	port (
		d0, d1: in std_logic_vector(15 downto 0);
		sel : in std_logic;
		dataout : out std_logic_vector(15 downto 0)
	);
end mux_1;
architecture arch of mux_1 is
begin
	with sel select
	dataout <= d0 when '0', 
	           d1 when '1',  
	           x"0000" when others;
end arch;
