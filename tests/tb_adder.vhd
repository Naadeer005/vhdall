library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_pkg.all;

entity tb_adder is end entity;
architecture Test of tb_adder is
    signal a, b, sum : std_logic_vector(3 downto 0);
    signal overflow, fa_a, fa_b, cin, fa_sum, cout : std_logic;
    signal hex1, hex0 : segment;
begin
    F: entity work.full_adder(Structural) port map (a => fa_a, b => fa_b, cin => cin, sum => fa_sum, cout => cout);
    U: entity work.adder_display_top(Structural) port map (a => a, b => b, sum => sum, overflow => overflow, hex1 => hex1, hex0 => hex0);
    process
    begin
        for i in 0 to 7 loop
            if i mod 2 = 0 then fa_a <= '0'; else fa_a <= '1'; end if;
            if (i/2) mod 2 = 0 then fa_b <= '0'; else fa_b <= '1'; end if;
            if i/4 = 0 then cin <= '0'; else cin <= '1'; end if;
            wait for 1 ns;
            assert fa_sum = (fa_a xor fa_b xor cin) and cout = ((fa_a and fa_b) or (fa_a and cin) or (fa_b and cin)) severity failure;
        end loop;
        for av in 0 to 15 loop
            for bv in 0 to 15 loop
                a <= std_logic_vector(to_unsigned(av, 4)); b <= std_logic_vector(to_unsigned(bv, 4)); wait for 1 ns;
                assert to_integer(unsigned(sum)) = (av+bv) mod 16 report "Adder sum mismatch" severity failure;
                if av+bv > 15 then assert overflow = '1' severity failure;
                else assert overflow = '0' severity failure; end if;
                assert hex1 = digit(((av+bv) mod 16)/10) and hex0 = digit(((av+bv) mod 16) mod 10) severity failure;
            end loop;
        end loop;
        report "PASS: tb_adder" severity note;
        wait;
    end process;
end architecture;
