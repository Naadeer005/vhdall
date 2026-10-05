library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_pkg.all;

entity tb_mux is end entity;
architecture Test of tb_mux is
    signal a, b, y4 : std_logic_vector(3 downto 0);
    signal s, yg, yd : std_logic;
begin
    G: entity work.mux_2to1_gate(Structural) port map (i0 => a(0), i1 => b(0), s => s, y => yg);
    D: entity work.mux_2to1(Dataflow) port map (i0 => a(0), i1 => b(0), s => s, y => yd);
    V: entity work.mux_2to1_4bit(Dataflow) port map (a => a, b => b, s => s, y => y4);
    process
    begin
        for av in 0 to 15 loop
            for bv in 0 to 15 loop
                a <= std_logic_vector(to_unsigned(av, 4)); b <= std_logic_vector(to_unsigned(bv, 4));
                s <= '0'; wait for 1 ns;
                assert y4 = a and yg = a(0) and yd = a(0) report "MUX select 0" severity failure;
                s <= '1'; wait for 1 ns;
                assert y4 = b and yg = b(0) and yd = b(0) report "MUX select 1" severity failure;
            end loop;
        end loop;
        report "PASS: tb_mux" severity note;
        wait;
    end process;
end architecture;
