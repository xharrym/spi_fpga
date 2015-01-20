--
-- Clock Divider by 128
-- Main Entity
-- xharrym 2015
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clk_divider is
  port (
    clk50: in std_logic;
    reset: in std_logic;
    clk: out std_logic
  );
end clk_divider;

architecture clk_divider_arch of clk_divider is
signal count: std_logic_vector (6 downto 0);
begin

  p_clk: process(clk50)
  begin
    if(reset = '0') then
           count <= "0000000";
    elsif(clk50'event and clk50 = '1') then
	   count <= std_logic_vector(unsigned(count)+1);
    end if;
  end process;

  clk <= count(6);

end clk_divider_arch;
