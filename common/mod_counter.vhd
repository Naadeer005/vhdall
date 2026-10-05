library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod_counter is
    generic (MOD_VALUE : positive := 10);
    port (clk, en : in std_logic; count : out std_logic_vector(3 downto 0); carry : out std_logic; clr : in std_logic := '0');
end entity;

architecture Behavioral of mod_counter is
    signal cnt : unsigned(3 downto 0) := (others => '0');
    signal wrap : std_logic := '0';
begin
    assert MOD_VALUE >= 1 and MOD_VALUE <= 16 report "MOD_VALUE must be 1..16" severity failure;
    process(clk)
    begin
        if rising_edge(clk) then
            wrap <= '0'; -- Always clear the pulse, including when enable is low.
            if clr = '1' then cnt <= (others => '0');
            elsif en = '1' then
                if cnt = MOD_VALUE-1 then cnt <= (others => '0'); wrap <= '1';
                else cnt <= cnt+1; end if;
            end if;
        end if;
    end process;
    count <= std_logic_vector(cnt);
    carry <= wrap;
end architecture;
