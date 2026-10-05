library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_top is
    generic (DIV_COUNT : positive := 50000000);
    port (clk : in std_logic; led : out std_logic_vector(3 downto 0));
end entity;

architecture Behavioral of counter_top is
    signal tick : std_logic;
    signal count : unsigned(3 downto 0) := (others => '0');
begin
    U_DIV: entity work.clock_divider(Behavioral) generic map (DIV_COUNT => DIV_COUNT) port map (clk => clk, tick => tick);
    process(clk)
    begin
        if rising_edge(clk) then
            if tick = '1' then count <= count+1; end if;
        end if;
    end process;
    led <= std_logic_vector(count);
end architecture;
