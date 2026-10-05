library ieee;
use ieee.std_logic_1164.all;

entity adder_display_top is
    port (a, b : in std_logic_vector(3 downto 0); sum : out std_logic_vector(3 downto 0); overflow : out std_logic; hex1, hex0 : out std_logic_vector(7 downto 0));
end entity;

architecture Structural of adder_display_top is
    signal sum_int : std_logic_vector(3 downto 0);
begin
    U_ADD: entity work.adder_4bit(Structural) port map (a => a, b => b, sum => sum_int, overflow => overflow);
    U_DISP: entity work.bin_to_dual_7seg(Structural) port map (bin => sum_int, hex1 => hex1, hex0 => hex0);
    sum <= sum_int;
end architecture;
