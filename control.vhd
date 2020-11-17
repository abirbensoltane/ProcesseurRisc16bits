library ieee;
use ieee.std_logic_1164.all;
entity control is
	port (
		clk : in std_logic;
		rst : in std_logic;
		status : in std_logic_vector(3 downto 0);
		instr_cond : in std_logic_vector(3 downto 0);
		instr_op : in std_logic_vector(3 downto 0);
		instr_updt : in std_logic;
		instr_ce : out std_logic;
		status_ce : out std_logic;
		acc_ce : out std_logic;
		pc_ce : out std_logic;
		rpc_ce : out std_logic;
		rx_ce : out std_logic;
		ram_we : out std_logic;
		sel_ram_addr : out std_logic;
		sel_op1 : out std_logic;
		sel_rf_din : out std_logic_vector(1 downto 0) 
	);
end entity;
architecture arch of control is
	type etat is (fetch1, fetch2, decode, exec, store);
	signal next_state: etat;
	signal etat_courant: etat := fetch1;
	function verif(instr_cond : std_logic_vector(3 downto 0); status : std_logic_vector(3 downto 0))
        return std_logic is
	begin
  		case (instr_cond) is
			when "0000" => return '0';
			when "0001" => return '1';
			when "0010" => return (status(3));
			when "0011" => return (not(status(3)));
			when "0100" => return (not(status(3)) and not(status(2)));
			when "0101" => return (status(3) or status(2));
			when "0110" => return (status(2));
			when "0111" => return (not(status(2)));
			when "1000" => return (status(1));
			when "1001" => return (not(status(1)));
			when "1010" => return (status(0));
			when "1011" => return (not(status(0)));
			when others => return '1'; 
		end case;
	end verif;
begin
	next_state <= fetch2 when etat_courant = fetch1 else
	           decode when etat_courant = fetch2 else
	           exec when etat_courant = decode else
	           store when etat_courant = exec else
	           fetch1 when etat_courant = store else
	           etat_courant;
	p1 : process(etat_courant, instr_op, instr_cond, status, instr_updt)
	begin
		instr_ce <= '0';
		status_ce <= '0';
		acc_ce <= '0';
		pc_ce <= '0';
		rpc_ce <= '0';
		rx_ce <= '0';
		ram_we <= '0';
		sel_ram_addr <= '0';
		sel_op1 <= '0'; 
		sel_rf_din <= "00";
		case etat_courant is
			when fetch1 =>  instr_ce <= '0';
					status_ce <= '0';
					acc_ce <= '0';
					pc_ce <= '0';
					rpc_ce <= '0';
					rx_ce <= '0';
					ram_we <= '0';
					sel_ram_addr <= '0';
					sel_op1 <= '0'; 
					sel_rf_din <= "00"; 
			when fetch2 =>  instr_ce <= '1';
					status_ce <= '0';
					acc_ce <= '0';
					pc_ce <= '0';
					rpc_ce <= '0';
					rx_ce <= '0';
					ram_we <= '0';
					sel_ram_addr <= '0';
					sel_op1 <= '0'; 
					sel_rf_din <= "00"; 	
			when decode =>  if(verif(instr_cond, status) = '0') then
						instr_ce <= '0';
						status_ce <= '0';
						acc_ce <= '0';
						pc_ce <= '0';
						rpc_ce <= '0';
						rx_ce <= '0';
						ram_we <= '0';
						sel_ram_addr <= '0';
						sel_op1 <= '0'; 
						sel_rf_din <= "00";
					elsif(instr_op(3 downto 2) = "11") then
						instr_ce <= '0';
						status_ce <= '0';
						acc_ce <= '0';
						pc_ce <= '0';
						rpc_ce <= '0';
						rx_ce <= '0';
						ram_we <= '0';
						sel_ram_addr <= '0';
						sel_op1 <= '1'; 
						sel_rf_din <= "00";
					else
						instr_ce <= '0';
						status_ce <= '0';
						acc_ce <= '0';
						pc_ce <= '0';
						rpc_ce <= '0';
						rx_ce <= '0';
						ram_we <= '0';
						sel_ram_addr <= '0';
						sel_op1 <= '0'; 
						sel_rf_din <= "00";
					end if;
			when exec => if(verif(instr_cond, status) = '0') then
						instr_ce <= '0';
						status_ce <= '0';
						acc_ce <= '0';
						pc_ce <= '1';
						rpc_ce <= '0';
						rx_ce <= '0';
						ram_we <= '0';
						sel_ram_addr <= '0';
						sel_op1 <= '0'; 
						sel_rf_din <= "10";
				     else
						status_ce <= instr_updt;
						acc_ce <= '0';
						instr_ce <= '0';
						rpc_ce <= '0';
						rx_ce <= '0';
						ram_we <= '0';
						sel_ram_addr <= '0';
						sel_op1 <= '0';
						sel_rf_din <="10";
						pc_ce <= '1';
						if (instr_op = "1000") then
							status_ce <= '0';
							sel_ram_addr <= '1';
						elsif (instr_op = "1001") then
							status_ce <= '0';
							sel_ram_addr <= '1';
							ram_we <= '1';
						elsif (instr_op = "1111") then
							status_ce <= '0';
							pc_ce <= '0'; 
							rpc_ce <= '1';
						elsif (instr_op = "1100" or instr_op ="1101" or instr_op ="1110") then
							status_ce <= '0';
						end if;
				     end if;
			when store => if (verif(instr_cond, status) = '0') then
						instr_ce <= '0';
						status_ce <= '0';
						acc_ce <= '0';
						pc_ce <= '0';
						rpc_ce <= '0';
						rx_ce <= '0';
						ram_we <= '0';
						sel_ram_addr <= '0';
						sel_op1 <= '0'; 
						sel_rf_din <= "00";
				      else
						status_ce <= '0';
						acc_ce <= '1';
						instr_ce <= '0';
						rpc_ce <= '0';
						rx_ce <= '0';
						ram_we <= '0';
						sel_ram_addr <= '0';
						sel_op1 <= '0';
						sel_rf_din <="00";
						pc_ce <= '0';
						if (instr_op(3 downto 2) = "11") then
							pc_ce <= '1';
							acc_ce <= '0';
						elsif (instr_op = "1011") then
							rx_ce <= '1';
							acc_ce <= '0';
						elsif (instr_op = "1001") then
							acc_ce <= '0';
						elsif (instr_op = "1000") then
							sel_rf_din <="01";
						end if;
				      end if;
		end case;
	end process p1;
	p2 : process (clk, rst)
	begin
		if (rst = '1') then
			etat_courant <= fetch1;
		elsif (clk'event and clk = '1') then
			etat_courant <= next_state;
		end if;
	end process p2;
end architecture;
