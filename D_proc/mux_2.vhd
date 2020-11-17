library ieee;
use ieee.std_logic_1164.all;
entity mux_2 is
	port (
		d0, d1, d2 : in std_logic_vector(15 downto 0);
		sel : in std_logic_vector(1 downto 0);
		dataout : out std_logic_vector(15 downto 0)
	);
end mux_2;
architecture arch of mux_2 is
begin
	with sel select
	dataout <= d0 when "00", 
	           d1 when "01", 
	           d2 when "10", 
	           x"0000" when others;
end arch;