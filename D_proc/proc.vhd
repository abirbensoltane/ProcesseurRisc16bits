-------------------------------------------------------------------------------
-- Top-level processor component
--
-- Ports:
--   - clk [in]  : clock signal
--   - rst [in]  : reset signal
--
--   - ram_addr [out] : memory address
--   - ram_din  [out] : data input to memory
--   - ram_dout [in]  : data output from memory
--   - ram_we   [out] : write enable signal for memory
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all; 
entity proc is
	port (
		clk : in std_logic;
		rst : in std_logic;
		ram_addr : out std_logic_vector(15 downto 0);
		ram_din : out std_logic_vector(15 downto 0);
		ram_dout : in std_logic_vector(15 downto 0);
		ram_we : out std_logic 
	);
end entity;
architecture arch of proc is
	signal ssel_op1, sinstr_ce, sclk, sacc_ce, srx_ce, ssel_ram_addr, spc_ce, srpc_ce, sstatus_ce, srst, supdt, simm: std_logic;
	signal scond, sop, sst, si: std_logic_vector(3 downto 0);
	signal sval: std_logic_vector(5 downto 0);
	signal sacc_out, salu, sbo_3, sop1, sop2, spc_out, srx_out, sdin, smux1_1_o, smux1_2_o, sd0, sd00: std_logic_vector(15 downto 0);
	signal temp: unsigned(15 downto 0);
	signal ssel_rf_din: std_logic_vector(1 downto 0);	
	component control is
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
	end component;
	component instr_reg is
		port (
			clk : in std_logic;
			ce : in std_logic;
			rst : in std_logic;
			instr : in std_logic_vector(15 downto 0);
			cond : out std_logic_vector(3 downto 0);
			op : out std_logic_vector(3 downto 0);
			updt : out std_logic;
			imm : out std_logic;
			val : out std_logic_vector(5 downto 0) 
		);
	end component;
	component status_reg is
		port (
			clk : in std_logic;
			ce : in std_logic;
			rst : in std_logic;
			i : in std_logic_vector(3 downto 0);
			o : out std_logic_vector(3 downto 0) 
		);
	end component;
	component reg_file is
		port (
			clk : in std_logic;
			rst : in std_logic;
			acc_out : out std_logic_vector(15 downto 0);
			acc_ce : in std_logic;
			pc_out : out std_logic_vector(15 downto 0);
			pc_ce : in std_logic;
			rpc_ce : in std_logic;
			rx_num : in std_logic_vector(5 downto 0);
			rx_out : out std_logic_vector(15 downto 0);
			rx_ce : in std_logic;
			din : in std_logic_vector(15 downto 0) 
		);
	end component;
	component alu is
		port (
			op : in std_logic_vector(3 downto 0);
			i1 : in std_logic_vector(15 downto 0);
			i2 : in std_logic_vector(15 downto 0);
			o : out std_logic_vector(15 downto 0);
			st : out std_logic_vector(3 downto 0) 
		);
	end component;
	component mux_1 is
		port (
			d0, d1: in std_logic_vector(15 downto 0);
			sel : in std_logic;
			dataout : out std_logic_vector(15 downto 0)
		);
	end component;
	component mux_2 is
		port (
			d0, d1, d2 : in std_logic_vector(15 downto 0);
			sel : in std_logic_vector(1 downto 0);
			dataout : out std_logic_vector(15 downto 0)
		);
	end component;
	component bascule is
		port (
			rst, clk : in std_logic;
			din: in std_logic_vector(15 downto 0);
			q : out std_logic_vector(15 downto 0)
		);
	end component;
begin
	sd0 <= "0000000000" & sval;
	temp <= unsigned(spc_out)+1;
	sd00 <= std_logic_vector(temp);
	sclk <= clk;
	srst <= rst;
	p1: instr_reg port map(sclk, sinstr_ce, srst, ram_dout, scond, sop, supdt, simm, sval);
	p2: status_reg port map(sclk, sstatus_ce, srst, si, sst);
	p3: reg_file port map(sclk, srst, sacc_out, sacc_ce, spc_out, spc_ce, srpc_ce, sval, srx_out, srx_ce, sdin);
	p4: mux_1 port map(srx_out, sd0, simm, smux1_1_o);
	p5: mux_1 port map(sacc_out, spc_out, ssel_op1, smux1_2_o);
	p6: mux_1 port map(spc_out, sop2, ssel_ram_addr, ram_addr);
	p7: mux_2 port map(sbo_3, ram_dout, sd00, ssel_rf_din, sdin);
	p8: bascule port map(srst, sclk, smux1_1_o, sop2);
	p9: bascule port map(srst, sclk, smux1_2_o, sop1);
	p10: bascule port map(srst, sclk, salu, sbo_3);
	p11: alu port map(sop, sop2, sop1, salu, si);
	p12: control port map(sclk, srst, sst, scond, sop, supdt, sinstr_ce, sstatus_ce, sacc_ce, spc_ce, srpc_ce, srx_ce, ram_we, ssel_ram_addr, ssel_op1, ssel_rf_din);
	ram_din <= sop1;
end architecture;
