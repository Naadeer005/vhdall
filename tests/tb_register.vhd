library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.tb_pkg.all;

entity tb_register is
end entity;

architecture Test of tb_register is

    signal clk : std_logic := '0'; signal d, q : std_logic_vector(3 downto 0);

begin

    U : entity work.register_4bit(Behavioral)
        port map (
            clk => clk,
            d   => d,
            q   => q
        );

    process
    begin

        for i in 0 to 15 loop

            d <= std_logic_vector(to_unsigned(i, 4));
            step(clk);
            assert q = std_logic_vector(to_unsigned(i, 4))
                severity failure;
            d <= not d;
            wait for 1 ns;
            assert q = std_logic_vector(to_unsigned(i, 4))
                report "Register changed without edge"
                severity failure;

        end loop;

        report "PASS: tb_register"
            severity note;
        wait;

    end process;

end architecture;
