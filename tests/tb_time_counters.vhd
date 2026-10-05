library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.tb_pkg.all;

entity tb_time_counters is
end entity;

architecture Test of tb_time_counters is

    signal clk, en, clr                 : std_logic := '0';
    signal c10, c6, c16, c1, ht, hu     : std_logic_vector(3 downto 0);
    signal wrap10, wrap6, wrap16, wrap1 : std_logic;

begin

    M10 : entity work.mod_counter(Behavioral)
        generic map (
            MOD_VALUE => 10
        )
        port map (
            clk   => clk,
            en    => en,
            count => c10,
            carry => wrap10,
            clr   => clr
        );

    M6 : entity work.mod_counter(Behavioral)
        generic map (
            MOD_VALUE => 6
        )
        port map (
            clk   => clk,
            en    => en,
            count => c6,
            carry => wrap6,
            clr   => clr
        );

    M16 : entity work.mod_counter(Behavioral)
        generic map (
            MOD_VALUE => 16
        )
        port map (
            clk   => clk,
            en    => en,
            count => c16,
            carry => wrap16,
            clr   => clr
        );

    M1 : entity work.mod_counter(Behavioral)
        generic map (
            MOD_VALUE => 1
        )
        port map (
            clk   => clk,
            en    => en,
            count => c1,
            carry => wrap1,
            clr   => clr
        );

    H : entity work.hours_counter(Behavioral)
        port map (
            clk     => clk,
            en      => en,
            tens    => ht,
            \units\ => hu,
            clr     => clr
        );

    process
    begin

        en <= '1';

        for i in 1 to 48 loop

            step(clk);
            assert to_integer(unsigned(c10)) = i mod 10 and to_integer(unsigned(c6)) = i mod 6 and to_integer(unsigned(c16)) = i mod 16 and c1 = "0000"
                severity failure;
            assert to_integer(unsigned(ht)) * 10 + to_integer(unsigned(hu)) = i mod 24
                severity failure;

            if i mod 10 = 0 then
                assert wrap10 = '1'
                    severity failure;
            else
                assert wrap10 = '0'
                    severity failure;
            end if;

            if i mod 6 = 0 then
                assert wrap6 = '1'
                    severity failure;
            else
                assert wrap6 = '0'
                    severity failure;
            end if;

            if i mod 16 = 0 then
                assert wrap16 = '1'
                    severity failure;
            else
                assert wrap16 = '0'
                    severity failure;
            end if;

            assert wrap1 = '1'
                severity failure;

        end loop;

        en  <= '0';
        step(clk);
        assert wrap10 = '0' and wrap6 = '0' and wrap16 = '0' and wrap1 = '0'
            report "Carry stuck while disabled"
            severity failure;
        assert c10 = "1000" and c6 = "0000"
            severity failure;
        en  <= '1';
        clr <= '1';
        step(clk);
        assert c10 = "0000" and c6 = "0000" and c16 = "0000" and ht = "0000" and hu = "0000" and wrap10 = '0' and wrap1 = '0'
            report "Clear priority"
            severity failure;
        report "PASS: tb_time_counters"
            severity note;
        wait;

    end process;

end architecture;
