library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_pkg.all;

entity tb_switch_vector is end entity;
architecture Test of tb_switch_vector is
    signal sw, led : std_logic_vector(9 downto 0);
begin
    U: entity work.switch_to_led(Dataflow) port map (sw => sw, led => led);
    process
    begin
        for i in 0 to 1023 loop
            sw <= std_logic_vector(to_unsigned(i, 10)); wait for 1 ns;
            assert led = std_logic_vector(to_unsigned(i, 10)) report "Switch vector mismatch" severity failure;
        end loop;
        report "PASS: tb_switch_vector" severity note;
        wait;
    end process;
end architecture;
