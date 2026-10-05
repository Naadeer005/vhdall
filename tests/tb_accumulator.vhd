library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.tb_pkg.all;

entity tb_accumulator is
end entity;

architecture Test of tb_accumulator is

    signal clk : std_logic                    := '0'; signal key0, key1 : std_logic := '1';
    signal a   : std_logic_vector(7 downto 0) := (others => '0'); signal add_sub : std_logic := '0';
    signal h   : segment_array(0 to 3); signal overflow : std_logic;
    signal bin : std_logic_vector(7 downto 0); signal hundreds, tens, units_digit : std_logic_vector(3 downto 0);

    type ints is array (natural range <>) of integer;

    constant amounts   : ints                     := (127, 131, 89, 73, 167, 251, 53, 113, 199, 97);
    constant subtracts : std_logic_vector(0 to 9) := "0011101100";

begin

    U : entity work.accumulator_top(Structural)
        port map (
            clk      => clk,
            a        => a,
            add_sub  => add_sub,
            key0     => key0,
            key1     => key1,
            hex3     => h(3),
            hex2     => h(2),
            hex1     => h(1),
            hex0     => h(0),
            overflow => overflow
        );

    C : entity work.bin_to_bcd(Dataflow)
        port map (
            bin  => bin,
            bcd2 => hundreds,
            bcd1 => tens,
            bcd0 => units_digit
        );

    process
    begin

        for i in 0 to 255 loop

            bin <= std_logic_vector(to_unsigned(i, 8));
            wait for 1 ns;
            assert to_integer(unsigned(hundreds)) * 100 + to_integer(unsigned(tens)) * 10 + to_integer(unsigned(units_digit)) = i
                report "Eight-bit BCD"
                severity failure;

        end loop;

        step(clk); assert overflow = '0' and h(0) = digit(0)
            severity failure;
        -- Website sequence with independent integer reference model.
        for i in amounts'range loop

            a       <= std_logic_vector(to_unsigned(amounts(i), 8));
            add_sub <= subtracts(i);
            push(clk, key0);

            case i is

                when 0 =>

                    assert h(3) = x"FF" and h(2) = digit(1) and h(1) = digit(2) and h(0) = digit(7) and overflow = '0'
                        severity failure;

                when 1 =>

                    assert h(3) = x"BF" and h(2) = digit(2) and h(1) = digit(5) and h(0) = digit(4) and overflow = '1'
                        severity failure;

                when 2 =>

                    assert h(3) = x"FF" and h(2) = digit(1) and h(1) = digit(6) and h(0) = digit(9) and overflow = '1'
                        severity failure;

                when 3 =>

                    assert h(3) = x"FF" and h(2) = digit(0) and h(1) = digit(9) and h(0) = digit(6) and overflow = '0'
                        severity failure;

                when 4 =>

                    assert h(3) = x"BF" and h(2) = digit(0) and h(1) = digit(7) and h(0) = digit(1) and overflow = '1'
                        severity failure;

                when 5 =>

                    assert h(3) = x"FF" and h(2) = digit(1) and h(1) = digit(8) and h(0) = digit(0) and overflow = '0'
                        severity failure;

                when 6 =>

                    assert h(3) = x"FF" and h(2) = digit(1) and h(1) = digit(2) and h(0) = digit(7) and overflow = '0'
                        severity failure;

                when 7 =>

                    assert h(3) = x"FF" and h(2) = digit(0) and h(1) = digit(1) and h(0) = digit(4) and overflow = '0'
                        severity failure;

                when 8 =>

                    assert h(3) = x"FF" and h(2) = digit(2) and h(1) = digit(1) and h(0) = digit(3) and overflow = '0'
                        severity failure;

                when 9 =>

                    assert h(3) = x"BF" and h(2) = digit(2) and h(1) = digit(0) and h(0) = digit(2) and overflow = '1'
                        severity failure;

            end case;

        end loop;

        push(clk, key1); assert h(0) = digit(0) and overflow = '0' and h(3) = x"FF"
            severity failure;
        a       <= x"FF";
        add_sub <= '1';
        push(clk, key0);
        assert h(3) = x"BF" and h(2) = digit(2) and h(1) = digit(5) and h(0) = digit(5)
            severity failure;
        a       <= x"01";
        push(clk, key0);
        assert h(3) = x"BF" and h(2) = digit(2) and h(1) = digit(5) and h(0) = digit(6) and overflow = '1'
            report "Minimum signed value -256"
            severity failure;
        a       <= x"AB";
        step(clk, 20);
        assert h(0) = digit(6) and overflow = '1'
            report "Accumulator retention"
            severity failure;
        key0    <= '0';
        key1    <= '0';
        step(clk, 10);
        assert h(0) = digit(0) and overflow = '0' and h(3) = x"FF"
            report "Reset priority"
            severity failure;
        step(clk, 10); assert h(0) = digit(0)
            report "Held button retriggered"
            severity failure;
        report "PASS: tb_accumulator"
            severity note;
        wait;

    end process;

end architecture;
