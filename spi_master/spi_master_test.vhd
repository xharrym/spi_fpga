--
-- SPI Master
-- Test Bench
-- harrym 2015
--

library IEEE;
use IEEE.std_logic_1164.all;

entity test_bench is
end test_bench;

architecture tb_arch of test_bench is
	component spi_master
	port(
	clk: in std_logic;
	reset: in std_logic;

	rw: in std_logic;
	sdi: in std_logic;
	sdo: out std_logic;
	sclk: out std_logic;
	cs: out std_logic;

	address: in std_logic_vector (5 downto 0);
	data_in: in std_logic_vector (7 downto 0);
	data_out: out std_logic_vector (7 downto 0)
	);
end component;

signal clk, reset, sdi, sdo, sclk, cs, rw: std_logic;
signal address: std_logic_vector (5 downto 0);
signal data_in, data_out: std_logic_vector (7 downto 0);

begin

	dut: spi_master port map(
	clk => clk,
	reset => reset,
	sclk => sclk,
	sdi => sdi,
	sdo => sdo,
	cs => cs,
	rw => rw,
	data_in => data_in,
	data_out => data_out,
	address => address
	);

	reset <= '1', '0' after 2 ns, '1' after 10 ns, '0' after 50 ns, '1' after 60 ns;
	sdi <= '1';
	rw <= '0', '1' after 55 ns;
	data_in <= "10101010";
	address <= "110010";

	clk_proc: process
	begin
		clk <= '0';
		sclk <= '0';
		wait for 1 ns;
		clk <= '1';
		sclk <= '1';
		wait for 1 ns;
	end process;

end tb_arch;
