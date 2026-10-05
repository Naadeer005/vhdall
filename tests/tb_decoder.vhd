library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.tb_pkg.all;

entity tb_decoder is
end entity;

architecture Test of tb_decoder is

    signal bcd : std_logic_vector(3 downto 0); signal seg : segment;

begin

    U : entity work.bcd_to_7seg(Structural)
        port map (
            bcd => bcd,
            seg => seg
        );

    process
    begin

        for i in 0 to 15 loop

            bcd <= std_logic_vector(to_unsigned(i, 4));
            wait for 1 ns;
            assert seg = digit(i)
                report "BCD decoder mismatch at " & integer'image(i)
                severity failure;

        end loop;

        report "PASS: tb_decoder"
            severity note;
        wait;

    end process;

end architecture;
