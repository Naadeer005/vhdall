library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.tb_pkg.all;

entity tb_stopwatch is
end entity;

architecture Test of tb_stopwatch is

    signal clk : std_logic := '0'; signal key0, key1 : std_logic := '1';
    signal h   : segment_array(0 to 5);

begin

    U : entity work.stopwatch_top(Structural)
        generic map (
            DIV_COUNT => 16
        )
        port map (
            clk  => clk,
            key0 => key0,
            key1 => key1,
            hex5 => h(5),
            hex4 => h(4),
            hex3 => h(3),
            hex2 => h(2),
            hex1 => h(1),
            hex0 => h(0)
        );

    process
    begin

        step(clk, 40);

        for i in 0 to 5 loop

            assert h(i) = digit(0)
                report "Stopwatch must start stopped"
                severity failure;

        end loop;

        push(clk, key0); step(clk, 20);
        assert h(0) /= digit(0)
            report "Start did not run"
            severity failure;
        key0 <= '0';
        step(clk, 6); -- Stop, then hold: no repeated toggles.
        key0 <= '1';
        step(clk, 6);
        -- Store stopped display, then check stability across multiple divider ticks.
        for n in 1 to 3 loop

            assert h(0) = digit(2)
                report "Unexpected stopwatch count"
                severity failure;
            step(clk, 16);

        end loop;

        key0 <= '0';
        key1 <= '0';
        step(clk, 6);

        for i in 0 to 5 loop

            assert h(i) = digit(0)
                report "Simultaneous reset must win"
                severity failure;

        end loop;

        step(clk, 40);

        for i in 0 to 5 loop

            assert h(i) = digit(0)
                report "Reset must leave stopped"
                severity failure;

        end loop;

        key0 <= '1';
        key1 <= '1';
        step(clk, 6);
        push(clk, key0); step(clk, 20);
        assert h(0) /= digit(0)
            report "Restart did not run"
            severity failure;
        push(clk, key1); step(clk, 16);

        for i in 0 to 5 loop

            assert h(i) = digit(0)
                report "Reset while running"
                severity failure;

        end loop;

        report "PASS: tb_stopwatch"
            severity note;
        wait;

    end process;

end architecture;
