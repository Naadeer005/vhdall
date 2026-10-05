library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.tb_pkg.all;

entity tb_multiplier is
end entity;

architecture Test of tb_multiplier is

    signal clk, start : std_logic                    := '0';
    signal a, b       : std_logic_vector(3 downto 0) := (others => '0');
    signal done       : std_logic; signal product : std_logic_vector(7 downto 0);
    signal key0       : std_logic                    := '1'; signal top_done : std_logic;
    signal h          : segment_array(0 to 2);

begin

    F : entity work.multiplier_fsm(Behavioral)
        port map (
            clk   => clk,
            start => start,
            a     => a,
            b     => b,
            done  => done,
            acc   => product
        );

    T : entity work.multiplier_top(Structural)
        port map (
            clk  => clk,
            a    => a,
            b    => b,
            key0 => key0,
            hex2 => h(2),
            hex1 => h(1),
            hex0 => h(0),
            done => top_done
        );

    process
    begin

        step(clk); assert done = '0' and product = x"00" and top_done = '0'
            severity failure;

        for av in 0 to 15 loop

            for bv in 0 to 15 loop

                a     <= std_logic_vector(to_unsigned(av, 4));
                b     <= std_logic_vector(to_unsigned(bv, 4));
                start <= '1';
                step(clk); -- Acceptance is edge 1.
                assert done = '0'
                    report "Done must clear on acceptance"
                    severity failure;
                start <= '0';
                a     <= not a;
                b     <= not b;

                for edge in 2 to 8 loop

                    -- A busy start must be ignored, not restart the operation.
                    if edge = 4 then
                        start <= '1';
                    else
                        start <= '0';
                    end if;

                    step(clk);
                    assert done = '0'
                        report "Multiplier finished too early"
                        severity failure;

                end loop;

                start <= '0';
                step(clk);
                assert done = '1' and to_integer(unsigned(product)) = av * bv
                    report "Multiplier product / ninth-edge latency"
                    severity failure;
                step(clk, 3);
                assert done = '1' and to_integer(unsigned(product)) = av * bv
                    report "Multiplier result retention"
                    severity failure;

            end loop;

        end loop;

        a    <= "1011";
        b    <= "1101";
        key0 <= '0';
        step(clk, 3); assert top_done = '0'
            severity failure;
        -- Synchronizer produces start after two edges, accepted at edge 3.
        step(clk, 7); assert top_done = '0'
            report "Top finished early"
            severity failure;
        step(clk); assert top_done = '1' and h(2) = digit(1) and h(1) = digit(4) and h(0) = digit(3)
            report "Top display 143"
            severity failure;
        a    <= "0000";
        b    <= "0000";
        step(clk, 20);
        assert top_done = '1' and h(0) = digit(3)
            report "Held start or operands changed retained result"
            severity failure;
        key0 <= '1';
        step(clk, 6); push(clk, key0);
        assert top_done = '1' and h(2) = digit(0) and h(1) = digit(0) and h(0) = digit(0)
            severity failure;
        report "PASS: tb_multiplier"
            severity note;
        wait;

    end process;

end architecture;
