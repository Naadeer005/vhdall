library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_pkg.all;

entity tb_rtc is end entity;
architecture Test of tb_rtc is
    signal clk : std_logic := '0'; signal h : segment_array(0 to 5);
begin
    U: entity work.rtc_top(Structural) generic map (DIV_COUNT => 8) port map (clk => clk, hex5 => h(5), hex4 => h(4), hex3 => h(3), hex2 => h(2), hex1 => h(1), hex0 => h(0));
    process
    begin
        step(clk, 6);
        for i in 0 to 5 loop assert h(i) = digit(0) report "RTC startup" severity failure; end loop;
        -- Check after all registered carry stages settle, before the next tick.
        for seconds in 1 to 86400 loop
            step(clk, 8);
            assert h(0) = digit(seconds mod 10) and h(1) = digit((seconds/10) mod 6) and
                h(2) = digit((seconds/60) mod 10) and h(3) = digit((seconds/600) mod 6) and
                h(4) = digit(((seconds/3600) mod 24) mod 10) and h(5) = digit(((seconds/3600) mod 24)/10)
                report "RTC time mismatch at second " & integer'image(seconds) severity failure;
        end loop;
        report "PASS: tb_rtc" severity note;
        wait;
    end process;
end architecture;
