library ieee;
use ieee.std_logic_1164.all;

entity clock_divider is
    generic (DIV_COUNT : positive := 50000000);
    port (clk : in std_logic; tick : out std_logic);
end entity;

architecture Behavioral of clock_divider is
    signal count : integer range 0 to DIV_COUNT-1 := 0;
    signal tick_int : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if count = DIV_COUNT-1 then count <= 0; tick_int <= '1';
            else count <= count+1; tick_int <= '0'; end if;
        end if;
    end process;
    tick <= tick_int;
end architecture;
