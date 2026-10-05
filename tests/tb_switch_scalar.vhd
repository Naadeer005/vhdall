library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.tb_pkg.all;

entity tb_switch_scalar is
end entity;

architecture Test of tb_switch_scalar is

    signal sw, led : std_logic_vector(9 downto 0);

begin

    U : entity work.switch_to_led(Dataflow)
        port map (
            sw0  => sw(0),
            sw1  => sw(1),
            sw2  => sw(2),
            sw3  => sw(3),
            sw4  => sw(4),
            sw5  => sw(5),
            sw6  => sw(6),
            sw7  => sw(7),
            sw8  => sw(8),
            sw9  => sw(9),
            led0 => led(0),
            led1 => led(1),
            led2 => led(2),
            led3 => led(3),
            led4 => led(4),
            led5 => led(5),
            led6 => led(6),
            led7 => led(7),
            led8 => led(8),
            led9 => led(9)
        );

    process
    begin

        for i in 0 to 1023 loop

            sw <= std_logic_vector(to_unsigned(i, 10));
            wait for 1 ns;
            assert led = std_logic_vector(to_unsigned(i, 10))
                report "Switch scalar mismatch"
                severity failure;

        end loop;

        report "PASS: tb_switch_scalar"
            severity note;
        wait;

    end process;

end architecture;
