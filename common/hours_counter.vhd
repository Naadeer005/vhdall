library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hours_counter is
    port (clk, en : in std_logic; tens, \units\ : out std_logic_vector(3 downto 0); clr : in std_logic := '0');
end entity;

architecture Behavioral of hours_counter is
    signal hour : integer range 0 to 23 := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if clr = '1' then hour <= 0;
            elsif en = '1' then
                if hour = 23 then hour <= 0; else hour <= hour+1; end if;
            end if;
        end if;
    end process;
    tens <= std_logic_vector(to_unsigned(hour/10, 4));
    \units\ <= std_logic_vector(to_unsigned(hour mod 10, 4));
end architecture;
