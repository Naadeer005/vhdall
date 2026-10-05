library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.tb_pkg.all;

entity tb_mux_display is
end entity;

architecture Test of tb_mux_display is

    signal sw : std_logic_vector(1 downto 0); signal hex0 : segment;

begin

    U : entity work.mux_7seg(Dataflow)
        port map (
            sw   => sw,
            hex0 => hex0
        );

    process
    begin

        for i in 0 to 3 loop

            sw <= std_logic_vector(to_unsigned(i, 2));
            wait for 1 ns;
            assert hex0 = digit(i)
                report "MUX display mismatch"
                severity failure;

        end loop;

        sw <= "XX";
        wait for 1 ns;
        assert hex0 = x"FF"
            severity failure;
        report "PASS: tb_mux_display"
            severity note;
        wait;

    end process;

end architecture;
