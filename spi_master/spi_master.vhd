--
-- SPI Master
-- Main Entity
-- harrym 2015
--

-- my slave follow these specification
-- CPOL = 1 and CPHA = 1
-- data updated on falling edge and captured on rising edge

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity spi_master is
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
end spi_master;

architecture spi_master_arch of spi_master is

type state_type_wr is (IDLE, WR, A5, A4, A3, A2, A1, A0, END_ADD, O7, O6, O5, O4, O3, O2, O1, O0, END_WR);
type state_type_rd is (D7, D6, D5, D4, D3, D2, D1, D0, UPDATE);

signal state_wr: state_type_wr;
signal state_rd: state_type_rd;

signal data_temp: std_logic_vector(7 downto 0);
signal rd, p0, p1: std_logic;

begin
	cs <= not (p0 or p1); -- cs low if at least one process is active

	wr_proc: process(clk, reset)
	begin
		if(reset = '0') then
			state_wr <= IDLE;
			rd <= '0';
			p0 <= '0';
		elsif(clk'event and clk = '0') then --falling edge, update output!
			p0 <= '1';
			case state_wr is
				when IDLE =>
					state_wr <= WR;
				when WR =>
					if(rw = '1') then
						sdo <= '1';
					else
						sdo <= '0';
					end if;
					state_wr <= A5;
				when A5 =>
					sdo <= address(5);
					state_wr <= A4;
				when A4 =>
					sdo <= address(4);
					state_wr <= A3;
				when A3 =>
					sdo <= address(3);
					state_wr <= A2;
				when A2 =>
					sdo <= address(2);
					state_wr <= A1;
				when A1 =>
					sdo <= address(1);
					state_wr <= A0;
				when A0 =>
					sdo <= address(0);
					if(rw = '1') then
						state_wr <= END_ADD;
						rd <= '1';
					else
						state_wr <= O7;
					end if;
				when END_ADD =>
					rd <= '1';
					p0 <= '0';
				when O7 =>
					sdo <= data_in(7);
					state_wr <= O6;
				when O6 =>
					sdo <= data_in(6);
					state_wr <= O5;
				when O5 =>
					sdo <= data_in(5);
					state_wr <= O4;
				when O4 =>
					sdo <= data_in(4);
					state_wr <= O3;
				when O3 =>
					sdo <= data_in(3);
					state_wr <= O2;
				when O2 =>
					sdo <= data_in(2);
					state_wr <= O1;
				when O1 =>
					sdo <= data_in(1);
					state_wr <= O0;
				when O0 =>
					sdo <= data_in(0);
					state_wr <= END_WR;
				when END_WR =>
					p0 <= '0';

			end case;
		end if;
	end process;

	rd_proc: process(clk, reset)
	begin
		if(reset = '0') then
			state_rd <= D7;
			data_temp <= "00000000";
			p1 <= '0';
		elsif(clk'event and clk = '1' and rd = '1') then --rising edge, capture data!
			p1 <= '1';
			case state_rd is
				when D7 =>
					data_temp(7) <= sdi;
					state_rd <= D6;
				when D6 =>
					data_temp(6) <= sdi;
					state_rd <= D5;
				when D5 =>
					data_temp(5) <= sdi;
					state_rd <= D4;
				when D4 =>
					data_temp(4) <= sdi;
					state_rd <= D3;
				when D3 =>
					data_temp(3) <= sdi;
					state_rd <= D2;
				when D2 =>
					data_temp(2) <= sdi;
					state_rd <= D1;
				when D1 =>
					data_temp(1) <= sdi;
					state_rd <= D0;
				when D0 =>
					data_temp(0) <= sdi;
					state_rd <= UPDATE;
				when UPDATE =>
					data_out <= data_temp;
					p1 <= '0';
			end case;
		end if;
	end process;

end spi_master_arch;
