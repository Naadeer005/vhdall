library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.tb_pkg.all;

entity tb_calculator is
end entity;

architecture Test of tb_calculator is

    signal clk          : std_logic                    := '0'; signal key0, key1 : std_logic := '1';
    signal a, b         : std_logic_vector(3 downto 0) := (others => '0');
    signal h0, h1, sign : segment;
    signal bin          : std_logic_vector(4 downto 0); signal bcd_tens,    bcd_ones : std_logic_vector(3 downto 0);

begin

    U : entity work.calculator_top(Structural)
        port map (
            clk  => clk,
            a    => a,
            b    => b,
            key0 => key0,
            key1 => key1,
            hex2 => sign,
            hex1 => h1,
            hex0 => h0
        );

    C : entity work.bin_to_bcd(Dataflow)
        port map (
            bin  => bin,
            bcd1 => bcd_tens,
            bcd0 => bcd_ones
        );

    process
    begin

        for i in 0 to 31 loop

            bin <= std_logic_vector(to_unsigned(i, 5));
            wait for 1 ns;
            assert to_integer(unsigned(bcd_tens)) * 10 + to_integer(unsigned(bcd_ones)) = i
                report "Five-bit BCD"
                severity failure;

        end loop;

        step(clk); assert h0 = digit(0) and h1 = digit(0) and sign = x"FF"
            severity failure;

        for av in 0 to 15 loop

            for bv in 0 to 15 loop

                a <= std_logic_vector(to_unsigned(av, 4));
                b <= std_logic_vector(to_unsigned(bv, 4));
                push(clk, key0);
                assert h1 = digit((av + bv) / 10) and h0 = digit((av + bv) mod 10) and sign = x"FF"
                    report "Calculator addition"
                    severity failure;
                a <= not a;
                b <= not b;
                step(clk, 2);
                assert h1 = digit((av + bv) / 10) and h0 = digit((av + bv) mod 10)
                    report "Calculator retention"
                    severity failure;
                a <= std_logic_vector(to_unsigned(av, 4));
                b <= std_logic_vector(to_unsigned(bv, 4));
                push(clk, key1);
                assert h1 = digit(abs(av - bv) / 10) and h0 = digit(abs(av - bv) mod 10)
                    report "Calculator subtraction"
                    severity failure;

                if av < bv then
                    assert sign = x"BF"
                        severity failure;
                else
                    assert sign = x"FF"
                        severity failure;
                end if;

            end loop;

        end loop;

        a    <= "0011";
        b    <= "0101";
        key0 <= '0';
        key1 <= '0';
        step(clk, 12);
        assert h0 = digit(8) and sign = x"FF"
            report "Simultaneous addition priority"
            severity failure;
        a    <= "1111";
        b    <= "1111";
        step(clk, 10);
        assert h0 = digit(8)
            report "Held button retriggered"
            severity failure;
        report "PASS: tb_calculator"
            severity note;
        wait;

    end process;

end architecture;
