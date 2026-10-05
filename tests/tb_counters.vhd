library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.tb_pkg.all;

entity tb_counters is
end entity;

architecture Test of tb_counters is

    signal clk         : std_logic := '0'; signal tick, tick1, tick2 : std_logic;
    signal ripple, led : std_logic_vector(3 downto 0);

begin

    R : entity work.ripple_counter_top(Structural)
        port map (
            clk => clk,
            led => ripple
        );

    D : entity work.clock_divider(Behavioral)
        generic map (
            DIV_COUNT => 4
        )
        port map (
            clk  => clk,
            tick => tick
        );

    D1 : entity work.clock_divider(Behavioral)
        generic map (
            DIV_COUNT => 1
        )
        port map (
            clk  => clk,
            tick => tick1
        );

    D2 : entity work.clock_divider(Behavioral)
        generic map (
            DIV_COUNT => 2
        )
        port map (
            clk  => clk,
            tick => tick2
        );

    C : entity work.counter_top(Behavioral)
        generic map (
            DIV_COUNT => 4
        )
        port map (
            clk => clk,
            led => led
        );

    process
    begin

        wait for 1 ns; assert ripple = "0000" and led = "0000" and tick = '0'
            severity failure;

        for i in 1 to 80 loop

            step(clk);
            assert to_integer(unsigned(ripple)) = i mod 16
                report "Ripple count mismatch"
                severity failure;
            assert to_integer(unsigned(led)) = ((i - 1) / 4) mod 16
                report "Tick-enabled counter mismatch"
                severity failure;

            if i mod 4 = 0 then
                assert tick = '1'
                    severity failure;
            else
                assert tick = '0'
                    severity failure;
            end if;

            assert tick1 = '1'
                severity failure;

            if i mod 2 = 0 then
                assert tick2 = '1'
                    severity failure;
            else
                assert tick2 = '0'
                    severity failure;
            end if;

        end loop;

        report "PASS: tb_counters"
            severity note;
        wait;

    end process;

end architecture;
