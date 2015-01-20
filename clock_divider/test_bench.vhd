--
-- Clock Divider by 128
-- Test Bench
-- xharrym 2015
--


library IEEE;
use IEEE.std_logic_1164.all;

entity test_bench is
end test_bench;

architecture tb_arch of test_bench is
component clk_divider
	port(
		clk50: in std_logic;
		reset: in std_logic;
		clk: out std_logic
	);
end component;

signal clk50, reset, clk: std_logic;

begin

	dut: clk_divider port map(
		clk50 => clk50,
		reset => reset,
		clk => clk
	);

	reset <= '1', '0' after 2 ns, '1' after 10 ns;

	tb: process
	begin
		clk50 <= '0';
		wait for 1 ns;
		clk50 <= '1';
		wait for 1 ns;
	end process;

end tb_arch;
