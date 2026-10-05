library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_pkg.all;

entity tb_binary_display is end entity;
architecture Test of tb_binary_display is
    signal bin, bcd1, bcd0 : std_logic_vector(3 downto 0);
    signal hex1, hex0 : segment;
begin
    C: entity work.bin_to_bcd(Dataflow) port map (bin => bin, bcd1 => bcd1, bcd0 => bcd0);
    U: entity work.bin_to_dual_7seg(Structural) port map (bin => bin, hex1 => hex1, hex0 => hex0);
    process
    begin
        for i in 0 to 15 loop
            bin <= std_logic_vector(to_unsigned(i, 4)); wait for 1 ns;
            assert to_integer(unsigned(bcd1)) = i/10 and to_integer(unsigned(bcd0)) = i mod 10 severity failure;
            assert hex1 = digit(i/10) and hex0 = digit(i mod 10) report "Dual display mismatch" severity failure;
        end loop;
        report "PASS: tb_binary_display" severity note;
        wait;
    end process;
end architecture;
